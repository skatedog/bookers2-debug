class RelationshipsController < ApplicationController
  def create
    relationship = Relationship.new
    relationship.follower_id = current_user.id
    relationship.followed_id = params[:id]
    relationship.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    relationships = Relationship.all
    relationship = relationships.where(follower_id: current_user.id, followed_id: params[:id])
    relationship.destroy_all
    redirect_back(fallback_location: root_path)
  end
end