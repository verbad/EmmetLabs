require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Butler do
  before do
    @homeowner = Object.new
    @fake_time = Object.new
    @start = Time.now
    @fake_time.should_receive(:now).any_number_of_times.and_return { @start }
  end

  it "should only send messages to the homeowner once every thirty seconds" do
    butler = Butler.new(@homeowner, 30.seconds, @fake_time)
    
    @homeowner.should_receive(:progress_report).with(0.5)
    butler.progress_report(0.5)

    @start += 5.seconds
    @homeowner.should_not_receive(:progress_report).with(0.6)
    butler.progress_report(0.6)

    @homeowner.should_receive(:progress_report).with(0.7)
    @start += 25.seconds
    butler.progress_report(0.7)
  end
=begin
  Comment this out cause it happens in real time.

  it "should test proper timeout in realtime too" do
    period = 2.seconds
    buffer = HomeownerBuffer.new(@homeowner,period)
    @homeowner.should_receive(:progress_report).with(0.5)
    buffer.progress_report(0.5)
    sleep 1.seconds
    @homeowner.should_not_receive(:progress_report).with(0.7)
    buffer.progress_report(0.7)
    sleep 1.seconds
    @homeowner.should_receive(:progress_report).with(0.8)
    buffer.progress_report(0.8)
  end
=end
end