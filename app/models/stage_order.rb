class StageOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :fes_date
  has_one :fes_year, through: :fes_date
  has_one :assign_stage, dependent: :destroy

  validates :group_id, :fes_date_id, presence: true
  validates :group_id, :uniqueness => {:scope => [:fes_date_id, :is_sunny] } # 日付と天候でユニーク
  validate :select_different_stage
  validate :is_correct_inputs


  def tenki
    return is_sunny ? "晴天時" :  "雨天時"
  end

  def date
    return FesDate.find(fes_date_id).date
  end

  def select_different_stage
    return if stage_first.blank? & stage_second.blank?
    if stage_first == stage_second
        errors.add( :stage_first, "候補が重複しています。")
        errors.add( :stage_second, "候補が重複しています。")
    end
  end

  def kibou1
    return Stage.find( stage_first )
  end

  def kibou2
    return Stage.find( stage_second )
  end

  def is_correct_inputs
    # レコード生成時のValidation回避
    if use_time_interval == '未回答' && prepare_time_interval == '未回答' && cleanup_time_interval == '未回答' && prepare_start_time == '未回答' && performance_start_time == '未回答' && performance_end_time == '未回答' && cleanup_end_time == '未回答'
      return
    end
    # 論理式
    is_any_intervals = (use_time_interval.present? | prepare_time_interval.present? | cleanup_time_interval.present?)
    is_all_intervals = (use_time_interval.present? & prepare_time_interval.present? & cleanup_time_interval.present? )
    is_any_times = (prepare_start_time.present? | performance_start_time.present? | performance_end_time.present? | cleanup_end_time.present?)
    is_all_times = (prepare_start_time.present? & performance_start_time.present? & performance_end_time.present? & cleanup_end_time.present?)

    # 全て未回答
    if !is_any_intervals && !is_any_times
      errors.add( :use_time_interval, "入力してください" )
      errors.add( :prepare_time_interval, "入力してください" )
      errors.add( :cleanup_time_interval, "入力してください" )
      errors.add( :prepare_start_time, "入力してください" )
      errors.add( :performance_start_time, "入力してください" )
      errors.add( :performance_end_time, "入力してください" )
      errors.add( :cleanup_end_time, "入力してください" )
    end
    # 時刻指定ありと時刻指定なしのどちらかを入力しなければならない
    if is_any_intervals & is_any_times
      errors.add( :use_time_interval, "どちらかのみ入力してください" )
      errors.add( :prepare_time_interval, "どちらかのみ入力してください" )
      errors.add( :cleanup_time_interval, "どちらかのみ入力してください" )
      errors.add( :prepare_start_time, "どちらかのみ入力してください" )
      errors.add( :performance_start_time, "どちらかのみ入力してください" )
      errors.add( :performance_end_time, "どちらかのみ入力してください" )
      errors.add( :cleanup_end_time, "どちらかのみ入力してください" )
    end
    # 時刻指定なしの場合の未完成の回答
    if is_any_intervals & !is_all_intervals
      errors.add( :use_time_interval, "全て入力してください" )
      errors.add( :prepare_time_interval, "全て入力してください" )
      errors.add( :cleanup_time_interval, "全て入力してください" )
    end
    # 時刻指定ありの場合の未完成の回答
    if is_any_times & !is_all_times
      errors.add( :prepare_start_time, "全て入力してください" )
      errors.add( :performance_start_time, "全て入力してください" )
      errors.add( :performance_end_time, "全て入力してください" )
      errors.add( :cleanup_end_time, "全て入力してください" )
    end

    # 時刻指定なしの場合
    if is_all_intervals
      # 入力された時間幅の文字列(ex. 5分)を数値にマッピング
      case use_time_interval
        when "30分" then use_time = 30
        when "1時間" then use_time = 60
        when "1時間30分" then use_time = 90
        when "2時間" then use_time = 120
      end
      case prepare_time_interval
        when "0分" then prepare_time = 0
        when "5分" then prepare_time = 5
        when "10分" then prepare_time = 10
        when "15分" then prepare_time = 15
        when "20分" then prepare_time = 20
      end
      case cleanup_time_interval
        when "0分" then cleanup_time = 0
        when "5分" then cleanup_time = 5
        when "10分" then cleanup_time = 10
        when "15分" then cleanup_time = 15
        when "20分" then cleanup_time = 20
      end
      # 準備・片付け時間の合計が使用時間に満たない場合
      if prepare_time + cleanup_time >= use_time
        errors.add( :use_time_interval, "不正な値です" )
        errors.add( :prepare_time_interval, "不正な値です" )
        errors.add( :cleanup_time_interval, "不正な値です" )
      end
    end

    # 時刻指定ありの場合
    if is_all_times
      prepare_start = DateTime.parse(prepare_start_time)
      perform_start = DateTime.parse(performance_start_time)
      perform_end = DateTime.parse(performance_end_time)
      cleanup_end = DateTime.parse(cleanup_end_time)

      if (prepare_start > perform_start or perform_start >= perform_end or perform_end > cleanup_end)
        errors.add( :prepare_start_time, "不正な値です" )
        errors.add( :performance_start_time, "不正な値です" )
        errors.add( :performance_end_time, "不正な値です" )
        errors.add( :cleanup_end_time, "不正な値です" )
      end

      if cleanup_end > prepare_start + Rational(2, 24)
        errors.add( :prepare_start_time, "最大利用時間は2時間までです" )
        errors.add( :performance_start_time, "最大利用時間は2時間までです" )
        errors.add( :performance_end_time, "最大利用時間は2時間までです" )
        errors.add( :cleanup_end_time, "最大利用時間は2時間までです" )
      end
    end
  end

  def self.time_points
    time_points = [["", ""]]
    (8..21).each do |h|
      %w(00 15 30 45).each do |m|
        time_points.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
      end
    end
    time_points
  end

  def self.time_intervals
    time_intervals = [["", ""],
                     ["0分", "0分"],
                     ["5分", "5分"],
                     ["10分", "10分"],
                     ["15分", "15分"],
                     ["20分", "20分"]]
  end

  def self.use_time_intervals
    use_time_intervals = [["", ""],
                          ["30分", "30分"],
                          ["1時間", "1時間"],
                          ["1時間30分", "1時間30分"],
                          ["2時間", "2時間"]]
  end
end
