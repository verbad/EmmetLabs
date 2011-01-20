class Admin::RelationshipCategoriesController <  Admin::AdminController
  before_filter :login_required
  before_filter :retrieve_categories_and_meta_categories, :only => [:index, :new, :edit]

  def index
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @relationship_categories.to_xml }
    end
  end

  def new
    @relationship_category = RelationshipCategory.new
    @opposite = RelationshipCategory.new
  end

  def edit
    @relationship_category = RelationshipCategory.find(params[:id])
    if @relationship_category.opposite_id.nil?
      @relationship_categories = RelationshipCategory.symmetric
    else
      @relationship_categories = RelationshipCategory.non_symmetric - [@relationship_category, @relationship_category.opposite]
    end
  end

  def create
    if RelationshipCategory.create_with_opposite(params[:relationship_category], params[:opposite])
      flash[:notice] = 'RelationshipCategory was successfully created.'
      redirect_to admin_relationship_categories_url
    else
      @relationship_metacategories = RelationshipMetacategory.find(:all)
      render :action => "new"
    end
  end

  def update
    @relationship_category = RelationshipCategory.find(params[:id])
    if params[:symmetric]
      @relationship_category.make_symmetric
    elsif (params[:migrate] && !params[:migrate].empty?)
      @relationship_category.migrate_to(params[:migrate])
    end
    
    if @relationship_category.update_attributes(params[:relationship_category])
      flash[:notice] = 'RelationshipCategory was successfully updated.'
      redirect_to admin_relationship_categories_url
    else
      retrieve_categories_and_meta_categories
      render :action => "edit"
    end
  end

  def destroy
    @relationship_category = RelationshipCategory.find(params[:id])
    @relationship_category.opposite.destroy unless @relationship_category.opposite_id.nil?
    @relationship_category.destroy
    redirect_to admin_relationship_categories_url
  end

  private

  def retrieve_categories_and_meta_categories
    @relationship_metacategories = RelationshipMetacategory.find(:all)
    @relationship_categories = RelationshipCategory.find(:all)
  end
end
