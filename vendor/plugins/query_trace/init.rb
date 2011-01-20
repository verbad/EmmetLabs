unless ENV['QUERY_TRACE'].blank?
  
  should_require = !Object.const_defined?(:SQL_TRACE) || SQL_TRACE
  if should_require
    require 'query_trace'

    class ::ActiveRecord::ConnectionAdapters::AbstractAdapter
      include QueryTrace
    end
  end
end