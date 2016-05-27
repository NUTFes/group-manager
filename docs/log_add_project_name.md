## 参加団体の「企画名」を入力する機能の追加

### 企画名を追加する経緯
  総務は, 参加団体から「参加団体名」と「企画名」を聴取し管理している.  
現状のシステムでは「参加団体名」のみを入力するようになっている. 
そこで, 今回は「企画名」を入力する機能を追加する.  

### Groupテーブルに企画名(project_name)カラムを追加する

Migrationファイルの追加

```terminal 
$ bundle exec rails g migration AddColumnToGroup
```

変更点
```diff
+class AddColumnToGroup < ActiveRecord::Migration
+  def change
+    add_column    :groups, :project_name, :string, defalut: "未回答"
+  end
+end
```

### Groupモデルのvalidateを追加

```diff
# app/models/group.rb
-  validates :name, presence: true, uniqueness: true
+  validates :name, presence: true, uniqueness: { scope: :fes_year }
+  validates :project_name, presence: true, uniqueness: true
```
 

### ユーザ側 団体一覧の改修

企画名を表示する列を増やす
``/app/views/groups/index.html.erb``を編集

```diff
  <thead>
  <tr>
  <th><%= model_class.human_attribute_name(:name) %></th>
+ <th><%= model_class.human_attribute_name(:project_name) %></th>
  <th><%= model_class.human_attribute_name(:group_category) %></th>
  <th><%= model_class.human_attribute_name(:activity) %></th>
  <th><%= model_class.human_attribute_name(:created_at) %></th>

  ...

  <% @groups.each do |group| %>
  <tr>
  <td><%= group.name %></td>
+ <td><%= group.project_name %></td>
  <td><%= group.group_category.name_ja %></td>
  <td><%= group.activity %></td>
  <td><%=l group.created_at %></td>
```

項目名を日本語化
``config/locales/01_model/ja.yml``を編集

```diff
  attributes:
    group:
      name: 運営団体の名称
+     project_name: 企画名・店名
      group_category: 参加形式
      activity: 主な活動内容
      first_question: 質問・要望など
```

### 参加団体入力フォームに企画名入力の欄を追加

入力フォームに``project_name``カラムを追加.  
controller側でパラメタのpermitを指定していたことに気付けずにハマった.  

``app/views/groups/_form.html.erb``を編集

```diff
    hint: t(".hint_name")
  %>
  <%= error_span(@group[:name]) %>
+
+ <%= f.input :project_name,
+   hint: t(".hint_project_name")
+ %>
+ <%= error_span(@group[:project_name]) %>
+
  <%= f.association :group_category,
    hint: t(".hint_group_category")
  %>
```

コントローラでフォームで追加可能なパラメタの権限を付与する
``app/controllers/groups_controller.rb``を編集

```diff
def group_params
  params.require(:group).
-   permit(:name, :group_category_id, :user_id, :activity, :first_question,
+   permit(:name, :project_name, :group_category_id, :user_id, :activity, :first_question,:fes_year_id)
  end
end
```

入力時のヒントを追加
``config/locales/03_views/ja.yml``を編集

```diff
  groups:
    form:
      hint_name: 店名とは異なります 例) 技大祭実行委員会
+     hint_project_name: 店名や展示・演舞名を入力してください
      hint_group_category: 1参加団体につき1つの形式を選択してください. 複数の形式を希望する場合はそれぞれ異なる参加団体でご登録下さい.
      hint_activity: 例) 〇〇の販売, 展示
      hint_questions: ご不明点がありましたらご記入ください.
```

### 企画名が未登録の場合warningを表示する


企画名を持たない参加団体を取得し変数に記録する
``app/controllers/group_base.rb``を編集する

```diff
# ログインユーザの所有しているグループのうち，
# 副代表が登録されていない団体数を取得する
-    @num_nosubrep_groups = @groups.count -
-                           Group.where(fes_year: this_year).
-                                 get_has_subreps(current_user.id).count
+    @num_nosubrep_groups    = @groups.count -
+                              @groups.get_has_subreps(current_user.id).count
+
+    # ログインユーザの所有しているグループのうち，
+    # 企画名を持たない参加団体を取得する
+    @num_no_project_groups  = @groups.count -
+                              @groups.where.not(project_name: nil).count
+
+
end
```


企画名を持たない団体の判別
``app/helpers/welcome_helper.rb``を編集

```diff
 module WelcomeHelper
  # 表示するパネルの判定
- def show_enable_panel(panel, num_nosubrep_groups)
+ def show_enable_panel(panel, num_nosubrep_groups, num_no_project_groups)
  # 参加団体，副代表以外は副代表が未登録の団体があれば表示しない
- if panel.id > 2 && num_nosubrep_groups > 0
+ if panel.id > 2 && (num_nosubrep_groups > 0 || num_no_project_groups > 0)
    return
  end
```


企画名を持たない団体がある場合, 警告の表示を行う
``app/views/groups/index.html.erb``を編集

```diff
  <div class="page-header">
    <h1><%=t '.title', :default => model_class.model_name.human.pluralize.titleize %></h1>
  </div>
+
+ <%# 企画名未登録の警告 %>
+ <%= render partial: 'shared/warning_project_name' %>
+
  <table class="table table-striped">
    <thead>
      <tr>
```

表示するパーシャルの追加
``app/views/welcome/_panel_group.html.erb``を編集

```diff
- <div class="panel panel-primary">
-   <div class="panel-heading">
+ <% if @num_no_project_groups > 0 %>
+   <%# 企画名を未登録の団体がある場合は枠をwarningへ変更 %>
+   <div class="panel panel-warning">
+ <% else %>
+   <div class="panel panel-primary">
+ <% end %>
+   <div class="panel-heading">
    <h3 class="panel-title">参加団体</h3>
  </div>
  <div class="panel-body">

...

<%# 副代表未登録の警告 %>
<%= render partial: 'shared/warning_subrep' %>
+<%# 企画名未登録の警告 %>
+<%= render partial: 'shared/warning_project_name' %>

<% @config_panel.each do |panel| %>
-  <%= show_enable_panel(panel, @num_nosubrep_groups) %>
+  <%= show_enable_panel(panel, @num_nosubrep_groups, @num_no_project_groups) %>
<% end %>
```

### 参加団体のShowページに企画名を追加

``app/views/groups/show.html.erb``を編集

```diff
  <dt><strong><%= model_class.human_attribute_name(:name) %>:</strong></dt>
  <dd><%= @group.name %></dd>
+ <dt><strong><%= model_class.human_attribute_name(:project_name) %>:</strong></dt>
+ <dd><%= @group.project_name %></dd>
  <dt><strong><%= model_class.human_attribute_name(:group_category) %>:</strong></dt>
  <dd><%= @group.group_category.name_ja %></dd>
  <dt><strong><%= model_class.human_attribute_name(:activity) %>:</strong></dt>
```

