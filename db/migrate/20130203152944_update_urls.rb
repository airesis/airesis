class UpdateUrls < ActiveRecord::Migration
  def up
    Authentication.all.each do |auth|
      case auth.provider
        when Authentication::FACEBOOK
          auth.user.facebook_page_url = "http://www.facebook.com/#{auth.uid}"
          auth.user.save!(validate: false)
        when Authentication::GOOGLE
          auth.user.google_page_url = "http://plus.google.com/#{auth.uid}"
          auth.user.save!(validate: false)
      end
    end
  end

  def down
  end
end
