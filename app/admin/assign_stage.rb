ActiveAdmin.register AssignStage do

  permit_params :stage_id, :time_point_start, :time_point_end
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column :stage_order do |as|
      as.stage_order.group
    end
    column :fes_date do |as|
      FesDate.find(as.stage_order.fes_date_id)
    end

    column :is_sunny do |as|
      as.stage_order.is_sunny ? "晴天時" : "雨天時"
    end
    column :order_time_start do |as|
      as.stage_order.prepare_start_time
    end

    column :order_time_end do |as|
      as.stage_order.cleanup_end_time
    end

    column :order_time_interval do |as|
      as.stage_order.use_time_interval
    end

    column :stage
    column :time_point_start
    column :time_point_end
    actions
  end

  csv do
    column :id
    column :stage_order do |as|
      as.stage_order.group
    end
    column :fes_date do |as|
      FesDate.find(as.stage_order.fes_date_id)
    end
    column :is_sunny do |as|
      as.stage_order.is_sunny ? "晴天時" : "雨天時"
    end
    column :order_time_start do |as|
      as.stage_order.prepare_start_time
    end
    column :order_time_end do |as|
      as.stage_order.cleanup_end_time
    end
    column :order_time_interval do |as|
      as.stage_order.use_time_interval
    end
    column :stage
    column :time_point_start
    column :time_point_end
  end

  form do |f|
    set_time_point
    order  = f.object.stage_order
    stages = Stage.all
    message= "未回答"

    panel "申請情報" do
      li "グループ: #{order.group}"
      li "希望場所1 : #{order.stage_first ?  stages.find(order.stage_first)  : message}"
      li "希望場所2 : #{order.stage_second ? stages.find(order.stage_second) : message}"
      li "希望使用時間 : #{order.use_time_interval ? order.use_time_interval : message}"
      li "希望準備時間 : #{order.prepare_time_interval ? order.prepare_time_interval : message}"
      li "希望片付け時間 : #{order.cleanup_time_interval ? order.cleanup_time_interval : message}"
      li "希望準備開始時刻 : #{order.prepare_start_time ? order.prepare_start_time : message}"
      li "希望公演開始時刻 : #{order.performance_start_time ? order.performance_start_time : message}"
      li "希望公演終了時刻 : #{order.performance_end_time ? order.performance_end_time : message}"
      li "希望片付け終了時刻 : #{order.cleanup_end_time ? order.cleanup_end_time : message}"
    end

    f.inputs '団体のステージ場所&時間決定' do
      input :stage, :as => :select, :collection => stages
      input :time_point_start, :as => :select, :collection => @time_point
      input :time_point_end, :as => :select, :collection => @time_point
    end
    f.actions
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(3)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示
  filter :stage_order_is_sunny, as: :select, collection: {"晴天時": true, "雨天時": false}
  filter :stage_order_fes_date_id, as: :select, collection: FesDate.where(fes_year_id: FesYear.this_year)
  filter :stage_order_stage_first, as: :select, collection: Stage.all
  filter :stage_order_stage_second, as: :select, collection: Stage.all
  filter :stage_order_use_time_interval, :as => :select, :collection => StageOrder.use_time_intervals
  filter :stage_order_prepare_time_interval, :as => :select, :collection => StageOrder.time_intervals
  filter :stage_order_cleanup_time_interval, :as => :select, :collection => StageOrder.time_intervals
  filter :stage_order_prepare_start_time, :as => :select, :collection => StageOrder.time_points
  filter :stage_order_performance_start_time, :as => :select, :collection => StageOrder.time_points
  filter :stage_order_performance_end_time, :as => :select, :collection => StageOrder.time_points
  filter :stage_order_cleanup_end_time, :as => :select, :collection => StageOrder.time_points

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end

def set_time_point
  @time_point = [["", ""]]
  (8..21).each do |h|
    %w(00 15 30 45).each do |m|
      @time_point.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
    end
  end
end
