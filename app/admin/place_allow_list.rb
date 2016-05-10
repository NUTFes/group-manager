ActiveAdmin.register PlaceAllowList do

  permit_params :enable,:group_category_id,:place

  index do
    id_column
    column :group_category_id do |order|
      order.group_category
    end
    column :place
    column :enable

    actions
  end

  form do |f|
    inputs '場所を許可/不許可' do
      input :enable
    end
    f.actions
  end

end
