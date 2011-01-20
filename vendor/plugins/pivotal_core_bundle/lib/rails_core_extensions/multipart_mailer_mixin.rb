require "action_mailer"

class ActionMailer::Base
  def multipart(template_name, assigns)
    content_type 'multipart/alternative'

    if Pivotal::VersionChecker.rails_version_is_below_2? # also below Rails 2 release candidates
      part :content_type => "text/plain",
           :body => render_message("./#{template_name}.plain.rhtml", assigns)

      part :content_type => "text/html",
           :body => render_message("./#{template_name}.html.rhtml", assigns)
    elsif Pivotal::VersionChecker.rails_version_is_below_rc2?  # path specifying changed in RC2 (1.99.1)
      part :content_type => "text/plain",
           :body => render_message("./#{template_name}.plain.erb", assigns)

      part :content_type => "text/html",
           :body => render_message("./#{template_name}.html.erb", assigns)
    elsif Pivotal::VersionChecker.rails_version_is_1991?
      part :content_type => "text/plain",
           :body => render_message("#{mailer_name}/#{template_name}", assigns)

      part :content_type => "text/html",
           :body => render_message("#{mailer_name}/#{template_name}", assigns)
    else # > 1.99.1
      part :content_type => "text/plain",
           :body => render_message("#{template_name}.plain.erb", assigns)

      part :content_type => "text/html",
           :body => render_message("#{template_name}.html.erb", assigns)
    end
  end
end

module MultipartMailerMixin
  def self.included(base)
    puts "MultipartMailerMixin has been deprecated.  Just remove the include, since ActionMailer has it automagically now."
  end
end