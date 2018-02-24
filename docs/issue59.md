# Userが誰も消せない問題の解決ログ

# 現状把握

まずは実際の挙動を把握します．

```
$ bundle exec rails s -e production # production 環境でアプリを立ち上げる
```

管理画面の`/users`ページから削除してみましたが以下のエラーメッセージが表示されました．

```
PG::ForeignKeyViolation: ERROR: update or delete on table "users" violates foreign key constraint "fk_rails_12e0b3043d" on table "user_details" DETAIL: Key (id)=(190) is still referenced from table "user_details". : DELETE FROM "users" WHERE "users"."id" = $1
```

外部キー制約のようですね．

# dependentオプションをつける

削除対象を主キーとするレコードを同時に消さないとエラーがでます．
Railsではモデルの中で定義している`has_many`とかのアソシエーションに`dependent: :destroy`オプションをつけてやれば，主キーを削除したときに勝手に関連するレコードを削除してくれます．
例えば次のようにします．

```diff
-  has_one :user_detail  # UserからUserDetailを参照可能にする
-  has_many :groups
+  has_one :user_detail, dependent: :destroy  # UserからUserDetailを参照可能にする
+  has_many :groups, dependent: :destroy
```

後はuserが削除できるようになるまでこれを繰り返します．
最終的には以下のファイルのアソシエーションにdependentオプションを追加しました

```
app/models/food_product.rb
app/models/group.rb
app/models/place_order.rb
app/models/rental_order.rb
app/models/stage_order.rb
app/models/user.rb
```
