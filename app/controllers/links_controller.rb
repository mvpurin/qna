class LinksController < ApplicationController
  def destroy
    link = Link.find(params[:id])
    link.destroy if link.linkable.user_id == current_user.id
  end
end
