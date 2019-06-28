UserDetail.seed( :id,
{   id: 1,
    user_id: User.where(:email => ENV["GROUP_MANAGER_ADMIN_EMAIL"]).first.id,
    name_en: "Taro Gidai (admin)",
    name_ja: "技大太郎 (admin)",
    department_id: 1,
    grade_id: 1,
    tel: "111-1111-1111",
})
