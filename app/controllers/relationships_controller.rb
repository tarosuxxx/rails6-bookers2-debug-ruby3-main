class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.followings << user

    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    relationship = current_user.relationships.find_by(followed_id: user.id)
    relationship.destroy

    redirect_to request.referer
  end
end
