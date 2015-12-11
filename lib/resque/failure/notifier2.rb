require 'net/smtp'
module Resque
  module Failure
    # Send an email to the developer, so we know something went foul.
    class Notifier2 < Base
      class << self
        attr_accessor :smtp, :sender, :recipients
      end

      def self.configure
        yield self
        Resque::Failure.backend = self unless Resque::Failure.backend == Resque::Failure::Multiple
      end

      def save
        # Create notification email
        msgstr = <<END_OF_MESSAGE
Subject: [Resque] #{exception}

Queue:    #{queue}
Worker:   #{worker}

        #{payload.inspect}

        #{exception}
        #{exception.backtrace.join("\n")}
END_OF_MESSAGE

        Net::SMTP.start(self.class.smtp[:address], self.class.smtp[:port], self.class.smtp[:address], self.class.smtp[:user], self.class.smtp[:secret]) do |smtp|
          smtp.send_message(msgstr, self.class.sender, self.class.recipients)
        end
      rescue
      end
    end
  end
end
