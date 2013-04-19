#encoding: utf-8
class TranslateCategories < ActiveRecord::Migration
  def up
    ProposalCategory.create_translation_table!({
       :description => :string
   }, {
       :migrate_data => true
   })

    I18n.locale = :eu

    ProposalCategory.find(5).update_attribute(:description,"Uncategorized")
    ProposalCategory.find(7).update_attribute(:description,"Education, Research")
    ProposalCategory.find(8).update_attribute(:description,"Health, Hygiene")
    ProposalCategory.find(9).update_attribute(:description,"Information, Communication")
    ProposalCategory.find(10).update_attribute(:description,"Commerce, Finance, Taxes")
    ProposalCategory.find(11).update_attribute(:description,"Work and Self-realization")
    ProposalCategory.find(12).update_attribute(:description,"Security and Justice")
    ProposalCategory.find(13).update_attribute(:description,"World, Migration")
    ProposalCategory.find(14).update_attribute(:description,"Minorities, Handicap")
    ProposalCategory.find(15).update_attribute(:description,"Ethics, Solidarity, Spirituality")
    ProposalCategory.find(16).update_attribute(:description,"Sexuality, Family, Children")
    ProposalCategory.find(17).update_attribute(:description,"Art and Culture")
    ProposalCategory.find(18).update_attribute(:description,"Social, Sport, Entertainment")
    ProposalCategory.find(19).update_attribute(:description,"Internal organization")
    ProposalCategory.find(20).update_attribute(:description,"Water, Food, Agriculture")
    ProposalCategory.find(21).update_attribute(:description,"Territory, Nature, Animals")
    ProposalCategory.find(22).update_attribute(:description,"Urbanism, Mobility, Construction")
    ProposalCategory.find(23).update_attribute(:description,"Energy, Climate")
    ProposalCategory.find(24).update_attribute(:description,"Industry, Materials and Waste")
    ProposalCategory.find(25).update_attribute(:description,"Democracy, Institutions")

    I18n.locale = :en

    ProposalCategory.find(5).update_attribute(:description,"Uncategorized")
    ProposalCategory.find(7).update_attribute(:description,"Education, Research")
    ProposalCategory.find(8).update_attribute(:description,"Health, Hygiene")
    ProposalCategory.find(9).update_attribute(:description,"Information, Communication")
    ProposalCategory.find(10).update_attribute(:description,"Commerce, Finance, Taxes")
    ProposalCategory.find(11).update_attribute(:description,"Work and Self-realization")
    ProposalCategory.find(12).update_attribute(:description,"Security and Justice")
    ProposalCategory.find(13).update_attribute(:description,"World, Migration")
    ProposalCategory.find(14).update_attribute(:description,"Minorities, Handicap")
    ProposalCategory.find(15).update_attribute(:description,"Ethics, Solidarity, Spirituality")
    ProposalCategory.find(16).update_attribute(:description,"Sexuality, Family, Children")
    ProposalCategory.find(17).update_attribute(:description,"Art and Culture")
    ProposalCategory.find(18).update_attribute(:description,"Social, Sport, Entertainment")
    ProposalCategory.find(19).update_attribute(:description,"Internal organization")
    ProposalCategory.find(20).update_attribute(:description,"Water, Food, Agriculture")
    ProposalCategory.find(21).update_attribute(:description,"Territory, Nature, Animals")
    ProposalCategory.find(22).update_attribute(:description,"Urbanism, Mobility, Construction")
    ProposalCategory.find(23).update_attribute(:description,"Energy, Climate")
    ProposalCategory.find(24).update_attribute(:description,"Industry, Materials and Waste")
    ProposalCategory.find(25).update_attribute(:description,"Democracy, Institutions")

    I18n.locale = :pt

    ProposalCategory.find(5).update_attribute(:description,"Sem categoria")
    ProposalCategory.find(7).update_attribute(:description,"Educação, Pesquisa")
    ProposalCategory.find(8).update_attribute(:description,"Saúde, Higiene")
    ProposalCategory.find(9).update_attribute(:description,"Informação, Comunicação")
    ProposalCategory.find(10).update_attribute(:description,"Comércio, Finanças, Tributos")
    ProposalCategory.find(11).update_attribute(:description,"Trabalho e Auto-realização")
    ProposalCategory.find(12).update_attribute(:description,"Segurança e Justiça")
    ProposalCategory.find(13).update_attribute(:description,"Mundial, Migração")
    ProposalCategory.find(14).update_attribute(:description,"Minorias. Deficientes Físicos,")
    ProposalCategory.find(15).update_attribute(:description,"Ética, Solidariedade, Espiritualidade")
    ProposalCategory.find(16).update_attribute(:description,"Sexualidade, Família, Infância")
    ProposalCategory.find(17).update_attribute(:description,"Arte e Cultura")
    ProposalCategory.find(18).update_attribute(:description,"Social, Desporto, Entretenimento")
    ProposalCategory.find(19).update_attribute(:description,"Organização interna")
    ProposalCategory.find(20).update_attribute(:description," Àgua, Alimentos, Agricultura")
    ProposalCategory.find(21).update_attribute(:description,"Território, Natureza, Animais")
    ProposalCategory.find(22).update_attribute(:description,"Urbanismo, Mobilidade, Construção")
    ProposalCategory.find(23).update_attribute(:description,"Energia, Clima")
    ProposalCategory.find(24).update_attribute(:description,"Indústria, Materiais e Resíduos")
    ProposalCategory.find(25).update_attribute(:description,"Democracia, Instituições")

    I18n.locale = :fr

    ProposalCategory.find(5).update_attribute(:description,"Aucune catégorie")
    ProposalCategory.find(7).update_attribute(:description,"Education, Recherche")
    ProposalCategory.find(8).update_attribute(:description,"Santé, Hygiène")
    ProposalCategory.find(9).update_attribute(:description,"Information, Communication")
    ProposalCategory.find(10).update_attribute(:description,"Commerce, Finance, Fisc")
    ProposalCategory.find(11).update_attribute(:description,"Travail et Auto-réalisation")
    ProposalCategory.find(12).update_attribute(:description,"Sécurité et Justice")
    ProposalCategory.find(13).update_attribute(:description,"Monde, Migration")
    ProposalCategory.find(14).update_attribute(:description,"Minorités, Handicap")
    ProposalCategory.find(15).update_attribute(:description,"Etique, Solidarité,Spiritualité")
    ProposalCategory.find(16).update_attribute(:description,"Sexualité, Famille, Enfants")
    ProposalCategory.find(17).update_attribute(:description,"Art et Culture")
    ProposalCategory.find(18).update_attribute(:description,"Vie sociale, Sport, Loisirs")
    ProposalCategory.find(19).update_attribute(:description,"Organisation interne")
    ProposalCategory.find(20).update_attribute(:description,"Eau, Nourriture, Agriculture")
    ProposalCategory.find(21).update_attribute(:description,"Territoire, Nature, Animaux")
    ProposalCategory.find(22).update_attribute(:description,"Urbanisme, Mobilité, Batiment")
    ProposalCategory.find(23).update_attribute(:description,"Energie, Climat")
    ProposalCategory.find(24).update_attribute(:description,"Industrie, Matériaux et Déchets")
    ProposalCategory.find(25).update_attribute(:description,"Démocratie, Institutions")

    I18n.locale = :de

    ProposalCategory.find(5).update_attribute(:description,"Keine Kategorie")
    ProposalCategory.find(7).update_attribute(:description,"Bildung, Forschung")
    ProposalCategory.find(8).update_attribute(:description,"Gesundheit, Hygiene")
    ProposalCategory.find(9).update_attribute(:description,"Information, Kommunikation")
    ProposalCategory.find(10).update_attribute(:description,"Commerce, Finanzen, Steuern")
    ProposalCategory.find(11).update_attribute(:description,"Arbeit und Selbstverwirklichung")
    ProposalCategory.find(12).update_attribute(:description,"Sicherheit und Justiz")
    ProposalCategory.find(13).update_attribute(:description,"Welt, Migration")
    ProposalCategory.find(14).update_attribute(:description,"Minderheiten, Handicap")
    ProposalCategory.find(15).update_attribute(:description,"Ethik, Solidarität, Spiritualität")
    ProposalCategory.find(16).update_attribute(:description,"Sexualität, Familie, Kinder")
    ProposalCategory.find(17).update_attribute(:description,"Kunst und Kultur")
    ProposalCategory.find(18).update_attribute(:description,"Social, Sport, Unterhaltung")
    ProposalCategory.find(19).update_attribute(:description,"Interne Organisation")
    ProposalCategory.find(20).update_attribute(:description,"Wasser, Ernährung, Landwirtschaft")
    ProposalCategory.find(21).update_attribute(:description,"Territory, Natur, Tiere")
    ProposalCategory.find(22).update_attribute(:description,"Städtebau, Mobilität, Bau")
    ProposalCategory.find(23).update_attribute(:description,"Energie, Klima")
    ProposalCategory.find(24).update_attribute(:description,"Industrie-und Abfallwirtschaft")
    ProposalCategory.find(25).update_attribute(:description,"Demokratie, Institutionen")

    I18n.locale = :es

    ProposalCategory.find(5).update_attribute(:description,"Ninguna Categoría")
    ProposalCategory.find(7).update_attribute(:description,"Educación, Investigación")
    ProposalCategory.find(8).update_attribute(:description,"Salud, Higiene")
    ProposalCategory.find(9).update_attribute(:description,"Información, Comunicación")
    ProposalCategory.find(10).update_attribute(:description,"Comercio, Finanzas, Impuestos")
    ProposalCategory.find(11).update_attribute(:description,"Trabajo y Realización Personal")
    ProposalCategory.find(12).update_attribute(:description,"Seguridad y Justicia")
    ProposalCategory.find(13).update_attribute(:description,"Mundo, Migraciones")
    ProposalCategory.find(14).update_attribute(:description,"Minorías, Handicap")
    ProposalCategory.find(15).update_attribute(:description,"Ètica, Solidaridad, Espiritualidad")
    ProposalCategory.find(16).update_attribute(:description,"Sexualidad, Familia, Niños")
    ProposalCategory.find(17).update_attribute(:description,"Arte y Cultura")
    ProposalCategory.find(18).update_attribute(:description,"Social, Deporte, Entretenimiento")
    ProposalCategory.find(19).update_attribute(:description,"Organización interna")
    ProposalCategory.find(20).update_attribute(:description,"Agua, Alimentos, Agricultura")
    ProposalCategory.find(21).update_attribute(:description,"Territorio, Naturaleza, Animales")
    ProposalCategory.find(22).update_attribute(:description,"Urbanismo, Movilidad, Obras")
    ProposalCategory.find(23).update_attribute(:description,"Energía, Clima")
    ProposalCategory.find(24).update_attribute(:description,"Industria, Materiales y Residuos")
    ProposalCategory.find(25).update_attribute(:description,"Democracia, Instituciones")

  end

  def down
    ProposalCategory.drop_translation_table! :migrate_data => true
  end
end
