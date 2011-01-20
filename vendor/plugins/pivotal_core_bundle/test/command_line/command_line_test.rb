dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"
require 'fileutils'

class CommandLineTest < Test::Unit::TestCase
  include FileSandbox
  include FlexMock::TestCase

  def test_should_write_to_both_files_when_both_files_specified_and_no_block
    in_total_sandbox do
      CommandLine.execute("echo hello", {:dir => @dir, :stdout => @stdout, :stderr => @stderr})
      assert_match(/.* echo hello *\n.?hello ?/n, File.read(@stdout))
      assert_match(/.* echo hello/n, File.read(@stderr))
    end
  end

  def test_should_not_write_to_stdout_file_when_no_stdout_specified
    in_total_sandbox do
      with_redirected_stdout do
        CommandLine.execute("echo hello", {:dir => @dir, :stderr => @stderr})
      end
      assert_equal("hello", File.read(@stdout).strip)
#      assert_equal("#{@prompt} echo hello\nhello", File.read(@stdout).strip)
      assert_equal("#{@prompt} echo hello", File.read(@stderr).strip)
    end
  end

  def test_should_only_write_command_to_stdout_when_block_specified
    in_total_sandbox do
      CommandLine.execute("echo hello", {:dir => @dir, :stdout => @stdout, :stderr => @stderr}) do |io|

        assert_equal("hello", io.read.strip)
      end
      assert_match(/.* echo hello\s*\[output captured and therefore not logged\]/n, File.read(@stdout).strip)
      assert_equal("#{@prompt} echo hello", File.read(@stderr).strip)
    end
  end

  def test_should_raise_on_bad_command
    in_total_sandbox do
      assert_raise(CommandLine::ExecutionError) do
        CommandLine.execute("xaswedf", {:dir => @dir, :stdout => @stdout, :stderr => @stderr})
      end
    end
  end

  def test_should_raise_on_bad_command_with_block
    in_total_sandbox do
      assert_raise(CommandLine::ExecutionError) do
        CommandLine.execute("xaswedf", {:dir => @dir, :stdout => @stdout, :stderr => @stderr}) do |io|
          io.each_line do |line|
          end
        end
      end
    end
  end

  def test_should_return_block_result
    in_total_sandbox do
      result = CommandLine.execute("echo hello", {:dir => @dir, :stdout => @stdout, :stderr => @stderr}) do |io|
        io.read
      end
      assert_equal "hello", result.strip
    end
  end

  def test_execute_should_raise_when_return_code_is_not_zero
    in_total_sandbox do
      with_redirected_stdout do
        assert_raise(CommandLine::ExecutionError) do
          CommandLine.execute "ruby -e 'exit(-1)'"
        end
      end
    end
  end

  def test_escape_and_concatenate
    platform('linux')
    assert_equal 'foo', CommandLine.escape_and_concatenate(['foo'])
    assert_equal 'foo bar', CommandLine.escape_and_concatenate(['foo', 'bar'])
    assert_equal 'foo b\\"ar', CommandLine.escape_and_concatenate(['foo', 'b"ar'])
    assert_equal 'foo b\\ \\ \\ ar', CommandLine.escape_and_concatenate(['foo', 'b   ar'])
    assert_equal "foo b\\'\\&\\<\\>\\\\\\|\\;ar", CommandLine.escape_and_concatenate(['foo', "b'&<>\\|;ar"])
  end

  def test_escape_and_concatenate_on_windows
    platform('mswin32')
    assert_equal 'foo "bar ^\\ ^& ^| ^> ^< ^^ baz"', CommandLine.escape_and_concatenate(['foo', "bar \\ & | > < ^ baz"])
  end

  def test_escape_and_concatenate_should_not_escape_variable_references_and_wildcards
    platform('linux')
    assert_equal "foo $*?{}[]", CommandLine.escape_and_concatenate(['foo', "$*?{}[]"])
  end

  def test_escape_and_concatenate_should_not_put_double_quotes_around_arguments_with_spaces_on_linux
    platform('mswin32')
    assert_equal '"foo bar^\\tom"', CommandLine.escape_and_concatenate(['foo bar\\tom'])
  end

  def test_escape_and_concatenate_should_put_double_quotes_around_arguments_with_spaces_on_windows
    platform('linux')
    assert_equal 'foo\ bar\\\\tom', CommandLine.escape_and_concatenate(['foo bar\\tom'])
  end

  def test_full_cmd_should_not_escape_command_if_it_is_a_string
    platform('linux')
    assert_equal 'foo bar\ baz  ', CommandLine.full_cmd('foo bar\ baz', {})
  end

  def test_full_cmd_should_escape_command_if_it_is_an_array
    platform('linux')
    assert_equal 'foo bar baz\\ \\>  ', CommandLine.full_cmd(['foo', 'bar', 'baz >'], {})
  end

  def platform(family)
    flexstub(Platform).should_receive(:family).and_return(family)
  end

  def test_escape_and_concatenate_accepts_non_strings
    assert_equal 'foo 10', CommandLine.escape_and_concatenate(['foo', 10])
  end

  def with_redirected_stdout
    orgout = STDOUT.dup
    STDOUT.reopen(@stdout)
    begin
      yield
    ensure
      STDOUT.reopen(orgout) rescue nil
    end
  end

  def in_total_sandbox(&block)
    in_sandbox do |sandbox|
      @dir = File.expand_path(sandbox.root)
      @stdout = "#{@dir}/stdout"
      @stderr = "#{@dir}/stderr"
      @prompt = "#{@dir} #{Platform.user}$"
      yield(sandbox)
    end
  end
end