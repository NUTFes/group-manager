namespace :stocker_item do
  desc "stocker_itemの2018年以前のデータを全て消す"

  task destroy_before_2018: :environment do
    StockerItem.where("fes_year_id < 4").destroy_all
    puts 'done.'
  end
end
