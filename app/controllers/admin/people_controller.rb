class Admin::PeopleController < Admin::AdminController

  def index
    @column_count = 3
    @page_number = params[:page]
    # Integer arithmetic to round to truncate to @column_count
    @per_page = !params[:count].nil? ? params[:count].to_i / @column_count * @column_count : EntityAttributes::ClassMethods::EXPLORE_PER_PAGE
    @people = Person.paginate(:all,
    :page => @page_number,
    :per_page => @per_page,
    :order => 'calculated_dashified_full_name asc')
  end

  def show
    @person = Person.find_by_param(params[:id])
  end

  def destroy
    @person = Person.find_by_param(params[:id])
    @person.destroy
    redirect_to(admin_people_url)
  end
  
  def migrate_to_entity
    @person = Person.find_by_param(params[:id])
    Person.transaction do
      Entity.transaction do
        @entity = Entity.migrate_from_person!(@person)
        @person.reload.destroy
      end
    end
    redirect_to(admin_entities_url)
  end  
end
