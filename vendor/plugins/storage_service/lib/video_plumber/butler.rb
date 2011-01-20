#
# Butler is a liason between the Homeowner (Server) and the plumber,
# prevents the home owner from getting too much chat from the plumber.
#
class Butler
  def initialize(homeowner, period = 20.seconds, time = Time)
    @period = period
    @homeowner = homeowner
    @time = time
    @last_time = @time.now - @period
  end

  # Invalid Strategy will be called
  # if the Plumber is unable to interface
  # with the pipe in a way that yields
  # progress reports.
  #
  # The Server (Homeowner) will need to be notified
  # that the pipes are getting cleaned but
  # the progress isn't going to be readily
  # avalible.
  #
  def invalid_strategy(problem)
    @homeowner.invalid_strategy( problem)
  end

  def progress_report(percent_completed)
    if @time.now >= (@last_time + @period)
      @homeowner.progress_report(percent_completed)
      @last_time = @time.now
    end
  end
end