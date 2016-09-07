# issue90 実装ログ

# コントローラの生成

```sh
$ bundle exec rails g controller GroupInformationPages
Running via Spring preloader in process 35929
      create  app/controllers/group_information_pages_controller.rb
      invoke  erb
      create    app/views/group_information_pages
      invoke  helper
      create    app/helpers/group_information_pages_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/group_information_pages.coffee
      invoke    scss
      create      app/assets/stylesheets/group_information_pages.scss
```

# 書類生成用メソッドの作成

scopeを作る

`app/models/power_order.rb`を編集

```diff
+  scope :year, -> (year) {joins(:group).where(groups: {fes_year_id: year})}
```

pdf生成用メソッドを追加
`app/controllers/group_information_pages_controller.rb`を編集

```diff
 class GroupInformationPagesController < ApplicationController
+  def preview_pdf_page(template_name, output_file_name)
+    respond_to do |format|
+      format.pdf do
+        # 詳細画面のHTMLを取得
+        html = render_to_string template: "group_information_pages/#{template_name}"
+
+        # PDFKitを作成
+        pdf = PDFKit.new(html, encoding: "UTF-8")
+
+        # 画面にPDFを表示する
+        # to_pdfメソッドでPDFファイルに変換する
+        # 他には、to_fileメソッドでPDFファイルを作成できる
+        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
+        send_data pdf.to_pdf,
+          filename:    "参加団体情報書類_#{output_file_name}.pdf",
+          type:        "application/pdf",
+          disposition: "inline"
+      end
+    end
+  end
+
+  def group_information_sheet
+    this_year = FesYear.this_year
+
+    @groups = Group.year(this_year)
+    @fes_date = FesDate.where(fes_year_id: this_year)
+    @rentables = RentableItem.year(this_year)
+    @assignment_items = AssignRentalItem.year(this_year)
+
+    preview_pdf_page('group_information_sheet', "参加団体情報管理表")
+  end
 end
```

# 書類生成用のリンクを追加

`app/admin/dashboard.rb`を編集

```diff
+    columns do
+      column do
+        panel "参加団体情報書類" do
+          li link_to("参加団体情報管理表", group_information_pages_group_information_sheet_path(format: 'pdf'))
+        end
+      end
+    end
+
```

ルーティングの設定
`config/routes.rb`を編集

```diff
+  get 'group_information_pages/group_information_sheet'
```

# pdfのViewを作成

Viewを作成
`app/views/group_information_pages/group_information_sheet.pdf.erb`を作成

```diff
+<style type='text/css'>
+   body {
+       font-family: "IPAGothic"
+   }
+  table {
+    border-collapse: separate;
+    border-spacing: 0;
+    vertical-align: middle;
+    width: 100%;
+    table-layout: fixed;
+  }
+  caption, th, td {
+    text-align: center;
+    font-weight: normal;
+    vertical-align: middle;
+    border: solid 1px;
+    padding: 0.5em;
+  }
+  .pagebreak{
+    page-break-after: always;
+  }
+</style>
+<% blank_columns = 3 # 空の行の数%>
+<% @groups.each_with_index do |group, i| %>
+  <div class='pagebreak'>
+  <h1 align="center">参加団体情報管理表</h1>
+  <table align="center">
+    <tr>
+      <td width="20%">No.</td>
+      <td width="65%"><%= i + 1 %></td>
+      <td width="15%"><%= group.id.to_s %></td>
+    </tr>
+    <tr>
+      <td height="50px">団体名</td>
+      <td colspan="2"><%= group.name %></td>
+    </tr>
+    <tr>
+      <td>分類</td>
+      <td colspan="2"><%= group.group_category.to_s %></td>
+    </tr>
+  </table>
+  <table align="center">
+    <tr>
+      <td width="20%" rowspan="2">活動時間</td>
+      <td width="40%"><%= @fes_date.where(days_num: 1).first.to_s + " (1日目)"%></td>
+      <td width="40%">10：00～17：00</td>
+    </tr>
+    <tr>
+      <td width="40%"><%= @fes_date.where(days_num: 2).first.to_s + " (2日目)"%></td>
+      <td width="40%">10：00～17：00</td>
+    </tr>
+    <tr>
+      <td height="50px">場所</td>
+      <td colspan="2"><%= get_place_by_group(group.id) %></td>
+    </tr>
+    <tr>
+      <td>電力</td>
+      <td colspan="2"><%= PowerOrder.where(group_id: group.id).first.try(:power) %> [W]</td>
+    </tr>
+  </table>
+  <br>
+  <div>◆貸出物品一覧</div>
+  <table algin="center">
+    <thead>
+      <tr>
+        <td width="20%">物品名</td>
+        <td width="30%">借りる場所</td>
+        <td width="10%">数量</td>
+        <td width="15%">貸出日</td>
+        <td width="15%">返却日</td>
+        <td width="10%">返却チェック</td>
+      </tr>
+    </thead>
+    <tbody>
+      <% assign_items = get_assign_rental_items_by_group(group.id) %>
+      <% RentalItem.all.each_with_index do |rental_item, j| %>
+        <% assign_item = find_assign_rental_item_by_rental_item_id(assign_items, rental_item.id) %>
+        <tr>
+          <td><%= rental_item.to_s %></td>
+          <td><%= assign_item.try(:rentable_item).try(:stocker_place).to_s %></td>
+          <td><%= assign_item.try(:num) %></td>
+          <td><%= GroupManagerCommonOption.first.rental_item_day %></td>
+          <td><%= GroupManagerCommonOption.first.return_item_day %></td>
+          <% if j == 0 then %>
+            <td rowspan="<%= RentalItem.all.count + blank_columns %>"></td>
+          <% end %>
+        </tr>
+      <% end %>
+      <% blank_columns.times do %>
+        <tr>
+          <td height="30px"></td>
+          <td></td>
+          <td></td>
+          <td></td>
+          <td></td>
+        </tr>
+      <% end %>
+    </tbody>
+  </table>
+  <br>
+  <div>
+  《注意事項》<br>
+    ●  物品は借用・返却場所を間違えないようにしてください．<br>
+    ●  返却時は本部でチェックを受けてください．<br>
+    ●  備品等は絶対に汚さないように使用し，綺麗にしてから返却して下さい．<br>
+  </div>
+  </div>
+<% end %>
```

煩雑なリレーション操作をHelperに書く

```diff
 module GroupInformationPagesHelper
+  def get_place_by_group(group_id)
+    place = AssignGroupPlace.find_by_group(group_id).first.try(:place_id)
+    Place.where(id: place).first.to_s
+  end
+
+  def get_assign_rental_items_by_group(group_id)
+    AssignRentalItem.find_by_group(group_id)
+  end
+
+  def find_assign_rental_item_by_rental_item_id(assign_rental_items, rental_item_id)
+    assign_rental_items.joins(rentable_item: [:stocker_item])
+        .where(stocker_items: {rental_item_id: rental_item_id}).first
+  end
 end
```

# Viewの表示に必要なscopeを作成

総務が確定した場所の情報をグループのIDで検索するスコープ
`app/models/assign_group_place.rb`を編集

```diff
+  scope :find_by_group, -> (group_id) {joins(:place_order).where(place_orders: {group_id: group_id})}
```

総務が確定した貸出物品の情報をグループのIDで検索するスコープ
`app/models/assign_rental_item.rb`を編集

```diff
+  scope :find_by_group, -> (group_id) {joins(:rental_order).where(rental_orders: {group_id: group_id})}
```