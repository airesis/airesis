require 'rails_helper'
require 'paperclip/matchers'

describe Colors do
  it 'gets darken' do
    expect(Colors.darken_color('#DFEFFC')).to eq '#596065'
  end

  it 'gets lighter' do
    expect(Colors.lighten_color('#DFEFFC')).to eq '#ffffff'
  end
end
