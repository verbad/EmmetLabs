require 'active_record'
module ActiveRecordValidations
  def validates_immutability_of(*attr_names)
    configuration = { :message => ActiveRecord::Errors.default_error_messages[:invalid], :on => :save, :with => nil }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

    validates_each(attr_names, configuration) do |record, attr_name, value|
      record.errors.add(attr_name, configuration[:message]) unless record.new_record? || self.find_by_id(record.id)[attr_name] == value
    end
  end
end

class ActiveRecord::Base
  extend ActiveRecordValidations
end
