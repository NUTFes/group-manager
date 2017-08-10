ActiveAdmin.register Employee do

  permit_params :group_id, :name, :student_id, :employee_category_id

  index do
    selectable_column
    id_column
    column :group
    column :name
    column :student_id
    column :employee_category
    # column :duplication
    actions
  end

  csv do
    column :id
    column :group_name do |employee|
      employee.group.name
    end
    column :name
    column :student_id
    column :employee_category do |employee|
      employee.employee_category.name_ja
    end
    column :duplication
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(1)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

end
