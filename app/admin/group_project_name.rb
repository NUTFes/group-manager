ActiveAdmin.register GroupProjectName do
  permit_params :project_name
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column :group
    column :project_name
    actions
  end

  csv do
    column :id
    column :group
    column :project_name
  end

  form do |f|
    year_id = FesYear.where(fes_year: Time.now.year).first.id

    f.inputs do
      input :group, :as => :select, :collection => Group.where(fes_year_id: year_id)
      input :project_name
    end
    actions
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(0)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
