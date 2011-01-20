require File.dirname(__FILE__) + '/../spec_helper'

describe NilUser do
  it "should return true for nil?" do
    NilUser.instance.should be_nil
  end

end