class RelationshipsController < ApplicationController
  def create
    current_user.followeds_list.create(followed_id: params[:id])
    # relationship = Relationship.new
    # relationship.follower_id = current_user.id
    # relationship.followed_id = params[:id]
    # relationship.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.followeds_list.find_by(followed_id: params[:id]).destroy
    # relationships = Relationship.all
    # relationship = relationships.where(follower_id: current_user.id, followed_id: params[:id])
    # relationship.destroy_all
    redirect_back(fallback_location: root_path)
  end
end