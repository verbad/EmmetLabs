class Admin::EntitiesController < Admin::AdminController

  def index
    @column_count = 3
    @page_number = params[:page]
    # Integer arithmetic to round to truncate to @column_count
    @per_page = !params[:count].nil? ? params[:count].to_i / @column_count * @column_count : EntityAttributes::ClassMethods::EXPLORE_PER_PAGE
    @entities = Entity.paginate(:all,
    :page => @page_number,
    :per_page => @per_page,
    :order => 'calculated_dashified_full_name asc')
  end

  def show
    @entity = Entity.find_by_param(params[:id])
  end

  def destroy
    @entity = Entity.find_by_param(params[:id])
    @entity.destroy
    redirect_to(admin_entities_url)
  end
   
end
