require 'rails_helper'

RSpec.describe Place do
  it 'can be built' do
    expect(create(:place)).to be_valid
  end
end
