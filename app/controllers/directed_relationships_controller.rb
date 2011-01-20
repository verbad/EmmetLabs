class DirectedRelationshipsController < ApplicationController
  before_filter :resolve_node, :only => [:index, :new, :create, :update]
  before_filter :resolve_categories, :only => [:index, :new, :create, :update, :show]

  helper :nodes

  CLOSURE_DEPTH = 2

  def new
    @to_node = params[:to_node_id].nil? ? Person.new : Person.find_by_param(params[:to_node_id])
    @directed_relationship = DirectedRelationship.new(:from => @from_node, :to => @to_node)
    @editable = params[:editable]
    respond_to do |fmt|
      fmt.html { redirect_to new_story_path(params.slice(:node_id)) }      
      fmt.js {}
    end
  end

  def show
    @from = Node.find_person_or_entity_by_param(params[:from_id])
    @to = Node.find_person_or_entity_by_param(params[:to_id])
    raise ActiveRecord::RecordNotFound unless @from && @to
    
    @directed_relationship = DirectedRelationship.find_by_from_and_to(@from, @to)
    raise ActiveRecord::RecordNotFound unless @directed_relationship
    
    respond_to do |fmt|
      fmt.html {}
      fmt.xml do
        #logger.debug("Sleeping to ease debugging of Wander widget (remove me!)")
        #sleep 10 unless params[:first] == 'true'
        depth = params[:depth].nil? ? CLOSURE_DEPTH : params[:depth].to_i
        @people = people_for_xml(depth)
        @directed_relationships = relationships_for_xml(depth)
        render :action => 'show.xml.haml', :layout => false
      end
      fmt.js {}
    end
  end

  def create
    @new = params[:new]
    @relationship_categories = RelationshipCategory.find(:all)
    @to_node = Node.find_person_or_entity_by_param(params[:to_node_id])
    @relationship = Relationship.new({:summary => params[:relationship][:summary], :author_id => current_user.id})
    @directed_relationship = @from_node.directed_relationships.build(
      :to => @to_node,
      :category_id => params[:category_id]
    )
    begin
      Relationship.transaction do
        @relationship.save!
        @directed_relationship.relationship = @relationship
        @directed_relationship.save!
      end
    rescue => exception
      #TODO: shouldn't we handle this error somehow?
    end
    respond_to do |fmt|
      fmt.html { redirect_to(  "/pair/#{@directed_relationship.from.to_param}/#{@directed_relationship.to.to_param}") }
      fmt.js {}
    end
  end

  def update
    @directed_relationship = DirectedRelationship.find(params[:id])
    @to_node = @directed_relationship.to
    @relationship = @directed_relationship.relationship

    @directed_relationship.update_attribute :category_id , params[:category_id]
    @directed_relationship.relationship.update_attribute :summary, params[:relationship][:summary]
 
    if  @directed_relationship.valid? && @directed_relationship.relationship.valid?
      render :action => 'create'
    end
  end

  private

  def people_for_xml(depth = CLOSURE_DEPTH)
    cache = Hash.new
    set = Set.new
    set.merge(@to.relatives_with_primary_photo(depth, cache))
    set.merge(@from.relatives_with_primary_photo(depth, cache))
    #puts "----------------------------------------- PEOPLE UPDATE START"
    # UGLY workaround, leak!
    set.each {|n| cache.update_item(n)}
    #puts "----------------------------------------- END"
    #set
  end

  def relationships_for_xml(depth = CLOSURE_DEPTH)
    cache = Hash.new
    set = @from.directed_relations_set(depth, cache).merge @to.directed_relations_set(depth, cache)
    #puts "----------------------------------------- RELATIONSHIPS UPDATE START"
    # UGLY workaround, leak!
    set.each {|n| cache.update_item(n)}
    #puts "----------------------------------------- END"
    #set
  end

  def resolve_node
    param = params[:person_id] || params[:entity_id] || params[:node_id]
    @from_node = Node.find_person_or_entity_by_param(param) if param
    true # return true, used as filter
  end

end
