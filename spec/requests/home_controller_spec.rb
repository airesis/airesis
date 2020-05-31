require 'rails_helper'
require 'requests_helper'

RSpec.describe HomeController, seeds: true do
  describe 'GET index' do
    it 'shows the homepage' do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to safe_include(I18n.t('home.tags.title'))
    end

    context 'when locale is wrong' do
      context 'when has a replacement' do
        it 'redirects to a correct locale' do
          get root_path(l: 'el')
          expect(response).to redirect_to(root_path(l: 'el-GR'))
        end
      end

      context 'when does not have a replacement' do
        it 'redirects without locale' do
          get root_path(l: 'mickey')
          expect(response).to redirect_to(root_path(l: nil))
        end
      end
    end
  end
end
