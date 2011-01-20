class Admin::HomePageRelationshipsController < Admin::AdminController
   
  before_filter :load_home_page_relationship
  
  
  def show
    @directed_relationship = @home_page_relationship.directed_relationship
  end
  
  def edit
    @directed_relationship = @home_page_relationship.directed_relationship
  end
  
  def update
    from_person = Person.find_by_param(params[:home_page_relationship][:from_param])
    to_person = Person.find_by_param(params[:home_page_relationship][:to_param])
    if from_person.nil? or to_person.nil?
      flash[:notice] = "One(or both) people are invalid"
      return redirect_to(:action => 'edit')
    end
    @directed_relationship = DirectedRelationship.find_by_from_id_and_to_id(from_person.id, to_person.id)
    if @directed_relationship.nil?
      flash[:notice] = "There is no relationship between those two people"
      return redirect_to(:action => 'edit')
    else
      @home_page_relationship.directed_relationship = @directed_relationship
      @home_page_relationship.save!
      render :action => 'show'
    end
  end
  
  private
  
  def load_home_page_relationship
    @home_page_relationship = HomePageRelationship.find(:first, :include => :directed_relationship)
  end

end