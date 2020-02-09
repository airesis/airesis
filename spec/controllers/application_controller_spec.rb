require 'rails_helper'
require 'requests_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'set_current_domain' do
    let(:host) { 'airesis.it' }
    let(:sys_locale) { create(:sys_locale, host: host) }

    before do
      SysLocale.destroy_all
      sys_locale
    end

    context 'set from host' do
      context 'host with no subdomain' do
        before do
          @request.host = host
        end

        it 'retrieves correctly the locale from sys_locales table depending on the request host' do
          subject.instance_eval { set_current_domain }
          expect(subject.instance_eval { current_domain }).to eq sys_locale
        end
      end

      context 'host with www subdomain' do
        before do
          @request.host = "www.#{host}"
        end

        it 'retrieves correctly the locale from sys_locales table depending on the request host' do
          subject.instance_eval { set_current_domain }
          expect(subject.instance_eval { current_domain }).to eq sys_locale
        end
      end

      context 'host not found' do
        before do
          @request.host = 'hello.com'
        end

        it 'fallbacks to default locale' do
          subject.instance_eval { set_current_domain }
          expect(subject.instance_eval { current_domain }).to eq SysLocale.default
        end
      end
    end

    context 'set from l param' do
      context 'l found in database' do
        before do
          @request.host = 'hello.com'
          allow(subject).to receive(:params).and_return(l: sys_locale.key)
        end

        it 'retrieves correctly the locale from sys_locales table depending on the request l parameter' do
          subject.instance_eval { set_current_domain }
          expect(subject.instance_eval { current_domain }).to eq sys_locale
        end
      end
    end
  end
end
