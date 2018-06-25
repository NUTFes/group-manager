ActiveAdmin.register PowerOrder do

  permit_params :group_id, :item, :power, :manufacturer, :model, :item_url
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column "参加団体", :group
    column :item
    column :power
    column :manufacturer
    column :model
    column :item_url
    column :updated_at
    actions
  end

  csv do
    column :id
    column :group do |order|
      order.group.name
    end
    column :item
    column :power
    column :manufacturer
    column :model
    column :item_url
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(0)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
