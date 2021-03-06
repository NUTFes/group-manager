ActiveAdmin.register AssignGroupPlace do

  permit_params :place_id

  index do
    selectable_column
    id_column
    column :place_order
    column :place
    actions
  end

  csv do
    column :id
    column :place_order
    column :place
  end

  form do |f|
    order  = f.object.place_order
    places = Place.usable_all_places
    message= "未回答"

    panel "申請情報" do
      li "グループ: #{order.group}" 
      li "第1希望 : #{order.first ?  places.find(order.first)  : message}"
      li "第2希望 : #{order.second ? places.find(order.second) : message}"
      li "第3希望 : #{order.third ?  places.find(order.third)  : message}"
    end

    f.inputs '団体の場所確定' do
      input :place, :as => :select, :collection => places
    end
    f.actions
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection([1,2,5,4,6])} # 見やすくなるようにGroupを年度順にセパレータ付きで表示
  filter :place, as: :select, collection: Place.usable_all_places

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
