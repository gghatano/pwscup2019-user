
library(dplyr)
## テスト用 結構時間がかかるので、100人くらいで試してから考えるといいかもしれない
user_id_list = 1:2000 %>% as.character

################ データ読み込み ################
## orgとanoとrefのパスを読み込む
dat_org = readr::read_csv("./sample/Data/orgtraces_team101_data01_IDP.csv", col_types = "ccc") %>% 
  filter(user_id %in% user_id_list)

## user_idとtime_idを加えておく
dat_ano = readr::read_csv("./sample/Data/anotraces_team101_data01_IDP.csv", col_types = "c") 
dat_ano$user_id = dat_org$user_id
dat_ano$time_id = dat_org$time_id


dat_ref = readr::read_csv("./sample/Data/reftraces_team101_data01_IDP.csv", col_types="ccc") %>% 
  filter(user_id %in% user_id_list)

dat_info_region = readr::read_csv("./sample/Data/info_region.csv")


################ 実行 ################
## 一般化されていたら、重心の位置に置き換た上で、
## 各時刻における距離の時間平均が、最も近いユーザを探す
reid_by_meandistance = function(dat_ano = dat_ano, dat_ref = dat_ref, dat_info_region = dat_info_region){
  dat_info_region %>% 
    mutate(reg_id = as.character(reg_id)) %>% 
    select(reg_id, y = `y(center)`, x = `x(center)`, hospital) -> dat_region
  
  dat_ref %>%
    mutate(time_id = as.numeric(time_id) + 40) %>%  ## time_idを合わせる
    mutate(time_id = as.character(time_id)) %>% 
    select(user_id_ref = user_id, reg_id_ref = reg_id, time_id_ref = time_id) %>% 
    mutate(reg_id_ref = as.character(reg_id_ref)) -> dat_ref_reid
  
  dat_ref_reid %>% 
    inner_join(dat_region, by = c("reg_id_ref" = "reg_id")) %>% 
    rename(x_ref = x, y_ref = y) %>% 
    select(-reg_id_ref) -> dat_ref_xy
    
  # dat_ano = dat_org
  dat_ano %>% 
    tidyr::separate_rows(reg_id, sep=" ") %>% 
    inner_join(dat_region, by = "reg_id") %>% 
    group_by(user_id, time_id) %>% 
    summarise(x = mean(x), y = mean(y)) -> dat_ano_reid
  dat_ano_reid %>% dim
  
  dat_ref_xy %>% dim
  
  dat_ref_xy %>% 
    inner_join(dat_ano_reid, by = c("time_id_ref" = "time_id")) %>% 
    mutate(distance = ((x_ref - x)**2 + (y_ref - y)**2) ** 0.5) %>% 
    mutate(distance = if_else(distance > 2, 2, distance)) %>% 
    select(user_id_ref, user_id, distance) %>% 
    group_by(user_id_ref, user_id) %>% 
    summarise(mean_distance = mean(distance)) %>% 
    ungroup -> dat_res_tmp
  
  dat_ref_xy %>% head
  
  dat_res_tmp %>% 
    group_by(user_id_ref) %>% 
    filter(mean_distance == min(mean_distance)) %>% 
    ungroup %>% 
    # filter(user_id_ref == user_id) %>% 
    as.data.frame %>% 
    return
}

start = Sys.time()
result = reid_by_meandistance(dat_ano = dat_ano, dat_ref = dat_ref, dat_info_region = dat_info_region)
Sys.time() - start

  
result %>% filter(user_id_ref == user_id) %>% dim

result %>% head
