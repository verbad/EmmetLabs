class NetworkController < ApplicationController

  def show
    @target_person = Node.find_person_or_entity_by_param(params[:id])

    raise ActiveRecord::RecordNotFound unless @target_person

    respond_to do |fmt|
      fmt.html {}
      fmt.xml do
        @people = @target_person.with_relatives
        render :template => "network/show", :layout => false
      end
    end
  end

end
