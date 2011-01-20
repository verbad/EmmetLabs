class SubversionHelper
  module SubversionTasks
    class Branch < Task
      def run
        subversion_helper = SubversionHelper.new(repository_base, application)
        subversion_helper.branch(initials, message)
      end
    end
  end
end
