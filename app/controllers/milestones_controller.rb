class MilestonesController < ApplicationController
  disable_store_location :index
  before_filter :resolve_node

  EDIT_MILESTONE_PREFIX = 'milestone_id_'
  NEW_MILESTONE_PREFIX = 'milestone_new_'

  def index
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

  def new
    @distinguisher = params[:distinguisher]
    respond_to do |format|
      format.js { }
    end
  end

  def create
    edit_milestone_keys = params.keys.select{|key| key.to_s.index(EDIT_MILESTONE_PREFIX) == 0}
    edit_milestone_keys.each do |key|
      milestone_id = key.to_s[EDIT_MILESTONE_PREFIX.length..key.to_s.length].to_i
      milestone = @node.milestones.select{|a_milestone| a_milestone.id == milestone_id}.first
      massage_milestone_parameters(key)
      if !milestone.update_attributes(params[key])
        @errors = true
      end
    end

    new_milestone_keys = params.keys.select{|key| key.to_s.index(NEW_MILESTONE_PREFIX) == 0}
    new_milestone_keys.each do |key|
      massage_milestone_parameters(key)
      milestone = Milestone.new(params[key].merge({:node_id => @node.id, :node_type => @node.class.name}))
      unless milestone.blank?
        @node.milestones << milestone
        @errors = true if !milestone.valid?
      end
    end

    @node.reload unless @errors

    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace 'milestones', :partial => 'index', :locals => { :node => @node }
        end
      end
    end
  end

  def destroy
    milestone = Milestone.find(params[:id])
    respond_to do |format|
      if milestone.destroy
        @node = milestone.node
        format.js {}
      else
        raise 'no'
      end
    end
  end

  private

  def resolve_node
    p = params[:node_id] || params[:person_id] || params[:entity_id]
    # Changing names are causing crashes. Special case this until we remove Entities completely
    # @node = Node.find_person_or_entity_by_param(p)
    p.gsub!(/.*_(\d+)/) { $1 }
    @node = Person.find(p)
    true
  end

  def massage_milestone_parameters(key)
    params[key][:estimate] = false unless params[key].include?(:estimate)
    params[key][:year] = '' if params[key][:year] == 'Year'
    params[key]
  end

end
