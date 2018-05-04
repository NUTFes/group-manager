ActiveAdmin.register FoodProduct do

  permit_params :group_id, :name, :num, :is_cooking
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column :group
    column :name
    column :first_day_num
    column :second_day_num
    column :is_cooking
    column :start do
      GroupManagerCommonOption.first.cooking_start_time
    end
    actions
  end

  csv do
    column :id
    column :group_name do |product|
      product.group.name
    end
    column :name
    column :first_day_num
    column :second_day_num
    column :is_cooking
    column :start do
      GroupManagerCommonOption.first.cooking_start_time
    end
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(1)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

end
