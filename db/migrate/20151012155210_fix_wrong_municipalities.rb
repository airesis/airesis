class FixWrongMunicipalities < ActiveRecord::Migration
  def change
    Municipality.where('description like ?', 'Arrondissement d’%').each do |municipality|
      municipality.update(description: municipality.description.gsub('Arrondissement d’', ''))
    end

    Municipality.where('description like ?', 'Arrondissement des %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Arrondissement des ', ''))
    end

    Municipality.where('description like ?', 'Arrondissement du %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Arrondissement du ', ''))
    end

    Municipality.where('description like ?', 'Arrondissement de %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Arrondissement de ', ''))
    end

    Municipality.where('description like ?', "Arrondissement d'%").each do |municipality|
      municipality.update(description: municipality.description.gsub("Arrondissement d'", ''))
    end

    Province.where('description like ?', 'Città metropolitana di %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Città metropolitana di ', ''))
    end

    Province.where('description like ?', 'Provincia di %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Provincia di ', ''))
    end

    Municipality.where('description like ?', 'Landkreis %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Landkreis ', ''))
    end

    Municipality.where('description like ?', 'Kreisfreie Stadt %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Kreisfreie Stadt ', ''))
    end

    Province.where('description like ?', 'Cantón %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Cantón ', ''))
    end

    Region.where('description like ?', 'Provincia del %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Provincia del ', ''))
    end

    Region.where('description like ?', 'Provincia de %').each do |municipality|
      municipality.update(description: municipality.description.gsub('Provincia de ', ''))
    end

  end
end
