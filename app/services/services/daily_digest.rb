module Services
  class DailyDigest
    def send_digest
      load_one_day_questions
byebug
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user, questions = @questions).deliver_later
      end
    end

    private

    def load_one_day_questions
      @questions = []
      Question.find_each(batch_size: 500) do |question|
        @questions << question.title if Time.now - question.created_at < 86400 
      end
      @questions
    end
  end
end