require 'rails_helper'

RSpec.describe PowerOrder, type: :model do
  # group_id, item, power, manufacturer, modelがあれば有効な状態であること
  it "is valid with a group_id, item, power, manufacturer, and model"
  # group_idがなければ無効な状態であること
  it "is invalid without a group_id"
  # itemがなければ無効な状態であること
  it "is invalid without a item"
  # powerがなければ無効な状態であること
  it "is invalid without a power"
  # manufacturerがなければ無効な状態であること
  it "is invalid without a manufacturer"
  # modelがなければ無効な状態であること
  it "is invalid without a model"
  # ステージ団体ではない場合,powerの値が1-1000以外の値であれば無効な状態であること
  it "is invalid if group_category is not stage and power is not between in the range of 1 to 1000"
  # ステージ団体の場合,powerの値が1-2500以外の値であれば無効な状態であること
  it "is invalid if group_category is stage and power is not between in the range of 1 to 2500"
  # ステージ団体ではない場合,新規レコード作成時にpowerの合計値が1000を超えれば無効な状態であること
  it "is invalid if group_category is not stage and total amount of power is more than 1000, when create record"
  # ステージ団体の場合,新規レコード作成時にpowerの合計値が2500を超えれば無効な状態であること
  it "is invalid if group_category is stage and total amount of power is more than 2500, when create a record"
  # ステージ団体ではない場合,既存レコード更新時にpowerの合計値が1000を超えれば無効な状態であること
  it "is invalid if group_category is not stage and total amount of power is more than 1000, when update a record"
  # ステージ団体の場合,既存レコード更新時にpowerの合計値が2500を超えれば無効な状態であること
  it "is invalid if group_category is stage and total amount of power is more than 2500, when update a record"
  # 指定された年度のレコードを返すこと
  it "return the record of specified year"
  # 関連付けられた団体の参加形式がステージ団体であるかをtrue/falseで返すこと
  it "return as a true or false wheter group_category is stage"
end
