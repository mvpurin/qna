require 'rails_helper'

RSpec.describe EmailConfirmationMailer, type: :mailer do
  describe 'email_confirmation' do
    let(:user) { create(:user) }
    let(:mail) { described_class.with(user: user).confirm_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Email confirmation | QNA app')
      expect(mail.to).to eq([user.email])
    end
  end
end
