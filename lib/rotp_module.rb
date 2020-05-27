module RotpModule
  # return true if the provided token is correct
  def check_token(user, token)
    security_code = token.to_s
    totp = ROTP::TOTP.new(user.rotp_secret)
    totp.verify(security_code, Time.zone.now + ROTP_DRIFT)
  end
end
