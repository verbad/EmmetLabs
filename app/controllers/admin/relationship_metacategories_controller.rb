class Admin::RelationshipMetacategoriesController <  Admin::AdminController
  before_filter :login_required
  def index
    @relationship_metacategories = RelationshipMetacategory.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @relationship_metacategories.to_xml }
    end
  end

  def new
    @relationship_metacategory = RelationshipMetacategory.new
  end

  def edit
    @relationship_metacategory = RelationshipMetacategory.find(params[:id])
  end

  def create
    @relationship_metacategory = RelationshipMetacategory.new(params[:relationship_metacategory])

    respond_to do |format|
      if @relationship_metacategory.save
        flash[:notice] = 'RelationshipMetacategory was successfully created.'
        format.html { redirect_to admin_relationship_metacategories_url }
        format.xml  { head :created, :location => relationship_metacategories_url }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relationship_metacategory.errors.to_xml }
      end
    end
  end

  def update
    @relationship_metacategory = RelationshipMetacategory.find(params[:id])

    respond_to do |format|
      if @relationship_metacategory.update_attributes(params[:relationship_metacategory])
        flash[:notice] = 'RelationshipMetacategory was successfully updated.'
        format.html { redirect_to admin_relationship_metacategories_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relationship_metacategory.errors.to_xml }
      end
    end
  end

  def destroy
    @relationship_metacategory = RelationshipMetacategory.find(params[:id])
    @relationship_metacategory.destroy

    respond_to do |format|
      format.html { redirect_to admin_relationship_metacategories_url }
      format.xml  { head :ok }
    end
  end
end
