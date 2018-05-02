FactoryGirl.define do
  factory :role do
    initialize_with do
      Role.find_or_initialize_by(id: id, name: name)
    end
  end

  factory :role_developer, parent: :role do
    id 1
    name 'developer'
  end
  factory :role_manager, parent: :role do
    id 2
    name 'manager'
  end
  factory :role_user, parent: :role do
    id 3
    name 'user'
  end
end
