class Akismetor
  attr_accessor :attributes

  require 'net/http'

  # Does a key-check on Akismet so you know you can actually use a specific key.
  # Returns "valid" or "invalid" depending on response.
  def self.valid_key?(attributes)
    new(attributes).execute('verify-key')
  end

  # Does a comment-check on Akismet with the submitted hash.
  # Returns true or false depending on response.
  def self.spam?(attributes)
    new(attributes).execute('comment-check') != 'false'
  end

  # Does a submit-spam on Akismet with the submitted hash.
  # Use this when Akismet incorrectly approves a spam comment.
  def self.submit_spam(attributes)
    new(attributes).execute('submit-spam')
  end

  # Does a submit-ham on Akismet with the submitted hash.
  # Use this for a false positive, when Akismet incorrectly rejects a normal comment.
  def self.submit_ham(attributes)
    new(attributes).execute('submit-ham')
  end

  def initialize(attributes)
    @attributes = attributes
  end

  def execute(command)
    host = "#{@attributes[:key]}." if attributes[:key] && command != 'verify-key'
    http = Net::HTTP.new("#{host}rest.akismet.com", 80)
    http.post("/1.1/#{command}", attributes_for_post, http_headers).body
  end

  private

  def http_headers
    {
      'User-Agent' => 'Akismetor Rails Plugin/1.1',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
  end

  def attributes_for_post
    result = attributes.map { |k, v| "#{k}=#{v}" }.join('&')
    URI.escape(result)
  end
end
