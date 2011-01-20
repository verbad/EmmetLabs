dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class ClockTest < Test::Unit::TestCase
  include FlexMock::TestCase
  def test_now__time_frozen_under_test
    now = Time.now
    flexstub(Time).should_receive(:now).and_return(now)
    first_time = Clock.now
    flexstub(Time).should_receive(:now).and_return(now + 1)
    assert_equal first_time, Clock.now
  end
  
  attr_reader :context, :clock_source
  
  def setup
    @context = Object.new
    dir = File.dirname(__FILE__)
    @clock_source = File.read("#{dir}/../../lib/clock/clock.rb")
  end
  
  def test_require__if_USE_MOCK_CLOCK_is_undefined__requires_mock_clock
    assert_equal 'test', RAILS_ENV
    
    flexstub(context).should_receive(:require).with('clock/mock_clock').once
    context.instance_eval(clock_source)
  end
  
  def test_require__if_USE_MOCK_CLOCK_is_true__requires_mock_clock
    assert_equal 'test', RAILS_ENV
    Object.redefine_const(:USE_MOCK_CLOCK, true)

    flexstub(context).should_receive(:require).with('clock/mock_clock').once
    context.instance_eval(clock_source)
  end  
  
  def test_require__if_USE_MOCK_CLOCK_is_false__requires_real_clock
    assert_equal 'test', RAILS_ENV
    Object.redefine_const(:USE_MOCK_CLOCK, false)

    flexstub(context).should_receive(:require).with('clock/real_clock').once
    context.instance_eval(clock_source)
  end
  
end