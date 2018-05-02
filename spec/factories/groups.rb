FactoryGirl.define do
  factory :group do
    first_question '質問・要望など'
    association :user, factory: :user
    association :fes_year, factory: :this_year
  end

  # 模擬店(食品販売)
  factory :group_food, parent: :group do
    name '模擬店(食品販売)'
    association :group_category, factory: :group_category_food
    activity '模擬店(食品販売)のテストデータ'
  end
  # 模擬店(物品販売)
  factory :group_sale, parent: :group do
    name '模擬店(物品販売)'
    association :group_category, factory: :group_category_sale
    activity '模擬店(物品販売)のテストデータ'
  end
  # ステージ企画
  factory :group_stage, parent: :group do
    name 'ステージ企画'
    association :group_category, factory: :group_category_stage
    activity 'ステージ企画のテストデータ'
  end
  # その他
  factory :group_other, parent: :group do
    name 'その他'
    association :group_category, factory: :group_category_other
    activity 'その他のテストデータ'
  end
  # 展示・体験
  factory :group_exhibition, parent: :group do
    name '展示・体験'
    association :group_category, factory: :group_category_exhibition
    activity '展示・体験のテストデータ'
  end
end
