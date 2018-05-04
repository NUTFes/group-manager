#　issue240
入力フォームのラベルを統一（運営団体の名称とGroup）

## 概要
副代表登録と使用電力の申請の入力フォームで”Group”と表示されていたラベルを他ページと統一するために”運営団体の名称”に変更


## 変更前　　

config/locales/01_model/ja.yml
```
sub_rep:   
group_name: 運営団体の名称

power_order:  
  group_name: 運営団体の名称
```

## 変更後
  ```
  sub_rep:   
  group: 運営団体の名称

  power_order:  
    group: 運営団体の名称
  ```
