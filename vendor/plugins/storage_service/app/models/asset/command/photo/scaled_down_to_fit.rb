class Asset::Command::Photo::ScaledDownToFit < Asset::Command::Photo::Base
  def process(image)
    if image.columns > width || image.rows > height
      image.resize_to_fit!(width, height)
    else
      image
    end
  end
end
