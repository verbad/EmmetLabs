class PrimaryPhotosAssociationsController < ApplicationController
  before_filter :login_required

  def update
    association = AssetsAssociation.find_by_asset_id(params[:id])
    associate = association.associate
    associate.primary_photo_id = association.asset_id
    respond_to do |format|
      if associate.save
        format.html { redirect_back }
        format.js do
          @photoable = association.associate
        end
      else
        raise "Could not make photo primary: #{params[:id]}"
      end
    end
  end

end
