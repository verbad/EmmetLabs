module CanBeCommentedOn
  def self.included(base)
    base.has_many :comments, :as => :topic do
      def latest(num_entries = nil)
        find(:all, :order => "created_at DESC", :limit => num_entries)
      end
      def earliest(num_entries = nil)
        find(:all, :order => "created_at ASC", :limit => num_entries) 
      end
    end
  end
end