class WelcomeController < ApplicationController
  layout 'welcome'
  
  def index
    @login = Login.new
  end
  
  def contact
    @login = Login.new
  end
  
  def legal
    @login = Login.new
  end
  
  def team
    @login = Login.new
  end
  
end  
