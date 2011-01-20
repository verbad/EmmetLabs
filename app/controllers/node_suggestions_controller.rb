class NodeSuggestionsController < ApplicationController
  before_filter :login_required

  def index
    @node_suggestions = []
    return @node_suggestions if params[:query].blank?

    @show_all = params[:show_all] #TODO: this is broken
    @index = params[:index]

    wildcard = "%#{params[:query]}%"
    conditions_values = {:name => wildcard}

    # find people first
    conditions_string = "(calculated_full_name like :name or common_name like :name) "

    from_node_id = params[:from_node_id]
    if !from_node_id.blank? && params[:from_node] == 'Person'
      @from_node = Person.find(from_node_id)
      conditions_string += "and id != :from_node_id"
      conditions_values[:from_node_id] = from_node_id
    end

    conditions = [conditions_string, conditions_values]
    @person_suggestions = Person.find(:all, :conditions => conditions, :limit =>@show_all ? nil : 5)
    @person_suggestions_count = Person.count(:all, :conditions => conditions) 


    # now find entities
    conditions_string = "(full_name like :name) "

    if !from_node_id.blank? && params[:from_node] == 'Entity'
      @from_node = Entity.find(from_node_id)
      conditions_string += "and id != :from_node_id"
      conditions_values[:from_node_id] = from_node_id
    end

    conditions = [conditions_string, conditions_values]
    @entity_suggestions = Entity.find(:all, :conditions => conditions, :limit =>@show_all ? nil : 5)
    @entity_suggestions_count = Entity.count(:all, :conditions => conditions) 

    @node_suggestions = @entity_suggestions + @person_suggestions
    @node_suggestions = @node_suggestions[0..4] unless @show_all
    @node_suggestions_count = @person_suggestions_count + @entity_suggestions_count

    render :partial => 'index', :locals => {:node_suggestions => @node_suggestions}
  end

end
