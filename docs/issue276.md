# issue276

# デフォルトでassociationが設定されたモデルを自動でfilterに含めないようにする

`config/initializers/active_admin.rb` で次の設定を行う

```
config.include_default_association_filters = false
```

associationが設定されたモデルを自動でfilterに含めてくれなくなるため，必要な部分は手動で設定する必要があります．

# filterに含めたい項目

各モデルのassociationを参考にfilterの項目を決定します．
検索機能を使わないと思われるもの，デフォルトおよび現在の設定で不足ないものは除外します．

### Group

- デフォルトである
    * 運営団体の名称
    * 主な活動内容
- 設定しないといけない
    * 年度
    * 参加形式

### User

- デフォルトである
    * email
- 設定しないといけない
    * role_id

### StageOrder

デフォルトのフィルターの場所・時間がID指定なので，セレクトボックスにする

- デフォルトである
    * 天候
    * 場所
    * 時間
- 設定しないといけない
    * 年度
    * 運営団体の名称
    * 運営団体のセレクトボックス
    * 場所セレクトボックス
    * 開催日

### AssignStage

- 設定しないといけない
    * 天候
    * 場所
    * 時間
    * 年度
    * 運営団体の名称
    * 運営団体のセレクトボックス
    * 開催日

### PlaceOrder

デフォルトのフィルターの場所がID指定なので，セレクトボックスにする

- デフォルトである
    * 場所
    * 備考
- 設定しないといけない
    * 年度
    * 運営団体の名称
    * 運営団体のセレクトボックス
    * 場所名セレクトボックス

### PlaceAllowList

- 設定しないといけない
    * 場所名セレクトボックス
    * 団体カテゴリ名セレクトボックス

### AssignGroupPlace

- 設定しないといけない
    * 年度
    * 運営団体の名称
    * 運営団体のセレクトボックス
    * 場所

### RentalOrder

- デフォルトである
    * 数量
- 設定しないといけない
    * 年度
    * 運営団体の名称
    * 運営団体のセレクトボックス
    * 物品名セレクトボックス

### RentableItem

- デフォルトである
    * 貸出可能数
- 設定しないといけない
    * 物品名
    * 貸出場所
    * 保管場所

### RentalItemAllowList

- 設定しないといけない
    * 物品名セレクトボックス
    * 団体カテゴリ名セレクトボックス

### StockerItem

- デフォルトである
    * 数量
- 設定しないといけない
    * 年度
    * 物品名セレクトボックス
    * 保管場所

### PurchaseList

- デフォルトである
    * 購入品のリスト
- 設定しないといけない
    * 年度
    * 運営団体の名称
    * 運営団体のセレクトボックス
    * 販売食品
    * 調理あり・なし
    * 仕入先
    * 仕入品名


# ActiveAdminでメソッド参照がうまくいかない

`app/admin/stage_order.rb` で定義された `set_time_params` メソッドをフィルタ定義の前で呼び出しても `no method error` が出た． `before_filter` の中で呼び出したり試してみたが，うまくいかなかった．controllerでも同じコードが記述されているので，せっかくだからmodelで各プロパティを返すメソッドを定義することにした．

各時間を返すメソッドを `app/models/stage_order.rb` に定義

```diff
+  def self.time_points
+    time_points = [["", ""]]
+    (8..21).each do |h|
+      %w(00 15 30 45).each do |m|
+        time_points.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
+      end
+    end
+    time_points
+  end
+
+  def self.time_intervals
+    time_intervals = [["", ""],
+                     ["0分", "0分"],
+                     ["5分", "5分"],
+                     ["10分", "10分"],
+                     ["15分", "15分"],
+                     ["20分", "20分"]]
+  end
+
+  def self.use_time_intervals
+    use_time_intervals = [["", ""],
+                          ["30分", "30分"],
+                          ["1時間", "1時間"],
+                          ["1時間30分", "1時間30分"],
+                          ["2時間", "2時間"]]
+  end
 end
```

定義したメソッドを使うようにする

`app/admin/stage_order.rb`

```diff
       f.input :is_sunny
       f.input :stage_first, :as => :select, :collection => Stage.all
       f.input :stage_second, :as => :select, :collection => Stage.all
-      f.input :use_time_interval, :as => :select, :collection => @use_time_intervals
-      f.input :prepare_time_interval, :as => :select, :collection => @time_intervals
-      f.input :cleanup_time_interval, :as => :select, :collection => @time_intervals
-      f.input :prepare_start_time, :as => :select, :collection => @time_points
-      f.input :performance_start_time, :as => :select, :collection => @time_points
-      f.input :performance_end_time, :as => :select, :collection => @time_points
-      f.input :cleanup_end_time, :as => :select, :collection => @time_points
+      f.input :use_time_interval, :as => :select, :collection => StageOrder.use_time_intervals
+      f.input :prepare_time_interval, :as => :select, :collection => StageOrder.time_intervals
+      f.input :cleanup_time_interval, :as => :select, :collection => StageOrder.time_intervals
+      f.input :prepare_start_time, :as => :select, :collection => StageOrder.time_points
+      f.input :performance_start_time, :as => :select, :collection => StageOrder.time_points
+      f.input :performance_end_time, :as => :select, :collection => StageOrder.time_points
+      f.input :cleanup_end_time, :as => :select, :collection => StageOrder.time_points
     end
     f.actions
   end
@@ -108,25 +108,16 @@ ActiveAdmin.register StageOrder do
   filter :fes_year
   filter :group_name, as: :string
   filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(3)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

 
 end
-
-def set_time_params
-  @time_points = [["", ""]]
-  (8..21).each do |h|
-    %w(00 15 30 45).each do |m|
-      @time_points.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
-    end
-  end
-  @time_intervals = [["", ""],
-                    ["0分", "0分"],
-                    ["5分", "5分"],
-                    ["10分", "10分"],
-                    ["15分", "15分"],
-                    ["20分", "20分"]]
-  @use_time_intervals = [["", ""],
-                         ["30分", "30分"],
-                         ["1時間", "1時間"],
-                         ["1時間30分", "1時間30分"],
-                         ["2時間", "2時間"]]
-end
```

`app/controllers/stage_orders_controller.rb`

```diff

 
     # 時刻入力の選択肢生成
     def set_time_params
-      @time_points = [["", ""]]
-      (8..21).each do |h|
-        %w(00 15 30 45).each do |m|
-          @time_points.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
-        end
-      end
-      @time_intervals = [["", ""],
-                        ["0分", "0分"],
-                        ["5分", "5分"],
-                        ["10分", "10分"],
-                        ["15分", "15分"],
-                        ["20分", "20分"]]
-      @use_time_intervals = [["", ""],
-                             ["30分", "30分"],
-                             ["1時間", "1時間"],
-                             ["1時間30分", "1時間30分"],
-                             ["2時間", "2時間"]]
+      @time_points = StageOrder.time_points
+      @time_intervals = StageOrder.time_intervals
+      @use_time_intervals = StageOrder.use_time_intervals
     end
 end
diff --git a/app/models/stage_order.rb b/app/models/stage_order.rb
index e4791b1..956d34e 100644
--- a/app/models/stage_order.rb
+++ b/app/models/stage_order.rb
@@ -136,4 +136,30 @@ class StageOrder < ActiveRecord::Base
     end
   end

```