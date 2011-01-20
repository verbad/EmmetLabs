require File.dirname(__FILE__) + '/../spec_helper'

describe Relationship do

  before do
    @relationship = relationships(:grace_and_josephine)
    @grace = people(:grace)
    @josephine = people(:josephine)
  end
  
  it "should destroy associated directed @relationships when it itself is destroyed" do
    directed_relationships = [directed_relationships(:josephine_to_grace), directed_relationships(:grace_to_josephine)]
    @relationship.directed_relationships.should == directed_relationships
    @relationship.destroy
    Relationship.find_by_id(@relationship.id).should be_nil
    directed_relationships.each do |directed_rel|
      DirectedRelationship.find_by_id(directed_rel.id).should be_nil
    end    
  end
  
  it "can return a list of the two related people sorted alphabetically" do
    @relationship.related_people[0].should == @grace
    @relationship.related_people[1].should == @josephine
  end
  
  it "can return the intersection of tags on both individuals" do
    pending("updated fixtures")
    @grace.tags.should_not be_empty
    @josephine.tags.should_not be_empty
    
    shared_tags = @relationship.shared_tags
    
    shared_tags.should_not be_empty
    shared_tags.each do |tag|
      @grace.tags.should include(tag)
      @josephine.tags.should include(tag)
    end
  end

  it "can return its article" do
    @relationship.article.text.should == "Grace and Josephine knew each other revision 3"
  end

  it "can return all articles" do
    articles = RelationshipArticle.find(:all, :conditions => ['relationship_articles.relationship_id = ?', @relationship.id], :order => 'relationship_articles.id desc')
    @relationship.articles.should == articles
  end

  it "should have comments" do
    @relationship.comments.should_not be_empty
    @relationship.comments.each do |comment|
      comment.topic_type.should == Relationship.to_s
    end
  end

  it "should have a summary" do
    @relationship.summary.should == 'grace and josephine relationship summary'
  end

  it "should have a bibliography" do
    @relationship.bibliography.should == 'grace and jospehine relationship bibliography'
  end

  it "should know if it has article text" do
    @relationship.should be_has_article_text
    @relationship.article.text = ''
    @relationship.should_not be_has_article_text
    @relationship.article.text = nil
    @relationship.should_not be_has_article_text

    no_article = relationships(:elvis_and_marilyn)
    no_article.article.should be_nil
    no_article.should_not be_has_article_text
  end

  it "should know it is a stub when its article is" do
    @relationship.article.should_receive(:stub?).once.and_return(true)
    @relationship.should be_stub
  end

  it "should know it isn't a stub when its article isn't" do
    @relationship.article.should_receive(:stub?).once.and_return(false)
    @relationship.should_not be_stub
  end

  it "should know it is a stub when it has no article" do
    @relationship.article = nil
    @relationship.should be_stub
  end

  it "should know if it has comments" do
    @relationship.comments.clear
    @relationship.should_not be_has_comments

    @relationship.comments.create!(:text => 'foo', :author_id => users(:janice).id)
    @relationship.should be_has_comments
  end

  it "knows that summary is required and is at most 150 characters" do
    relationship = Relationship.new(:author_id => 5)
    relationship.should_not be_valid
    relationship.summary = 'a summary'
    relationship.should be_valid
    relationship.summary = 'x'*150
    relationship.should be_valid
    relationship.summary = 'x'*151
    relationship.should_not be_valid
  end

end
