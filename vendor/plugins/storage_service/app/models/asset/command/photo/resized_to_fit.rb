class Asset::Command::Photo::ResizedToFit < Asset::Command::Photo::Base
  def process(image)
    image.resize_to_fit!(width, height)
  end
end
