require 'active_record'

module Changed
  module ClassMethods
    def update_parent_functor(parent_association)
      # note: reload is necessary where caching causes strange behavior.
      lambda do |record|
        if record.send(parent_association) && !record.send(parent_association).being_saved?
          record.send(parent_association).reload.child_has_changed(record)
        end
      end
    end

    def update_parent(parent_association, options = {:only => [:after_save, :after_destroy]})
      options[:only].each do |callback|
        send(callback, update_parent_functor(parent_association))
      end

      define_method :child_has_changed do |record|
        self.send(parent_association).child_has_changed(self)
      end
    end
  end

  module InstanceMethods
    def clean!
      @original_attributes = {}
    end

    def original_attributes
      @original_attributes ||= {}
    end

    def changed?
      !original_attributes.empty?
    end

    def reload_with_clean!
      clean!
      reload_without_clean!
    end
    
    def create_or_update_with_clean!
      if create_or_update_without_clean!
        clean!
        true
      else
        false
      end
    end  

    def write_attribute_with_changed(attr_name, value)
      if self[attr_name].to_s != value.to_s
        original_attributes[attr_name.to_sym] = self[attr_name.to_sym]
      end
      write_attribute_without_changed(attr_name, value)
    end

    def attribute_changed?(attr)
      original_attributes.has_key?(attr.to_sym)
    end

    def attribute_original(attr)
      return original_attributes[attr.to_sym] if attribute_changed?(attr)
      send(attr.to_sym)
    end

    def child_has_changed(child)
      save!
    end
  end
end

class ActiveRecord::Base
  include Changed::InstanceMethods
  extend Changed::ClassMethods

  alias_method_chain :reload, :clean!
  alias_method_chain :create_or_update, :clean!
  alias_method_chain :write_attribute, :changed

  attribute_method_suffix '_changed?'
  attribute_method_suffix '_original'
end
