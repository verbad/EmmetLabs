dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

class TimeTest < Pivotal::IsolatedPluginTestCase

  def test_dayth
    assert_equal "3rd", Time.local(2006, 'Jan', 3).dayth
    assert_equal "4th", Time.local(2006, 'Jan', 4).dayth
    assert_equal "2nd", Time.local(2006, 'Jan', 2).dayth
    assert_equal "1st", Time.local(2006, 'Jan', 1).dayth
    assert_equal "20th", Time.local(2006, 'Jan', 20).dayth
    assert_equal "21st", Time.local(2006, 'Jan', 21).dayth
  end

  def test_to_dayth_of_year
    assert_equal "January 3rd, 2006", Time.local(2006, 'Jan', 3).to_dayth_of_year
  end

  def test_rfc3339

    time = Time.parse("Thu Nov 29 16:30:00 GMT 2001")
    assert_equal "2001-11-29T16:30:00-00:00", time.rfc3339

    time = Time.parse("Thu Nov 29 16:30:00 EST 2001")
    assert_equal "2001-11-29T21:30:00-00:00", time.rfc3339

    time = Time.parse("Thu Dec 31 20:30:00 EST 2001")
    assert_equal "2002-01-01T01:30:00-00:00", time.rfc3339
  end

end