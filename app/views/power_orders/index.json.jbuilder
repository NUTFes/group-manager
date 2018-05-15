json.array!(@power_orders) do |power_order|
  json.extract! power_order, :id, :group_id, :item, :power, :item_url
  json.url power_order_url(power_order, format: :json)
end
