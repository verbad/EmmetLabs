class LoginController < ApplicationController
  def show
    @login = Login.new
    @hideHeader = true;
    render :template => 'login/show.html.haml'
  end
  
  def on_successful_create
    respond_to do |format|
      format.html {redirect_back post_login_path}
      format.js {}
    end
  end
  
  def on_failed_create
    @hideHeader = true;
    flash.now[:error] = "Login unsuccessful".customize
    render :action => 'show'
  end

end