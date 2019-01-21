ActiveAdmin.register StageCommonOption do


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
  permit_params :group, :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content

  index do
    selectable_column
    id_column
    column :group
    column :own_equipment
    column :bgm
    column :camera_permittion
    column :loud_sound
    column :stage_content
    actions
  end

  csv do
    column :id
    column :group_name do  |order|
      order.group.name
    end
    column :own_equipment
    column :bgm
    column :camera_permittion
    column :loud_sound
    column :stage_content
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(3)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
