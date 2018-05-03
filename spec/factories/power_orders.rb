FactoryGirl.define do
  factory :power_order do
    item 'テスト家電'
    power 100
    manufacturer 'テスト家電'
    model '型番100-NF'
    association :group, factory: :group_food
  end
end
