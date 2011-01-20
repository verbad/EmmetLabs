class ContentPage < ActiveRecord::Base
  validates_presence_of :calculated_dashified_name, :message => "Please enter a name for this content page."

  def before_validation
    self.calculated_dashified_name = self.name.nil? ? nil : self.name.dashify
  end
end
