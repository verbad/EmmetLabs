class RelationshipArticlesController < ApplicationController
  before_filter :login_required
  before_filter :resolve_relationship

  def show
    @relationship_article = RelationshipArticle.find(params[:id])
    respond_to do |format|
      format.js { }
    end
  end

  def create
    @relationship.articles.create(params[:relationship_article].merge({:author => current_user}))
  end

  private

  def resolve_relationship
    @relationship = Relationship.find(params[:relationship_id])
  end

end