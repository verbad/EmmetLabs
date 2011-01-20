require File.dirname(__FILE__) + '/../spec_helper'

describe ContentPagesController do
  it_should_behave_like 'login'
  
  describe "route generation" do

    it "should map { :controller => 'content_pages', :action => 'index' } to /content_pages" do
      route_for(:controller => "content_pages", :action => "index").should == "/content_pages"
    end
  
    it "should map { :controller => 'content_pages', :action => 'new' } to /content_pages/new" do
      route_for(:controller => "content_pages", :action => "new").should == "/content_pages/new"
    end
  
    it "should map { :controller => 'content_pages', :action => 'show', :id => 1 } to /content_pages/1" do
      route_for(:controller => "content_pages", :action => "show", :id => 1).should == "/content_pages/1"
    end
  
    it "should map { :controller => 'content_pages', :action => 'edit', :id => 1 } to /content_pages/1/edit" do
      route_for(:controller => "content_pages", :action => "edit", :id => 1).should == "/content_pages/1/edit"
    end
  
    it "should map { :controller => 'content_pages', :action => 'update', :id => 1} to /content_pages/1" do
      route_for(:controller => "content_pages", :action => "update", :id => 1).should == "/content_pages/1"
    end
  
    it "should map { :controller => 'content_pages', :action => 'destroy', :id => 1} to /content_pages/1" do
      route_for(:controller => "content_pages", :action => "destroy", :id => 1).should == "/content_pages/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'content_pages', action => 'index' } from GET /content_pages" do
      params_from(:get, "/content_pages").should == {:controller => "content_pages", :action => "index"}
    end
  
    it "should generate params { :controller => 'content_pages', action => 'new' } from GET /content_pages/new" do
      params_from(:get, "/content_pages/new").should == {:controller => "content_pages", :action => "new"}
    end
  
    it "should generate params { :controller => 'content_pages', action => 'create' } from POST /content_pages" do
      params_from(:post, "/content_pages").should == {:controller => "content_pages", :action => "create"}
    end
  
    it "should generate params { :controller => 'content_pages', action => 'show', id => '1' } from GET /content_pages/1" do
      params_from(:get, "/content_pages/1").should == {:controller => "content_pages", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'content_pages', action => 'edit', id => '1' } from GET /content_pages/1;edit" do
      params_from(:get, "/content_pages/1/edit").should == {:controller => "content_pages", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'content_pages', action => 'update', id => '1' } from PUT /content_pages/1" do
      params_from(:put, "/content_pages/1").should == {:controller => "content_pages", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'content_pages', action => 'destroy', id => '1' } from DELETE /content_pages/1" do
      params_from(:delete, "/content_pages/1").should == {:controller => "content_pages", :action => "destroy", :id => "1"}
    end
  end
end