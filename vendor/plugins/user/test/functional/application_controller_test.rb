require File.dirname(__FILE__) + '/../test_helper'

class AController < ApplicationController
  before_filter :login_required, :only =>[:requires_login]
  before_filter :signup_required, :only =>[:requires_signup]
  disable_store_location :storage_1, :storage_2

  def requires_signup
    head :ok
  end

  def requires_login
    head :ok
  end

  def storage_1
    head :ok
  end

  def storage_2
    head :ok
  end

  def storage_3
    head :ok
  end

  def index
    super
    render :template => "application/index" 
  end

  public :log_in!
  public :log_out!
  public :cookies
end

class BController < ApplicationController
  disable_store_location :storage_2
  def storage_1
    render :text => ""
  end

  def storage_2
    render :text => ""
  end
end

class CurrentUserTestController < ApplicationController
  def test_current_user_on_controller
    expected_current_user = User.find(params[:expected_current_user_id])
    raise "User not set in controller" if current_user != expected_current_user
    render :text => ""
  end
  
  def test_current_user_on_model
    expected_current_user = User.find(params[:expected_current_user_id])    
    raise "User not set on ActiveRecord::Base" if ActiveRecord::Base.current_user != expected_current_user
    render :text => ""
  end
end

class ApplicationControllerTest < UserPluginTestCase

  def setup
    super
    @controller = AController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    get :index
  end

  def test_log_in__should_set_user_and_session_user
    user = users(:valid_bob)
    login = user.logins.create
    @controller.log_in!(login)
    assert_equal user.id, session[:user_id]
    assert_equal user, @controller.current_user
    assert_equal login.id, session[:login_id]
    assert_nil @response.cookies["auto_login"]
  end
  
  def test_log_in__should_set_current_user
    assert_equal nil, ActiveRecord::Base.current_user
    user = users(:valid_bob)
    login = user.logins.create
    @controller.log_in!(login)
    assert_equal users(:valid_bob), @controller.current_user
    assert_equal users(:valid_bob), ActiveRecord::Base.current_user
  end

  def test_log_out_should_unset_session
    login = users(:valid_bob).logins.create
    @controller.log_in!(login)
    @controller.log_out!
    assert_nil session[:location]
    assert_nil session[:login_id]
    assert_nil session[:user_id]
  end

  def test_log_in_should_set_auto_login_cookie
    user = users(:valid_bob)
    login = user.logins.create
    @controller.params.merge!({:auto_login => 'true'})

    assert_nil @request.cookies["auto_login"]
    @controller.log_in!(login)

    assert_not_nil @response.cookies["auto_login"]
  end

  def test_login_required__when_user_not_logged_in__should_redirect_to_login
    get :requires_login
    assert_redirected_to login_url
  end

  def test_login_required__when_user_authenticated_should_return_true
    user = users(:valid_bob)
    log_in(user)
    get :requires_login
    assert_response :success
  end

  def test_login_required__when_user_not_verified__should_redirect_to_somewhere
    log_in(users(:unverified_user))
    get :requires_login
    assert_redirected_to new_email_address_verification_request_path(users(:unverified_user), users(:unverified_user).primary_email_address)
  end

  def test_signup_required__when_user_logged_in__should_return_true
    log_in(users(:unverified_user))
    get :requires_signup
    assert_response :success
  end

  def test_signup_required__when_user_not_logged_in__should_redirect_to_signup
    get :requires_signup
    assert_redirected_to new_user_path
  end

  def test_auto_login
    user = users(:valid_bob)
    the_token = AutoLogin.create(:user => user)
    @request.cookies['auto_login'] = CGI::Cookie.new('auto_login', the_token.token)

    get :index
    assert_not_nil user.logins.find_by_id(session[:login_id])
  end

  def test_store_location
    get :index
    assert_equal({'action'=>'index', 'controller'=>'a'}, session[:location], "Ordinary actions should store location")
    get :storage_1
    assert_equal({'action'=>'index', 'controller'=>'a'}, session[:location], "Location storage is disabled for storage 1")
    get :storage_2
    assert_equal({'action'=>'index', 'controller'=>'a'}, session[:location], "Same for storage 2")
    get :storage_3
    assert_equal({'action'=>'storage_3', 'controller'=>'a'}, session[:location], "Storage 3 isn't mentioned, so it should store location")
    post :index
    assert_equal({'action'=>'storage_3', 'controller'=>'a'}, session[:location], "Posts should be ignored")
    xhr :get, :index
    assert_equal({'action'=>'storage_3', 'controller'=>'a'}, session[:location], "XHR gets should be ignored")
  end

  def test_store_location__controllers_are_independent
    @controller = BController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    get :storage_1
    assert_equal({'action'=>'storage_1', 'controller'=>'b'}, session[:location], "Storage 1 should store, even though A disables it, because this is B")
    get :storage_2
    assert_equal({'action'=>'storage_1', 'controller'=>'b'}, session[:location], "B disables storage 2, though.")
  end
  
  def test_current_user_id_set_in_session__sets_current_user_during_request_and_unsets_it_thereafter
    @controller = CurrentUserTestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    user = log_in :valid_bob

    get :test_current_user_on_controller, :expected_current_user_id => user.id
    assert_response :success
    
    get :test_current_user_on_model, :expected_current_user_id => user.id
    assert_response :success
    
    assert_nil @controller.send(:current_user)
    assert_nil ActiveRecord::Base.send(:current_user)
  end
  
end