FactoryBot.define do
  factory :answer do
    title { 'AnswerTitle' }
    body { 'AnswerBody' }

    trait :invalid do
      title { nil }
    end
  end
end
