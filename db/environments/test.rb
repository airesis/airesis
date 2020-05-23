a1 = Continent.create!(description: "Europe")
a1.translations.where(locale: "en").first_or_create.update(description: "Europe")
a1.translations.where(locale: "it").first_or_create.update(description: "Europa")
s1 = Country.create!(description: "Italy", continent_id: a1.id, sigla: "IT", sigla_ext: "ITA")
s1.translations.where(locale: "it").first_or_create.update(description: "Italia")
s1.translations.where(locale: "en").first_or_create.update(description: "Italy")
r14 = Region.create!(description: "Emilia Romagna", country_id: s1.id, continent_id: a1.id)
p1 = Province.create!(description: "Bologna", region_id:  r14.id, country_id: s1.id, continent_id: a1.id, sigla: "BO")
Municipality.create!(description: "Bologna", province_id: p1.id, region_id:  r14.id, country_id: s1.id,
                     continent_id: a1.id , population: 371217)
Municipality.create!(description: "Marzabotto", province_id: p1.id, region_id:  r14.id, country_id: s1.id,
                     continent_id: a1.id , population: 6262)
Municipality.create!(description: "Medicina", province_id: p1.id, region_id:  r14.id, country_id: s1.id,
                     continent_id: a1.id , population: 13570)

load File.join(Rails.root, 'db', 'seeds', "999_airesis_seed.rb")
