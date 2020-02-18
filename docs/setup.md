# SETUP

各環境でアプリを動かす手順

# rubyのインストール
※ 導入するrubyのバージョンは2.2.0  (gemfileで確認して下さい)  
\# mac  
[Homebrewのインストールとrbenvのインストール Mac編]( http://qiita.com/issobero/items/e0443b79da117ed48294)
# postgresqlの準備
```sh
#mac
brew install postgresql

# linux
apt-get install postgresql
# コマンドはこのへんにあるはず
# /usr/lib/postgresql/<バージョン>/bin/
sudo passwd postgres
```

[linuxの場合は個々を参考に](http://ossfan.net/setup/postgresql-20.html)

```sh
# postgresqlのデータベースdirを指定する
export PGDATA=/usr/local/var/postgres # mac
export PGDATA=/var/lib/pgsql/data     # linux

# $PGDATAを初期化
initdb --encoding=UTF-8 --locale=ja_JP.UTF-8
```
ここでmacの人は"もう既にディレクトリがあるよ！"と怒られるかもしれない.
こんなエラーが出たら``/usr/local/var/postgres``ディレクトリを消す.
```sh
#エラー文
initdb: directory "/usr/local/var/postgres" exists but is not empty
If you want toreate a new database system, either remove or empty
the directory "/usr/local/var/postgres" or run initdb
with an argument other than "/usr/local/var/postgres".

# /usr/local/var/postgresを消す
rm -rf /usr/local/var/postgres
```
そしてもう一度``initdb``を行う.
# development環境

```sh
git clone
cd group_manager
bundle install --path vendor/bundle
pg_ctl start
rake db:create  # postgresqlのDB作成
rake db:migrate # マイグレーション実行, モデルが生成されてDBに反映される
rake db:seed_fu # 初期値投入
```

環境変数を設定する.
`~/.***rc`に書いとくとよい.

```sh
export SMTP_ADRESS=smtp.gmail.com
export SMTP_PORT=587
export EMAIL_DOMAIN=gmail.com
export SMTP_AUTH=plain
export SMTP_TLS=false
export EMAIL_USERNAME=<ユーザ名>@gmail.com
export EMAIL_BCC='<BCC送信先>@gmail.com'
export EMAIL_PASSWORD=<パスワード> # gmailの場合は2段階認証を設定後, アプリ固有のパスワードを設定する
export EMAIL_SENDER='送信者名 <ユーザ名@gmail.com>'
export DEFAULT_URL=https://<アプリ名>.herokuapp.com
```

環境変数を追加, 変更, 削除した場合は  
terminal上で以下を必ず実行する.  
```
# 設定ファイルの再読み込み
source $HOME/.***rc
```


あとは`bundle exec rails s`でサーバ起動,  
`localhost:3000`でアクセス

# production環境

production環境の設定を全てやる.
追加して

```sh
# これも`~/.***rc`に書いとくとよい.
export GROUP_MANAGER_DATABASE_PASSWORD=<パスワード>
export GROUP_MANAGER_ADMIN_EMAIL=<管理者用初期アカウントのメールアドレス>
export GROUP_MANAGER_ADMIN_PASSWORD=<管理者用初期アカウントのパスワード>

# postgresqlのユーザ作成( production環境のDBで必要 )
createuser -P -d group_manager
# ここでパスワードを聞かれるので, $GROUP_MANAGER_DATABASE_PASSWORDと同じものを打つ.

# production環境でDB作成, マイグレーション, 初期値投入
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed_fu RAILS_ENV=production

# terminal
$ source ~/.***rc
```

`bundle exec rails s -e production`でサーバ起動,  
`localhost:3000`でアクセス  

```sh 
# エラー
`raise_no_secret_key': Devise.secret_key was not set. Please add the following to your Devise initializer:
```

になった.

[rakeがDevise.secret_key was not setと出て失敗するときの対処法](http://hack.aipo.com/archives/7992/)
を参考に, `config/initializers/devise.rb`に追加する.

ソースにsecret_keyを入れたくない.
環境変数から設定する.

```
# config/initializers/devise.rb

Devise.setup do |config|
    ...
  config.secret_key = ENV['DEVICE_SECRET_KEY']
    ...
``` 

```

# terminal上でsecret_keyを生成
$ rake secret

# ~/.***rcに追加
export DEVICE_SECRET_KEY=<生成したsecret_key>

# terminal
$ source ~/.***rc
```

これで

`bundle exec rails s -e production`でサーバ起動,  
`localhost:3000`にアクセス  

```
# エラー
Missing `secret_token` and `secret_key_base` for 'production' environment, set these values in `config/secrets.yml` 
```

secret_key_baseを追加する   
環境変数から設定する. 

```
# config/secrets.yml
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  ...

# terminalでsecret_keyを生成
$ rake secret

# ~/.***rc 
export SECRET_KEY_BASE=<secret_key>

# terminal
$ source ~/.***rc
```


サーバ起動とアクセス

```sh
bundle exec rails s -e production
```

css, jsがうまく読み込めていない  

[RailsをローカルでProductionモードで起動させる方法](http://ruby-rails.hatenadiary.com/entry/20141110/1415623670)を参考に,  
`~/.***rc`に環境変数を追加する
```
# ~/.***rcに追加
export RAILS_SERVE_STATIC_FILES=true

# terminal 
source ~/.***rc
```

サーバ起動とアクセス

```sh
bundle exec rails s -e production
```

# VPS(サクラサーバー)
## 現在の状況
- ユーザ: root
- directory: `/var/www/group-manager`
- puma起動コマンド: `bin/rails s -e production`
- pumaが起動しているかの確認: `ps aux|grep puma`
- pumaの停止: `bundle exec pumactl -P tmp/pids/puma.pid halt`
- pumaの再起動: `bundle exec pumactl -P tmp/pids/puma.pid restart`
- nginxの設定ファイル: `/etc/nginx/sites-available/group-manager.nutfes.net`
- 公開URL: https://group-manager.nutfes.net

## デプロイの仕方
- VPSにrootユーザーでログイン
  - `sudo su`
- `cd /var/www/group-manager`
- `git pull --rebase`
- `bin/rake db:create RAILS_ENV=production` (最初のみ)
- `bin/rake db:migrate RAILS_ENV=production` (必要に応じて)
- `bin/rake db:seed_fu RAILS_ENV=production` (seedデータを書き換えた場合)
- `bundle exec pumactl -P tmp/pids/puma.pid restart`

## アプリの配置場所
今後も新しいアプリができて，それをデプロイするときは`/var/www/`の直下にアプリのディレクトリを保存する．

## 追記
環境変数`EMAIL_PASSWORD`はGmail(nutfes.info)から生成されるアプリケーションごとに固有のパスワード(アプリパスワード)を設定する必要がある．  
アプリパスワードはnutfes.infoアカウントにログインし，下のリンクを開いて生成できる．  
https://security.google.com/settings/security/apppasswords  
公開するサーバを移行するような場合はこのパスワードも設定し直す必要がある．  

