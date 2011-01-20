class StoriesController < ApplicationController
  before_filter :login_required
  helper :milestones, :nodes
  
  def new
    param = params[:person_id] || params[:entity_id] || params[:node_id]
    @node = Node.find_person_or_entity_by_param(param) if param
    @node ||= Person.from_string(params[:query]) if params[:query]
    @first = true if params[:index] == 'first'
    @relationship_categories = RelationshipCategory.find(:all)

    respond_to do |format|
      format.html { }
    end
  end
end
