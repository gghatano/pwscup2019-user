■このディレクトリについて
このディレクトリには，PWS Cup 2019の公開情報（PWS Cup 2019競技ルール: https://www.iwsec.org/pws/2019/cup19-rule.pdf 2.7節参照）が格納されています．

■ディレクトリ構成
- 00ReadMe.txt
  - このファイル

- Data/                                データ
  - PWSCup2019_Osaka/                    PWSCup2019用人工データ（大阪データセット）【競技ルール 2.7.7節参照】
    - info_region.csv                      領域情報ファイル
    - info_time.csv                        時刻情報ファイル
    - orgtraces_teamXXX_dataYY_ZZZ.csv     チーム番号XXX，データセット番号YYの元トレース
    - reftraces_teamXXX_dataYY_ZZZ.csv     チーム番号XXX，データセット番号YYの参照トレース
  - PWSCup2019_Tokyo_Preliminary/        予備選における領域情報ファイルと時刻情報ファイル
    - info_region.csv                      領域情報ファイル【競技ルール 2.7.5節参照】
    - info_time.csv                        時刻情報ファイル【競技ルール 2.7.6節参照】

- Data_Anonymize/                      匿名加工データ（シャッフル前）

- Data_Anonymize_Shuffle/              匿名加工データ（シャッフル後）

- Data_IDDisclose/                     ID識別結果データ

- Data_TraceInfer/                     トレース推定結果データ

- Prog_Eval/                           有用性・安全性評価プログラム
  - EvalSecI.py                          ID識別安全性評価プログラム【競技ルール 2.7.3節参照】
  - EvalSecT.py                          トレース推定安全性評価プログラム【競技ルール 2.7.4節参照】
  - EvalUtil.py                          有用性評価プログラム【競技ルール 2.7.2節参照】

- Prog_Shuffle/                        シャッフル（仮名化）プログラム
  - ShuffleIDs.py                        指定したディレクトリ下の全匿名加工データに対して，ユーザIDをシャッフルするプログラム

- SmplProg_Anonymize/                  匿名加工サンプルプログラム【競技ルール 2.7.1節参照】
  - A1-none.py                           評価用トレースをそのまま出力する（何もしない）
  - A2-MRLH.py                           MRLH (Merging Regions and Location Hiding) [Shokri+,S&P11]
  - A3-kRR.py                            k-RR (k-ary randomized response) [Kairouz+,ICML16]
  - A4-PL.py                             PL (Planaer Laplace mechanism) [Andres+,CCS13]
  - A5-YA.py                             Yamaoka anonymization (cheating anonymization)

- SmplProg_IDDisclose/                 ID識別（ID-disclosure）サンプルプログラム【競技ルール 2.7.1節参照】
  - I1-rand.py                           ランダムなID識別
  - I2-VisitProb.py                      ユーザ毎の領域滞在分布を学習し，最も尤度の大きいユーザとしてID識別する
  - I3-HomeProb.py                       ユーザ毎の領域滞在分布を学習し，最も尤度の大きいユーザとしてID識別する（8時台のデータのみを使用）

- SmplProg_Track/                      トレース推定（Trace Inference）サンプルプログラム【競技ルール 2.7.1節参照】
  - T1-rand.py                           ランダムなトレース推定
  - T2-VisitProb.py                      ユーザ毎の領域滞在分布を学習し，最も尤度の大きい領域としてID識別後，位置情報を推定する
  - T3-HomeProb.py                       ユーザ毎の領域滞在分布を学習し，最も尤度の大きい領域としてID識別後，位置情報を推定する（8時台のデータのみを使用）

- Eval.bash                            大阪の元トレース（チーム番号：001，データセット番号：01）に対して，匿名加工（A2-MRLH）・ID識別（I1-rand）・トレース推定（T1-rand）する

■サンプルプログラムの実行
python3.6以上の環境であれば動きます．numpyとscipyが必要です．
Eval.bashでサンプルプログラムを用いた匿名加工・ID識別・トレース推定ができます．詳細は以下のとおり．
- Eval.bash: 大阪データセットの元トレース（チーム番号：001，データセット番号：01）に対して，以下の匿名加工・ID識別・トレース推定を行う．
  - 匿名加工アルゴリズム：A2-MRLH
  - ID識別アルゴリズム：I1-rand
  - トレース推定アルゴリズム：T1-rand

実行例：
$ bash Eval.bash

■データセットについて
Dataディレクトリにある位置情報データ（元トレース・参照トレース）は，
疑似人流データ（ https://nightley.jp/archives/1954/ ）を基に新たに作成した人工データです．
詳細は，PWSCup2019データセットについて（ https://www.iwsec.org/pws/2019/cup19-dataset.pdf )を参照してください．

疑似人流データの原作者クレジットは以下の通りです．

【クレジット】
株式会社ナイトレイ
東京大学　柴崎・関本研究室
マイクロジオデータ研究会
人の流れプロジェクト
東京大学空間情報科学研究センター
