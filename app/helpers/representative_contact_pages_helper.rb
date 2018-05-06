module RepresentativeContactPagesHelper
  def get_subrep_by_group(group_id)
    SubRep.where(group_id:group_id)
  end

  def get_user_detail_by_group(group_user_id)
    UserDetail.where(user_id:group_user_id)
  end
end
