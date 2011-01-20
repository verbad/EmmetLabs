class Admin::UsersController < Admin::AdminController
  before_filter :load_user, :only => [:edit, :update, :destroy]
  helper :users

  def index
    @users = User.find(:all, :order => "super_admin DESC, unique_name")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.super_admin = params[:user][:super_admin]
    @user.accept_terms_of_service = '1'
    @user.primary_email_address.verified = true

    if @user.save
      on_successful_create
    else
      on_failed_create
    end
  end

  def update
    @user.attributes = params[:user]
    @user.super_admin = params[:user][:super_admin]

    if @user.save
      on_successful_update
    else
      on_failed_update
    end
  end

  def destroy
    if @user.destroy
      on_successful_destroy
    else
      on_failed_destroy
    end
  end

  protected
  def on_successful_update
    flash[:notice] = "Account for #{@user.unique_name} has been updated".customize
    redirect_to admin_users_path
  end

  def on_failed_update
    flash[:error] = "Failed to update #{@user.unique_name}".customize
    redirect_to admin_users_path
  end

  def on_successful_create
    flash[:notice] = "Account for #{@user.unique_name} has been created".customize
    redirect_to admin_users_path
  end

  def on_failed_create
    flash[:error] = "Failed to save #{@user.unique_name}".customize
    render :action => 'new'
  end

  def on_successful_destroy
    redirect_to admin_users_path
  end

  def on_failed_destroy
    flash[:error] = "Failed to delete #{@user.unique_name}".customize
    redirect_to admin_users_path
  end

  def load_user
    @user = User.find_by_param(params[:id])
  end

end
