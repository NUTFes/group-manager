ActiveAdmin.register StageOrder do

  permit_params :group_id, :fes_date_id, :is_sunny, :stage_first, :stage_second, :use_time_interval, :prepare_time_interval, :cleanup_time_interval, :prepare_start_time, :performance_start_time, :performance_end_time, :cleanup_end_time
  belongs_to :group, optional: true

  index do
    selectable_column
    id_column
    column :group
    column :fes_date_id do |order|
      FesDate.find(order.fes_date_id).date
    end
    column :is_sunny do |order|
      order.tenki
    end
    column :stage_first do  |order|
      order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
    end
    column :stage_second do |order|
      order.stage_second ? Stage.find(order.stage_second) : "未回答"
    end
    column :use_time_interval
    column :prepare_time_interval
    column :cleanup_time_interval
    column :prepare_start_time
    column :performance_start_time
    column :performance_end_time
    column :cleanup_end_time
    actions
  end

  csv do
    column :id
    column :group_name do  |order|
      order.group.name
    end
    column :fes_date_id do |order|
      FesDate.find(order.fes_date_id).date
    end
    column :is_sunny do |order|
      order.tenki
    end
    column :stage_first do  |order|
      order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
    end
    column :stage_second do |order|
      order.stage_second ? Stage.find(order.stage_second) : "未回答"
    end
    column :use_time_interval
    column :prepare_time_interval
    column :cleanup_time_interval
    column :prepare_start_time
    column :performance_start_time
    column :performance_end_time
    column :cleanup_end_time
    column("自前の音響機材を使用する") {|order| StageCommonOption.where(group_id: order.group_id).first.own_equipment ? "Yes" : "No" }
    column("実行委員にBGMをかけるのを依頼する") {|order| StageCommonOption.where(group_id: order.group_id).first.bgm ? "Yes" : "No" }
    column("実行委員による撮影を許可する") {|order| StageCommonOption.where(group_id: order.group_id).first.camera_permittion ? "Yes" : "No" }
    column("大きな音を出す") {|order| StageCommonOption.where(group_id: order.group_id).first.loud_sound ? "Yes" : "No" }
    column("出演内容") {|order| StageCommonOption.where(group_id: order.group_id).first.stage_content }
  end

  form do |f|
    set_time_params
    f.inputs do
      f.input :group
      f.input :fes_date_id, :as => :select, :collection => FesDate.all
      f.input :is_sunny
      f.input :stage_first, :as => :select, :collection => Stage.all
      f.input :stage_second, :as => :select, :collection => Stage.all
      f.input :use_time_interval, :as => :select, :collection => @use_time_intervals
      f.input :prepare_time_interval, :as => :select, :collection => @time_intervals
      f.input :cleanup_time_interval, :as => :select, :collection => @time_intervals
      f.input :prepare_start_time, :as => :select, :collection => @time_points
      f.input :performance_start_time, :as => :select, :collection => @time_points
      f.input :performance_end_time, :as => :select, :collection => @time_points
      f.input :cleanup_end_time, :as => :select, :collection => @time_points
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :group
      row :is_sunny
      row :fes_date_id  do |order|
        FesDate.find(order.fes_date_id).date
      end
      row :stage_first do  |order|
        order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
      end
      row :stage_second do |order|
        order.stage_second ? Stage.find(order.stage_second) : "未回答"
      end
      row :use_time_interval
      row :prepare_time_interval
      row :cleanup_time_interval
      row :prepare_start_time
      row :performance_start_time
      row :performance_end_time
      row :cleanup_end_time
    end
    active_admin_comments
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_name, as: :string
  filter :group, label: "運営団体", as: :select, collection: proc {Group.active_admin_collection(3)} # 見やすくなるようにGroupを年度順にセパレータ付きで表示

  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end

def set_time_params
  @time_points = [["", ""]]
  (8..21).each do |h|
    %w(00 15 30 45).each do |m|
      @time_points.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
    end
  end
  @time_intervals = [["", ""],
                    ["0分", "0分"],
                    ["5分", "5分"],
                    ["10分", "10分"],
                    ["15分", "15分"],
                    ["20分", "20分"]]
  @use_time_intervals = [["", ""],
                         ["30分", "30分"],
                         ["1時間", "1時間"],
                         ["1時間30分", "1時間30分"],
                         ["2時間", "2時間"]]
end
