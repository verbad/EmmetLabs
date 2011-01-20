class SwitchToAssetsAssociations < ActiveRecord::Migration
  def self.up
    begin
      all_assets = Asset.find(:all)
      all_assets.each do |asset|
        owner_id = asset.asset_owner_id
        owner_type = asset.asset_owner_type

        AssetsAssociation.create!(
          :asset => asset,
          :associate_id => owner_id,
          :associate_type => owner_type,
          :position => asset.position
        )
      end
    rescue Exception => e
      p e
    end
  end

  def self.down
    raise "There's no going back now"
  end
end