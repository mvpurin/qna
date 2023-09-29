class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file, only: :destroy

  authorize_resource

  def show; end

  def destroy
    @file.purge if can? :destroy, @file
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find_by(blob_id: params[:id])
  end
end
