ActiveAdmin.register Shop do

  permit_params :name, :tel, :time_weekdays, :time_sat, :time_sun, :time_holidays,:is_closed_sun, :is_closed_mon, :is_closed_tue, :is_closed_wed, :is_closed_thu, :is_closed_fri, :is_closed_sat, :is_closed_holiday, :kana

  csv do
    column :id
    column :name
    column :kana
    column :tel
    column :time_weekdays
    column :time_sat
    column :time_sun
    column :time_holidays
    column :is_closed_sun
    column :is_closed_mon
    column :is_closed_tue
    column :is_closed_wed
    column :is_closed_thu
    column :is_closed_fri
    column :is_closed_sat
    column :is_closed_holiday
  end
end
