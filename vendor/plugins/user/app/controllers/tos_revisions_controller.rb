class TosRevisionsController < ApplicationController
  before_filter :login_required
  
  def index
    @tos_revisions = TermsOfService.find(:all, :order => "revision DESC")
  end

  def show
    @tos_revision = TermsOfService.find(params[:id])
  end
  
  def new
    @tos_revision = TermsOfService.new
  end
  
  def create
    @tos_revision = TermsOfService.new(params[:tos_revision])
    if @tos_revision.save
      on_successful_create
    else
      on_failed_create
    end
  end

  protected
  def can_show?
    current_user.super_admin?
  end
  
  def on_successful_create
    flash[:notice] = 'Terms of Service has been created.'.customize
    redirect_to tos_revisions_path
  end

  def on_failed_create
    render :action => "new"
  end
  
end