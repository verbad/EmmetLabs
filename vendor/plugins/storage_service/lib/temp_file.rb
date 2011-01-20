require 'tempfile'
Tempfile.class_eval do
  def to_tempfile
    self
  end

  def ==(other)
    self.equal? other
  end
end