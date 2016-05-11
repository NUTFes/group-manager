ActiveAdmin.register Stage do

  permit_params do 
    params = [:is_sunny,:enable] 
    params.concat [:name_ja, :name_en] if current_user.role_id==1
    params
  end

  form do |f|
    

    inputs 'ステージの編集' do
      if current_user.role_id==1 then
        input :name_ja
        input :name_en
      end
      input :is_sunny
      input :enable
    end
    f.actions
  end

end
