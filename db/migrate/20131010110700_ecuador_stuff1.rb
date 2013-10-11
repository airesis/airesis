#encoding: utf-8
class EcuadorStuff1 < ActiveRecord::Migration
  def up
    SysLocale.create(:key => 'es-EC', :host => 'http://www.airesis.us', lang: 'es-EC')

    I18n.locale = 'it-IT'

    @america = Continente.find_by_description('America')
    @ecuador = Stato.create(:description => 'Ecuador', :continente_id => @america.id, sigla: 'EC' )

    I18n.locale = 'en'
    @ecuador.update_attribute(:description,'Ecuador')

    I18n.locale = 'en-US'
    @ecuador.update_attribute(:description,'Ecuador')

    I18n.locale = 'es-ES'
    @ecuador.update_attribute(:description,'Ecuador')

    I18n.locale = 'es-EC'
    @ecuador.update_attribute(:description,'Ecuador')

    I18n.locale = 'pt-PT'
    @ecuador.update_attribute(:description,'Equador')

    I18n.locale = 'pt-BR'
    @ecuador.update_attribute(:description,'Equador')

    I18n.locale = 'fr'
    @ecuador.update_attribute(:description,'Équateur')

  end

  def down
    Stato.find_by_description('Ecuador').destroy
    SysLocale.where(:key => 'es-EC').first.destroy
  end
end
