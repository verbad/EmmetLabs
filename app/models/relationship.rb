class Relationship < ActiveRecord::Base
  include CanBeCommentedOn
  validates_presence_of :summary, :message => 'Summary is required'
  validates_length_of :summary, :maximum => 150, :message => 'Too many characters (150 maximum)'

  has_many :directed_relationships, :foreign_key => "relationship_id", :class_name => "DirectedRelationship", :dependent => :delete_all
  has_many :related_people, :through => :directed_relationships, :source => :from, :source_type => 'Person', :order => 'calculated_full_name ASC'
  has_many :related_entities, :through => :directed_relationships, :source => :from, :source_type => 'Entity', :order => 'full_name ASC'

  has_many :stories, :foreign_key => "relationship_id", :class_name => "RelationshipStory"

  has_assets :photos, :class_name => 'Photo', :through => :assets_associations

  has_one :article, :class_name => 'RelationshipArticle', :order => 'relationship_articles.revision desc'
  has_many :articles, :foreign_key => 'relationship_id', :class_name => 'RelationshipArticle', :order => 'relationship_articles.revision desc'

  has_many :user_actions, :as => :loggable, :dependent => :destroy
  

  def shared_tags
    related_nodes[0].tags_shared_with(related_nodes[1])
  end
  
  def related_nodes
    [related_people,related_entities].flatten
  end

  def has_article_text?
    article && !article.blank?
  end

  def stub?
    !article || article.stub?
  end

  def has_comments?
    self.comments and !self.comments.empty?
  end
  
  def self.mangle_default_photo(url)
    return url
  end
end
