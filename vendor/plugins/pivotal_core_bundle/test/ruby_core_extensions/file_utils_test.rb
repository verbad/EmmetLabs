dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class FileUtilsTest < Pivotal::IsolatedPluginTestCase
  include FlexMock::TestCase

  def setup
    super

    @tmp_dir = File.join(Dir.tmpdir, @method_name)
    FileUtils.rm_rf @tmp_dir
    FileUtils.mkdir_p @tmp_dir
  end

  def teardown
    FileUtils.rm_rf @tmp_dir
  end

  def test_treecopy
    # clear and create temp source dir
    tmp_dir_source = tmp('source')
    tmp_dir_dest = tmp('dest')

    FileUtils.mkdir_p tmp_dir_source

    # create hierarchy of files, including .hidden dirs and ".foo" files
    tmp_tree = [
      'somedir/docopy',
      '.svn/no_copy',
      'somedir/dontcopy.foo',
      'somedir/.hidden/dont_copy',
    ].each do |path|
      full_path = "#{tmp_dir_source}/#{path}"
      dir_name = File.dirname(full_path)
      file_name = File.basename(full_path)

      FileUtils.mkdir_p dir_name
      create_file "#{dir_name}/#{file_name}"
    end

    # call treecopy with a filter excluding .hidden dirs and ".foo" files
    FileUtils.treecopy(tmp_dir_source, tmp_dir_dest){ |path| (path !~ /^\./) && (path !~ /\.foo$/i) }

    # get the list of all files in the target dir
    files = Dir.glob("#{tmp_dir_dest}/*/**")
    assert_equal 1, files.length
    assert files.first =~ %r|test_treecopy/dest/somedir/docopy|
  end

  def create_file(path)
    open(path, 'w') do |f|
      f.puts "contents of #{File.basename(path)}"
    end
  end

  def tmp(file)
    "#{@tmp_dir}/#{file}"
  end

  def test_make_fresh_tempdir
    current_dir = Dir.pwd
    flexstub(Time).should_receive(:now).and_return(Time.at(123456))
    dir = FileUtils.make_fresh_tempdir
    assert_equal current_dir, Dir.pwd

    dir = File.expand_path(dir)
    assert_equal "rake_tmp.123456", File.basename(dir)
    assert File.directory?(dir)
    assert_equal Dir::tmpdir, File.dirname(dir)
    FileUtils.rm_rf(dir) if File.exists?(dir)
  end

  def test_barf_unless_parameters_are_both_directories
    create_file tmp("foo")
    create_file tmp("bar")
    FileUtils.mkdir_p tmp("dir")

    #src should exists
    assert_raise(IOError) { FileUtils.treecopy(tmp("nonexistant"), tmp("dir"))   }

    # source should be a directory, not a file
    assert_raise(IOError) { FileUtils.treecopy(tmp("foo"), tmp("dir"))   }

    # if dest exists, it must be a directory, not a file
    assert_raise(IOError) { FileUtils.treecopy(tmp("dir"), tmp("foo"))   }

  end

end
