class RelationshipsController < ApplicationController
  before_filter :login_required
  before_filter :resolve_relationship

  def edit
    @related_people = @relationship.related_people
  end

  def update
    if @relationship.update_attributes(params[:relationship])
      flash[:notice] = 'Relationship was successfully updated.'
      redirect_to edit_relationship_url(@relationship)
    else
      render :action => "edit"
    end
  end

  private

  def resolve_relationship
    @relationship = Relationship.find(params[:id])
    true
  end
end
