module CurrentUser
  module ActionController
    def self.included(a_controller)
      a_controller.module_eval do
        extend ClassMethods
        include InstanceMethods
      
        attr_reader :current_user
      
        before_filter :auto_login
        
        alias_method_chain :perform_action, :current_user_assignment      
        helper_method :current_user, :logged_in?, :logged_in_as?
      end
    end
  
    module ClassMethods
    end
  
    module InstanceMethods
      def auto_login
        if !logged_in? && cookies[:auto_login]
          token = AutoLogin.find_by_token(cookies[:auto_login])
          log_in!(token.user.logins.create) unless token.nil?
        end
      end
    
      def log_in!(login)
        self.current_user = login.user
        session[:login_id] = login.id
        session[:user_id] = current_user.id
        if params[:auto_login] and not cookies[:auto_login]
          cookies[:auto_login] = {
            :value => current_user.auto_logins.create.to_s,
            :expires => 6000.days.from_now
          }
        end
      end
    
      def log_out!
        reset_session
        cookies.delete(:auto_login)
        self.current_user = nil
      end
    
      def perform_action_with_current_user_assignment
        load_current_user
        begin
          perform_action_without_current_user_assignment
        ensure 
          clear_current_user
        end
      end

      def current_user=(user)
        @current_user = user
        ::ActiveRecord::Base.current_user = user
      end

      def logged_in?
        !current_user.nil?
      end

      def logged_in_as?(user)
        logged_in? && current_user == user
      end

      def super_admin_required
        if !current_user.super_admin?
          raise SecurityTransgression
          return false
        end
      end

      def login_required
        if !logged_in?
          on_not_logged_in
          false
        elsif !current_user.account_verified?
          redirect_to new_email_address_verification_request_path(current_user, current_user.primary_email_address)
          false
        else
          true
        end
      end

      def on_not_logged_in
        redirect_to login_url
      end
      protected :on_not_logged_in

      def signup_required
        unless logged_in?
          redirect_to new_user_path
          false
        end
        true
      end
      
      private
      def load_current_user
        if session && session[:user_id]
          self.current_user = User.find(session[:user_id])
        else
          self.current_user = NilUser.instance
        end
      end
      
      def clear_current_user
        self.current_user = nil
      end
    end
  end

  module ActiveRecord
    def self.included(active_record)
      active_record.module_eval do
        extend ClassMethods
        include InstanceMethods
        alias_method_chain :create, :current_user
      end
    end

    module ClassMethods
      # these can't be a cattr_accessor because the instance
      # methods in the mixin need to take priority over the cattr_accessor
      @@current_user = nil
      
      def current_user
        @@current_user
      end

      def current_user=(current_user)
        @@current_user = current_user
      end
    end

    module InstanceMethods
      attr_writer :current_user

      def current_user
        @current_user || self.class.current_user
      end

      def create_with_current_user
        write_attribute('creator_id', current_user.id) if respond_to?(:creator_id) && creator_id.nil? && current_user
        create_without_current_user
      end
    end
  end
end

ActionController::Base.send(:include, CurrentUser::ActionController)
ActiveRecord::Base.send(:include, CurrentUser::ActiveRecord)
