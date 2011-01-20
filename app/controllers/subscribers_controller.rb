class SubscribersController < ApplicationController

  def create
    @subscriber = Subscriber.new(params[:subscriber])
    @subscriber.save
  end

end