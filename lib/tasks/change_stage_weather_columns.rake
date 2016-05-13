namespace :change_stage_weather_columns do
  desc "既存のStageOrderからStageの重複データを取り除く"

  task copy: :environment do
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_order = StageOrder.where(group_id: group.id)
      if StageOrder.exists?(group_id: group.id)
        stage_order.each do |order|
          # 重複したStage_idを参照するレコードを修正
          order.update(
            stage_first:    exchager(order.stage_first ),
            stage_second:   exchager(order.stage_second)
          )
        end
      end
    }
  end

  # 重複するStage_idを指定して置換
  def exchager(stage_id)
    return 3 if stage_id==5
    return 4 if stage_id==6
    stage_id
  end

end
