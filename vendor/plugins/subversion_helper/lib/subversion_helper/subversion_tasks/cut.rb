class SubversionHelper
  module SubversionTasks
    class Cut < Task
      def run
        subversion_helper = SubversionHelper.new(repository_base, application, true)
        subversion_helper.cleanup
        branch_path = subversion_helper.branch(initials, message)
        release_name = File.basename(branch_path)
        begin
          subversion_helper.create_version_file
          subversion_helper.switch(branch_path)
          subversion_helper.freeze_externals
          subversion_helper.commit("branched and frozen")
          subversion_helper.tag_from_branch(release_name)
          subversion_helper.execute "echo -e '# this file was created by the rake cut task to provide the tag to cruisecontrol.  It can be deleted (but this should never be necessary, since a cut should only be done by CI on the ci box)\nrelease_tag=#{release_name}\n' > release_tag.properties"
          release_name
        ensure
          subversion_helper.cleanup
          subversion_helper.switch_to_trunk
          subversion_helper.update
          nil
        end
      end
    end
  end
end
