require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipArticlesController do
  it_should_behave_like 'login'
  
  before do
    @relationship = relationships(:grace_and_josephine)
    @article = @relationship.article
  end

  it "should handle successful create" do
    initial_count = @relationship.articles.size
    long_text = 'foo ' * (RelationshipArticle::STUB_THRESHOLD_WORD_COUNT + 1)
    post :create, :relationship_id => @relationship.id, :relationship_article => {:text=>long_text}
    assigns(:relationship).articles.first.errors.should be_empty
    @relationship.articles(true)
    @relationship.articles.size.should == initial_count + 1
    @relationship.articles.first.text.should == long_text
    @relationship.articles.first.author.should == @janice
  end

  it "should handle show" do
    get :show, :relationship_id => @relationship.id, :id => @article.id, :format => 'js'
    assigns(:relationship_article).should == @article
    response.should be_success
  end

end

describe RelationshipArticlesController do
  it "should require login" do
    post :create, :relationship_id => relationships(:grace_and_josephine).id
    response.response_code.should == 302
  end
end