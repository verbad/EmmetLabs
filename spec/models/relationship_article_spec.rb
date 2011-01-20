require File.dirname(__FILE__) + '/../spec_helper'

describe RelationshipArticle do

  it "should populate the next revision number on create" do
    article = RelationshipArticle.create!(:relationship => relationships(:grace_and_josephine), :text => 'a new article revision', :author => users(:edward))
    article.revision.should == 4
    article.author.should == users(:edward)
  end

  it "should start at 1 for revision numbers" do
    article = RelationshipArticle.create!(:relationship => relationships(:janis_and_marilyn), :text => 'a new article revision')
    article.revision.should == 1
  end

  it "should be able to diff itself against another article" do
    result = relationship_articles(:grace_and_josephine_article_r1).diff(relationship_articles(:grace_and_josephine_article_r2), {
      :tag_change_before_start   => 'aaa',
      :tag_change_before_end     => 'bbb',
      :tag_change_after_start    => 'ccc',
      :tag_change_after_end      => 'ddd'
    })
    result.should == 'Grace and Josephine knew each other revision aaa1bbbccc2ddd'
  end

  it "should be able to diff itself against its previous revision" do
    expected_difference = relationship_articles(:grace_and_josephine_article_r1).diff(relationship_articles(:grace_and_josephine_article_r2))
    relationship_articles(:grace_and_josephine_article_r2).diff_with_previous_revision.should == expected_difference
  end

  it "should know if it is a stub" do
    article = RelationshipArticle.create!(:relationship => relationships(:janis_and_marilyn), :text =>  'stub article')
    article.should be_stub
    article.text = 'foo ' * (RelationshipArticle::STUB_THRESHOLD_WORD_COUNT + 1)
    article.should_not be_stub
  end

  it "should know if it is blank" do
    article = RelationshipArticle.create!(:relationship => relationships(:janis_and_marilyn), :text =>  'stub article')
    article.should_not be_blank
    article.text = ''
    article.should be_blank
  end

  it "should have a nil previous revision if there is only one revision" do
    relationship = relationships(:janis_and_marilyn)
    relationship.articles.should be_empty
    relationship.articles.create!(:text =>  'stub article')
    relationship.articles.size.should == 1
    relationship.article.previous_revision.should be_stub
    relationship.article.previous_revision.should be_blank
  end
end
