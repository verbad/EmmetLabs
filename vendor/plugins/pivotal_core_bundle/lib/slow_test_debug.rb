SLOW_TEST_DEBUG_BEFORE = {}
SLOW_TEST_DEBUG_AFTER = {}
module SlowTestDebug
  @@ordered_before_keys ||= []
  @@ordered_after_keys ||= []
  
  def self.elapsed(key)
    SLOW_TEST_DEBUG_AFTER[key] - SLOW_TEST_DEBUG_BEFORE[key]
  end
  
  def self.elapsed_from_start(key)
    SLOW_TEST_DEBUG_AFTER[key] - @@start_timestamp
  end
  
  def self.time(key)
    before(key)
    yield
    after(key)
  end
  
  def self.print_report
    return unless ENV['SLOW_TEST_DEBUG']
    puts "-------- Slow Test Debug Report ---------"
    puts "Elapsed times (ordered):"
    all_elapsed = {}
    @@ordered_before_keys.each do |key|
      puts "#{formatted_timestamp(elapsed(key))}: #{key}"
      all_elapsed[key] = elapsed(key)
    end
    
    puts 
    puts "Elapsed times (sorted):"
    all_elapsed_sorted = all_elapsed.sort_by {|key, value| all_elapsed[key]}
    all_elapsed_sorted.each do |key, value|
      puts "#{formatted_timestamp(value)}: #{key}"
    end
    
    puts
    puts "Timeline:"
    first_before_key = @@ordered_before_keys.first
    puts "0: Start (before #{first_before_key})"    
    @@ordered_after_keys.each do |key|
      puts "#{formatted_timestamp(elapsed_from_start(key))} (+#{formatted_timestamp(elapsed(key))}): #{key}"
    end
    last_after_key = @@ordered_after_keys.last
    puts "#{formatted_timestamp(elapsed_from_start(last_after_key))}: End (after #{last_after_key})"    
    puts "----------------------------------"
  end
  
  def self.now_timestamp
    ("%10.5f" % Time.now.to_f).to_f
  end
  
  def self.formatted_timestamp(timestamp)
    "%0.2f" % timestamp
  end
  
  private
  # 'before' and 'after' methods are private to prevent the possibility of overlapping times, 
  # everything should be done via 'time'
  def self.before(key)
    ts = now_timestamp
    @@start_timestamp = ts if @@ordered_before_keys.size == 0
    @@ordered_before_keys << key
    SLOW_TEST_DEBUG_BEFORE[key] = ts
  end
  
  def self.after(key)
    @@ordered_after_keys << key
    SLOW_TEST_DEBUG_AFTER[key] =  now_timestamp
  end  
end