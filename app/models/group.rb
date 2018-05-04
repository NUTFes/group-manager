class Group < ActiveRecord::Base
  belongs_to :group_category
  belongs_to :user
  belongs_to :fes_year
  has_many :sub_reps, dependent: :destroy
  has_many :food_products, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :rental_orders, dependent: :destroy
  has_many :power_orders, dependent: :destroy
  has_many :stage_orders, dependent: :destroy
  has_many :group_project_names, dependent: :destroy
  has_many :assign_stages, through: :stage_orders, dependent: :destroy
  has_many :assign_rental_items, through: :rental_orders, dependent: :destroy
  has_one :place_order, dependent: :destroy
  has_one :stage_common_option, dependent: :destroy
  has_one :assign_group_place, through: :place_order, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :fes_year }
  validates :user, presence: true
  validates :activity, presence: true
  validates :group_category, presence: true
  validates :fes_year, presence: true

  scope :year, -> (year) {where(fes_year_id: year)}
  scope :active_admin_collection, -> (group_category_id) { # ActiveAdminのフィルター用コレクション, group_category_id: 0ですべてのグループを取得
    fes_years = FesYear.all.order("id DESC") # 降順ですべてのFesYearを取得
    groups = []
    fes_years.each do |fes_year|
      the_year_groups = Group.where(fes_year: fes_year)
                             .order('name COLLATE "C" ASC') # その年のグループを取得.日本語ソート（漢字は無理）
      if group_category_id != 0
        the_year_groups = the_year_groups.where(group_category_id: group_category_id)
      end
      if the_year_groups.blank? == false
        groups.push( Group.new(id: nil, name: "---------------------" + fes_year.to_s.to_s + "---------------------") ) # セパレータを追加
        the_year_groups.each {|group| groups.push(group)}
      end
    end
    groups
  }

  # simple_form, activeadminで表示するカラムを指定
  # 関連モデル.groupが関連モデル.group.nameと同等になる
  def to_s
    self.name
  end

  def self.year_groups(year_id)
    return Group.where(fes_years: {id: year_id})
  end

  # このメソッドselfいらないな...
  def self.init_rental_order(id) # RentalOrderのレコードが無ければ数量0で登録する
    items_ids = RentalItem.all.pluck('id')
    items_ids.each{ |item_id|
      order = RentalOrder.new( group_id: id, rental_item_id: item_id, num: 0)
      order.save
    }
  end

  def init_stage_order # StageOrderのレコードが無ければ登録
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    # 1日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: 8, is_sunny: true, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
    # 1日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: 8, is_sunny: false, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
    # 2日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: 9, is_sunny: true, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
    # 2日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: 9, is_sunny: false, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
  end

  # ステージ企画の場所決定用のレコードを生成
  def init_assign_stage
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    return unless orders = StageOrder.where(group_id: id)
    empty = "未回答"

    Stage.find_or_create_by(id: 0, name_ja:"未入力")

    orders.each do |ord|
      as = AssignStage.find_or_initialize_by(stage_order_id: ord.id)
      as.stage_id = 0
      as.time_point_start = empty
      as.time_point_end   = empty
      as.save(validate: false) if as.new_record?
    end
  end

  def init_place_order
    return if group_category_id == 3 # ステージ企画ならば戻る
    order = PlaceOrder.new( group_id: id )
    order.save
  end

  # 使用場所用のレコードを生成
  def init_assign_place_order
    return unless order = PlaceOrder.find_by(group_id: id)
    Place.find_or_create_by(id: 0, name_ja:"未入力")
    AssignGroupPlace.find_or_create_by(place_order_id: order.id) do |agp|
      agp.place_id = 0
    end
  end

  def init_stage_common_option # StageCommonOptionのレコードが無ければ登録
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    StageCommonOption.find_or_create_by(group_id: id) do |sco|
      sco.own_equipment = false
      sco.bgm = false
      sco.camera_permittion = false
      sco.loud_sound = false
      sco.stage_content = '未回答'
    end
  end

  def is_exist_subrep
    # 副代表の有無
    num_subrep = self.sub_reps.count
    return num_subrep > 0 ? true : false
  end

  def self.get_has_subreps(user_id)
    # 副代表が登録済みの団体を返す
    return Group.joins(:sub_reps).where(user_id: user_id)
  end
end
