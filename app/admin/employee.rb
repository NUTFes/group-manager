ActiveAdmin.register Employee do

  permit_params :group_id, :name, :student_id, :employee_category_id
  belongs_to :group, optional: true

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
      employee.employee_category
    end
    # column :duplication
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(1)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
