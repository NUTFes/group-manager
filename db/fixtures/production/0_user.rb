users = [{
     :email=>ENV["GROUP_MANAGER_ADMIN_EMAIL"],
     :role=>Role.find(1),
     :password=>ENV["GROUP_MANAGER_ADMIN_PASSWORD"],
     :password_confirmation=>ENV["GROUP_MANAGER_ADMIN_PASSWORD"]
 }
]

users.each do |u|
    if User.where(:email => u[:email]).empty?
        user = User.new(u)
        user.skip_confirmation!
        user.save(:validate=>false)
    end
end