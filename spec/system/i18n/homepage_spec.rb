require 'rails_helper'
require 'requests_helper'

RSpec.describe 'Home Page', :js do
  it 'is visible in english' do
    visit open_space_path
    page_should_be_ok
  end

  it 'is visible in greek' do
    create(:sys_locale, key: 'el-GR', host: 'airesis.gr')
    visit open_space_path(l: :'el-GR')
    page_should_be_ok
  end
end
