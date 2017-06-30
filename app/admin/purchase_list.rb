ActiveAdmin.register PurchaseList do

  permit_params :food_product_id, :shop_id, :fes_date_id, :is_fresh, :items

  index do
    selectable_column
    id_column
    column '運営団体名' do |list|
      list.food_product.group
    end
    column :food_product
    column '販売食品の調理の有無' do |list|
      list.food_product.disp_cooking
    end
    column :shop
    column :fes_date
    column :is_fresh do |list|
      list.fresh
    end
    column :items
    actions
  end

  csv do
    column :id
    column '運営団体名' do |list|
      list.food_product.group
    end
    column :food_product
    column '販売食品の調理の有無' do |list|
      list.food_product.disp_cooking
    end
    column :shop
    column :fes_date
    column :is_fresh do |list|
      list.fresh
    end
    column :items
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(0)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

end
