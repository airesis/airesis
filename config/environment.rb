FACEBOOK_APP_ID=""
GOOGLE_APP_ID=""
TWITTER_APP_ID=""
MEETUP_APP_ID=""
LINKEDIN_APP_ID=""
MAPS_API_KEY=""

FACEBOOK_APP_SECRET=""
GOOGLE_APP_SECRET=""
TWITTER_APP_SECRET=""
MEETUP_APP_SECRET=""
LINKEDIN_APP_SECRET=""

EMAIL_ADDRESS=""
EMAIL_USERNAME=""
EMAIL_PASSWORD=""

RECAPTCHA_PUBLIC=""
RECAPTCHA_PRIVATE=""

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DemocracyOnline3::Application.initialize!

require 'will_paginate'

#OmniAuth.config.test_mode = true

