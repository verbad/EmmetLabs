class PersonSuggestionsController < ApplicationController
  before_filter :login_required

  def index
    @person_suggestions = []
    return @person_suggestions if params[:query].blank?

    @show_all = params[:show_all]
    
    conditions_string = "(calculated_full_name like ? or common_name like ?) "

    from_person_id = params[:from_person_id]
    unless from_person_id.blank?
      @from_person = Person.find(from_person_id)
      conditions_string += "and id != #{from_person_id}"
    end

    conditions = [conditions_string]
    conditions << "#{params[:query]}%"
    conditions << "#{params[:query]}%"
    @person_suggestions = Person.find(:all, :conditions => conditions, :limit =>@show_all ? nil : 5)
    @person_suggestions_count = Person.count(:all, :conditions => conditions) if @person_suggestions.size >= 5

    render :partial => 'index', :locals => {:person_suggestions => @person_suggestions}
  end

end
