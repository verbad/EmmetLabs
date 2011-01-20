require File.dirname(__FILE__) + '/../spec_helper'

describe RFC::EmailAddress do
  it "should allow mixed case emails" do
    "Goo@demailaddRess.com".should match(RFC::EmailAddress)
  end

  it "should allow dot and plus before @ and after the first character" do
    "test.test@example.com".should match(RFC::EmailAddress)
    ".test@example.com".should_not match(RFC::EmailAddress)
    ".@example.com".should_not match(RFC::EmailAddress)
    "test+@example.com".should match(RFC::EmailAddress)
    "test+test@example.com".should match(RFC::EmailAddress)
  end
end