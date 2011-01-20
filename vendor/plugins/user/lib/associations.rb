module ActiveRecord::Associations::ClassMethods
  def collection_reader_method_with_question(reflection, association_proxy_class)
    collection_reader_method_without_question(reflection, association_proxy_class)
    if association_proxy_class == ActiveRecord::Associations::HasManyAssociation || association_proxy_class == ActiveRecord::Associations::HasManyThroughAssociation
      define_method("has_#{reflection.name.to_s.singularize}?") do |element_of_collection|
        send(reflection.name).find_by_id(element_of_collection.id) == element_of_collection
      end
    end
  end
  alias_method_chain :collection_reader_method, :question
end