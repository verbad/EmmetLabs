class SubversionHelper
  module SubversionTasks
    class FreezeExternalsToTag < Task
      def initialize(tag, plugin_group)
        @tag = tag
        @plugin_group = plugin_group
      end

      def run
        subversion_helper = SubversionHelper.new(repository_base, application)
        subversion_helper.freeze_externals_to_tag(@tag, @plugin_group)
      end
    end
  end
end
