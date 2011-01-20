# Note: this module needs to be required and included in your project's test_helper method
module CommonTestHelper

  def assert_contains(substring, string, message_on_error = "Expected '#{substring}' to be in '#{string}'")
    assert string.include?(substring), message_on_error
  end
  
  def assert_does_not_contain(substring, string, message_on_error = "Expected '#{substring}' not to be in '#{string}', but it was")
    assert !string.include?(substring), message_on_error
  end
  
  alias_method :assert_not_contains, :assert_does_not_contain
  
  def assert_called(spy, method_name, *args)
    assert spy.was_called?(method_name, *args), "Expected #{args.inspect}\n" + 
            " but was #{spy.methods_called.inspect}"
  end
  
  def assert_called_exactly(spy, *args)
    assert spy.were_called_exactly?(*args), "Expected #{args.inspect}\n" + 
            " but was #{spy.methods_called.inspect}"
  end
  
  def assert_false(condition, msg = nil)
    assert !condition, msg
  end

  def assert_true(condition, msg = nil)
    assert condition, msg
  end

  def assert_equal_ignoring_order(expected, actual)
    assert_equal expected.size, actual.size, "#{actual} is not equal to #{expected} with respect to size"
    assert expected.is_equivalent_to?(actual), "#{actual} is not equal to #{expected} with respect to elements"
  end
  
  def assert_not_valid(model, messages=[])
    assert !model.valid?, "Found valid active record: expected errors [#{messages.join(',')}] but got #{model.errors.full_messages.sort.join(',')}"
    assert_equal messages.sort, model.errors.full_messages.sort
  end
  
  def assert_email_sent(expected_from, expected_to, expected_subject = nil, expected_body = nil)
    assert ActionMailer::Base.deliveries.length > 0, "Did not receive an email"
    recipients = expected_to.is_a?( Array) ? expected_to : [expected_to]
    delivery = ActionMailer::Base.deliveries.find {|delivery| delivery.to == recipients}
    assert_not_nil delivery, "Unable to find email sent to #{expected_to}"
    assert_equal [expected_from], delivery.from
    assert_equal expected_subject, delivery.subject unless expected_subject.nil?
    unless expected_body.nil?
      assert_equal expected_body, delivery.body[0..expected_body.length-1]
    end
  end

  def assert_showing_flash(key, expected_message)
    if @response.redirect?
      fail "Please use flash rather than flash.now for this redirect action" if flash.now[key] == expected_message
      assert_equal expected_message, flash[key]
    else
      fail "Please use flash.now rather than flash for this non-redirect action" if flash[key] == expected_message
      assert_equal expected_message, flash.now[key]
    end
  end
  
  def assert_response_success
    if @response.error?
      fail("Got app error - #{@response.body}")
    elsif @response.redirect?
      fail("Expected immediate render, but got redirect - #{@response.body}")
    else
      assert_response :success
    end
  end


  ########
  #### This is a copy of assert_redirected_to from actionpack-1.13.3
  ####   with two patches (need to submit):
  ####   more sensible failure message if you get an app error (1)
  ####   better handling of symbols in redirects (2)
  ####   Look for PATCH (X) in the code
  def assert_redirected_to(options = {}, message=nil)
    clean_backtrace do
      fail("Got app error - #{@response.body}") and return if @response.error? #### PATCH (1)
      assert_response(:redirect, message)
      return true if options == @response.redirected_to
      ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?

      begin
        url  = {}
        original = { :expected => options, :actual => @response.redirected_to.is_a?(Symbol) ? @response.redirected_to : @response.redirected_to.dup }
        original.each do |key, value|
          if value.is_a?(Symbol)
            value = @controller.respond_to?(value, true) ? @controller.send(value) : @controller.send("hash_for_#{value}_url")
          end

          unless value.is_a?(Hash)
            request = case value
              when NilClass    then nil
              when /^\w+:\/\// then recognized_request_for(%r{^(\w+://.*?(/|$|\?))(.*)$} =~ value ? $3 : nil)
              else                  recognized_request_for(value)
            end
            value = request.path_parameters if request
          end

          if value.is_a?(Hash) # stringify 2 levels of hash keys
            if name = value.delete(:use_route)
              route = ActionController::Routing::Routes.named_routes[name]
              value.update(route.parameter_shell)
            end

            value.stringify_keys!
            value.values.select { |v| v.is_a?(Hash) }.collect { |v| v.stringify_keys! }
            if key == :expected && value['controller'] == @controller.controller_name && original[:actual].is_a?(Hash)
              original[:actual].stringify_keys!
              value.delete('controller') if original[:actual]['controller'].nil? || original[:actual]['controller'] == value['controller']
            end
          end

          if value.respond_to?(:[]) && value['controller']
            value['controller'] = value['controller'].to_s #### PATCH (2)
            if key == :actual && value['controller'].first != '/' && !value['controller'].include?('/')
              new_controller_path = ActionController::Routing.controller_relative_to(value['controller'], @controller.class.controller_path)
              value['controller'] = new_controller_path if value['controller'] != new_controller_path && ActionController::Routing.possible_controllers.include?(new_controller_path)
            end
            value['controller'] = value['controller'][1..-1] if value['controller'].first == '/' # strip leading hash
          end
          url[key] = value
        end


        @response_diff = url[:expected].diff(url[:actual]) if url[:actual]
        msg = build_message(message, "response is not a redirection to all of the options supplied (redirection is <?>), difference: <?>",
                            url[:actual], @response_diff)

        assert_block(msg) do
          url[:expected].keys.all? do |k|
            if k == :controller then url[:expected][k] == ActionController::Routing.controller_relative_to(url[:actual][k], @controller.class.controller_path)
            else parameterize(url[:expected][k]) == parameterize(url[:actual][k])
            end
          end
        end
      rescue ActionController::RoutingError # routing failed us, so match the strings only.
        msg = build_message(message, "expected a redirect to <?>, found one to <?>", options, @response.redirect_url)
        url_regexp = %r{^(\w+://.*?(/|$|\?))(.*)$}
        eurl, epath, url, path = [options, @response.redirect_url].collect do |url|
          u, p = (url_regexp =~ url) ? [$1, $3] : [nil, url]
          [u, (p.first == '/') ? p : '/' + p]
        end.flatten

        assert_equal(eurl, url, msg) if eurl && url
        assert_equal(epath, path, msg) if epath && path
      end
    end
  end


  def assert_email_not_sent
    assert_equal 0, ActionMailer::Base.deliveries.length
  end
  
  def assert_array_contents_match(collection_to_match, collection_to_test, message = "")
    extra_in_match = collection_to_match - collection_to_test
    extra_in_test = collection_to_test - collection_to_match
    assert_equal [], extra_in_match, "Missing elements" + message
    assert_equal [], extra_in_test, "Extra elements" + message
  end
  
  def assert_roughly_equal(thing1, thing2, tolerance = nil)
    if thing1.is_a?(Time) || thing2.is_a?(Time)
      default_tolerance = 2.0 #seconds
    else
      default_tolerance = 0.01
    end
    tolerance ||= default_tolerance
    assert((thing1.to_f + tolerance) > thing2.to_f, "Results were off by #{thing1.to_f - thing2.to_f}, exceeding the tolerance of #{tolerance}")
    assert((thing1.to_f - tolerance) < thing2.to_f, "Results were off by #{thing1.to_f - thing2.to_f}, exceeding the tolerance of #{tolerance}")
  end

  def assert_arrays_roughly_equal(thing1, thing2, tolerance = nil)
    thing1.each_with_index do |t1, index|
      assert_roughly_equal(t1, thing2[index], tolerance)
    end
  end

  def spy_on_console_messages(object)
    @console_messages = console_messages = []
    object.instance_class do
      define_method :puts do |message|
        console_messages << message
      end
    end
    @console_messages
  end
  def assert_no_console_messages
    assert_equal [], @console_messages
  end
  
  def assert_lazy_loader(object, method_name, default_value)
    assert_equal default_value, object.send(method_name)
    test_object = Object.new
    object.send(method_name.to_s + "=", test_object)
    assert_equal test_object, object.send(method_name)
  end
  
  def run(result=nil, &block)
    return_value = super(result, &block)
    filter_common_test_helper_file_from_result(result)
    return_value
  end
  
  def assert_json_equal(expected, actual, *args)
    assert_equal create_json_object(expected), create_json_object(actual), *args
  end
  
  def create_json_object(object)
    JSON.parse(object.to_json)
  end
  
  def filter_common_test_helper_file_from_result(result)
    traces_to_filter = []
    if result && result.error_count != 0
      result.instance_eval{@errors}.each do |r|
        traces_to_filter << r.location if r.respond_to?(:location)
      end
    end
    if result && result.failure_count != 0
      result.instance_eval{@failures}.each do |r|
        traces_to_filter << r.location if r.respond_to?(:location)
      end
    end
    traces_to_filter.each do |trace|
      trace.pop if trace.last.include?(__FILE__)
    end
  end

  def clear_table_except_for(objectect_class=nil, objectect_array=[])
    raise "You must pass an objectect class" if objectect_class.nil?
    return if objectect_array.empty?
    objectect_array.each do |object|
      raise "All objectects must be of type #{objectect_class.to_s}" unless object.is_a? objectect_class
    end
    objectect_class.destroy_all(["id not in (?)", objectect_array.collect {|object| object.id}])
  end

  def assert_empty(container)
    assert container.empty?
  end
  
  def assert_html_equal(expected, actual, message = '')
    assert_equal Hpricot(expected).to_s, Hpricot(actual).to_s, message
  end

  def get_diff(expected, actual, num_chars = nil)
    diff = ""
    0.upto(expected.length) do |i|
      unless expected[i] == actual[i]
        diff += "difference at character #{i}\n"
        diff += "Expected: #{expected[i..(num_chars.nil? ? -1 : i+num_chars)]}\n"
        diff += "  Actual: #{actual[i..(num_chars.nil? ? -1 : i+num_chars)]}\n"
        return diff
      end
    end
    return ""
  end

  def print_diff(expected, actual)
    p get_diff(expected, actual)
  end
end