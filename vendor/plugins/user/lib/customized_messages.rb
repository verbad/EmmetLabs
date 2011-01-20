class String
  def self.add_customized_message(standard_message, customized_message)
    customized_messages[standard_message] = customized_message
  end
  
  def self.customized_messages
    if defined?(@@CUSTOMIZED_MESSAGES)
      @@CUSTOMIZED_MESSAGES
    else
      {}
    end
  end

  def customize(substitutions = {})
    customized_message = String.customized_messages[self] || self
    substitute(customized_message, substitutions)
  end

  def substitute(customized_message, substitutions)
    substitutions.inject(customized_message) do |result, (key, value)| 
      result.gsub("{:#{key}}", value.to_s)
    end
  end

  def self.load_customized_messages_from_config
    filename = "#{RAILS_ROOT}/config/customized_messages.yml"
    if File.exist? filename
      File.open(filename) do |file|
        @@CUSTOMIZED_MESSAGES = from_yaml(file.read)
      end
    end
  end

  def self.from_yaml(yaml_string)
    erb_parsed_yaml = ERB.new(yaml_string).result
    YAML.load(erb_parsed_yaml)
  end

  load_customized_messages_from_config
end


