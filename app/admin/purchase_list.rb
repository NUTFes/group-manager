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
  filter :food_product_name, as: :string
  filter :food_product_is_cooking, as: :select, collection: {'調理あり': true, '調理なし(提供のみ)': false}
  filter :shop
  filter :items, as: :string
  filter :is_fresh

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
