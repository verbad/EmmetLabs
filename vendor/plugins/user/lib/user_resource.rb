module UserResource
  def self.included(klass)
    klass.class_eval do
      before_filter :load_user
    end
  end

  def load_user
    return if @user
    @user = User.find_by_param(params[:user_id])
    raise ActiveRecord::RecordNotFound.new("User not found with to_param of #{params[:user_id]}") unless @user
  end

  def current_user_must_be_user_resource
    @user == current_user
  end

end