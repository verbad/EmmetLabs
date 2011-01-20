class PasswordController < ApplicationController
  protected
  def on_successful_update
    flash.now[:notice] = 'Password was successfully updated.'.customize
    render :action => :edit
  end
end