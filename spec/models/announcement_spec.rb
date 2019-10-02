require 'rails_helper'

RSpec.describe Announcement do
  context 'validations' do
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_length_of(:message).is_at_most(10.kilobytes) }
  end
end
