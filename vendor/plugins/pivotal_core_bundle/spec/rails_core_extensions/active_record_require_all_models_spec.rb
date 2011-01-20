dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe ActiveRecord::Base do
  specify "should include the ActiveRecordRequireAllModels module" do
    ActiveRecord::Base.included_modules.should include(ActiveRecordRequireAllModels)  
  end
  
  specify "should require all model files" do
    RAILS_ROOT = "/foobar"
    model_path = "#{RAILS_ROOT}/app/models"

    files = [
      "#{model_path}/foobar.rb",
      "#{model_path}/baz.rb",
      "#{model_path}/dir/another.rb"
    ]
    Dir.should_receive(:glob).with("#{model_path}/**/*.rb").and_return(files)

    obj = Object.new
    obj.extend(ActiveRecordRequireAllModels)

    obj.should_receive(:require_dependency).with("foobar")
    obj.should_receive(:require_dependency).with("baz")
    obj.should_receive(:require_dependency).with("another")

    obj.require_all_models
  end
end