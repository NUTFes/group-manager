ActiveAdmin.register StockerItem do
  permit_params :rental_item_id, :stocker_place_id, :num

  index do
    selectable_column
    id_column
    column :stocker_place
    column :rental_item
    column :num
    actions
  end

  csv do
    column :id
    column :stocker_place
    column :rental_item
    column :num

  end

  preserve_default_filters!
  filter :rental_item
  filter :stocker_place

end
