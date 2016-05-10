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

## ステージ団体が利用可能な場所の指定を行えるようにテーブルを変更
```
# enableカラムの追加
$ bundle exec rails g migration AddEnableToStage enable:boolean
Running via Spring preloader in process 27019
    invoke  active_record
  create    db/migrate/20160510084512_add_enable_to_stage.rb
```

マイグレート
```
$ bundle exec rake db:migrate
== 20160510084512 AddEnableToStage: migrating =================================
-- add_column(:stages, :enable, :boolean)
   -> 0.0198s
   == 20160510084512 AddEnableToStage: migrated (0.0204s) ========================
```


## Seedファイルの変更

```
# 新設場所の追加
db/fixtures/place.rb # データの追加

# 団体カテゴリごとに利用できる場所を指定したシードデータを生成
db/fixtures/place_allow_list.rb

# ステージ団体用のシードにデータを追加
db/fixtures/stage.rb
```

## Seedの適応
```
# 新設場所の追加
$ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=place.rb

== Filtering seed files against regexp: /place.rb/

== Seed from db/fixtures/place.rb
- Place {:id=>1, :name_ja=>"事務棟エリア", :is_outside=>true}
- Place {:id=>2, :name_ja=>"図書館エリア", :is_outside=>true}
- Place {:id=>3, :name_ja=>"福利棟エリア", :is_outside=>true}
- Place {:id=>4, :name_ja=>"ステージエリア", :is_outside=>true}
- Place {:id=>5, :name_ja=>"体育館エリア", :is_outside=>true}
- Place {:id=>6, :name_ja=>"セコムホール", :is_outside=>false}
- Place {:id=>7, :name_ja=>"電気棟204", :is_outside=>false}
- Place {:id=>8, :name_ja=>"電気棟206", :is_outside=>false}
- Place {:id=>9, :name_ja=>"電気棟208", :is_outside=>false}
- Place {:id=>10, :name_ja=>"電気棟212", :is_outside=>false}
- Place {:id=>11, :name_ja=>"電気棟310", :is_outside=>false}
- Place {:id=>12, :name_ja=>"講義棟部屋A", :is_outside=>false}
- Place {:id=>13, :name_ja=>"講義棟部屋B", :is_outside=>false}
- Place {:id=>14, :name_ja=>"マルチメディアセンター", :is_outside=>false}
- Place {:id=>15, :name_ja=>"グラウンド", :is_outside=>true}
```

```
# 団体カテゴリと場所の関連を追加
$ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=place_allow_list.rb
== Filtering seed files against regexp: /place_allow_list.rb/

== Seed from db/fixtures/place_allow_list.rb
- PlaceAllowList {:id=>1, :place_id=>1, :group_category_id=>1, :enable=>true}
- PlaceAllowList {:id=>2, :place_id=>2, :group_category_id=>1, :enable=>true}
- PlaceAllowList {:id=>3, :place_id=>3, :group_category_id=>1, :enable=>true}
- PlaceAllowList {:id=>4, :place_id=>4, :group_category_id=>1, :enable=>true}
- PlaceAllowList {:id=>5, :place_id=>5, :group_category_id=>1, :enable=>true}
- PlaceAllowList {:id=>6, :place_id=>6, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>7, :place_id=>7, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>8, :place_id=>8, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>9, :place_id=>9, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>10, :place_id=>10, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>11, :place_id=>11, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>12, :place_id=>12, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>13, :place_id=>13, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>14, :place_id=>14, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>15, :place_id=>15, :group_category_id=>1, :enable=>false}
- PlaceAllowList {:id=>16, :place_id=>1, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>17, :place_id=>2, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>18, :place_id=>3, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>19, :place_id=>4, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>20, :place_id=>5, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>21, :place_id=>6, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>22, :place_id=>7, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>23, :place_id=>8, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>24, :place_id=>9, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>25, :place_id=>10, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>26, :place_id=>11, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>27, :place_id=>12, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>28, :place_id=>13, :group_category_id=>2, :enable=>true}
- PlaceAllowList {:id=>29, :place_id=>14, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>30, :place_id=>15, :group_category_id=>2, :enable=>false}
- PlaceAllowList {:id=>31, :place_id=>1, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>32, :place_id=>2, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>33, :place_id=>3, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>34, :place_id=>4, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>35, :place_id=>5, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>36, :place_id=>6, :group_category_id=>4, :enable=>true}
- PlaceAllowList {:id=>37, :place_id=>7, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>38, :place_id=>8, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>39, :place_id=>9, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>40, :place_id=>10, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>41, :place_id=>11, :group_category_id=>4, :enable=>false}
- PlaceAllowList {:id=>42, :place_id=>12, :group_category_id=>4, :enable=>true}
- PlaceAllowList {:id=>43, :place_id=>13, :group_category_id=>4, :enable=>true}
- PlaceAllowList {:id=>44, :place_id=>14, :group_category_id=>4, :enable=>true}
- PlaceAllowList {:id=>45, :place_id=>15, :group_category_id=>4, :enable=>true}
- PlaceAllowList {:id=>46, :place_id=>1, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>47, :place_id=>2, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>48, :place_id=>3, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>49, :place_id=>4, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>50, :place_id=>5, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>51, :place_id=>6, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>52, :place_id=>7, :group_category_id=>5, :enable=>false}
- PlaceAllowList {:id=>53, :place_id=>8, :group_category_id=>5, :enable=>false}
- PlaceAllowList {:id=>54, :place_id=>9, :group_category_id=>5, :enable=>false}
- PlaceAllowList {:id=>55, :place_id=>10, :group_category_id=>5, :enable=>false}
- PlaceAllowList {:id=>56, :place_id=>11, :group_category_id=>5, :enable=>false}
- PlaceAllowList {:id=>57, :place_id=>12, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>58, :place_id=>13, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>59, :place_id=>14, :group_category_id=>5, :enable=>true}
- PlaceAllowList {:id=>60, :place_id=>15, :group_category_id=>5, :enable=>true}
```

