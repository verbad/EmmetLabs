class AssetsAssociation < ActiveRecord::Base
  set_table_name :assets_associations
  belongs_to :asset
  belongs_to :associate, :polymorphic => true
  acts_as_list :scope => 'associate_id = #{associate_id} AND associate_type = #{quote_value associate_type}'
  validates_associated :asset
  before_create :make_primary_if_only_assets_association
  after_destroy :choose_new_primary_if_primary_was_deleted

  def make_primary_if_only_assets_association
    self.primary = associate.assets_associations.count == 0
    true
  end

  def choose_new_primary_if_primary_was_deleted
    if primary? && (next_primary = associate.assets_associations.find(:first))
      next_primary.primary = true
      next_primary.save!
    end
  end

end