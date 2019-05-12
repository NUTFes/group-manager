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
  has_many :assign_rental_items, through: :rental_orders, dependent: :destroy
  has_one :place_order, dependent: :destroy
  has_one :stage_common_option, dependent: :destroy
  has_one :assign_group_place, through: :place_order, dependent: :destroy
  has_one  :group_project_name, dependent: :destroy
  has_many :assign_stages, through: :stage_orders, dependent: :destroy

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
    return unless group_category_id == 3 
    this_year_first_date = FesDate.where(fes_year_id: FesYear.this_year, days_num: 1).first.id
    this_year_second_date = FesDate.where(fes_year_id: FesYear.this_year, days_num: 2).first.id
    # ステージ企画でなければ戻る
    # 1日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: this_year_first_date , is_sunny: true, use_time_interval: '未回答', prepare_time_interval: '未回答', cleanup_time_interval: '未回答', prepare_start_time: '未回答', performance_start_time: '未回答', performance_end_time: '未回答', cleanup_end_time: '未回答')
    order.save
    # 1日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: this_year_first_date, is_sunny: false, use_time_interval: '未回答', prepare_time_interval: '未回答', cleanup_time_interval: '未回答', prepare_start_time: '未回答', performance_start_time: '未回答', performance_end_time: '未回答', cleanup_end_time: '未回答')
    order.save
    # 2日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: this_year_second_date, is_sunny: true, use_time_interval: '未回答', prepare_time_interval: '未回答', cleanup_time_interval: '未回答', prepare_start_time: '未回答', performance_start_time: '未回答', performance_end_time: '未回答', cleanup_end_time: '未回答')
    order.save
    # 2日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: this_year_second_date, is_sunny: false, use_time_interval: '未回答', prepare_time_interval: '未回答', cleanup_time_interval: '未回答', prepare_start_time: '未回答', performance_start_time: '未回答', performance_end_time: '未回答', cleanup_end_time: '未回答')
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
    return Group.joins(:sub_reps).where(user_id: user_id).distinct!
  end

  # パーテーションの申請があるがパーテーション足の申請がない場合，もしくはその逆の場合trueを返す
  def partition_or_leg_is_not_ordered?
    partition_order = self.rental_orders.find{|order| order.rental_item_id == 5}  # パーテーションの申請
    partition_leg_order = self.rental_orders.find{|order| order.rental_item_id == 11}  # パーテーション足の申請
    return false if partition_order.nil? or partition_leg_order.nil?
    # パーテーションの申請があるが足の申請がない場合
    return true if partition_order.num > 0 and partition_leg_order.num == 0
    # パーテーション足の申請があるがパーテーションの申請がない場合
    partition_leg_order.num > 0 and partition_order.num == 0
  end

  # パーテーションとパーテーションの足の組み合わせに適さない場合trueを返す
  def partition_and_leg_are_not_appropriate?
    partition_order = self.rental_orders.find{|order| order.rental_item_id == 5}  # パーテーションの申請
    partition_leg_order = self.rental_orders.find{|order| order.rental_item_id == 11}  # パーテーション足の申請
    return false if partition_order.nil? or partition_leg_order.nil?
    return false if partition_order.num == 0 or partition_leg_order.num == 0  # 片方or両方の申請数が0の場合は対象にしない
    # パーテーション1枚の場合は足は2本しかない
    return true if partition_order.num == 1 and partition_leg_order.num != 2
    # パーテーション2枚→足3,4本，3枚→4,5,6本，4枚→5,6,7,8本 ...
    partition_leg_order.num < partition_order.num + 1 or partition_leg_order.num > partition_order.num * 2
  end

  # ステージ以外の団体で，実施場所の申請が未回答の場合trueを返す
  def place_order_is_empty?
    return false if self.group_category_id == 3
    self.place_order.first.nil?
  end

  # ステージ団体で，ステージ利用の申請が未回答の場合trueを返す
  def stage_order_is_incomplete?
    return false if self.group_category_id != 3
    # 4つのstage_orderのうち未回答でないものをselectし，fes_date_idの配列を作る
    stage_order_fes_dates = self.stage_orders.select{|order| order.stage_first}.map{|order| order.fes_date_id}
    # 申請が片日ot両日埋まっていなければtrue
    not ( (stage_order_fes_dates.size == 2 and stage_order_fes_dates.uniq.size == 1) \
      or (stage_order_fes_dates.size == 4 and stage_order_fes_dates.uniq.size == 2) )
  end

  # ステージ団体で，ステージ利用の詳細が未回答の場合trueを返す
  def stage_common_option_is_empty?
    return false if self.group_category_id != 3
    self.stage_common_option.stage_content == '未回答'
  end

end

