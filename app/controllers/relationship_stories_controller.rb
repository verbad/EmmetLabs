class RelationshipStoriesController < ApplicationController
  before_filter :login_required

  def new
    @relationship_story = RelationshipStory.new(:relationship_id => params[:relationship_id])
  end

  def edit
    @relationship_story = RelationshipStory.find(params[:id])
  end

  def create
    @relationship_story = RelationshipStory.new(params[:relationship_story])

    respond_to do |format|
      if @relationship_story.save
        flash[:notice] = 'Relationship story was successfully created.'
        format.html { redirect_to edit_relationship_url(@relationship_story.relationship) }
        format.xml  { head :created, :location => edit_directed_relationship_url(@relationship_story.relationship.directed_relationships[0]) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relationship_story.errors.to_xml }
      end
    end
  end

  def update
    @relationship_story = RelationshipStory.find(params[:id])

    respond_to do |format|
      if @relationship_story.update_attributes(params[:relationship_story])
        flash[:notice] = 'Relationship story was successfully updated.'
        format.html { redirect_to edit_relationship_url(@relationship_story.relationship) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relationship_story.errors.to_xml }
      end
    end
  end

  def destroy
    @relationship_story = RelationshipStory.find(params[:id])
    @relationship_story.destroy

    respond_to do |format|
      format.html { redirect_to edit_relationship_url(@relationship_story.relationship) }
      format.xml  { head :ok }
    end
  end

end
