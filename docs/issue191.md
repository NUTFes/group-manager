# issue191
「ステージ利用の申請」の日付を年度ごと自動で切り替えるように

## 変更前
現在は日付をハードコーディングしている
```
StageOrder.new( group_id: id, fes_date_id: 8, is_sunny: true, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
```
このままだと毎年変更する必要があるので，this_yearからfes_date_idを特定するようにする

## 変更点
・手順1
今年のFesDateを追加する
なお，今年（2018年）のFesYearは入力済みであった．(id:4)

db/fixtures/fes_year_date.rbのFesDate.seedの中に以下の内容を追記
```
{ id: 10, days_num:0, date:'9/14', day:'fri', fes_year_id: 4} ,
{ id: 11, days_num:1, date:'9/15', day:'sat', fes_year_id: 4} ,
{ id: 12, days_num:2, date:'9/16', day:'sun', fes_year_id: 4} ,
```

・手順2
fes_date_idをthis_yearからとってこれるように設定する

app/models/group.rbの
def init_stage_orderの中に以下の変数を追加
```
date1 = FesDate.where(fes_year_id: FesYear.this_year).where(days_num: 1).first.id
date2 = FesDate.where(fes_year_id: FesYear.this_year).where(days_num: 2).first.id
```
さらにfesdate_idを1日目の場合date1を，2日目の場合date2を指定．

## 変更後
よって，日付がthis_yearからとってこれるようになった．
