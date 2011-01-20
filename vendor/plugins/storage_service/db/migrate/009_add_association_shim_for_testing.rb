class AddAssociationShimForTesting < ActiveRecord::Migration
  def self.up
    if ['test', 'development'].include? RAILS_ENV
      create_table :association_shims do |t|
        t.column "name", :string
      end
    end
  end

  def self.down
    drop_table :associations_shims if ['test', 'development'].include? RAILS_ENV
  end
end
