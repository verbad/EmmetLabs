dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe TermsOfServiceController, "#route_for" do
  include ActionController::UrlWriter

  it "should map for #show" do
    route_for(:controller => "terms_of_service", :action => "show").should == "/terms_of_service"
  end

  it "should support helper method for #show" do
    terms_of_service_path.should == "/terms_of_service"
  end
end

describe TermsOfServiceController, "#show" do
  it "should show latest revision of terms of service text" do
    @old_tos = TermsOfService.create!(:text => 'My Old TOS')
    @tos = TermsOfService.create!(:text => 'My TOS')

    get :show
    assigns(:terms_of_service).should == @tos
  end

  it "should throw an exception if there are no terms of services" do
    caught = false;

    begin
      get :show
    rescue => x
      x.should_not be_nil
      caught = true
    end

    "Should have thrown an exception".should be_nil unless caught
  end
end