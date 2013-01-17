#Maktoub.from = "Airesis Newsletter <noreply@airesis.it>" # the email the newsletter is sent from
Maktoub.from = "Coorasse <coorasse@gmail.com>" # the email the newsletter is sent from
Maktoub.twitter_url = "http://twitter.com/#!/democracyo" # your twitter page
Maktoub.facebook_url = "http://www.facebook.com/facebook" # your facebook oage
Maktoub.google_plus_url = "https://plus.google.com/b/108270340723482080584/108270340723482080584" # your facebook oage
Maktoub.subscription_preferences_url = "http://www.airesis.it/users/alarm_preferences" #subscribers management url
Maktoub.logo = "logo120.png" # path to your logo asset
Maktoub.home_domain = "www.airesis.it" # your domain
 Maktoub.app_name = "Airesis - Scegli di partecipare" # your app name
#Maktoub.unsubscribe_method = "unsubscribe" # method to call from unsubscribe link (doesn't include link by default)

# pass a block to subscribers_extractor that returns an object that  reponds to :name and :email
# (fields can be configured as shown below)

# require "ostruct"
 Maktoub.subscribers_extractor do
   (1..5).map do |i|
     users << OpenStruct.new({name: "tester#{i}", email: "test#{i}@example.com"})
  end
 end

# uncomment lines below to change subscriber fields that contain email and
# Maktoub.email_field = :address
# Maktoub.name_field = :nickname
