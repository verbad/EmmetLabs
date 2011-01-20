class ProfilePhotoAssociation < AssetsAssociation
  alias_method :profile, :associate

  def updatable_by?(user)
    user == profile.user
  end

  def destroyable_by?(user)
    updatable_by?(user)
  end
end
