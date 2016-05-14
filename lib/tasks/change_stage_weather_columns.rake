namespace:change_stage_weather_columns do
  desc "既存のStageOrderからStageの重複データを取り除く"

  task delete_stage_all_records: :environment do
    Stage.delete_all
  end

  task copy: :environment do
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_order = StageOrder.where(group_id: group.id)
      if StageOrder.exists?(group_id: group.id)
        stage_order.each do |order|
          next if order.stage_first==nil && order.stage_second==nil
          puts "group_id: #{group.id}\t" + "order_id: #{order.id}\t" 
          stage = "before:\t first:#{order.stage_first}, second:#{order.stage_second} =>\t"

          # 重複したStage_idを参照するレコードを修正(validateを無視)
          order.update_attribute(:stage_first     , exchager(order.stage_first ))
          order.update_attribute(:stage_second    , exchager(order.stage_second))
          order.update_attribute(:time_point_start, time_nil?(order.time_point_start))
          order.update_attribute(:time_point_end  , time_nil?(order.time_point_end))
          order.update_attribute(:time_interval   , time_nil?(order.time_interval))

          puts stage + "ofter:\t first:#{order.stage_first}, second:#{order.stage_second}"
          puts "---------------------------------------------------"
        end
      end
    }
  end

  # 重複するStage_idを指定して置換
  def exchager(stage_id)
    return 3 if stage_id==5
    return 4 if stage_id==6
    return 5 if stage_id==7
    stage_id
  end

  def time_nil?(time)
    return time.nil? ? "未回答" : time
  end

end
