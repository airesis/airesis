#!/usr/bin/env ruby
require 'mailman'

Mailman.config.logger = Logger.new('log/mailman.log')
Mailman.config.ignore_stdin = true

env = YAML.load_file('config/application.yml')
Mailman.config.pop3 = {
  server: env['MAILMAN_SERVER'], port: 110,
  username: env['MAILMAN_USERNAME'],
  password: env['MAILMAN_PASSWORD']
}

Mailman::Application.run do
  to env['MAILMAN_EMAIL'] do
    begin
      ReceivedEmail.create!(subject: message.subject,
                            body: message.text_part.decoded,
                            from: message.from.first,
                            to: message.to.first,
                            token: params[:token])

    rescue Exception => e
      Mailman.logger.error "Exception occurred while receiving message:\n#{message}"
      Mailman.logger.error [e, *e.backtrace].join("\n")
    end
  end
end
