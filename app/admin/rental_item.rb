ActiveAdmin.register RentalItem do
  permit_params :name_ja, :name_en, :is_rentable

  csv do
    column :id
    column :name_ja
    column :name_en
    column :is_rentable
  end
end
