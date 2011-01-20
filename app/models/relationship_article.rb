class RelationshipArticle < ActiveRecord::Base
  belongs_to :relationship
  before_create :populate_revision
  belongs_to :author, :class_name => 'User'
  delegate :blank?, :to => :text
  STUB_THRESHOLD_WORD_COUNT = 150
  
  def after_create
    unless current_user.nil?
      self.relationship.directed_relationships.each do |dr|
         UserAction.create!(:user_id => current_user.id, 
                             :action => 'edit',
                             :loggable_id => dr.from_id,
                             :loggable_type => 'DirectedRelationship' )
      end
      UserAction.create!(:user_id => current_user.id, 
                          :action => 'edit',
                          :loggable_id => self.relationship.id,
                          :loggable_type => 'Relationship' )
    end
  end
  
  DIFF_TAGS = {
    :tag_common_start          => '<span class="diff_common">',
    :tag_del_start             => '<span class="diff_deletion">',
    :tag_add_start             => '<span class="diff_insertion">',
    :tag_change_before_start   => '<span class="diff_from">',
    :tag_change_after_start    => '<span class="diff_to">',
  }
  DIFF_TAGS.default = '</span>'
  
  def diff(other_article, options = DIFF_TAGS)
      docdiff = DocDiff.new
      docdiff.config.update(options)
      docdiff.run(self.as_document, other_article.as_document, :resolution => "word", :format => "user", :digest => false)
  end

  def diff_with_previous_revision(options = DIFF_TAGS)
    previous_revision.diff(self, options)
  end

  def as_document
    Document.new(self.text, 'ASCII', 'LF')
  end

  def previous_revision
    result = self.class.find_by_relationship_id_and_revision(self.relationship_id, self.revision - 1)
    result || NilRevision.new
  end

  def stub?
    word_count <= STUB_THRESHOLD_WORD_COUNT
  end

  def self.total_word_count
    all({
      :select => :text,
      :conditions => ['relationship_id is not null'],
      :joins => "INNER JOIN (SELECT id, revision FROM relationship_articles ra WHERE revision = (SELECT MAX(revision) FROM relationship_articles WHERE relationship_id = ra.relationship_id)) ids ON relationship_articles.id = ids.id"
    }).inject(0) { |sum, a| sum += a.word_count}
  end

  def word_count
    (text || '').split.size
  end

  private

  def populate_revision
    current = self.relationship.article
    self.revision = current.nil? ? 1 : current.revision + 1
  end

  class NilRevision
    def stub?
      true
    end

    def blank?
      true
    end
  end
end