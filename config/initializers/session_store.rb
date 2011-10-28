# Be sure to restart your server when you modify this file.

DemocracyOnline3::Application.config.session_store :cookie_store, :key => '_DemocracyOnline3_session'

ActionController::Base.session = {
  :key         => '_Postgres_session',
  :secret      => '35ceaab83b8af2e1cd52067d6511b151b04a31374640f7c1e8a9f81c9eebe7082faab9a15583ab2af67f9ddc62e39e19e9df88db1a68917daf3f5c533de7454b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# DemocracyOnline3::Application.config.session_store :active_record_store
