Dir["#{Rails.root}/lib/rails_admin/*.rb"].sort.each { |file| require file }

RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan, Abilities::RailsAdmin

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard # mandatory
    index # mandatory
    new do
      except %w[User SysPaymentNotification ReceivedEmail]
    end
    # export
    # bulk_delete
    show
    edit do
      except %w[ReceivedEmail]
    end
    delete do
      except %w[User SysPaymentNotification]
    end
    login_as do
      only ['User']
    end
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.included_models = %w[User Announcement NotificationType SysLocale SysFeature
                              SysPaymentNotification Configuration ReceivedEmail]

  config.model 'SysFeature' do
    exclude_fields %w[sys_payment_notifications]
  end
  config.model 'SysLocale' do
    object_label_method do
      :description
    end
    field :key, :enum do
      enum { I18n.available_locales }
    end
    field :host
    field :lang, :enum do
      enum { I18n.available_locales }
    end
    field :territory_type
    field :territory_id
    field :default
  end

  config.model 'User' do
    list do
      filters %i[id name surname email]
      sort_by :id
    end
    edit do
      field :name
      field :surname
      field :email
      field :sex
      field :receive_newsletter
      field :facebook_page_url
      field :google_page_url
      field :show_tooltips
      field :show_urls
      field :receive_messages
      field :rotp_enabled
      field :locale
      field :original_locale
    end
  end
end
