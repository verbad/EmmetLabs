class TermsOfServiceController < ApplicationController
  
  def show
    if !@terms_of_service = TermsOfService.latest
      throw "No terms of service!"
    end
  end
  
end