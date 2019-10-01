require 'rails_helper'
require 'requests_helper'

RSpec.describe HomeController  do
  describe '#set_locale' do
    let(:locale) { nil }
    let(:http_accepted_language) { nil }

    def expect_localized_response(locale)
      expect(response.body).to include I18n.t('home.intro.paragraph_1.title', locale: locale)
    end

    before do
      get root_path, params: { l: locale }, headers: { 'HTTP_ACCEPT_LANGUAGE' => http_accepted_language }
    end

    context 'when accepted language header of the browser is german' do
      let(:http_accepted_language) { 'de-DE,de;q=0.8,en-US;q=0.5,en;q=0.3' }

      it { expect_localized_response(:de) }
    end

    context 'when accepted language header of the browser is english' do
      let(:http_accepted_language) { 'en-US,en;q=0.5' }

      it { expect_localized_response(:en) }

      context 'when a locale parameter is set' do
        let(:locale) { :de }

        it { expect_localized_response(:de) }
      end

      context 'when a locale parameter is unsupported' do
        let(:locale) { :cn }

        it { expect_localized_response(:en) }
      end
    end

    context 'when accepted language header of the browser is not set' do
      it { expect_localized_response(I18n.default_locale) }
    end
  end
end
