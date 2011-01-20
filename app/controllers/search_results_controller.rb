class SearchResultsController < ApplicationController

  def show
    @page_number = params[:page]

    @per_page = !params[:count].nil? ? params[:count].to_i : EntityAttributes::ClassMethods::SEARCH_PER_PAGE
    @per_page = EntityAttributes::ClassMethods::MAX_SEARCH_PER_PAGE if @per_page > EntityAttributes::ClassMethods::MAX_SEARCH_PER_PAGE

    @search_query = params[:search_query]
    pagination_options = {:per_page => @per_page, :page => @page_number}

    @people = Person.full_name_like(@search_query).sorted_by_full_name
    @entities = Entity.full_name_like(@search_query).sorted_by_full_name
    @nodes = (@people + @entities).sort_by {|n| n.calculated_dashified_full_name}.paginate(pagination_options)
  end
end
