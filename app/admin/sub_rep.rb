ActiveAdmin.register SubRep do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :group_id, :name_ja, :name_en, :department_id, :grade_id, :tel,
                :email
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column :group
    column :name_ja
    column :name_en
    column :email
    actions
  end

  csv do
    column :id
    column :group
    column :name_ja
    column :name_en
    column :department
    column :grade
    column :tel
    column :email
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
