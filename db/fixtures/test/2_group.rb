Group.seed(:id, {
  id: 1,
  name: "テストグループ(模擬店・食販)",
  group_category_id: 1,
  user_id: User.where(:email => ENV["GROUP_MANAGER_ADMIN_EMAIL"]).first.id,
  activity: "テストグループ(模擬店・食販)",
  fes_year_id: FesYear.this_year.id,
})
