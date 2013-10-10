#encoding: utf-8
class AddNewContinentes < ActiveRecord::Migration
  def up
    I18n.locale = 'it-IT'
    @europa = Continente.first
    @america = Continente.create(:description => 'America')
    @africa = Continente.create(:description => 'Africa')
    @asia = Continente.create(:description => 'Asia')
    @oceania = Continente.create(:description => 'Oceania')

    I18n.locale = 'en'
    @europa.update_attribute(:description,'Europe')
    @america.update_attribute(:description,'America')
    @africa.update_attribute(:description,'Africa')
    @asia.update_attribute(:description,'Asia')
    @oceania.update_attribute(:description,'Oceania')

    I18n.locale = 'en-US'
    @europa.update_attribute(:description,'Europe')
    @america.update_attribute(:description,'America')
    @africa.update_attribute(:description,'Africa')
    @asia.update_attribute(:description,'Asia')
    @oceania.update_attribute(:description,'Oceania')

    I18n.locale = 'es-ES'
    @europa.update_attribute(:description,'Europa')
    @america.update_attribute(:description,'América')
    @africa.update_attribute(:description,'África')
    @asia.update_attribute(:description,'Asia')
    @oceania.update_attribute(:description,'Oceanía')

    I18n.locale = 'es-EC'
    @europa.update_attribute(:description,'Europa')
    @america.update_attribute(:description,'América')
    @africa.update_attribute(:description,'África')
    @asia.update_attribute(:description,'Asia')
    @oceania.update_attribute(:description,'Oceanía')

    I18n.locale = 'fr'
    @europa.update_attribute(:description,'Europe')
    @america.update_attribute(:description,'Amérique')
    @africa.update_attribute(:description,'Afrique')
    @asia.update_attribute(:description,'Asie')
    @oceania.update_attribute(:description,'Océanie')

    I18n.locale = 'pt-PT'
    @europa.update_attribute(:description,'Europa')
    @america.update_attribute(:description,'América')
    @africa.update_attribute(:description,'África')
    @asia.update_attribute(:description,'Ásia')
    @oceania.update_attribute(:description,'Oceania')

    I18n.locale = 'pt-BR'
    @europa.update_attribute(:description,'Europa')
    @america.update_attribute(:description,'América')
    @africa.update_attribute(:description,'África')
    @asia.update_attribute(:description,'Ásia')
    @oceania.update_attribute(:description,'Oceania')


  end

  def down
    Continente.where(:description => 'America').first.destroy
    Continente.where(:description => 'Africa').first.destroy
    Continente.where(:description => 'Asia').first.destroy
    Continente.where(:description => 'Oceania').first.destroy
  end
end
