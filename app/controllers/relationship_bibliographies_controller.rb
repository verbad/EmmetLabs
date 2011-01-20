class RelationshipBibliographiesController < ApplicationController
  before_filter :login_required

  def update
    @relationship = Relationship.find(params[:relationship_id])
    @relationship.update_attributes(params[:relationship])
  end
end