ActiveAdmin.register RentalItemAllowList do
  permit_params do
    params = [:rental_item, :group_category_id] if current_user.role_id==1
    params
  end

  index do 
    selectable_column
    id_column
    column :rental_item
    column :group_category
    actions
  end

  filter :rental_item
  filter :group_category

end
