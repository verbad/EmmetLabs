require 'active_record'
class ActiveRecord::Errors
  def full_messages
    full_messages = []
    @errors.each_key do |attr|
      @errors[attr].each do |msg|
        next if msg.nil?
        full_messages << msg
      end
    end
    return full_messages
  end
end

module DefaultErrorMessageGetters
  ActiveRecord::Errors.default_error_messages.keys.each do |key|
    define_method "#{key}_error_message" do |field_name|
      "#{field_name.to_s.humanize} #{ActiveRecord::Errors.default_error_messages[key]}"
    end
  end
end
ActiveRecord::Errors.send(:extend, DefaultErrorMessageGetters)
ActiveRecord::Base.send(:extend, DefaultErrorMessageGetters)

#TODO: NW/BT - Make unit tests for these
module ActiveRecord::Validations::ClassMethods
  def validates_confirmation_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = confirmation_error_message(attr_name) unless params[:message]
    validates_confirmation_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_confirmation_of, :customizable_messages

  def validates_acceptance_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = accepted_error_message(attr_name) unless params[:message]
    validates_acceptance_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_acceptance_of, :customizable_messages

  def validates_presence_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = blank_error_message(attr_name) unless params[:message]
    validates_presence_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_presence_of, :customizable_messages

  def validates_uniqueness_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = taken_error_message(attr_name) unless params[:message]
    validates_uniqueness_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_uniqueness_of, :customizable_messages

  def validates_length_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:too_short] = too_short_error_message(attr_name) unless params[:too_short]
    params[:too_long] = too_long_error_message(attr_name) unless params[:too_long]
    params[:wrong_length] = wrong_length_error_message(attr_name) unless params[:wrong_length]
    validates_length_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_length_of, :customizable_messages

  def validates_inclusion_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = inclusion_error_message(attr_name) unless params[:message]
    validates_inclusion_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_inclusion_of, :customizable_messages

  def validates_exclusion_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = exclusion_error_message(attr_name) unless params[:message]
    validates_exclusion_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_exclusion_of, :customizable_messages

  def validates_format_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = invalid_error_message(attr_name) unless params[:message]
    validates_format_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_format_of, :customizable_messages

  def validates_associated_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = invalid_error_message(attr_name) unless params[:message]
    validates_associated_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_associated, :customizable_messages

  def validates_numericality_of_with_customizable_messages(*attr_names)
    attr_name, params = parse_attr_list(attr_names)
    params[:message] = not_a_number_error_message(attr_name) unless params[:message]
    validates_numericality_of_without_customizable_messages(attr_name, params)
  end
  alias_method_chain :validates_numericality_of, :customizable_messages

  def parse_attr_list(attr_names)
    case attr_names.length
    when 1
      return [attr_names[0], {}]
    when 2
      if attr_names[1].is_a?(Hash)
        return attr_names
      else
        raise "Right now, we only support a single attribute for validations.  Please split this out."
      end
    else
      raise "Right now, we only support a single attribute for validations.  Please split this out."
    end
  end
end
