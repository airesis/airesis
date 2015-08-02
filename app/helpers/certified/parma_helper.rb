module Certified
  module ParmaHelper
    def parma_participation_request
      link_to 'Accedi tramite Parma', user_omniauth_authorize_path(:parma), alt: t('pages.top_panel.parma_login'), title: t('pages.top_panel.parma_login'), class: 'btn blue'
    end

    def parma_login
      link_to t('pages.header.login'), user_omniauth_authorize_path(:parma), alt: t('pages.top_panel.parma_login'), title: t('pages.top_panel.parma_login')
    end
  end
end
