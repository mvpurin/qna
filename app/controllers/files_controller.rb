class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file, only: :destroy

  def show; end

  def destroy
    @file.purge if @file.record.user_id == current_user.id
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find_by(blob_id: params[:id])
  end
end
