class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :likes, :dislikes, :created_at, :updated_at, :files
  has_many :comments
  has_many :links, serializer: LinksSerializer

  def files
    return unless object.files.attachments

    files_urls = object.files.map do |file|
      Rails.application.routes.url_helpers.rails_blob_url(file, host: 'localhost:3000')
    end
    
    files_urls.to_json
  end
end