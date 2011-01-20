module UsersHelper
  def user_select(name, users = User.find(:all), selected = nil, options = {})
    truncate_at = nil
    if options[:truncate_at]
      truncate_at = options[:truncate_at]
      options.delete(:truncate_at)
    end
    names_and_ids = users.map do |u|
      full_name = u.full_name
      full_name = truncate_with_ellipses(full_name, truncate_at) if truncate_at
      [full_name, u.id]
    end
    select_tag(name, options_for_select(names_and_ids, selected), options)
  end
  
  def truncate_with_ellipses(string, len)
    string_truncated = string.slice(0, len)
    if string.length != string_truncated.length
      string_truncated += '...'
    end
    string_truncated
  end
end