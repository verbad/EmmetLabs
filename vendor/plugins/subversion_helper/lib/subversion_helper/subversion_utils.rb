require 'tmpdir'

class SubversionUtils
  module ClassMethods
    def get_revision_number(target)
      rev = execute "svn info #{target} | grep Revision | cut -f 2 -d' '"
      return rev.strip
    end

    def checkout(svn_root, target_dir = ".")
      execute "svn co #{svn_root} #{target_dir}"
    end

    def execute(cmd, trace = false)
      puts "\t#{cmd}" if trace
      retbuf = nil
      IO.popen(cmd) do |exec|
        retbuf = exec.read
      end
      raise Exception.new("\"#{cmd}\" failed with status=#{$?}") if $? != 0
      return retbuf
    end

    def exists?(target)
      begin
        info = execute("svn info #{target}")
        return info.include?("Revision:")
      rescue Exception => e
        return false
      end
    end
  end
  extend ClassMethods
end