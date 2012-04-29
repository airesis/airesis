# config/initializers/email_preview.rb
# basic example for previewing an email built manually
EmailPreview.register 'notification email' do
  ResqueMailer.notification(322)
end