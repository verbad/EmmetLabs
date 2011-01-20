class MockFlashHash
  def initialize
    @hash = {}
    @now_hash = {}
  end

  def [](key)
    @hash[key]
  end

  def []=(key, obj)
    @hash[key] = obj
  end

  def discard(k = nil)
    initialize
  end

  def now
    @now_hash
  end

  def update(hash)
    @hash.update(hash)
  end

  def sweep
    # This is the key.  We don't really want flash.now's to go away.
  end

  def method_missing(name, *args, &block)
    @hash.send(name, *args, &block)
  end

end
