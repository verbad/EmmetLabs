class << ActiveRecord::Base
  def belongs_to_with_deleted(association_id, options = {})
    with_deleted = options.delete :with_deleted
    returning belongs_to_without_deleted(association_id, options) do
      if with_deleted
        reflection = reflect_on_association(association_id)
        if reflection.options[:polymorphic]
          association_accessor_methods(reflection,            Caboose::Acts::BelongsToPolymorphicWithDeletedAssociation)
        else
          association_accessor_methods(reflection,            Caboose::Acts::BelongsToWithDeletedAssociation)
        end
        association_constructor_method(:build,  reflection, Caboose::Acts::BelongsToWithDeletedAssociation)
        association_constructor_method(:create, reflection, Caboose::Acts::BelongsToWithDeletedAssociation)
      end
    end
  end
  
  alias_method_chain :belongs_to, :deleted
end
ActiveRecord::Base.send :include, Caboose::Acts::Paranoid