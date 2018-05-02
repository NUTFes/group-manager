FactoryGirl.define do
  factory :power_order do
    association :group, factory: group
  end
end
