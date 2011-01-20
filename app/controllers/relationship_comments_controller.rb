class RelationshipCommentsController < ApplicationController
  before_filter :login_required
  
  def create
    @relationship = Relationship.find(params[:relationship_id])
    @relationship.comments.create(:author => current_user, :text => params[:comment][:text])
  end

end
