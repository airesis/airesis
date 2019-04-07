require 'rails_helper'
require 'paperclip/matchers'

describe Colors do
  it 'gets darken' do
    expect(described_class.darken_color('#DFEFFC')).to eq '#596065'
  end

  it 'gets lighter' do
    expect(described_class.lighten_color('#DFEFFC')).to eq '#ffffff'
  end
end
