class ViewersController < ApplicationController
  helper :milestones

  def show
    if params[:id].nil?
      redirect_to people_path 
      return
    end
    @node = node_class.find_by_param(params[:id])
    raise ActiveRecord::RecordNotFound unless @node
    @node.photos.reload # TODO: why?
    resolve_categories
  end
end
