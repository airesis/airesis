class FixCroatiaCountry < ActiveRecord::Migration
  def change
    SysLocale.where(key: 'sh-HR').each do |sl|
      sl.update(territory: Country.find_by(description: 'Croatia'))
    end
  end
end
