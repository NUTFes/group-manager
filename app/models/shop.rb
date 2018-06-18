class Shop < ActiveRecord::Base
  has_many :purchase_lists, dependent: :destroy 
  
  validates_presence_of :name, :kana, :tel
  validates_uniqueness_of :name, :kana

  # tel -> 半角数字とハイフンのみ, [4444-22-4444, for 固定] )
  validates :tel,     format: { with: /(\A\d{4}-\d{2}-\d{4})+\z/i }

  # true or falseを指定
  validates :is_closed_sun    , inclusion: {in: [true, false]}
  validates :is_closed_mon    , inclusion: {in: [true, false]}
  validates :is_closed_tue    , inclusion: {in: [true, false]}
  validates :is_closed_wed    , inclusion: {in: [true, false]}
  validates :is_closed_thu    , inclusion: {in: [true, false]}
  validates :is_closed_fri    , inclusion: {in: [true, false]}
  validates :is_closed_sat    , inclusion: {in: [true, false]}
  validates :is_closed_holiday, inclusion: {in: [true, false]}

  def to_s
    self.name
  end

  # FesDateのidを指定し，その日が休日でないものを抜き出す．
  def self.open_at_fesdate_id( fes_date_id )
    day = FesDate.find(fes_date_id).day
    self.where( "is_closed_" + day + " = ?", 'false')
  end

  # 休日を表示
  def closed_days
    days = { sun: '日曜', mon: '月曜', tue: '火曜', wed: '水曜', thu: '木曜', fri: '金曜', sat: '土曜', holiday: '祝日'}
    hash_data = self.attributes # ハッシュへ
    closed_days = Array.new
    days.each do |day, day_ja|
      if hash_data[ 'is_closed_' + day.to_s]
        closed_days.push( day_ja.to_s )
      end
    end
    return closed_days.length == 0 ? 'なし' : closed_days.join(', ')
  end
end
