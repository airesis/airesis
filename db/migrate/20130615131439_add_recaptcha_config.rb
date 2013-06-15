class AddRecaptchaConfig < ActiveRecord::Migration
  def up
    Configuration.create(name: 'recaptcha', value: 1)
  end

  def down
    Configuration.find_by_name('recaptcha').destroy
  end
end
