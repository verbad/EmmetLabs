class EntitiesController < ApplicationController
  
  def index
    @column_count = 3
    @page_number = params[:page]
    # Integer arithmetic to round to truncate to @column_count
    @per_page = !params[:count].nil? ? params[:count].to_i / @column_count * @column_count : EntityAttributes::ClassMethods::EXPLORE_PER_PAGE
    @entities = Entity.sorted_by_relationship_count_and_full_name(@page_number, @per_page)
  end
  
  def show
    respond_to do |format|
      format.html { redirect_to viewer_path(:node_type => params[:controller], :id => params[:id]) }
      format.js   do
        #FIXME: This should not be happening here. Refactor photo creation stuff into the photos controller!
        # That goes for People as well.
        @entity = Entity.find_by_param(params[:id])
        render :update do |page|
          page.replace 'primary_photo', :partial => 'photos/primary_photo', :locals => {:photoable => @entity}
          if @entity.photos.empty?
            page.replace_html 'add_first_photo', :partial => 'photos/new_photo', :locals => {:id => 'add_first_photo', :show => false}
            page.visual_effect :slide_down, 'add_first_photo', :duration => 0.3
          end
        end
      end
    end
  end
  
  def update
    @entity = Entity.find_by_param(params[:id])
    respond_to do |format|

      if @entity.update_attributes(params[:entity])
        format.html { redirect_to entity_url(@entity) }
        format.js {  render :action => 'create' }
      else
        @entity_errors = @entity.errors
        @entity.reload
        format.html do
          render :action => 'show'
        end
        format.js do
          @edit = true
          render :action => 'create'
        end
      end
    end
  end
end
