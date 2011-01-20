module EmailAddressResource
  def self.included(klass)
    klass.class_eval do
      include UserResource
      before_filter :load_email_address
    end
  end

  protected
  def load_email_address
    @email_address ||= @user.email_addresses.find(params[:email_address_id])
  end

end