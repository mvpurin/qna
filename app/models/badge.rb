class Badge < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :file

  validate :validate_file_format

  private

  def validate_file_format
    if self.file.attached? && !self.file.blob.content_type.starts_with?('image/')
      self.file.purge
      errors.add :image, 'has wrong format!'
    end
  end
end
