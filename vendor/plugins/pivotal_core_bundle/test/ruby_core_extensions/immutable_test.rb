dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class Book
  attr_accessor :title, :author
  include Immutable
  attr_immutable :title
  attr_immutable :author, :raise => "That's plagiarizing."
end

class ImmutableTest < Pivotal::IsolatedPluginTestCase
  
  def test_attr_immutable
    book = Book.new
    assert_nil book.title
    assert_nil book.author
    
    book.title = "once upon a time..."
    book.author = "anonymous"
    assert_equal "once upon a time...", book.title
    assert_equal "anonymous", book.author
    
    assert_raise(Immutable::AttemptToModifyImmutablePropertyViolation) {book.title = "whatever"}
    assert_raise(Immutable::AttemptToModifyImmutablePropertyViolation) {book.author = "whoever"}
  end

end