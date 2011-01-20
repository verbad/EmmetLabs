class AssetVersion < ActiveRecord::Base
  attr_protected :id

  set_table_name :asset_versions

  class State < ActiveRecord::Base
    set_table_name :asset_version_states
    acts_as_enumerated
  end

  class Size < Struct.new(:width, :height); end  

  has_enumerated :state, :class_name => 'AssetVersion::State', :foreign_key => :state_id
  belongs_to :asset

  def original
    asset.versions[:original]
  end
  
  def completed?
    raise "override me"
  end

  def pending?
    raise "override me"
  end

  def url(options = {})
    raise "override me"
  end

  def size
    asset.class.versions[version.to_sym].size
  end
  
  def data=(blah)
  end

  def data
  end

  def state_name=(state_name)
    self.state = State[state_name.to_sym]
  end
end