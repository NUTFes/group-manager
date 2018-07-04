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
    column("自前の音響機材を使用する") {|order| StageCommonOption.where(group_id: order.group_id).first.try(:own_equipment) ? "Yes" : "No" }
    column("実行委員にBGMをかけるのを依頼する") {|order| StageCommonOption.where(group_id: order.group_id).first.try(:bgm) ? "Yes" : "No" }
    column("実行委員による撮影を許可する") {|order| StageCommonOption.where(group_id: order.group_id).first.try(:camera_permittion) ? "Yes" : "No" }
    column("大きな音を出す") {|order| StageCommonOption.where(group_id: order.group_id).first.try(:loud_sound) ? "Yes" : "No" }
    column("出演内容") {|order| StageCommonOption.where(group_id: order.group_id).first.try(:stage_content) }
  end

  form do |f|
    set_time_params
    f.inputs do
      f.input :group
      f.input :fes_date_id, :as => :select, :collection => FesDate.all
      f.input :is_sunny
      f.input :stage_first, :as => :select, :collection => Stage.all
      f.input :stage_second, :as => :select, :collection => Stage.all
      f.input :use_time_interval, :as => :select, :collection => StageOrder.use_time_intervals
      f.input :prepare_time_interval, :as => :select, :collection => StageOrder.time_intervals
      f.input :cleanup_time_interval, :as => :select, :collection => StageOrder.time_intervals
      f.input :prepare_start_time, :as => :select, :collection => StageOrder.time_points
      f.input :performance_start_time, :as => :select, :collection => StageOrder.time_points
      f.input :performance_end_time, :as => :select, :collection => StageOrder.time_points
      f.input :cleanup_end_time, :as => :select, :collection => StageOrder.time_points
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
  filter :is_sunny, as: :select, collection: {"晴天時": true, "雨天時": false}
  filter :fes_date, as: :select, collection: FesDate.where(fes_year_id: FesYear.this_year)
  filter :stage_first, as: :select, collection: Stage.all
  filter :stage_second, as: :select, collection: Stage.all
  filter :use_time_interval, :as => :select, :collection => StageOrder.use_time_intervals
  filter :prepare_time_interval, :as => :select, :collection => StageOrder.time_intervals
  filter :cleanup_time_interval, :as => :select, :collection => StageOrder.time_intervals
  filter :prepare_start_time, :as => :select, :collection => StageOrder.time_points
  filter :performance_start_time, :as => :select, :collection => StageOrder.time_points
  filter :performance_end_time, :as => :select, :collection => StageOrder.time_points
  filter :cleanup_end_time, :as => :select, :collection => StageOrder.time_points

  controller do
    before_filter only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

end
