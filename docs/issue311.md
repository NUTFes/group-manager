# issue311

### issueの内容
stocker_itemモデルからfes_year_idカラムを消す

# やること

0. fes_year_idを消して良いかチェックする
1. stocker_itemレコードのfes_year_idが最新（2018年）のデータ以外消す
2. fes_year_idを消すマイグレーションを作成
3. マイグレーションを実行
4. 管理画面のViewから年度に関する項目を消す

# 0. fes_year_idを消して良いかチェックする

fes_year_idを消した環境でアプリケーションが想定外の動作をすることがないように，fes_year_idが消されても正常に動作するかどうか確認する必要がある．

Githubで検索したところ，stocker_itemを管理画面でなく，User側のViewから編集する機能があった．ここで，fes_year_idが使われているが，この機能は現状使用されていないため，削除することにした．

```bash
$ bundle exec rails destroy controller stocker_items # stocker_itemのコントローラを消す．同時にViewも消える．
```

他にも`models/stocker_item.rb`のアソシエーションや，`models/rentable_item.rb`のyearスコープ，`db/fixtures/development/6_stocker_item.rb`からfes_yearを削除した．


# 1. stocker_itemレコードのfes_year_idが最新（2018年）のデータ以外消す

現状は年度ごとに物品の在庫が管理されているため，1つの物品の種類に対して年度数分のレコードが存在する．

このままfes_year_idカラムを消してしまうと，最新（2018年）のデータがどれか分からなくなってしまうので，最新（2018年）のデータ以外を全て消す必要がある．

まずは消せるかテストする．

```bash
$ bundle exec rails c --sandbox # sandboxモードでrails consoleを起動
> StockerItem.where("fes_year_id < 4").destroy_all
StockerItem Load (0.5ms)  SELECT "stocker_items".* FROM "stocker_items" WHERE (fes_year_id < 4)
   (0.1ms)  SAVEPOINT active_record_1
  SQL (0.8ms)  DELETE FROM "stocker_items" WHERE "stocker_items"."id" = $1  [["id", 1]]
   (0.1ms)  ROLLBACK TO SAVEPOINT active_record_1
ActiveRecord::InvalidForeignKey: PG::ForeignKeyViolation: ERROR:  update or delete on table "stocker_items" violates foreign key constraint "fk_rails_c0f2b4bbce" on table "rentable_items"
DETAIL:  Key (id)=(1) is still referenced from table "rentable_items".
: DELETE FROM "stocker_items" WHERE "stocker_items"."id" = $1
from /Users/kkoike/Development/rails_projects/group-manager/vendor/bundle/ruby/2.2.0/gems/activerecord-4.2.10/lib/active_record/connection_adapters/postgresql_adapter.rb:602:in `exec_prepared'
```

外部キー制約で削除できない．
関連付けが設定されていないからだと思われる．ついでに `dependent: :destroy` をつける．

```diff
# app/models/stocker_item.rb

   belongs_to :rental_item
   belongs_to :stocker_place
   belongs_to :fes_year
+  has_many :rentable_items, dependent: :destroy

   validates :rental_item_id, :stocker_place_id, :num, :fes_year_id, presence: true
   validates :num, numericality: {

# app/models/rentable_item.rb

 class RentableItem < ActiveRecord::Base
   belongs_to :stocker_item
   belongs_to :stocker_place
-  has_many :assign_rental_item
+  has_many :assign_rental_item, dependent: :destroy

   validates :stocker_item_id, :stocker_place_id, :max_num, presence: true
   validates :max_num, numericality: {
```

もう一度消せるかテストする．

```
$ bundle exec rails c --sandbox # sandboxモードでrails consoleを起動
> StockerItem.where("fes_year_id < 4").destroy_all
```

消えた．

次にこの動作をheroku上で実行するtaskを作る．レコードを消す作業はheroku上のrails consoleから行っても良いが，taskを用意しておくと，deployする人が楽だし，他の作業者環境との統一に便利．

```bash
$ bundle exec rails g task stocker_item # taskの生成
```

```ruby
# lib/tasks/stocker_item.rake

namespace :remove_records_before_2018_from_stocker_items do
  desc "stocker_itemの2018年以前のデータを全て消す"

  task destroy_before_2018: :environment do
    StockerItem.where("fes_year_id < 4").destroy_all
  	puts 'done.'
  end

end
```

`bundle exec rake stocker_item:destroy_before_2018`で消える．

# 2. fes_year_idを消すマイグレーションを作成

```bash
$ bundle exec rails g migration RemoveFesYearFromStockerItems fes_year_id:integer
```

```ruby
# db/migrate/20181022132431_remove_fes_year_from_stocker_items.rb

class RemoveFesYearFromStockerItems < ActiveRecord::Migration
  def up
    remove_column :stocker_items, :fes_year_id, :integer
  end

  def down
    add_column :stocker_items, :fes_year_id, :integer
  end
end

```

# 3. マイグレーションを実行

```bash
$ bundle exec rake db:migrate
== 20181022132431 RemoveFesYearFromStockerItems: migrating ====================
-- remove_column(:stocker_items, :fes_year_id, :integer)
   -> 0.0115s
== 20181022132431 RemoveFesYearFromStockerItems: migrated (0.0116s) ===========
```

これで年度情報が消えた．

# 4. 管理画面のViewから年度に関する項目を消す

```diff
# app/admin/stocker_item.rb

   index do
     selectable_column
     id_column
-    column :fes_year
     column :stocker_place
     column :rental_item
     column :num
@@ -12,7 +11,6 @@ ActiveAdmin.register StockerItem do
   end

   preserve_default_filters!
-  filter :fes_year
   filter :rental_item
   filter :stocker_place
```
