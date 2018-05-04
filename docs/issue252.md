# 配属先データの整理 (refer issue252)

# 経緯

課程・専攻名がたくさん変わってきた．既存のseedを変更して対応してきたが，課程の並び順がぐちゃぐちゃになったことと，課程・専攻は名前が変わっただけで本質的に同じなので，名前が変わったレコードを1つにまとめるとスッキリすることから，seedを整理することにした．
この変更に合わせて既存のレコードとの対応を取るり，かつIDを並び替えるためのtaskを作ることにした．
この方法だと課程・専攻名が変わるたびにtaskを作り直す必要がある．もっといい方法があったら教えてください．

# seedの変更

`db/fixtures/departments.rb`

[学部]環境社会基盤工学課程 / 建設工学課程 / 環境システム工学課程のようにまとめることにした．
また，並び順を学部，修士，博士の順番になるようIDを変更

# ID再割当てタスクの作成

department_idをid値を指定して参照していたり，department_idが変化してはうまく動作しないコードがないかどうかを確認する．

その後，関連付けを確認し，変更しなければならないレコードを探す．今回は次の2つのモデルのレコードで再割当てが必要．

- UserDetail
- SubRep

```ruby
  task reallocate: :environment do
    user_details = UserDetail.all
    sub_reps = SubRep.all

    user_details.each do |ud|
      new_id = exchanger(ud.department_id)

      ud.department_id = new_id
      ud.save
    end

    sub_reps.each do |sr|
      new_id = exchanger(sr.department_id)

      sr.department_id = exchanger(sr.department_id)
      sr.save
    end
  end
  
  def exchanger(current_id)
    pat = {
      1 => 1,
      2 => 2,
      3 => 3,
      4 => 4,
      5 => 5,
      6 => 5,
      7 => 6,
      8 => 7,
      9 => 8,
      10 =>9,
      11 =>10,
      12 => 11,
      13 => 11,
      14 => 12,
      15 => 13,
      16 => 14,
      17 => 15,
      18 => 16,
      19 => 17,
      20 => 18,
      21 => 19,
      22 => 20,
      23 => 4,
      24 => 10,
      25 => 5,
      26 => 11,
      27 => 7,
      28 => 13
    }
    return pat[current_id]
  end
```

# 不要なレコード削除

不要なレコードを削除するタスクを作ります．今回は再割当て後idが21以上のものは不要なので消します．他モデルの外部キーになっているレコードがある場合は外部キー制約に引っかかってエラーになります．


```ruby
  task delete: :environment do
    used_id = 20 # 20までは使う

    Department.where("id > #{used_id}").each do |d|
      d.destroy

      puts "id: #{d.id}, #{d} deleted."
    end
  end
```
