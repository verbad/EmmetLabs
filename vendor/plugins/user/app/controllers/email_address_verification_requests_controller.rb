class EmailAddressVerificationRequestsController < ApplicationController
  disable_store_location :show, :new, :create, :update
  before_filter :signup_required, :only => [:new, :create]
  include EmailAddressResource

  def show
    @token = EmailAddressVerificationToken.find_by_param(params[:id])
  end

  def new
  end

  def create
    @token = @email_address.verification_tokens.build
    if @token.save
      on_successful_create
    else
      on_failed_create
    end
  end

  def update
    @token = EmailAddressVerificationToken.find_by_param(params[:id])
    if @token.save
      log_in!(@token.user.logins.create)
      on_successful_update
    else
      on_failed_update
    end
  end

  protected
  def on_successful_create
    flash[:notice] = "A new validation email has been sent to {:email_address}".customize(:email_address => @email_address)
    redirect_to home_page_path
  end

  def on_failed_create
    head :forbidden
  end

  def on_successful_update
    flash[:notice] = "Your address has been verified. Welcome!".customize
    redirect_to home_page_path
  end

  def on_failed_update
    flash[:error] = 'There was a problem validating your account.'.customize
    redirect_to new_email_address_verification_request_path(@email_address.user, @email_address)
  end
end

