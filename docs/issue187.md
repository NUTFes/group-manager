# issue187
管理者ページの参加団体のラベルを英語表記から日本語表記に変更

## 変更点
config/locales/01_model/ja.yml  
attributes:　　group:　の変更

```diff
group:
  name: 運営団体の名称
      group_category_id: 参加形式
+          user_name: 氏名
+          user_id: Email
+          user_tel: 電話番号
+          subrep_name: 副代表 氏名
+          subrep_tel: 副代表 電話番号
  activity: 主な活動内容
+          created_at: 作成日
+          updated_at: 更新日
+          fes_year_id: 年度
group_project_name:
  group: 運営団体の名称
  project_name: 企画名
```

app/admin/group.rb 内での変更
```diff
show do
    attributes_table do
      row :id
      row :name
-     row :group_category_id
+     row :group_category
      row :user_name do |group|
        group.user.user_detail.name_ja
      end
```
