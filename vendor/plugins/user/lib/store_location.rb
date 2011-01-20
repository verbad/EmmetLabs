module StoreLocation
  def self.included(a_controller)
    a_controller.module_eval do
      extend ClassMethods
      include InstanceMethods
      
      before_filter :store_location
    end
  end
  
  module ClassMethods
    def actions_not_storing_location
      @actions_not_storing_location ||= []
    end

    def disable_store_location(*actions)
      actions_not_storing_location.concat(actions.collect(&:to_sym))
    end
  end
  
  module InstanceMethods
    def store_location
      session[:location] = params if should_store_location?
    end

    def should_store_location?
      request.get? && !request.xhr? &&
        !self.class.actions_not_storing_location.include?(action_name.to_sym)
    end

    def redirect_back(default = home_page_path)
      redirect_to(session && session[:location] ? session[:location] : default)
    end
  end
end