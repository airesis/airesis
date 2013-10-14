#encoding: utf-8
class AddBorderToSysLocale < ActiveRecord::Migration
  def up


    I18n.locale = 'it-IT'
    Continente.find_by_description('Europe').update_attribute(:description,'Europa')
    @brasil = Stato.create(description: 'Brasile', continente_id: Continente.find_by_description('America').id, sigla: 'BR')

    I18n.locale = 'en'
    @brasil.update_attribute(:description,'Brazil')

    I18n.locale = 'en-US'
    @brasil.update_attribute(:description,'Brazil')

    I18n.locale = 'fr'
    @brasil.update_attribute(:description,'Brésil')

    I18n.locale = 'pt-PT'
    @brasil.update_attribute(:description,'Brasil')

    I18n.locale = 'pt-BR'
    @brasil.update_attribute(:description,'Brasil')

    I18n.locale = 'de'
    @brasil.update_attribute(:description,'Brazil')

    I18n.locale = 'es-ES'
    @brasil.update_attribute(:description,'Brasil')

    I18n.locale = 'es-EC'
    @brasil.update_attribute(:description,'Brasil')



    I18n.locale = 'it-IT'

    add_column :sys_locales, :territory_type, :string
    add_column :sys_locales, :territory_id, :integer

    SysLocale.reset_column_information

    @sys = SysLocale.where(key: 'it-IT').first
    @sys.territory = Stato.find_by_sigla('IT')
    @sys.save!

    @sys = SysLocale.where(key: 'en').first
    @sys.territory = Continente.find_by_description('Europa')
    @sys.save!

    @sys = SysLocale.where(key: 'en-US').first
    @sys.territory = Continente.find_by_description('America')
    @sys.save!

    @sys = SysLocale.where(key: 'fr').first
    @sys.territory = Stato.find_by_sigla('FR')
    @sys.save!

    @sys = SysLocale.where(key: 'es-ES').first
    @sys.territory = Stato.find_by_sigla('ES')
    @sys.save!

    @sys = SysLocale.where(key: 'pt-PT').first
    @sys.territory = Stato.find_by_sigla('PT')
    @sys.save!

    @sys = SysLocale.where(key: 'de').first
    @sys.territory = Stato.find_by_sigla('DE')
    @sys.save!

    @sys = SysLocale.where(key: 'pt-BR').first
    @sys.territory = @brasil
    @sys.save!

    @sys = SysLocale.where(key: 'es-EC').first
    @sys.territory = Stato.find_by_sigla('EC')
    @sys.save!


  end

  def down

  end
end
