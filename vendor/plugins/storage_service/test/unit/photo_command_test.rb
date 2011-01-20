require File.dirname(__FILE__) + '/../test_helper'

class PhotoCommandTest < StorageServicePluginTestCase

  BLACK = "#000000"
  WHITE = "#FFFFFF"

  def setup
    super
  end

  def test_scaled_down_to_fit
    command = Asset::Command::Photo::ScaledDownToFit.new(100, 200)
    assert_equal 100, command.width
    assert_equal 200, command.height
  end

  def test_resized_to_fit
    command = Asset::Command::Photo::ResizedToFit.new(100, 200)
    assert_equal 100, command.width
    assert_equal 200, command.height
  end
  
  def test_resized_and_cropped
    command = Asset::Command::Photo::ResizedAndCropped.new(100, 200, Magick::NorthGravity)
    assert_equal 100, command.width
    assert_equal 200, command.height
    assert_equal Magick::NorthGravity, command.gravity
  end

  def test_scaled_down_to_fit__scales_down_to_fit_within_bounding_box
    scaled_down_to_fit = scaled_down_to_fit create_white_photo(500, 1000)
    assert scaled_down_to_fit.columns <= RESIZED_TO_FIT_WIDTH
    assert_equal RESIZED_TO_FIT_HEIGHT, scaled_down_to_fit.rows
  end

  def test_resized_to_fit__scales_up_to_fit_within_bounding_box
    resized_to_fit = resized_to_fit create_white_photo(20, 30)
    assert RESIZED_TO_FIT_WIDTH == resized_to_fit.columns || RESIZED_TO_FIT_HEIGHT == resized_to_fit.rows
  end

  def test_resized_to_fit__scales_down_to_fit_within_bounding_box
    resized_to_fit = resized_to_fit create_white_photo(500, 1000)
    assert resized_to_fit.columns <= RESIZED_TO_FIT_WIDTH
    assert_equal RESIZED_TO_FIT_HEIGHT, resized_to_fit.rows
  end

  def test_resized_and_cropped__portrait_source_image_crops_to_desired_size
    portrait_photo = resized_and_cropped create_white_photo(199, 200)
    assert_image_size RESIZED_AND_CROPPED_WIDTH,
                      RESIZED_AND_CROPPED_HEIGHT,
                      portrait_photo
  end

  def test_resized_and_cropped__landscape_source_image_crops_to_desired_size
    landscape_photo = resized_and_cropped create_white_photo(980, 20)
    assert_image_size RESIZED_AND_CROPPED_WIDTH,
                      RESIZED_AND_CROPPED_HEIGHT,
                      landscape_photo
  end

  def test_resized_and_cropped__square_source_image_crops_to_desired_size
    square_photo = resized_and_cropped create_white_photo(500, 500)
    assert_image_size RESIZED_AND_CROPPED_WIDTH,
                      RESIZED_AND_CROPPED_HEIGHT,
                      square_photo
  end

  def test_resized_and_cropped__smaller_source_image_expands_and_crops_to_desired_size
    square_photo = resized_and_cropped create_white_photo(20, 10)
    assert_image_size RESIZED_AND_CROPPED_WIDTH,
                      RESIZED_AND_CROPPED_HEIGHT,
                      square_photo
  end

  protected

  def scaled_down_to_fit(image)
    Magick::Image.from_blob(Asset::Command::Photo::ScaledDownToFit.new(SCALED_DOWN_TO_FIT_WIDTH, SCALED_DOWN_TO_FIT_HEIGHT).do(StringIO.new(image.to_blob)).read).first
  end

  def resized_to_fit(image)
    Magick::Image.from_blob(Asset::Command::Photo::ResizedToFit.new(RESIZED_TO_FIT_WIDTH, RESIZED_TO_FIT_HEIGHT).do(StringIO.new(image.to_blob)).read).first
  end

  def resized_and_cropped(image)
    Magick::Image.from_blob(Asset::Command::Photo::ResizedAndCropped.new(RESIZED_AND_CROPPED_WIDTH, RESIZED_AND_CROPPED_HEIGHT).do(StringIO.new(image.to_blob)).read).first
  end

  def assert_image_size(width, height, image)
    assert_equal width, image.columns
    assert_equal height, image.rows
  end

  def create_white_photo(width, height, file_name = nil)
    create_photo(width, height, file_name) do |canvas|
      canvas.fill WHITE
      canvas.rectangle(0, 0, width - 1, height - 1)
    end
  end

  def create_photo(width, height, file_name = nil)
    image = Magick::ImageList.new
    image.new_image(width, height)
    image.format = "PNG"
    canvas = Magick::Draw.new

    yield(canvas)

    canvas.draw(image)
    image
  end

end
