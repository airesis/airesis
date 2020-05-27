if ENV['OVERRIDE_MAIL_RECIPIENT'].present? && Rails.env.development?
  class OverrideMailRecipient
    def self.delivering_email(mail)
      mail.to = ENV['OVERRIDE_MAIL_RECIPIENT']
    end
  end
  ActionMailer::Base.register_interceptor(OverrideMailRecipient)
end
