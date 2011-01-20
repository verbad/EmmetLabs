class SubversionHelper
  module SubversionTasks
    class Task
      attr_accessor :application, :repository_base

      def initials
        @initials ||= "ci"
      end
      attr_writer :initials

      def message
        @message ||= "Creating branch via rake task"
      end
      attr_writer :message
    end
  end
end