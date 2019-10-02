require 'rails_helper'

RSpec.describe Newsletter do
  context 'validations' do
    it { is_expected.to validate_length_of(:body).is_at_most(1.megabyte) }
  end
end
