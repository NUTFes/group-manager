ActiveAdmin.register RentalOrder do


  permit_params :num
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column :group
    column :rental_item
    column :num
    actions
  end

  form do |f|
    panel '編集上の注意' do
      "数量のみ変更可能です. グループと物品は変更できません. "
    end
    f.inputs do
    input :group
    input :rental_item
    input :num
    end
    actions
  end

  csv do
    column :id
    column :group do |order|
      order.group.name
    end
    column :rental_item do |order|
      order.rental_item.name_ja
    end
    column :num
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(0)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示
  filter :rental_item

end
