module UserAuthentication
  def self.included(user_class)
    user_class.class_eval do
      attr_reader :password
      attr_accessor :current_password

      include InstanceMethods
      extend ClassMethods
      
      validates_presence_of :password,
                            :on => :create,
                            :message => "Please enter your password".customize
      validates_presence_of :password_confirmation,
                            :on => :save,
                            :if => lambda {|record| !record.password.nil?},
                            :message => "Please confirm your password".customize
      validates_presence_of :current_password,
                            :on => :update,
                            :if => lambda {|record| record.must_confirm_password?},
                            :message => "Please enter your current password".customize
      validates_length_of :password,
                          :minimum => 3,
                          :on => :save,
                          :if => lambda {|record| !record.password.nil?}
      validates_confirmation_of :password,
                                :on => :save,
                                :message => "Password does not match confirmation".customize
      validate_on_update :password_is_correct

      before_save :encrypt_password
    end
  end

  module InstanceMethods
    def new_salt
      Guid.new.to_s
    end

    def password=(new_password)
      @password = new_password
      @password_changed = true
    end

    def must_confirm_password?
      password_changed? && password_reset_tokens.empty?
    end

    def password_changed?
      @password_changed
    end

    def authenticate?(password)
      encrypted_password == self.class.encrypt(password, salt) ? self : nil
    end

    def password_is_correct
      if must_confirm_password? && !User.authenticate(:email_address => email_address, :password => current_password)
        errors.add(:current_password, "The password you entered does not match our records".customize)
      end
    end

    def clear_password_and_password_confirmation
      @password_confirmation = nil
      @password = nil
      @password_changed = false
    end

    def encrypt_password
      self.salt ||= new_salt
      self.encrypted_password = self.class.encrypt(@password, salt) if @password
      clear_password_and_password_confirmation
      true
    end
  end

  module ClassMethods
    def encrypt(text, salt)
      Digest::SHA1::hexdigest("#{salt}--#{text}--")
    end

    def authenticate(options)
      user = User.find_by_email_address(options[:email_address]) ||
        find_by_unique_name(options[:email_address])
      user && user.authenticate?(options[:password])
    end
  end
end