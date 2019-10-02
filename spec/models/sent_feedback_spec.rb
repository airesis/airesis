require 'rails_helper'

RSpec.describe SentFeedback do
  context 'validations' do
    it { is_expected.to validate_length_of(:message).is_at_most(10.kilobytes) }
  end
end
