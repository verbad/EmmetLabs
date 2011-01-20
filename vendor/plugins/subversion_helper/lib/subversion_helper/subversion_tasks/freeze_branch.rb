class SubversionHelper
  module SubversionTasks
    class FreezeBranch < Task
      def run
        subversion_helper = SubversionHelper.new(repository_base, application, true)
        subversion_helper.cleanup
        branch_name = subversion_helper.branch(initials, message)
        subversion_helper.switch(branch_name)
        subversion_helper.freeze_externals
        subversion_helper.commit("branched and frozen")
        subversion_helper.cleanup
        subversion_helper.switch_to_trunk
        subversion_helper.update
      end
    end
  end
end
