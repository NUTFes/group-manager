FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@nutfes.com"
    end
    password 'nutfes'
    password_confirmation 'nutfes'
    role_id :role_user
    to_create { |user| user.save(validate:false) } # validationを無効にする

    initialize_with do
      User.find_or_initialize_by(email: email)
    end
  end
  factory :user_manager, parent: :user do
    email 'manager@nutfes.com'
    role_id :role_manager
  end
  factory :user_developer, parent: :user do
    email 'developer@nutfes.com'
    role_id :role_developer
  end
end
