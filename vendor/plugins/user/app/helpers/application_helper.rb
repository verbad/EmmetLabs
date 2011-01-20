module ApplicationHelper
  def ajax_login_javascript_functions
    <<-EOF
      function login_successful() {
        window.location.href = unescape(window.location.pathname)
      }
    EOF
  end
end
