class EntityAttributesController < ApplicationController
  before_filter :login_required

  def update
    @node = find_entity_or_person_by_params
    @node.attributes = params_for_entity
    changed_attributes = @node.changed
    @node.save!

    attribute_name = changed_attributes.blank? ? params_for_entity.shift.first : changed_attributes.first
    attribute_name = "tags" if attribute_name == "tag_list" # WARNING: special case for tags

    respond_to do |wants|
      wants.js do
        render :update do |page|
          if @node.is_a?(Person) || attribute_name == "tags"
            page.replace attribute_name, :partial => "#{attribute_name}/show", :locals => { :person => @node, :node => @node }
          else
            page.replace attribute_name, :partial => "entities/#{attribute_name}", :locals => { :entity => @node }
          end
        end
      end
    end
  end
  
  private
  
  def find_entity_or_person_by_params
    node_class.find_by_param(params["node_id"])
  end
  
  def params_for_entity
    if node_class == Person
      p = params[:person]
    elsif node_class == Entity
      p = params[:entity]
    else
      p = {}
    end
    if p.blank?
      p = params[:node]
    end
    p
  end
end
