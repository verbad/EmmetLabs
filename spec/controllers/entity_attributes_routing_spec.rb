require File.dirname(__FILE__) + '/../spec_helper'

describe EntityAttributesController do
  it_should_behave_like 'login'
  
  describe "route generation" do
    
    it "should map \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'person', :node_id => ':node_id' } \
        to /people/:node_id/summary" do
      route_for(:controller => "entity_attributes", :action => "update", :node_type => 'person', :node_id => ':node_id').should == "/people/:node_id/summary"
    end

    it "should map \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'person', :node_id => ':node_id' } \
        to /people/:node_id/biography" do
      pending "specificity of secondary routes"
      route_for(:controller => "entity_attributes", :action => "update", :node_type => 'person', :node_id => ':node_id').should == "/people/:node_id/biography"
    end

    it "should map \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :node_id => ':node_id' } \
        to /entities/:node_id/summary" do
      pending "specificity of secondary routes"
      route_for(:controller => "entity_attributes", :action => "update", :node_type => 'entity', :node_id => ':node_id').should == "/entities/:node_id/summary"
    end

    it "should map \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :node_id => ':node_id' } \
        to /entities/:node_id/backgrounder" do
      pending "specificity of secondary routes"
      route_for(:controller => "entity_attributes", :action => "update", :node_type => 'entity', :node_id => ':node_id').should == "/entities/:node_id/backgrounder"
    end

    it "should map \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :node_id => ':node_id' } \
        to /entities/:node_id/further_reading" do
        pending "specificity of secondary routes"
      route_for(:controller => "entity_attributes", :action => "update", :node_type => 'entity', :node_id => ':node_id').should == "/entities/:node_id/further_reading"
    end
  end
  
  describe "route recognition" do

    it "should generate params \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'person', :node_id => ':node_id' } \
        from PUT /people/:node_id/summary" do
      params_from(:put, "/people/:node_id/summary").should == {:controller => "entity_attributes", :action => "update", :node_type => 'person', :node_id => ':node_id'}
    end

    it "should generate params \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'person', :node_id => ':node_id' } \
        from PUT /people/:node_id/biography" do
      params_from(:put, "/people/:node_id/biography").should == {:controller => "entity_attributes", :action => "update", :node_type => 'person', :node_id => ':node_id'}
    end

    it "should generate params \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :node_id => ':node_id' } \
        from PUT /entities/:node_id/summary" do
      params_from(:put, "/entities/:node_id/summary").should == {:controller => "entity_attributes", :action => "update", :node_type => 'entity', :node_id => ':node_id'}
    end

    it "should generate params \
        { :controller => 'entity_attributes', :action => 'update', :node_type => 'entity', :node_id => ':node_id' } \
        from PUT /entities/:node_id/backgrounder" do
      params_from(:put, "/entities/:node_id/backgrounder").should == {:controller => "entity_attributes", :action => "update", :node_type => 'entity', :node_id => ':node_id'}
    end
  end
end