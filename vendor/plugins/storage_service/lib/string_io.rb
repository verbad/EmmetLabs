class StringIO
  def to_tempfile
    t = Tempfile.new('stringio')
    t.write self.read
    t.rewind; self.rewind
    t
  end
end