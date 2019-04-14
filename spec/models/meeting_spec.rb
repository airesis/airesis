require 'rails_helper'

RSpec.describe Meeting do
  it 'can be built' do
    expect(create(:meeting)).to be_valid
  end
end
