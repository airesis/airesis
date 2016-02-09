require 'spec_helper'
require 'requests_helper'

describe 'Home Page', type: :feature, js: true do
  it 'is visible in english' do
    visit open_space_path
    page_should_be_ok
  end

  it 'is visible in greek' do
    visit open_space_path(l: :el)
    page_should_be_ok

    visit open_space_path(l: :'el-GR')
    page_should_be_ok
  end
end
