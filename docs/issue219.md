# issue219
---
企画名が複数作成できる問題


## 変更点
app/models/group_project_name.rbに
`validate :group_id, uniqueness: true`
を追加
