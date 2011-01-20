class Asset::Command::Identity < Asset::Command::Base
  def extension
    nil
  end
  
  def do(data)
    data
  end
end