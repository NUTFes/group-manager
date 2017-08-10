ActiveAdmin.register AssignRentalItem do

  permit_params :rental_order_id, :rentable_item_id, :num


  action_item only: :index do
    link_to '物品割当画面に移動', assign_rental_items_path
  end

  

  index do
    panel 'Notice' do
     '右上の「物品割当画面に移動」ボタンから物品管理を行ってください. 管理画面からの編集は非推奨です.'
    end

    selectable_column
    id_column
    column :rental_order
    column :rentable_item
    column :num
    actions
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(0)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

end
