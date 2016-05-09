場所申請で行える候補の問題 #35 

## 団体カテゴリ毎に利用できる場所を変更できる機能を追加
モデル生成
```
# 場所が利用可能な団体のカテゴリ
$ bundle exec rails g model placeAllowList place:references group_category:references enable:boolean
Running via Spring preloader in process 71755
      invoke  active_record
      create    db/migrate/20160509172843_create_place_allow_lists.rb
      create    app/models/place_allow_list.rb
```

マイグレート
```
$ bundle exec rake db:migrate
== 20160509172843 CreatePlaceAllowLists: migrating ============================
-- create_table(:place_allow_lists)
   -> 0.0885s
   == 20160509172843 CreatePlaceAllowLists: migrated (0.0886s) ===================
```


## Seedファイルの変更

新設場所の追加
```
db/fixtures/place.rb # データの追加
```

## Seedの適応
```
$ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=place.rb
```

