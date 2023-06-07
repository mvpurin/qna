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
    model_class = @file.record.class
    model_instance = model_class.find_by(id: @file.record.id)
    params[:model_instance] = model_instance
  end
end