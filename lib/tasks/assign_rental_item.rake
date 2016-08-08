namespace :assign_rental_item do

  task init_records: :environment do
    # 今年分の貸出申請と貸出可能物品を取得
    orders = RentalOrder.this_year_order
    items  = RentableItem.this_year_items

    # 貸出確定分を入力するレコードを生成
    orders.each do |odr|
      items.each do |itm|
        AssignRentalItem.find_or_create_by( \
          rental_order_id: odr.id, rentable_item_id: itm.id) do |user|
          user.num = 0
        end
      end
    end
    
  end
end
