class ContentPagesController < ApplicationController
  #before_filter :login_required

  def show
    if params[:name]
      @content_page = ContentPage.find_by_calculated_dashified_name(params[:name])
    else
      @content_page = ContentPage.find(params[:id])
    end

    #ActiveRecord::RecordNotFound if @content_page.draft? && !current_user.super_admin?
    render_404 if @content_page.nil? || (@content_page.draft? && !current_user.super_admin?)
  end

 
end
