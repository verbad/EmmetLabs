class Entity < ActiveRecord::Base
  include EntityAttributes

  before_validation :dashify_full_name
  
  named_scope :full_name_like, lambda { |name| {:conditions => ['full_name like ?', "%#{name}%"]} }
  
  def self.from_string(string)
    Entity.new(:full_name => string)
  end
  
  def self.migrate_from_person!(person)
    entity = new
    entity.attributes = person.attributes_for_entity
    entity.migrate_associations_from_person!(person)
    # action_log(person, 'migrated to entity') # TODO: Is it important to save or update the logged information?
    entity.migrate_milestones_from_person!(person)
    entity.save!
    entity
  end
  
  def migrate_associations_from_person!(person)
    self.class.reflect_on_all_associations.each do |assoc|
      self.send("#{assoc.name}=", person.send(assoc.name).to_a) unless assoc.through_reflection
    end
    self.assets = person.assets
    self
  end
  
  def migrate_milestones_from_person!(person)
    person.milestones.each do |milestone|
      catch(:born_died) do
        for type in %w{born died}
          if milestone.type.name == type
            throw :born_died
          end
        end
        self.milestones << milestone
      end
    end
  end

  def self.mangle_default_photo(url)
    # This gsub is a bit brittle, but it avoids mucking about inside the plugin
    return url.gsub(%r{^/images/default_photo/}, '\&entity_')
  end
  private
  
  def dashify_full_name
    full = self.full_name
    self.calculated_dashified_full_name = full.nil? ? nil : full.dashify
  end

end
