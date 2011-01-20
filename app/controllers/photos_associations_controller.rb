class PhotosAssociationsController < ApplicationController
  before_filter :login_required

  def destroy
    association = AssetsAssociation.find_by_asset_id(params[:id])
    respond_to do |format|
      if association.destroy
        format.html { redirect_back }
        format.js do
          @photoable = association.associate
        end
      else
        raise "Could not delete photoable association: #{params[:id]}"
      end
    end
  end

end
