# Issue317 Rubyのversion up, 各種gemのupgrade


## Issueの内容
ruby2.2.0のサポートが終了し、herokuにデプロイができなくなった。
これを機に、rubyのバージョンを上げる。
一緒にrailsのバージョンも最新のものにする。

## やったこと

1. ruby2.2.0→ruby2.3.0
2. ruby2.3.0→ruby2.4.0
3. ruby2.4.0→ruby2.5.3
4. rails4.2.10→rails5.2.0


## ruby2.2.0 → ruby2.3.0

[error] todというgemでエラー  
todはruby2.2.0までしか対応してないらしい(https://github.com/jackc/tod)  
`app/models/stage_order.rb` のtodを使用している部分を変更し、Gemfileから削除した  

変更前

```app/models/stage_order.rb
...

if is_all_times
    prepare_start_tod = Tod::TimeOfDay.try_parse(prepare_start_time)
    perform_start_tod = Tod::TimeOfDay.try_parse(performance_start_time)
    perform_end_tod = Tod::TimeOfDay.try_parse(performance_end_time)
    cleanup_end_tod = Tod::TimeOfDay.try_parse(cleanup_end_time)

    all_interval = cleanup_end_tod - prepare_start_tod

    if (prepare_start_tod > perform_start_tod || perform_start_tod >= perform_end_tod || perform_end_tod > cleanup_end_tod)
        errors.add( :prepare_start_time, "不正な値です" )
        errors.add( :performance_start_time, "不正な値です" )
        errors.add( :performance_end_time, "不正な値です" )
        errors.add( :cleanup_end_time, "不正な値です" )
    end

    if all_interval > Tod::TimeOfDay.parse("02:00:00")
        errors.add( :prepare_start_time, "最大利用時間は2時間までです" )
        errors.add( :performance_start_time, "最大利用時間は2時間までです" )
        errors.add( :performance_end_time, "最大利用時間は2時間までです" )
        errors.add( :cleanup_end_time, "最大利用時間は2時間までです" )
    end
end

...
```

変更後

```app/models/stage_order.rb
...

if is_all_times
    prepare_start = DateTime.parse(prepare_start_time)
    perform_start = DateTime.parse(performance_start_time)
    perform_end = DateTime.parse(performance_end_time)
    cleanup_end = DateTime.parse(cleanup_end_time)

    if (prepare_start > perform_start or perform_start >= perform_end or perform_end > cleanup_end)
        errors.add( :prepare_start_time, "不正な値です" )
        errors.add( :performance_start_time, "不正な値です" )
        errors.add( :performance_end_time, "不正な値です" )
        errors.add( :cleanup_end_time, "不正な値です" )
    end

    if cleanup_end > prepare_start + Rational(2, 24)
        errors.add( :prepare_start_time, "最大利用時間は2時間までです" )
        errors.add( :performance_start_time, "最大利用時間は2時間までです" )
        errors.add( :performance_end_time, "最大利用時間は2時間までです" )
        errors.add( :cleanup_end_time, "最大利用時間は2時間までです" )
    end
end

...
```

[error] simple\_formの `error_span` というメソッドでエラー  
→ [twitter-bootstrap-railsを導入したらフォームが動かなくなった](https://github.com/dhacks/team-f_2015w/issues/1)  

`twitter-bootstrap-rails` のバージョンをダウングレードしたら解消した  

```Gemfile
gem 'twitter-bootstrap-rails', '3.2.0'  # '3.2.2からダウングレード'
```


## ruby2.3.0 → ruby2.4.0

[error]

```
Array values in the parameter to Gem.paths= are deprecated.
Please use a String or nil.
An Array ({"GEM_PATH"=>["/Users/kicchii/workspace/group-manager/vendor/bundle/ruby/2.4.0"]}) was passed in from bin/rails:3:in `load'
...
```

→ [参考:ruby/rails のversionを上げた際に Array values in the parameter to `Gem.paths=` are deprecated.　エラーが出た時](https://qiita.com/lulu-ulul/items/f6cdfb02570821c82418)

```shell
$ bundle update spring
$ bundle exec spring binstub --remove --all
$ bundle exec spring binstub --all
```

でおk

[error]

```shell
Users/kicchii/workspace/group-manager/vendor/bundle/ruby/2.4.0/gems/therubyracer-0.12.2/lib/v8/conversion.rb:21: warning: constant ::Fixnum is deprecated
/Users/kicchii/workspace/group-manager/vendor/bundle/ruby/2.4.0/gems/therubyracer-0.12.2/lib/v8/conversion.rb:23:in `include': wrong argument type Class (expected Module) (TypeError)
    from /Users/kicchii/workspace/group-manager/vendor/bundle/ruby/2.4.0/gems/therubyracer-0.12.2/lib/v8/conversion.rb:23:in `block (2 levels) in <top (required)>'
    from /Users/kicchii/workspace/group-manager/vendor/bundle/ruby/2.4.0/gems/therubyracer-0.12.2/
...
spring/binstub.rb:11:in `<top (required)>'
    from /Users/kicchii/workspace/group-manager/bin/spring:13:in `require'
    from /Users/kicchii/workspace/group-manager/bin/spring:13:in `<top (required)>'
    from bin/rails:3:in `load'
    from bin/rails:3:in `<main>'
```

→ [参照:Uglifier doesn't load with Ruby 2.4.0 using The Ruby Racer JS runtime #105](https://github.com/lautis/uglifier/issues/105)  
`therubyracer` のバージョンを0.12.3以上にすればいいっぽい．  
Gemfileの`therubyracer`のバージョンを0.12.3にすればおk．  


## ruby2.4.0 → ruby2.5.3
問題なかった

## rails4.2.0 → rails 5.2.0

Railsが提供する `bundle exec rails app:update` コマンドで設定ファイル等を更新した。  
実行すると、conflictが発生したファイルが表示される。  
上書きするか、変更しないか等を聞かれる。  
`d`を押すとdiffを確認できる。  
大半は上書きしても問題ない変更だが、こちら側で意図的に変更した箇所は変更しないようにする。  

各種gemのバージョンに関するエラーがたくさん出たので、よしなにアップグレードした。  
また、以下のgemを新規に追加した。  

* gem 'bootsnap'
* gem 'listen'
* gem 'rails-i18n'

viewsで使われていた `error_span` メソッドは不要そうなので全て削除した。  
rails5から `before_filter` が非推奨になったので、 `before_action`に全て変更した。  
ActiveRecordの `uniq` メソッドが `distinct` に変更されたらしいので、全て変更した。  

## db/schema.rbの書式変更
`bundle exec rake db:migrate` すると自動で `db/schema.rb` に変更が加わりました．
スキーマの書き方がrails5から変わったらしいです．

例）assign_rental_itemsのスキーマの変更点
```diff
- create_table "assign_rental_items", force: :cascade do |t|
+ create_table "assign_rental_items", id: :serial, force: :cascade do |t|
    t.integer  "rental_order_id",  null: false
    t.integer  "rentable_item_id", null: false
    t.integer  "num",              null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
+     t.index ["rentable_item_id"], name: "index_assign_rental_items_on_rentable_item_id"
+     t.index ["rental_order_id"], name: "index_assign_rental_items_on_rental_order_id"
end
- add_index "assign_rental_items", ["rentable_item_id"], name: "index_assign_rental_items_on_rentable_item_id", using: :btree
- add_index "assign_rental_items", ["rental_order_id"], name: "index_assign_rental_items_on_rental_order_id", using: :btree 
```

## マイグレーションファイルの書式変更
マイグレーションファイルにバージョンの指定が必要になりました．
今あるマイグレーションファイルはrails4.2のものなので，全てのマイグレーションファイルの継承の部分を

```ruby
class ClassName < ActiveRecord::Migration[4.2]
```

の様に変更しました．

## therubyracerの削除
`therubyracer` というgemはなんか良くないらしいのでGemfileから削除しました．
nodejsをインストールすることで代用できるそうです．

