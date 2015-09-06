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
      except %w(SysPaymentNotification)
    end
    export
    #bulk_delete
    show
    edit
    delete do
      except %w(SysPaymentNotification)
    end
    #show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.included_models = %w(Announcement NotificationType SysLocale SysFeature SysMovement
                              SysPaymentNotification Configuration)

  config.model 'SysFeature' do
    exclude_fields %w(sys_payment_notifications)
  end
  config.model 'SysLocale' do
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
end
