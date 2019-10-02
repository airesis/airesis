require 'rails_helper'

RSpec.describe BlogPost do
  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(1.megabyte) }
  end
end
