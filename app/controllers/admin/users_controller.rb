class Admin::UsersController < Admin::AdminController

  def index
    sort_by = params[:sort_by]
    if sort_by.nil?
      sort_by = 'super_admin_rev,unique_name'
    end
      
    @users = User.find(:all, :order => User.sort_by_to_sql(sort_by))
  end

  def edit
  end 

  def new
    @user = User.new
  end

  def on_failed_update
    redirect_to admin_users_path
  end

  def on_failed_create
    render :template => 'admin/users/new.html.haml'
  end

  def on_successful_create
    NewUserEmailer.deliver_welcome(@user, params[:user][:password])
    redirect_to admin_users_path
  end

  def on_successful_update
    redirect_to admin_users_path
  end

end