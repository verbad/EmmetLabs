require File.dirname(__FILE__) + '/file_sandbox'

module FileSandbox
  def self.included(spec)
    return unless spec.respond_to? :before

    spec.before do
      setup_sandbox
    end

    spec.after do
      teardown_sandbox
    end
  end
end
