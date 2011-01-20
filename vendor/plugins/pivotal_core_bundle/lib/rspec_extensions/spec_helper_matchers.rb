module SpecHelperMatchers
  def start_with(str)
    be_starts_with(str)
  end

  def end_with(str)
    be_ends_with(str)
  end

  def contain_exactly(collection)
    ContainExactly.new(collection)
  end

  def have_response_code(code)
    HaveResponseCode.new(code)
  end

  def have_records
    HaveRecords.new
  end

  def have_records_with_deleted
    HaveRecordsWithDeleted.new
  end

  class HaveResponseCode
    def initialize(code)
      @expected_code = code
      @expected_code = {:forbidden => 403, :bad_request => 400}[code] if code.is_a?(Symbol)
      raise "Only :forbidden and :bad_request currently supported by this helper. Extend it!" if @expected_code.nil?
    end

    def matches?(response)
      @response = response
      @response.response_code == @expected_code
    end

    def failure_message
      "Expected response code #{@expected_code}, received code #{@response.response_code}"
    end
  end

  class ContainExactly
    def initialize(collection)
      @collection = collection
      @offending_objects = []
    end

    def matches?(other_collection)
      @other_collection = other_collection
      @offending_contained_objects = @other_collection.reject do |object|
        @collection.include?(object)
      end
      @offending_uncontained_objects = @collection.reject do |object|
        @other_collection.include?(object)
      end
      @offending_contained_objects.empty? and @offending_uncontained_objects.empty?
    end

    def failure_message
      "Expected collection contained: #{@collection.inspect}\n" +
      "Actual collection contained:   #{@other_collection.inspect}\n" +
      "Missing stuff:                 #{@offending_uncontained_objects.inspect}\n" +
      "Extra stuff:                   #{@offending_contained_objects.inspect}\n"
    end
  end

  class HaveRecords
    def matches?(target)
      @target = target
      !@target.find(:all).empty?
    end
    def failure_message
      "expected #{@target.inspect} to have records found by find(:all)"
    end
    def negative_failure_message
      "expected #{@target.inspect} not to have records found by find(:all)"
    end
  end

  class HaveRecordsWithDeleted
    def matches?(target)
      @target = target
      begin
        !@target.find_with_deleted(:all).empty?
      rescue
        raise "Unable to call 'find_with_deleted(:all) for #{@target.inspect}"
      end
    end
    def failure_message
      "expected #{@target.inspect} to have records found by find_with_deleted(:all)"
    end
    def negative_failure_message
      "expected #{@target.inspect} not to have records found by find_with_deleted(:all)"
    end
  end
end