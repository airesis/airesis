module AuthenticationModule
  mattr_accessor :name_regex, :bad_name_message, :url_regex,
    :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :bad_email_message

  self.name_regex        = /\A[a-zA-Z\u00C0-\u00F6\u00F8-\u00FF][a-zA-Z\s\-\u00C0-\u00F6\u00F8-\u00FF' ]*[a-zA-Z\u00C0-\u00F6\u00F8-\u00FF]\z/
  self.url_regex        = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix
  self.bad_name_message  = "Formato del nome non valido.".freeze

  self.email_name_regex  = '[\w\.%\+\-]+'.freeze
  self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|it|name|aero|jobs|museum)'.freeze
  self.email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  self.bad_email_message = "indirizzo email non valido".freeze

  def self.included(recipient)
    recipient.extend(ModelClassMethods)
    recipient.class_eval do
      include ModelInstanceMethods
    end
  end

  module ModelClassMethods
    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

    def make_token
      secure_digest(Time.now, (1..10).map{ rand.to_s })
    end
  end # class methods

  module ModelInstanceMethods
  end # instance methods
end
