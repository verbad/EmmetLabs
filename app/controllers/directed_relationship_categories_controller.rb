class DirectedRelationshipCategoriesController < ApplicationController
  before_filter :login_required
  before_filter :resolve_categories
  
  def update
    @directed_relationship = DirectedRelationship.find(params[:id])
    if @directed_relationship.update_attributes(params[:directed_relationship])
      opposite_category_id = @directed_relationship.category.opposite.nil? ? @directed_relationship.category.id : @directed_relationship.category.opposite.id
      @directed_relationship.opposite.update_attribute(:category_id, opposite_category_id)
    end
  end
end