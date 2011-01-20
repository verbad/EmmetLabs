class EmailAddressesController < ApplicationController
  include UserResource

  before_filter :login_required
  before_filter :load_email_address, :only => [:show, :destroy, :update]

  def index
    @email_addresses = @user.email_addresses
  end
  
  def new
    @email_address = @user.email_addresses.build
  end

  def create
    @email_address = @user.email_addresses.build(params[:email_address])
    if @email_address.save
      on_successful_create
    else
      on_failed_create
    end
  end

  def show
  end

  def update
    @email_address.attributes = params[:email_address]
    if @email_address.save
      on_successful_update
    else
      on_failed_update
    end
  end

  def destroy
    if @email_address.destroy
      on_successful_destroy
    else
      on_failed_destroy
    end
  end

  protected
  def load_email_address
    @email_address = @user.email_addresses.find(params[:id])
  end

  def on_successful_create
    redirect_to user_email_address_path(@user, @email_address)
  end

  def on_failed_create
    render :action => :new
  end

  def on_successful_destroy
    redirect_to user_email_addresses_path(@user)
  end

  def on_failed_destroy
    head :forbidden
  end

  def on_successful_update
    redirect_to user_email_addresses_path(@user)
  end

  def on_failed_update
    head :forbidden
  end
  
end