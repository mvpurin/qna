class Badge < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :file

  validate :validate_file_format

  private

  def validate_file_format
    return unless file.attached? && !file.blob.content_type.starts_with?('image/')

    file.purge
    errors.add :image, 'has wrong format!'
  end
end
