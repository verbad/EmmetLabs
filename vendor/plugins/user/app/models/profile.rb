class Profile < ActiveRecord::Base
  acts_as_paranoid unless Object.const_defined?(:DISABLE_ACTS_AS_PARANOID)
  
  belongs_to :user
  has_assets :photos, :class_name => 'ProfilePhoto', :through => :profile_photo_associations

  def creatable_by?(current_user)
    user.creatable_by?(current_user)
  end

  def updatable_by?(current_user)
    self.user == current_user || current_user.super_admin?
  end

  def destroyable_by?(current_user)
    updatable_by?(current_user)
  end
  
  def age
    today = Date.today
    return nil if date_of_birth.nil? || date_of_birth.to_date > today.to_date

    temp = date_of_birth.to_date >> 12
    age = 0
    while temp < today
      age += 1
      temp = temp >> 12
    end

    age
  end
end