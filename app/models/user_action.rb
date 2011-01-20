class UserAction < ActiveRecord::Base
   belongs_to :loggable, :polymorphic => true
   belongs_to :user
   
   named_scope :recent, lambda { |limit|
     {
       :select => 'DISTINCT loggable_id, loggable_type, action',
       :conditions => "loggable_type != 'DirectedRelationship'",
       :order => "created_at DESC",
       :limit => (limit || 8)
     }
   }   
end