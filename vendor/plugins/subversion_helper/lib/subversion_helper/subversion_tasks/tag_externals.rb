class SubversionHelper
  module SubversionTasks
    class TagExternals < Task
      def initialize(tag = nil)
        @custom_tag = tag
      end

      def run
        subversion_helper = SubversionHelper.new(repository_base, application)
        if @custom_tag
          subversion_helper.tag_externals(@custom_tag)
        else
          subversion_helper.tag_externals_with_timestamped_tagname(initials)
        end
      end
    end
  end
end