```
# stageテーブルにEnableカラムを追加
$ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=stage.rb

== Filtering seed files against regexp: /stage.rb/

== Seed from db/fixtures/stage.rb
- Stage {:id=>1, :name_ja=>"メインステージ", :is_sunny=>true, :enable=>true}
- Stage {:id=>2, :name_ja=>"サブステージ", :is_sunny=>true, :enable=>true}
- Stage {:id=>3, :name_ja=>"体育館", :is_sunny=>true, :enable=>true}
- Stage {:id=>4, :name_ja=>"マルチメディアセンター", :is_sunny=>true, :enable=>true}
- Stage {:id=>5, :name_ja=>"体育館", :is_sunny=>false, :enable=>true}
- Stage {:id=>6, :name_ja=>"マルチメディアセンター", :is_sunny=>false, :enable=>true}
- Stage {:id=>7, :name_ja=>"武道館", :is_sunny=>false, :enable=>true}
- Stage {:id=>8, :name_ja=>"武道館", :is_sunny=>true, :enable=>true}
```

## 実施場所の申請フォームの選択肢を修正
 * ``app/models/place.rb``で, 場所について``PlaceAllowListテーブル``を参照するように変更.
 * ``is_outside``カラムを廃止

## Placeテーブルからis_outside項目を削除
```
# is_outside項目を削除
$ bundle exec rails g migration RemoveIsOutsideFromPlace is_outside:boolean
Running via Spring preloader in process 48665
    invoke  active_record
  create    db/migrate/20160510110533_remove_is_outside_from_place.rb

# マイグレート
$ bundle exec rake db:migrate
== 20160510110533 RemoveIsOutsideFromPlace: migrating =========================
-- remove_column(:places, :is_outside, :boolean)
   -> 0.0329s
   == 20160510110533 RemoveIsOutsideFromPlace: migrated (0.0331s) ================
```

再度,placeテーブルのseedファイルの書き換える

  * is_outsideカラムを除去

 ```
 #seedの適応
 $ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=place.rb  
 == Filtering seed files against regexp: /place.rb/

 == Seed from db/fixtures/place.rb
 - Place {:id=>1, :name_ja=>"事務棟エリア"}
 - Place {:id=>2, :name_ja=>"図書館エリア"}
 - Place {:id=>3, :name_ja=>"福利棟エリア"}
 - Place {:id=>4, :name_ja=>"ステージエリア"}
 - Place {:id=>5, :name_ja=>"体育館エリア"}
 - Place {:id=>6, :name_ja=>"セコムホール"}
 - Place {:id=>7, :name_ja=>"電気棟204"}
 - Place {:id=>8, :name_ja=>"電気棟206"}
 - Place {:id=>9, :name_ja=>"電気棟208"}
 - Place {:id=>10, :name_ja=>"電気棟212"}
 - Place {:id=>11, :name_ja=>"電気棟310"}
 - Place {:id=>12, :name_ja=>"講義棟部屋A"}
 - Place {:id=>13, :name_ja=>"講義棟部屋B"}
 - Place {:id=>14, :name_ja=>"マルチメディアセンター"}
 - Place {:id=>15, :name_ja=>"グラウンド"}
 ```
 
## ステージ利用の申請フォームの選択肢を修正
 * ``app/models/stage.rb``で, Enableの項目を参照するように変更

## 管理画面側に利用可能場所の操作画面を追加
```
$ bundle exec rails g active_admin:resource PlaceAllowList
Running via Spring preloader in process 58344
    create  app/admin/place_allow_list.rb
```

** cancancan **
developer : PlaceAllowListについてCRUDを許可
manager   : Read, Updateのみ許可

** 編集画面 **
developer : 団体カテゴリ, 場所, enableを編集可能
manager   : enableのみ編集可能


