require 'singleton'

class NilUser < User
  include Singleton
  
  def nil?
    true
  end
  
  def id
    nil
  end
end