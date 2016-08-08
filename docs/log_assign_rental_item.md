

# 貸出物品入力機能

### 要求仕様
[貸出物品割当入力機能](https://github.com/NUTFes/group-manager/issues/143)  
作業中は, 必ず細かくgit commitしておくこと.  
特に, ``rails g`` や``rake``コマンドの後は大きな変更が加えられるので,   
その時点の状態を保存しておく.   
このログに書く``commit``という文字を見たらコミットしておくこと.

---------------------------------
#### MVC作成

今回は, 管理画面(activeadmin)ではなくRailsの通常画面で構築するので,   
Rails g でMVCを作成する.  

```
# MVC生成
$ bundle exec rails g scaffold AssignRentalItem rental_order:references rentable_item:references num:integer

# DBにmigrateファイルを適用
$ bundle exec rake db:migrate
```

``commit``

#### Bootstrapの適用

Bootstrapというよく使うCSSをとりまとめたライブラリがある.    
Group-managerでは, Bootstrapで見た目を指定しているためこれを適応する.  
[Techacademy Bootstrap](http://techacademy.jp/magazine/6270)  

```
# css適用
$ bundle exec rails g bootstrap:themed AssignRentalItems
```

``commit``

