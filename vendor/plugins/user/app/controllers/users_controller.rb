class UsersController < ApplicationController
  before_filter :load_user, :only => [:show, :edit, :update]
  before_filter :login_required, :only => [:edit, :update]

  disable_store_location :new, :create
  # require_ssl :new, :create
  filter_parameter_logging( :password )

  def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      log_in!(@user.logins.create)
      on_successful_create
    else
      on_failed_create
    end
  end

  def update
    @user.attributes = params[:user]
    if @user.save
      on_successful_update
    else
      on_failed_update
    end
  end

  protected
  def can_edit?
    current_user.can_update?(@user)
  end

  def can_new?
    current_user.can_create?(User.new)
  end
  
  def load_user
    @user = User.find_by_param(params[:id])
    raise ActiveRecord::RecordNotFound.new("User not found with to_param of #{params[:user_id]}") unless @user
  end

  def on_successful_create
    flash[:notice] = 'Your account has been created.'.customize
    redirect_back new_email_address_verification_request_path(@user, @user.primary_email_address)
  end

  def on_failed_create
    render :action => "new"
  end

  def on_successful_update
    flash[:notice] = 'User was successfully updated.'.customize
    redirect_to @user
  end

  def on_failed_update
    render :action => "edit"    
  end
end
