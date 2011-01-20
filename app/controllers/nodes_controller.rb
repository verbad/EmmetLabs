class NodesController < ApplicationController
  
  def show
    @node = Node.find_person_or_entity_by_param(params[:id])
    respond_to do |format|
      format.html { redirect_to viewer_path(:node_type => @node.class.name.tableize, :id => params[:id]) }
      format.js   do
        @index = params[:index]
      end
    end
  end
  
end