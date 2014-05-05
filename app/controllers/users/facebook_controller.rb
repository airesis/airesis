#encoding: utf-8
class Users::FacebookController < ApplicationController
  def setup
    request.env['omniauth.strategy'].options[:scope] = 'email'
    request.env['omniauth.strategy'].options[:client_options] = {ssl: {verify: false, ca_path: '/etc/ssl/certs'}}

    render text: "Setup complete.", status: 404

  end

end
