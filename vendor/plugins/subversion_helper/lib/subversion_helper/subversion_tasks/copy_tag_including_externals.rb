class SubversionHelper
  module SubversionTasks
    class CopyTagIncludingExternals < Task
      def initialize(from_tag, to_tag)
        @from_tag = from_tag
        @to_tag = to_tag
        raise "'FROM_TAG' must be specified" unless @from_tag
        raise "'TO_TAG' must be specified" unless @to_tag
      end

      def run
        subversion_helper = SubversionHelper.new(repository_base, application)
        subversion_helper.copy_tag_including_externals(@from_tag, @to_tag, initials)
      end
    end
  end
end
