ActiveAdmin.register Group do
  permit_params :user_id, :name, :group_category_id, :activity, :fes_year_id, :project_name

  index do
    selectable_column
    id_column
    column :fes_year
    column :user
    column :name
    column :project_name do |group|
      group.group_project_name.try(:project_name)
    end
    column :group_category
    column :activity
    column :created_at
    actions
  end

  csv do
    column :id
    column :fes_year do |group|
      group.fes_year.to_s
    end
    column :user do |group|
      group.user.user_detail.name_ja
    end
    column :user do |group|
      group.user.user_detail.name_en
    end
    column :name
    column :group_category do |group|
      group.group_category.name_ja
    end
    column :activity
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row :name
      row :group_category
      row :user_name do |group|
        group.user.user_detail.name_ja
      end

      row :user
      row :user_tel do |group|
        group.user.user_detail.tel
      end
      row :subrep_name do |group|
        group.sub_reps.map(&:name_ja).join(", ")
      end
      row :subrep_tel do |group|
        group.sub_reps.map(&:tel).join(", ")
      end
      row :activity
      row :created_at
      row :updated_at
      row :fes_year
    end
    active_admin_comments
  end

  sidebar "詳細へのリンク", only: [:show] do
    hm_children = Group.reflect_on_all_associations(:has_many) # has_many関係にあるモデルを全て取得
    ho_children = Group.reflect_on_all_associations(:has_one) # has_one関係にあるモデルを全て取得

    ul do
      hm_children.each do |child|
        if child.kind_of?(ActiveRecord::Reflection::ThroughReflection) # throughアソシエーションの場合は中のActiveRecord::Reflection::HasManyReflectionを取得する
          # child = child.delegate_reflection
        end
        li link_to child.klass.model_name.human, [:admin, group, child.name]
      end

      ho_children.each do |child|
        if child.kind_of?(ActiveRecord::Reflection::ThroughReflection)
          # child = child.delegate_reflection
        end
        c = group.send(child.name)
        if c != nil
          li link_to child.klass.model_name.human, [:admin, child.klass.find(c.id)] # group.send(child.name)ではなぜかうまくいかないので再度探してくる
        end
      end
    end
  end

  preserve_default_filters!
  filter :fes_year
  filter :group_category
  filter :user_user_detail_name_ja, as: :string

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank? && params[:scope].blank? && params[:page].blank?
        params['q'] = {:fes_year_id_eq => FesYear.this_year.id}
      end
    end
  end

  # csvダウンロードアクションを作成
  collection_action :download_group_list, :method => :get do
    groups = Group.where({ fes_year_id: FesYear.this_year() })
    csv = CSV.generate do |csv|
      csv << ['Name', 'E-mail Address']
      groups.each do |group|
        groupname = group.name + '( ' + group.user.user_detail.name_ja + ' )'
        csv << [
          groupname,
          group.user.email
        ]
      end
    end

    send_data csv.encode('Shift_JIS', :invalid => :replace, :undef => :replace), type: 'text/csv; charset=shift_jis; header=present', disposition: "attachment; filename=group_list.csv"
  end

  # 参加団体と物品がマトリックスのcsvを作る
  collection_action :download_rental_item_list, :method => :get do
    groups = Group.where({ fes_year_id: FesYear.this_year})
    groups = groups.sort{|g1, g2| g1.group_category_id <=> g2.group_category_id}
    rental_item_names = RentalItem.all.map{ |item| item.name_ja }
    value_columns = rental_item_names.map{ |_| '数量' }  # 物品数と同じだけ数量カラムを作る
    rental_item_columns = rental_item_names.zip(value_columns).flatten  # 物品名と数量が連続する配列を作る
    csv = CSV.generate do |csv|
      csv << %w(No. 参加形式 団体名 エリア) + rental_item_columns
      groups.each_with_index do |group, i|
        group_name = group.name
        group_category_name = group.group_category.name_ja
        place_order = PlaceOrder.where(group_id: group.id).first
        assign_place_name = place_order ? AssignGroupPlace.where(place_order_id: place_order.id).first.place.name_ja : ''
        csv << [i+1, group_category_name, group_name, assign_place_name]
      end

    end

    send_data csv.encode('Shift_JIS', :invalid => :replace, :undef => :replace), type: 'text/csv; charset=shift_jis; header=present', disposition: "attachment; filename=rental_item_list.csv"
  end

end
