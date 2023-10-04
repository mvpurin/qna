class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :question_id, :likes, :dislikes, :created_at, :updated_at
end