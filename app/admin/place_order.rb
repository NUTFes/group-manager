ActiveAdmin.register PlaceOrder do

  index do
    selectable_column
    id_column
    column :group
    column :first do  |order|
      order.first  ? Place.find(order.first)  : "未回答"
    end
    column :second do |order|
      order.second ? Place.find(order.second) : "未回答"
    end
    column :third do  |order|
      order.third  ? Place.find(order.third)  : "未回答"
    end
    column :remark
  end

  csv do
    column :id
    column :group_name do  |order|
      order.group.name
    end
    column :first do  |order|
      order.first  ? Place.find(order.first)  : "未回答"
    end
    column :second do |order|
      order.second ? Place.find(order.second) : "未回答"
    end
    column :third do  |order|
      order.third  ? Place.find(order.third)  : "未回答"
    end
    column :remark
  end

  show do
    attributes_table do
      row :id
      row :group
      row :first do |order|
        order.first  ? Place.find(order.first)  : "未回答"
      end
      row :second do |order|
        order.second ? Place.find(order.second) : "未回答"
      end
      row :third do |order|
        order.third  ? Place.find(order.third)  : "未回答"
      end
      row :remark
      row :created_at
      row :updated_at
    end
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection([1,2,5,4,6])} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
