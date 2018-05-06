# issue249 ステージ利用申請に準備片付け時間を追加

## やったこと
- stage_ordersのカラムを変更
- 利用時間の選択肢を変更
- バリデーションを変更
- 選択肢のチェックで表示するフォームを切り替える

## stage_ordersのカラムの変更

```diff
group_id: integer
is_sunny: boolean
fes_date_id: integer
stage_first: integer
stage_second: integer
- time_interval: string
- time_point_start: string
- time_point_end: string
+ use_time_interval: string, default=""  # 利用時間
+ prepare_time_interval: string, default=""  # 準備時間
+ cleanup_time_interval: string, default=""  # 片付け時間
+ prepare_start_time: string, default=""  # 準備開始時刻
+ performance_start_time: string, default=""  # 公演開始時刻
+ performance_end_time: string, default=""  # 公演終了時刻
+ cleanup_end_time: string, default=""  # 片付け終了時刻
```

## 利用時間の選択肢の変更
- `app/views/stage_orders/_form.html.erb`での選択肢を、`app/controllers/stage_orders_controller.rb`にて定義する
- @time_points: 時刻の選択肢(08:00〜21:45)
- @time_intervals: 準備・片付け時間の選択肢(0分, 5分, 10分, 15分 20分)
- @use_time_intervals: 利用時間の選択肢(30分, 1時間, 1時間30分, 2時間)

## バリデーションの変更
- `app/models/stage_order.rb`にて入力される値のバリデーションを定義する
- 名前の定義
  - 時刻指定なし → [use_time_interval, prepare_time_interval, cleanup_time_interval]
  - 時刻指定あり → [prepare_start_time, performance_start_time, performance_end_time, cleanup_end_time]
- 定義したバリデーション(以下の条件を満たすとエラーを吐く):
  - 全て未回答の場合
  - 時刻指定なしのいずれかが入力 && 時刻指定ありのいずれかが入力
  - 時刻指定なしのいずれかが入力 && 時刻指定なしが全て入力されていない
  - 時刻指定ありのいずれかが入力 && 時刻指定ありが全て入力されていない
  - 時刻指定なしの入力で、準備時間と片付け時間の合計が利用時間より長い場合
  - 時刻指定ありの入力で、時間を巻き戻していない(公演開始が10:00で公演終了が09:00等)
  - 時刻指定ありの入力で、準備開始から片付け終了までの合計時間が2時間より長い
- 時刻指定なしの場合は入力された"10分"などの文字列を条件式で整数にマッピングして計算した
- 時刻指定ありの場合は入力された"10:30"などの文字列を[`tod`](https://qiita.com/hirokishirai/items/93ca9b566dddc815063c)というgemを使ってパースして計算した

## 選択肢のチェックで表示するフォームを切り替える
- 時刻指定なしと時刻指定ありのradioを表示し、チェックされた方のフォームのみを表示するようにした
- `app/views/stage_orders/_form.html.erb`の中に直接jQueryを書いた(スマートではない?)
- デフォルトで時刻指定なしのフォームを表示している
- 時刻指定ありを入力してバリデーションエラーになると、時刻指定なしのフォームが表示されていしまう問題がある
