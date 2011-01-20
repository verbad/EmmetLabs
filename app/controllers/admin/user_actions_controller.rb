class Admin::UserActionsController < Admin::AdminController

  def index
    @page_number = params[:page]
    @per_page = !params[:count].nil? ? params[:count].to_i : EntityAttributes::ClassMethods::EXPLORE_PER_PAGE
    
    conditions = "loggable_type != 'DirectedRelationship'"
    if params[:user_id] 
      conditions = [ conditions + " AND user_id = ? ", params[:user_id]]
    end
    @user_actions = UserAction.paginate(:all, 
                                        :page => @page_number,
                                        :per_page => @per_page,
                                        :order => 'created_at DESC',
                                        :conditions => conditions
                                        )
  end
end