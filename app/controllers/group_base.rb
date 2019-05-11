class GroupBase < ApplicationController

  before_action :set_groups # カレントユーザの所有する団体を@groupsへ
  before_action :set_ability # カレントユーザの権限設定を@abilityへ

  def set_groups
    # ログインしていなければ何もしない
    return if current_user.nil?
    # 今年のレコード
    this_year = FesYear.where(fes_year: Time.now.year)
    # 自分の所有するグループで今年に紐づくもの
    @groups = Group.where(user_id: current_user.id).
                    where(fes_year: this_year)
    # ログインユーザの所有しているグループのうち，
    # 副代表が登録されていない団体数を取得する
    @num_nosubrep_groups = @groups.count -
                           Group.where(fes_year: this_year).
                                 get_has_subreps(current_user.id).count
    # ステージ団体以外の場合，実施場所の申請が未回答のグループがあるかどうか
    @is_place_order_empty = @groups.any? {|group| group.place_order_is_empty?}
    # ステージ団体の場合，ステージ利用の申請が未回答のグループがあるかどうか
    @is_stage_order_incomplete = @groups.any? {|group| group.stage_order_is_incomplete?}
    # ステージ団体の場合，ステージ利用の詳細が未回答のグループがあるかどうか
    @is_stage_common_option_empty = @groups.any? {|group| group.stage_common_option_is_empty?}
  end

  def set_ability
    return if current_user.nil?
    @ability = Ability.new(current_user)
  end

end
