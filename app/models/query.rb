class Query
  attr_accessor :query_string, :query_time

  def execute
    raise 'Not implemented'
  end

  protected
  def perform_query
    begin
      host = URI.parse(@query_url).host
      request = Net::HTTP::Get.new(@query_url)
      response = Net::HTTP.start(host) do |http|
        http.read_timeout = 3
        http.open_timeout = 3
        
        self.query_time = Benchmark.realtime do
          response = http.request(request)
        end
        response
      end
      return response.body
    rescue Exception => e
      query_time = 0
      raise QueryException.new(query_string, e)
    end
  end
end

class QueryException
  def initialize(query_string, exception)
    @query_string = query_string
    @exception = exception
  end
end