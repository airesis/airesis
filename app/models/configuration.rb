class Configuration < ActiveRecord::Base
  def self.phases_active
      @phases_active = !self.find_by_name('phases_active').value.to_i.zero? unless @phases_active
  end
end