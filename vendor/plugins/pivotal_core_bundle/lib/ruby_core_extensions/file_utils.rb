require 'fileutils'

module FileUtils
  def treecopy(src, dest, &filter)
    raise IOError unless File.exists?(src) && File.directory?(src)
    raise IOError if File.exists?(dest) && !File.directory?(dest)

    Dir.new(src).each do |filename|
      copy = should_copy(filename, filter)
      next unless copy
      src_file = "#{src}/#{filename}"
      dest_file = "#{dest}/#{filename}"
      if File.directory? src_file
        treecopy(src_file, dest_file, &filter)
      else
        mkdir_p "#{dest}"
        cp(src_file, File.dirname(dest_file))
      end
    end
  end

  def should_copy(filename, filter)
    return false if filename =~ /^\.\.?$/
    return true if filter.nil?
    passed_filter = filter.call(filename)
    return passed_filter
  end

  def in_fresh_tempdir
    tmpdir = Dir::tmpdir
    current_dir = FileUtils.pwd
    fresh_dir = make_fresh_tempdir
    FileUtils.cd(fresh_dir)
    yield
    FileUtils.cd(tmpdir)
    FileUtils.rm_rf(fresh_dir)
    FileUtils.cd(current_dir)
  end

  def make_fresh_tempdir
    tmpdir = Dir::tmpdir
    fresh_dirname = File.join(tmpdir, "rake_tmp.#{Time.now.to_i}")
    FileUtils.mkdir(fresh_dirname)[0]
  end

  extend self
end
