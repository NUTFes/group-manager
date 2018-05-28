ActiveAdmin.register Group do

  permit_params :user_id, :name, :group_category_id, :activity, :fes_year_id

  index do
    selectable_column
    id_column
    column :fes_year
    column :user
    column :name
    column :group_category
    column :activity
    column :created_at
    actions
  end

  csv do
    column :id
    column :fes_year
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
          child = child.delegate_reflection
        end
        li link_to child.klass.model_name.human, [:admin, group, child.name]
      end

      ho_children.each do |child|
        if child.kind_of?(ActiveRecord::Reflection::ThroughReflection)
          child = child.delegate_reflection
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

end
