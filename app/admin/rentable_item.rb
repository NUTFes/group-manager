ActiveAdmin.register RentableItem do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :stocker_item_id, :stocker_place_id, :max_num

  index do
    selectable_column
    id_column
    column :stocker_item
    column :stocker_place
    column :max_num
    actions
  end

  csv do
    column :id
    column :stocker_item
    column :stocker_place
    column :max_num
  end

  preserve_default_filters!
  filter :stocker_item_rental_item_id, as: :select, collection: RentalItem.all
  filter :stocker_item_stocker_place_id, as: :select, collection: StockerPlace.all
  filter :stocker_place
end
