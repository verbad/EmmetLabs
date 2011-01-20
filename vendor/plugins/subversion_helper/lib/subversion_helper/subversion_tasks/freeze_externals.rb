class SubversionHelper
  module SubversionTasks
    class FreezeExternals < Task
      def run
        subversion_helper = SubversionHelper.new(repository_base, application)
        subversion_helper.freeze_externals
      end
    end
  end
end
