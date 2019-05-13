ActiveAdmin.register PlaceOrder do

  index do
    selectable_column
    id_column
    column :group
    column :inside_or_outside_id do |order|
      order.inside_or_outside_id ? InsideOrOutside.find(order.inside_or_outside_id) : "未回答"
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

  csv do
    column :id
    column :group_name do  |order|
      order.group.name
    end
    column :inside_or_outside_id do |order|
      order.inside_or_outside_id ? InsideOrOutside.find(order.inside_or_outside_id) : "未回答"
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
      row :inside_or_outside_id do |order|
        order.inside_or_outside_id ? InsideOrOutside.find(order.inside_or_outside_id) : "未回答"
      end
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
  filter :inside_or_outside_id, as: :select, collection: InsideOrOutside.all
  filter :first, as: :select, collection: Place.usable_all_places
  filter :second, as: :select, collection: Place.usable_all_places
  filter :third, as: :select, collection: Place.usable_all_places

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
