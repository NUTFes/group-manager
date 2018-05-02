FactoryGirl.define do
  factory :group_category do
    initialize_with do
      GroupCategory.find_or_initialize_by(id: id)
    end
  end
  factory :group_category_food, parent: :group_category do
    id 1
    name_ja '模擬店(食品販売)'
  end
  factory :group_category_sale, parent: :group_category do
    id 2
    name_ja '模擬店(物品販売)'
  end
  factory :group_category_stage, parent: :group_category do
    id 3
    name_ja 'ステージ企画'
  end
  factory :group_category_other, parent: :group_category do
    id 4
    name_ja 'その他'
  end
  factory :group_category_exhibition, parent: :group_category do
    id 5
    name_ja '展示・体験'
  end
end
