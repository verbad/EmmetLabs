class ApplicationController < ActionController::Base
  # For testing 404/500 errors REMOVE IT WHEN DONE
  # alias_method :rescue_action_locally, :rescue_action_in_public
  
  include ExceptionNotifiable
  session :session_key => '_emmet_session_id'
  helper :xml
  before_filter :resolve_content_pages

  hide_action :node_class
  def node_class
    class_name = params[:node_type].classify
    raise ActiveRecord::RecordNotFound unless %w(Person Entity).include?(class_name)
    class_name.constantize
  end
  
  private
  
  def resolve_content_pages
    @content_pages = ContentPage.find(:all, :conditions => ['draft is false AND display_in_footer is true'])
  end

  def resolve_categories
    @meta_categories = RelationshipMetacategory.sorted_by_name
    @categories_count = RelationshipCategory.count(:all)
  end
  
  # Override vendor/plugins/user/lib/store_location
  def store_location
    if should_store_location?
      session[:location] = params.dup
      # Delete XML & JS format so that the redirect is to the HTML.
      session[:location].delete(:format)
    end
  end
  
  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      render_500
    end
  end
  
  def render_404
    render_error(404)
  end
  
  def render_500
    render_error(500)
  end
  
  def render_error(status)
    respond_to do |format|
      format.html { render :template => "errors/error_#{status}", :layout => 'application', :status => status }
      format.all  { render :nothing => true, :status => status }
    end
    true  # so we can do "render_xxx and return"
  end
  
  
end
