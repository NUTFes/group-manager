users = [{
     :email=>"admin@nutfes.com",
     :role=>Role.find(1),
     :password=>"nutfes",
     :password_confirmation=>"nutfes"
 }
]

users.each do |u|
    if User.where(:email => u[:email]).empty?
        user = User.new(u)
        user.skip_confirmation!
        user.save(:validate=>false)
    end
end
