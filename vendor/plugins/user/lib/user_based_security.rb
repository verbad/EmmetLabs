module UserBasedSecurity
  module ActionController
    def self.included(controller)
      controller.module_eval do
        include InstanceMethods
        alias_method_chain :perform_action_without_filters, :user_based_security
      end
    end
    
    module InstanceMethods
      def perform_action_without_filters_with_user_based_security
        assert_security(params[:action])
        perform_action_without_filters_without_user_based_security
      end
      
      def assert_security(action)
        if respond_to?("can_#{action}?")
          die!(action) unless send("can_#{action}?")
        elsif respond_to?("can_access?")
          die!(action) unless can_access?
        end
      end

      def die!(action)
        raise SecurityTransgression, "User '#{current_user}' may not #{action} #{self.inspect}"
      end
    end
  end
  
  module ActiveRecord
    VERB_TO_QUESTION_METHOD = {
      :create => :creatable_by?,
      :update => :updatable_by?,
      :destroy => :destroyable_by?,
      :read => :readable_by?
    }
    
    def self.included(active_record)
      active_record.module_eval do
        extend ClassMethods
        include InstanceMethods
        
        cattr_accessor :permission_check_passed
        
        class << self
          alias_method_chain :find, :security_check
        end

        alias_method_chain :create, :security_check
        alias_method_chain :update, :security_check
        alias_method_chain :destroy, :security_check
      end
    end
    
    module ClassMethods
      def as_user(user, &block)
        self.current_user = user
        begin
          yield
        ensure
          self.current_user = nil
        end
      end
      
      def find_with_security_check(*args)
        returning find_without_security_check(*args) do |found|
          if found.is_a?(::ActiveRecord::Base) && !permission_check_passed
            found.assert_security(:read)
          end
        end
      end
    end
    
    module InstanceMethods
      def create_with_security_check(*args)
        action_with_security_check(:create, *args)
      end

      def update_with_security_check(*args)
        action_with_security_check(:update, *args)
      end

      def destroy_with_security_check(*args)
        action_with_security_check(:destroy, *args)
      end

      def action_with_security_check(action, *args)
        if !self.class.permission_check_passed
          assert_security(action)
          self.class.permission_check_passed = true
          begin
            self.send("#{action}_without_security_check", *args)
          ensure
            self.class.permission_check_passed = false
          end
        else
          self.send("#{action}_without_security_check", *args)
        end
      end

      def should_check_security?(verb)
        self.class.current_user and self.respond_to?(VERB_TO_QUESTION_METHOD[verb])
      end

      def die!(verb)
        raise SecurityTransgression, "User '#{self.class.current_user}' may not #{verb} #{self.inspect}[#{self.id}]"
      end

      def assert_security(verb)
        if should_check_security?(verb) && !self.class.current_user.send("can_#{verb.to_s}?", self)
          die!(verb)
        end
      end      
    end
  end
end

ActionController::Base.send(:include, UserBasedSecurity::ActionController)
ActiveRecord::Base.send(:include, UserBasedSecurity::ActiveRecord)