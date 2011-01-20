dir = File. dirname(__FILE__)
require "#{dir}/../spec_helper"

describe ActiveRecord::Base, "#field_name_changed?" do
  attr_reader :model
  
  before do
    @model = TestModel.create!(:string => "Foobar", :number => 3)
    model.string_changed?.should be_false
  end

  it "when the field name is changed and not reloaded, returns true" do
    model.string = "baz"
    model.string_changed?.should be_true
  end

  it "when the field name is changed and reloaded, returns false" do
    model.string = "baz"
    model.reload
    model.string_changed?.should be_false
  end
end

describe ActiveRecord::Base, "#field_name_changed? using symbols" do
  attr_reader :model
  before do
    @model = TestModel.create!(:string => "Foobar", :number => 3)
    model.string_changed?.should be_false
  end

  it "when the field name is changed and not reloaded, returns true" do
    @model[:string] = 'baz'
    model.string_changed?.should be_true
  end

  it "when the field name is changed and reloaded, returns false" do
    @model[:string] = 'baz'
    model.reload
    model.string_changed?.should be_false
  end
end

describe ActiveRecord::Base, "#field_name_original" do
  attr_reader :model

  before do
    @model = TestModel.create!(:string => "Foobar", :number => 3)
  end

  it "should know original values when no changes have been made" do
    model.string_original.should == "Foobar"
    model.number_original.should == 3
  end

  it "should know original values" do
    model.string = "baz"
    model.number = 5
    model.string_original.should == "Foobar"
    model.number_original.should == 3
  end
  
  it "should know original values after reload" do
    model.string = "baz"
    model.number = 5
    model.reload
    model.string_original.should == "Foobar"
    model.number_original.should == 3
  end

end

class FieldNameChangedTestModel < TestModel
  before_save :raise_if_string_did_not_change
  after_save :raise_if_string_did_not_change

  def after_save
    raise_if_string_did_not_change
  end

  def before_save
    raise_if_string_did_not_change
  end

  def raise_if_string_did_not_change
    unless string_changed?
      raise "string_changed? should be true"
    end
  end
end

describe ActiveRecord::Base, "#after and before save callbacks" do
  attr_reader :model

  before do
    @model = FieldNameChangedTestModel.create!(:string => "Foobar", :number => 3)
  end

  it "has access to attribute_changed?" do
    model.string = "baz"
    model.save.should be_true
  end
end

describe ActiveRecord::Base, "#create_or_update" do
  attr_reader :model
  
  before do
    @model = FieldNameChangedTestModel.create!(:string => "Foobar", :number => 3)
    model.string = "Baz"
    model.string_changed?.should be_true
    model.original_attributes.should_not be_empty
  end

  it "when successfully saved, clears the original_attributes hash" do
    model.save.should be_true

    model.string_changed?.should be_false
    model.original_attributes.should be_empty
  end

  it "when not successfully saved, does not clear the original_attributes hash" do
    model.should_receive(:update).and_return(false)

    model.save.should be_false

    model.string_changed?.should be_true
    model.original_attributes.should_not be_empty
  end
end