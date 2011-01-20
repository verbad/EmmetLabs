class Photo < Asset
  include CanBeCommentedOn  

  has_versions :large => Asset::Command::Photo::ScaledDownToFit.new(248, 1000),
               :medium => Asset::Command::Photo::ScaledDownToFit.new(100, 300),
               :small => Asset::Command::Photo::ScaledDownToFit.new(75, 75),
               :medium_large => Asset::Command::Photo::ScaledDownToFit.new(200, 250)

  def photo?
    true
  end

  def comment
    comments && comments.first ? comments.first : nil
  end

  def primary?
    assets_associations.first.primary?
  end
end