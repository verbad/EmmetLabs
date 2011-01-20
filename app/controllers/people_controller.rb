class PeopleController < ApplicationController
  helper :milestones
  
  def index
    @column_count = 3
    @page_number = params[:page]
    # Integer arithmetic to round to truncate to @column_count
    @per_page = !params[:count].nil? ? params[:count].to_i / @column_count * @column_count : EntityAttributes::ClassMethods::EXPLORE_PER_PAGE
    @people = Person.sorted_by_relationship_count_and_full_name(@page_number, @per_page)
  end

  def show
    respond_to do |format|
      format.html { redirect_to viewer_path(:node_type => params[:controller], :id => params[:id]) }
      format.js   do
        @index = params[:index]
        @person = Person.find_by_param(params[:id])
      end
    end
  end

  def new
    @person = Person.from_string(params[:query])
    @first = true if params[:index] == 'first'

    respond_to do |format|
      format.js { }
    end
  end

  def create
    @person = Person.new(params[:person].merge({:author_id => current_user.id}))
    @index = params[:index]
    @first = true if params[:index] == 'first'
   
    respond_to do |format|
      format.html do
        if @person.save
          redirect_to "/people/#{@person.to_param}"
        else
          @person_errors = @person.errors
          render :action => "show"
        end
      end

      format.js do
        birth_parameters = massage_milestone_parameters(:birth).merge({:node => @person})
        birth_milestone = Milestone.new(birth_parameters)
        death_parameters = massage_milestone_parameters(:death).merge({:node => @person})
        death_milestone = Milestone.new(death_parameters)

        @editable = params[:editable]
        @person.milestones << birth_milestone unless birth_milestone.blank?
        @person.milestones << death_milestone unless death_milestone.blank?
        @person.save
        @person_errors = @person.errors
      end
    end
  end

  def update
    @person = Person.find_by_param(params[:id])
    
    if @person.update_attributes(params[:person])
      respond_to do |format|
        format.html { redirect_to person_url(@person) }
        format.js   { render :action => 'create' }
      end
    else
      @node = @person
      resolve_categories
      respond_to do |format|
        format.html { render :template => 'viewers/show' }
      end
    end
  end

  private

  def massage_milestone_parameters(key)
    params[key][:estimate] = false unless params[key].include?(:estimate)
    params[key][:year] = '' if params[key][:year] == 'YYYY'
    params[key]
  end

end
