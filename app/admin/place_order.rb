ActiveAdmin.register PlaceOrder do

  index do
    selectable_column
    id_column
    column :group
    column :first do  |order|
      order.first  ? Place.find(order.first)  : "未回答"
    end
    column :second do |order|
      order.second ? Place.find(order.second) : "未回答"
    end
    column :third do  |order|
      order.third  ? Place.find(order.third)  : "未回答"
    end
  end

  csv do
    column :id
    column :group do  |order|
      order.group.name
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
  end


end
