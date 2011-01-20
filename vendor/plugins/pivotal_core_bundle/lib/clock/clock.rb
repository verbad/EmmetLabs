def use_mock_clock
  return USE_MOCK_CLOCK if Object.const_defined?(:USE_MOCK_CLOCK)
  return RAILS_ENV =~ /test/ if Object.const_defined?(:RAILS_ENV)
  false
end

if use_mock_clock
  require 'clock/mock_clock'
else
  require 'clock/real_clock'
end