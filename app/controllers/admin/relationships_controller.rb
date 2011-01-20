class Admin::RelationshipsController < Admin::AdminController

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    respond_to do |format|
      format.js {}
    end
  end

end
