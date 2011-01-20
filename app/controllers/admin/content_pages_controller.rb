class Admin::ContentPagesController < Admin::AdminController  
  
  def index
    @admin_content_pages = ContentPage.find(:all)
  end

  def show
    if params[:name]
      @content_page = ContentPage.find_by_calculated_dashified_name(params[:name])
    else
      @content_page = ContentPage.find(params[:id])
    end

   raise ActiveRecord::RecordNotFound if @content_page.draft? && !current_user.super_admin?
  end

  def new
    @content_page = ContentPage.new
  end

  def edit
    @content_page = ContentPage.find(params[:id])
  end

  def create
    @content_page = ContentPage.new(params[:content_page])

    if @content_page.save
      flash[:notice] = 'Success!'
      redirect_to(admin_content_page_path(@content_page))
    else
      render :action => "new"
    end
  end

  def update
    @content_page = ContentPage.find(params[:id])

    if @content_page.update_attributes(params[:content_page])
      flash[:notice] = 'Successfully updated!'
      redirect_to(admin_content_page_path(@content_page))
    else
      render :action => "edit"
    end
  end

  def destroy
    @content_page = ContentPage.find(params[:id])
    @content_page.destroy

    redirect_to(admin_content_pages_url)
  end
end
