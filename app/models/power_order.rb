class PowerOrder < ActiveRecord::Base
  belongs_to :group
  has_one :fes_year, through: :group

  validates :group_id, :item, :power, :manufacturer, :model, :item_url, presence: true # 必須項目
  validate :is_correct_url

  scope :year, -> (year) {joins(:group).where(groups: {fes_year_id: year})}

  def stage?
    group_category = Group.find(group_id).group_category_id
    if 3 == group_category
      return true
    end
    return false
  end


  validates :power, if: :stage?, numericality: {
    only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 2500,
  }

  validates :power, unless: :stage?, numericality: {
    only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1500,
  } 

  def is_correct_url
    # 正しいURLか'なし'の場合を許可
    return if item_url.match(%r(\Ahttps?://[\w/:%#\$&\?\(\)~\.=\+\-]+\z)) or item_url == 'なし'
    errors.add( :item_url, "正しいURLを入力してください" )
  end

  validates_with PowerOrderCreateValidator, on: :create
  validates_with PowerOrderUpdateValidator, on: :update

end
