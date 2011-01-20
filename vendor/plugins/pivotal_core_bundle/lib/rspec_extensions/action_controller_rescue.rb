class ApplicationController
  unless method_defined?(:rescue_action_with_immediate_error)
    attr_accessor :use_rails_error_handling

    protected
    def rescue_action_with_immediate_error(exception)
      if @use_rails_error_handling
        rescue_action_without_immediate_error(exception)
      else
        raise exception
      end
    end
    alias_method_chain :rescue_action, :immediate_error
  end
end

module ActionController::Rescue
  unless method_defined?(:rescue_action_with_immediate_error)
    attr_accessor :use_rails_error_handling

    protected
    def rescue_action_with_immediate_error(exception)
      if @use_rails_error_handling
        rescue_action_without_immediate_error(exception)
      else
        raise exception
      end
    end
    alias_method_chain :rescue_action, :immediate_error
  end
end
