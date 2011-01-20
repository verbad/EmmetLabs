dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class HashTest < Test::Unit::TestCase

  attr_accessor :input

  def setup
    self.input = {:fruit => "banana", "eggs" => "scrambled", 10 => "bo derek"}
  end

  def test_keys_to_strings
    assert_equal({"fruit" => "banana", "eggs" => "scrambled", "10" => "bo derek"}, input.keys_to_strings)
  end

  def test_keys_to_symbols
    assert_equal({:fruit => "banana", :eggs => "scrambled", 10 => "bo derek"}, input.keys_to_symbols)
  end

end