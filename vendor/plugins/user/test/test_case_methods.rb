module UserPluginTestCaseMethods
  def new_user(attr_overrides = {})
    attrs = new_user_attributes(attr_overrides)
    user = User.new(attrs)
    # Password/confirm is not set through group model assignment, so set them specifically
    user.password = 'password'
    user.password_confirmation = 'password'
    return user
  end

  def new_user_attributes(changes = {})
    unique_name = "valid"
    while User.find_by_unique_name(unique_name)
      unique_name += "1"
    end
    {
      :email_address => 'newguy@example.com',
      :password => 'password',
      :password_confirmation => 'password',
      :unique_name => unique_name
    }.merge(changes)
  end
  
  def log_in(user)
    user = users(user) if user.is_a?(Symbol)
    login = Login.create(:user => user)
    @request.session[:user_id] = user.id
    @request.session[:login_id] = login.id
    # TODO: grokit checked this in as part of a changeset and it broke group plugin view tests
    #@controller.send(:current_user=, user)
    return user
  end

  def log_in_as_admin
    admin = users(:admin)
    admin.should be_super_admin
    log_in(admin)
    admin
  end

  def log_out
    @request.session[:user_id] = nil
  end

  def set_last_visited_page(url)
    @request.session[:location] = url
  end

  def assert_logged_in_as(user)
    assert_equal user.id, @request.session[:user_id], "User #{user.id} should be logged in, but is not"
  end

  def assert_not_logged_in
    assert_nil @request.session[:user_id], "No users should be logged in, but we found user ID #{@request.session[:user_id]}"
  end

  def logged_in?
    !request.session[:user_id].nil?
  end
end
