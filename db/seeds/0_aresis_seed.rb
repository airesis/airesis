#encoding: utf-8
a = Continente.create(:description => "Europa")
 s5 = Stato.create( :description => "Albania", :continente_id => a.id, sigla: "AX", sigla_ext: "ALA")
  s5.translations.where(locale: "eu").first_or_create.update_attributes(description: "Åland Islands")
  s5.translations.where(locale: "it").first_or_create.update_attributes(description: "Albania")
  s5.translations.where(locale: "en").first_or_create.update_attributes(description: "Åland Islands")
  s5.translations.where(locale: "pt").first_or_create.update_attributes(description: "Ilhas Aland")
  s5.translations.where(locale: "de").first_or_create.update_attributes(description: "Åland-Inseln")
  s5.translations.where(locale: "es").first_or_create.update_attributes(description: "Islas Åland")
 s6 = Stato.create( :description => "Andorra", :continente_id => a.id, sigla: "AL", sigla_ext: "ALB")
  s6.translations.where(locale: "eu").first_or_create.update_attributes(description: "Albania")
  s6.translations.where(locale: "it").first_or_create.update_attributes(description: "Andorra")
  s6.translations.where(locale: "en").first_or_create.update_attributes(description: "Albania")
  s6.translations.where(locale: "pt").first_or_create.update_attributes(description: "Albânia")
  s6.translations.where(locale: "de").first_or_create.update_attributes(description: " Albanien")
  s6.translations.where(locale: "es").first_or_create.update_attributes(description: "Albania")
 s7 = Stato.create( :description => "Austria", :continente_id => a.id, sigla: "AD", sigla_ext: "AND")
  s7.translations.where(locale: "eu").first_or_create.update_attributes(description: "Andorra")
  s7.translations.where(locale: "it").first_or_create.update_attributes(description: "Austria")
  s7.translations.where(locale: "en").first_or_create.update_attributes(description: "Andorra")
  s7.translations.where(locale: "pt").first_or_create.update_attributes(description: "Andorra")
  s7.translations.where(locale: "de").first_or_create.update_attributes(description: "Andorra")
  s7.translations.where(locale: "es").first_or_create.update_attributes(description: "Andora")
 s8 = Stato.create( :description => "Bielorussia", :continente_id => a.id, sigla: "AT", sigla_ext: "AUT")
  s8.translations.where(locale: "eu").first_or_create.update_attributes(description: "Austria")
  s8.translations.where(locale: "it").first_or_create.update_attributes(description: "Bielorussia")
  s8.translations.where(locale: "en").first_or_create.update_attributes(description: "Austria")
  s8.translations.where(locale: "pt").first_or_create.update_attributes(description: "Áustria")
  s8.translations.where(locale: "de").first_or_create.update_attributes(description: "Österreich")
  s8.translations.where(locale: "es").first_or_create.update_attributes(description: "Austria")
 s9 = Stato.create( :description => "Belgio", :continente_id => a.id, sigla: "BY", sigla_ext: "BLR")
  s9.translations.where(locale: "eu").first_or_create.update_attributes(description: "Belarus")
  s9.translations.where(locale: "it").first_or_create.update_attributes(description: "Belgio")
  s9.translations.where(locale: "en").first_or_create.update_attributes(description: "Belarus")
  s9.translations.where(locale: "pt").first_or_create.update_attributes(description: "Belarússia")
  s9.translations.where(locale: "de").first_or_create.update_attributes(description: "Weissrußland")
  s9.translations.where(locale: "es").first_or_create.update_attributes(description: "Bielorusia")
 s10 = Stato.create( :description => "Bosnia ed Erzegovina", :continente_id => a.id, sigla: "BE", sigla_ext: "BEL")
  s10.translations.where(locale: "eu").first_or_create.update_attributes(description: "Belgium")
  s10.translations.where(locale: "it").first_or_create.update_attributes(description: "Bosnia ed Erzegovina")
  s10.translations.where(locale: "en").first_or_create.update_attributes(description: "Belgium")
  s10.translations.where(locale: "pt").first_or_create.update_attributes(description: "Bélgica")
  s10.translations.where(locale: "de").first_or_create.update_attributes(description: "Belgien")
  s10.translations.where(locale: "es").first_or_create.update_attributes(description: "Bélgica")
 s11 = Stato.create( :description => "Bulgaria", :continente_id => a.id, sigla: "BA", sigla_ext: "BIH")
  s11.translations.where(locale: "eu").first_or_create.update_attributes(description: "Bosnia and Herzegovina")
  s11.translations.where(locale: "it").first_or_create.update_attributes(description: "Bulgaria")
  s11.translations.where(locale: "en").first_or_create.update_attributes(description: "Bosnia and Herzegovina")
  s11.translations.where(locale: "pt").first_or_create.update_attributes(description: "Bósnia Herzegovina")
  s11.translations.where(locale: "de").first_or_create.update_attributes(description: "Bosnien und Herzogowina")
  s11.translations.where(locale: "es").first_or_create.update_attributes(description: "Bósnia Herzegovina")
 s12 = Stato.create( :description => "Croazia", :continente_id => a.id, sigla: "BG", sigla_ext: "BGR")
  s12.translations.where(locale: "eu").first_or_create.update_attributes(description: "Bulgaria")
  s12.translations.where(locale: "it").first_or_create.update_attributes(description: "Croazia")
  s12.translations.where(locale: "en").first_or_create.update_attributes(description: "Bulgaria")
  s12.translations.where(locale: "de").first_or_create.update_attributes(description: "Bulgarien")
  s12.translations.where(locale: "pt").first_or_create.update_attributes(description: "Bulgária")
  s12.translations.where(locale: "es").first_or_create.update_attributes(description: "Bulgária")
 s13 = Stato.create( :description => "Repubblica Ceca", :continente_id => a.id, sigla: "HR", sigla_ext: "HRV")
  s13.translations.where(locale: "eu").first_or_create.update_attributes(description: "Croatia")
  s13.translations.where(locale: "it").first_or_create.update_attributes(description: "Repubblica Ceca")
  s13.translations.where(locale: "en").first_or_create.update_attributes(description: "Croatia")
  s13.translations.where(locale: "de").first_or_create.update_attributes(description: "Kroatien")
  s13.translations.where(locale: "pt").first_or_create.update_attributes(description: "Croácia")
  s13.translations.where(locale: "es").first_or_create.update_attributes(description: "Croácia")
 s14 = Stato.create( :description => "Danimarca", :continente_id => a.id, sigla: "CZ", sigla_ext: "CZE")
  s14.translations.where(locale: "eu").first_or_create.update_attributes(description: "Czech Republic")
  s14.translations.where(locale: "it").first_or_create.update_attributes(description: "Danimarca")
  s14.translations.where(locale: "en").first_or_create.update_attributes(description: "Czech Republic")
  s14.translations.where(locale: "de").first_or_create.update_attributes(description: "Tschechische Republik")
  s14.translations.where(locale: "pt").first_or_create.update_attributes(description: "República Checa")
  s14.translations.where(locale: "es").first_or_create.update_attributes(description: "República Checa")
 s15 = Stato.create( :description => "Estonia", :continente_id => a.id, sigla: "DK", sigla_ext: "DNK")
  s15.translations.where(locale: "eu").first_or_create.update_attributes(description: "Denmark")
  s15.translations.where(locale: "it").first_or_create.update_attributes(description: "Estonia")
  s15.translations.where(locale: "en").first_or_create.update_attributes(description: "Denmark")
  s15.translations.where(locale: "de").first_or_create.update_attributes(description: "Dänemark")
  s15.translations.where(locale: "pt").first_or_create.update_attributes(description: "Dinamarca")
  s15.translations.where(locale: "es").first_or_create.update_attributes(description: "Dinamarca")
 s16 = Stato.create( :description => "Isole Fær Øer", :continente_id => a.id, sigla: "EE", sigla_ext: "EST")
  s16.translations.where(locale: "eu").first_or_create.update_attributes(description: "Estonia")
  s16.translations.where(locale: "it").first_or_create.update_attributes(description: "Isole Fær Øer")
  s16.translations.where(locale: "en").first_or_create.update_attributes(description: "Estonia")
  s16.translations.where(locale: "de").first_or_create.update_attributes(description: "Estland")
  s16.translations.where(locale: "pt").first_or_create.update_attributes(description: "Estónia")
  s16.translations.where(locale: "es").first_or_create.update_attributes(description: "Estónia")
 s17 = Stato.create( :description => "Finlandia", :continente_id => a.id, sigla: "FO", sigla_ext: "FRO")
  s17.translations.where(locale: "eu").first_or_create.update_attributes(description: "Faroe Islands")
  s17.translations.where(locale: "it").first_or_create.update_attributes(description: "Finlandia")
  s17.translations.where(locale: "en").first_or_create.update_attributes(description: "Faroe Islands")
  s17.translations.where(locale: "de").first_or_create.update_attributes(description: "Faroe Inseln")
  s17.translations.where(locale: "pt").first_or_create.update_attributes(description: "Ilhas Faroe")
  s17.translations.where(locale: "es").first_or_create.update_attributes(description: "Islas Faroe")
 s18 = Stato.create( :description => "Francia", :continente_id => a.id, sigla: "FI", sigla_ext: "FIN")
  s18.translations.where(locale: "eu").first_or_create.update_attributes(description: "Finland")
  s18.translations.where(locale: "it").first_or_create.update_attributes(description: "Francia")
  s18.translations.where(locale: "en").first_or_create.update_attributes(description: "Finland")
  s18.translations.where(locale: "de").first_or_create.update_attributes(description: "Finnland")
  s18.translations.where(locale: "pt").first_or_create.update_attributes(description: "Finlândia")
  s18.translations.where(locale: "es").first_or_create.update_attributes(description: "Finlândia")
 s19 = Stato.create( :description => "Germania", :continente_id => a.id, sigla: "FR", sigla_ext: "FRA")
  s19.translations.where(locale: "eu").first_or_create.update_attributes(description: "France")
  s19.translations.where(locale: "it").first_or_create.update_attributes(description: "Germania")
  s19.translations.where(locale: "en").first_or_create.update_attributes(description: "France")
  s19.translations.where(locale: "de").first_or_create.update_attributes(description: "Frankreich")
  s19.translations.where(locale: "pt").first_or_create.update_attributes(description: "França")
  s19.translations.where(locale: "es").first_or_create.update_attributes(description: "Francia")
 s20 = Stato.create( :description => "Gibilterra", :continente_id => a.id, sigla: "DE", sigla_ext: "DEU")
  s20.translations.where(locale: "eu").first_or_create.update_attributes(description: "Germany")
  s20.translations.where(locale: "it").first_or_create.update_attributes(description: "Gibilterra")
  s20.translations.where(locale: "en").first_or_create.update_attributes(description: "Germany")
  s20.translations.where(locale: "de").first_or_create.update_attributes(description: "Deutschland")
  s20.translations.where(locale: "pt").first_or_create.update_attributes(description: "Alemanha")
  s20.translations.where(locale: "es").first_or_create.update_attributes(description: "Alemania")
 s21 = Stato.create( :description => "Grecia", :continente_id => a.id, sigla: "GI", sigla_ext: "GIB")
  s21.translations.where(locale: "eu").first_or_create.update_attributes(description: "Gibraltar")
  s21.translations.where(locale: "it").first_or_create.update_attributes(description: "Grecia")
  s21.translations.where(locale: "en").first_or_create.update_attributes(description: "Gibraltar")
  s21.translations.where(locale: "de").first_or_create.update_attributes(description: "Gibraltar")
  s21.translations.where(locale: "pt").first_or_create.update_attributes(description: "Gibraltar")
  s21.translations.where(locale: "es").first_or_create.update_attributes(description: "Gibraltar")
 s22 = Stato.create( :description => "Guernsey", :continente_id => a.id, sigla: "GR", sigla_ext: "GRC")
  s22.translations.where(locale: "eu").first_or_create.update_attributes(description: "Greece")
  s22.translations.where(locale: "it").first_or_create.update_attributes(description: "Guernsey")
  s22.translations.where(locale: "en").first_or_create.update_attributes(description: "Greece")
  s22.translations.where(locale: "de").first_or_create.update_attributes(description: "Griechenland")
  s22.translations.where(locale: "pt").first_or_create.update_attributes(description: "Grécia")
  s22.translations.where(locale: "es").first_or_create.update_attributes(description: "Grécia")
 s23 = Stato.create( :description => "Ungheria", :continente_id => a.id, sigla: "GG", sigla_ext: "GGY")
  s23.translations.where(locale: "eu").first_or_create.update_attributes(description: "Guernsey")
  s23.translations.where(locale: "it").first_or_create.update_attributes(description: "Ungheria")
  s23.translations.where(locale: "en").first_or_create.update_attributes(description: "Guernsey")
  s23.translations.where(locale: "de").first_or_create.update_attributes(description: "Guernsey")
  s23.translations.where(locale: "pt").first_or_create.update_attributes(description: "Guernsey")
  s23.translations.where(locale: "es").first_or_create.update_attributes(description: "Guernsey")
 s24 = Stato.create( :description => "Islanda", :continente_id => a.id, sigla: "HU", sigla_ext: "HUN")
  s24.translations.where(locale: "eu").first_or_create.update_attributes(description: "Hungary")
  s24.translations.where(locale: "it").first_or_create.update_attributes(description: "Islanda")
  s24.translations.where(locale: "en").first_or_create.update_attributes(description: "Hungary")
  s24.translations.where(locale: "de").first_or_create.update_attributes(description: "Ungarn")
  s24.translations.where(locale: "pt").first_or_create.update_attributes(description: "Hungria")
  s24.translations.where(locale: "es").first_or_create.update_attributes(description: "Hungria")
 s25 = Stato.create( :description => "Irlanda", :continente_id => a.id, sigla: "IS", sigla_ext: "ISL")
  s25.translations.where(locale: "eu").first_or_create.update_attributes(description: "Iceland")
  s25.translations.where(locale: "it").first_or_create.update_attributes(description: "Irlanda")
  s25.translations.where(locale: "en").first_or_create.update_attributes(description: "Iceland")
  s25.translations.where(locale: "de").first_or_create.update_attributes(description: "Island")
  s25.translations.where(locale: "pt").first_or_create.update_attributes(description: "Islândia")
  s25.translations.where(locale: "es").first_or_create.update_attributes(description: "Islândia")
 s26 = Stato.create( :description => "Isola di Man", :continente_id => a.id, sigla: "IE", sigla_ext: "IRL")
  s26.translations.where(locale: "eu").first_or_create.update_attributes(description: "Ireland")
  s26.translations.where(locale: "it").first_or_create.update_attributes(description: "Isola di Man")
  s26.translations.where(locale: "en").first_or_create.update_attributes(description: "Ireland")
  s26.translations.where(locale: "de").first_or_create.update_attributes(description: "Irland")
  s26.translations.where(locale: "pt").first_or_create.update_attributes(description: "Irlanda")
  s26.translations.where(locale: "es").first_or_create.update_attributes(description: "Irlanda")
 s27 = Stato.create( :description => "Jersey", :continente_id => a.id, sigla: "IM", sigla_ext: "IMN")
  s27.translations.where(locale: "eu").first_or_create.update_attributes(description: "Isle of Man")
  s27.translations.where(locale: "it").first_or_create.update_attributes(description: "Jersey")
  s27.translations.where(locale: "en").first_or_create.update_attributes(description: "Isle of Man")
  s27.translations.where(locale: "de").first_or_create.update_attributes(description: "Isle of Man")
  s27.translations.where(locale: "pt").first_or_create.update_attributes(description: "Ilha de Man")
  s27.translations.where(locale: "es").first_or_create.update_attributes(description: "Isla de Man")
 s1 = Stato.create( :description => "Italia", :continente_id => a.id, sigla: "IT", sigla_ext: "ITA")
  s1.translations.where(locale: "it").first_or_create.update_attributes(description: "Italia")
  s1.translations.where(locale: "eu").first_or_create.update_attributes(description: "Italy")
  s1.translations.where(locale: "en").first_or_create.update_attributes(description: "Italy")
  s1.translations.where(locale: "de").first_or_create.update_attributes(description: "Italien")
  s1.translations.where(locale: "pt").first_or_create.update_attributes(description: "Itália")
  s1.translations.where(locale: "es").first_or_create.update_attributes(description: "Italia")
  r1 = Regione.create(:description => "Marche", :stato_id => s1.id)
   Provincia.create(:description => "Ancona", :regione_id => r1.id, :sigla => "AN"){ |c| c.id = 1}.save
   Provincia.create(:description => "Macerata", :regione_id => r1.id, :sigla => "MC"){ |c| c.id = 2}.save
   Provincia.create(:description => "Pesaro Urbino", :regione_id => r1.id, :sigla => "PU"){ |c| c.id = 3}.save
   Provincia.create(:description => "Ascoli Piceno", :regione_id => r1.id, :sigla => "AP"){ |c| c.id = 4}.save
  r2 = Regione.create(:description => "Abruzzo", :stato_id => s1.id)
   Provincia.create(:description => "Chieti", :regione_id => r2.id, :sigla => "CH"){ |c| c.id = 44}.save
   Provincia.create(:description => "L'Aquila", :regione_id => r2.id, :sigla => "AQ"){ |c| c.id = 45}.save
   Provincia.create(:description => "Pescara", :regione_id => r2.id, :sigla => "PE"){ |c| c.id = 46}.save
   Provincia.create(:description => "Teramo", :regione_id => r2.id, :sigla => "TE"){ |c| c.id = 47}.save
  r3 = Regione.create(:description => "Basilicata", :stato_id => s1.id)
   Provincia.create(:description => "Matera", :regione_id => r3.id, :sigla => "MT"){ |c| c.id = 27}.save
   Provincia.create(:description => "Potenza", :regione_id => r3.id, :sigla => "PZ"){ |c| c.id = 28}.save
  r4 = Regione.create(:description => "Molise", :stato_id => s1.id)
   Provincia.create(:description => "Isernia", :regione_id => r4.id, :sigla => "IS"){ |c| c.id = 86}.save
   Provincia.create(:description => "Campobasso", :regione_id => r4.id, :sigla => "CB"){ |c| c.id = 87}.save
  r5 = Regione.create(:description => "Trentino Alto Adige", :stato_id => s1.id)
   Provincia.create(:description => "Trento", :regione_id => r5.id, :sigla => "TN"){ |c| c.id = 101}.save
   Provincia.create(:description => "Bolzano", :regione_id => r5.id, :sigla => "BZ"){ |c| c.id = 102}.save
  r6 = Regione.create(:description => "Puglia", :stato_id => s1.id)
   Provincia.create(:description => "Bari", :regione_id => r6.id, :sigla => "BA"){ |c| c.id = 29}.save
   Provincia.create(:description => "Brindisi", :regione_id => r6.id, :sigla => "BR"){ |c| c.id = 30}.save
   Provincia.create(:description => "Foggia", :regione_id => r6.id, :sigla => "FG"){ |c| c.id = 31}.save
   Provincia.create(:description => "Lecce", :regione_id => r6.id, :sigla => "LE"){ |c| c.id = 32}.save
   Provincia.create(:description => "Taranto", :regione_id => r6.id, :sigla => "TA"){ |c| c.id = 33}.save
  r7 = Regione.create(:description => "Calabria", :stato_id => s1.id)
   Provincia.create(:description => "Catanzaro", :regione_id => r7.id, :sigla => "CZ"){ |c| c.id = 21}.save
   Provincia.create(:description => "Cosenza", :regione_id => r7.id, :sigla => "CS"){ |c| c.id = 22}.save
   Provincia.create(:description => "Crotone", :regione_id => r7.id, :sigla => "KR"){ |c| c.id = 23}.save
   Provincia.create(:description => "Reggio Calabria", :regione_id => r7.id, :sigla => "RC"){ |c| c.id = 24}.save
   Provincia.create(:description => "Vibo Valentia", :regione_id => r7.id, :sigla => "VV"){ |c| c.id = 25}.save
  r8 = Regione.create(:description => "Campania", :stato_id => s1.id)
   Provincia.create(:description => "Avellino", :regione_id => r8.id, :sigla => "AV"){ |c| c.id = 34}.save
   Provincia.create(:description => "Benevento", :regione_id => r8.id, :sigla => "BN"){ |c| c.id = 35}.save
   Provincia.create(:description => "Caserta", :regione_id => r8.id, :sigla => "CE"){ |c| c.id = 36}.save
   Provincia.create(:description => "Napoli", :regione_id => r8.id, :sigla => "NA"){ |c| c.id = 37}.save
   Provincia.create(:description => "Salerno", :regione_id => r8.id, :sigla => "SA"){ |c| c.id = 38}.save
  r9 = Regione.create(:description => "Lazio", :stato_id => s1.id)
   Provincia.create(:description => "Frosinone", :regione_id => r9.id, :sigla => "FR"){ |c| c.id = 39}.save
   Provincia.create(:description => "Latina", :regione_id => r9.id, :sigla => "LT"){ |c| c.id = 40}.save
   Provincia.create(:description => "Rieti", :regione_id => r9.id, :sigla => "RI"){ |c| c.id = 41}.save
   Provincia.create(:description => "Roma", :regione_id => r9.id, :sigla => "RM"){ |c| c.id = 42}.save
   Provincia.create(:description => "Viterbo", :regione_id => r9.id, :sigla => "VT"){ |c| c.id = 43}.save
  r10 = Regione.create(:description => "Sardegna", :stato_id => s1.id)
   Provincia.create(:description => "Cagliari", :regione_id => r10.id, :sigla => "CA"){ |c| c.id = 78}.save
   Provincia.create(:description => "Nuoro", :regione_id => r10.id, :sigla => "NU"){ |c| c.id = 79}.save
   Provincia.create(:description => "Oristano", :regione_id => r10.id, :sigla => "OR"){ |c| c.id = 80}.save
   Provincia.create(:description => "Sassari", :regione_id => r10.id, :sigla => "SS"){ |c| c.id = 81}.save
   Provincia.create(:description => "Carbonia Iglesias", :regione_id => r10.id, :sigla => "CI"){ |c| c.id = 105}.save
   Provincia.create(:description => "Medio Campidano", :regione_id => r10.id, :sigla => "VS"){ |c| c.id = 106}.save
   Provincia.create(:description => "Ogliastra", :regione_id => r10.id, :sigla => "OG"){ |c| c.id = 107}.save
   Provincia.create(:description => "Olbia Tempio", :regione_id => r10.id, :sigla => "OT"){ |c| c.id = 108}.save
  r11 = Regione.create(:description => "Sicilia", :stato_id => s1.id)
   Provincia.create(:description => "Agrigento", :regione_id => r11.id, :sigla => "AG"){ |c| c.id = 12}.save
   Provincia.create(:description => "Caltanissetta", :regione_id => r11.id, :sigla => "CL"){ |c| c.id = 13}.save
   Provincia.create(:description => "Catania", :regione_id => r11.id, :sigla => "CT"){ |c| c.id = 14}.save
   Provincia.create(:description => "Enna", :regione_id => r11.id, :sigla => "EN"){ |c| c.id = 15}.save
   Provincia.create(:description => "Messina", :regione_id => r11.id, :sigla => "ME"){ |c| c.id = 16}.save
   Provincia.create(:description => "Palermo", :regione_id => r11.id, :sigla => "PA"){ |c| c.id = 17}.save
   Provincia.create(:description => "Ragusa", :regione_id => r11.id, :sigla => "RG"){ |c| c.id = 18}.save
   Provincia.create(:description => "Siracusa", :regione_id => r11.id, :sigla => "SR"){ |c| c.id = 19}.save
   Provincia.create(:description => "Trapani", :regione_id => r11.id, :sigla => "TP"){ |c| c.id = 20}.save
  r12 = Regione.create(:description => "Toscana", :stato_id => s1.id)
   Provincia.create(:description => "Arezzo", :regione_id => r12.id, :sigla => "AR"){ |c| c.id = 48}.save
   Provincia.create(:description => "Firenze", :regione_id => r12.id, :sigla => "FI"){ |c| c.id = 49}.save
   Provincia.create(:description => "Grosseto", :regione_id => r12.id, :sigla => "GR"){ |c| c.id = 50}.save
   Provincia.create(:description => "Livorno", :regione_id => r12.id, :sigla => "LI"){ |c| c.id = 51}.save
   Provincia.create(:description => "Lucca", :regione_id => r12.id, :sigla => "LU"){ |c| c.id = 52}.save
   Provincia.create(:description => "Massa Carrara", :regione_id => r12.id, :sigla => "MS"){ |c| c.id = 53}.save
   Provincia.create(:description => "Pisa", :regione_id => r12.id, :sigla => "PI"){ |c| c.id = 54}.save
   Provincia.create(:description => "Pistoia", :regione_id => r12.id, :sigla => "PT"){ |c| c.id = 55}.save
   Provincia.create(:description => "Siena", :regione_id => r12.id, :sigla => "SI"){ |c| c.id = 56}.save
   Provincia.create(:description => "Prato", :regione_id => r12.id, :sigla => "PO"){ |c| c.id = 103}.save
  r13 = Regione.create(:description => "Piemonte", :stato_id => s1.id)
   Provincia.create(:description => "Alessandria", :regione_id => r13.id, :sigla => "AL"){ |c| c.id = 5}.save
   Provincia.create(:description => "Asti", :regione_id => r13.id, :sigla => "AT"){ |c| c.id = 6}.save
   Provincia.create(:description => "Biella", :regione_id => r13.id, :sigla => "BI"){ |c| c.id = 7}.save
   Provincia.create(:description => "Cuneo", :regione_id => r13.id, :sigla => "CN"){ |c| c.id = 8}.save
   Provincia.create(:description => "Novara", :regione_id => r13.id, :sigla => "NO"){ |c| c.id = 9}.save
   Provincia.create(:description => "Vercelli", :regione_id => r13.id, :sigla => "VC"){ |c| c.id = 10}.save
   Provincia.create(:description => "Torino", :regione_id => r13.id, :sigla => "TO"){ |c| c.id = 11}.save
   Provincia.create(:description => "Verbania", :regione_id => r13.id, :sigla => "VB"){ |c| c.id = 104}.save
  r14 = Regione.create(:description => "Emilia Romagna", :stato_id => s1.id)
   Provincia.create(:description => "Bologna", :regione_id => r14.id, :sigla => "BO"){ |c| c.id = 57}.save
   Provincia.create(:description => "Ferrara", :regione_id => r14.id, :sigla => "FE"){ |c| c.id = 58}.save
   Provincia.create(:description => "Forlì Cesena", :regione_id => r14.id, :sigla => "FC"){ |c| c.id = 59}.save
   Provincia.create(:description => "Modena", :regione_id => r14.id, :sigla => "MO"){ |c| c.id = 60}.save
   Provincia.create(:description => "Parma", :regione_id => r14.id, :sigla => "PR"){ |c| c.id = 61}.save
   Provincia.create(:description => "Piacenza", :regione_id => r14.id, :sigla => "PC"){ |c| c.id = 62}.save
   Provincia.create(:description => "Ravenna", :regione_id => r14.id, :sigla => "RA"){ |c| c.id = 63}.save
   Provincia.create(:description => "Reggio Emilia", :regione_id => r14.id, :sigla => "RE"){ |c| c.id = 64}.save
   Provincia.create(:description => "Rimini", :regione_id => r14.id, :sigla => "RN"){ |c| c.id = 65}.save
  r15 = Regione.create(:description => "Friuli Venezia Giulia", :stato_id => s1.id)
   Provincia.create(:description => "Gorizia", :regione_id => r15.id, :sigla => "GO"){ |c| c.id = 73}.save
   Provincia.create(:description => "Pordenone", :regione_id => r15.id, :sigla => "PN"){ |c| c.id = 74}.save
   Provincia.create(:description => "Udine", :regione_id => r15.id, :sigla => "UD"){ |c| c.id = 75}.save
   Provincia.create(:description => "Trieste", :regione_id => r15.id, :sigla => "TS"){ |c| c.id = 76}.save
  r16 = Regione.create(:description => "Valle d'Aosta", :stato_id => s1.id)
   Provincia.create(:description => "Aosta", :regione_id => r16.id, :sigla => "AO"){ |c| c.id = 77}.save
  r17 = Regione.create(:description => "Veneto", :stato_id => s1.id)
   Provincia.create(:description => "Belluno", :regione_id => r17.id, :sigla => "BL"){ |c| c.id = 66}.save
   Provincia.create(:description => "Padova", :regione_id => r17.id, :sigla => "PD"){ |c| c.id = 67}.save
   Provincia.create(:description => "Rovigo", :regione_id => r17.id, :sigla => "RO"){ |c| c.id = 68}.save
   Provincia.create(:description => "Treviso", :regione_id => r17.id, :sigla => "TV"){ |c| c.id = 69}.save
   Provincia.create(:description => "Venezia", :regione_id => r17.id, :sigla => "VE"){ |c| c.id = 70}.save
   Provincia.create(:description => "Verona", :regione_id => r17.id, :sigla => "VR"){ |c| c.id = 71}.save
   Provincia.create(:description => "Vicenza", :regione_id => r17.id, :sigla => "VI"){ |c| c.id = 72}.save
  r18 = Regione.create(:description => "Liguria", :stato_id => s1.id)
   Provincia.create(:description => "Genova", :regione_id => r18.id, :sigla => "GE"){ |c| c.id = 82}.save
   Provincia.create(:description => "Imperia", :regione_id => r18.id, :sigla => "IM"){ |c| c.id = 83}.save
   Provincia.create(:description => "Savona", :regione_id => r18.id, :sigla => "SV"){ |c| c.id = 84}.save
   Provincia.create(:description => "La Spezia", :regione_id => r18.id, :sigla => "SP"){ |c| c.id = 85}.save
  r19 = Regione.create(:description => "Lombardia", :stato_id => s1.id)
   Provincia.create(:description => "Bergamo", :regione_id => r19.id, :sigla => "BG"){ |c| c.id = 90}.save
   Provincia.create(:description => "Brescia", :regione_id => r19.id, :sigla => "BS"){ |c| c.id = 91}.save
   Provincia.create(:description => "Como", :regione_id => r19.id, :sigla => "CO"){ |c| c.id = 92}.save
   Provincia.create(:description => "Cremona", :regione_id => r19.id, :sigla => "CR"){ |c| c.id = 93}.save
   Provincia.create(:description => "Lecco", :regione_id => r19.id, :sigla => "LC"){ |c| c.id = 94}.save
   Provincia.create(:description => "Lodi", :regione_id => r19.id, :sigla => "LO"){ |c| c.id = 95}.save
   Provincia.create(:description => "Mantova", :regione_id => r19.id, :sigla => "MN"){ |c| c.id = 96}.save
   Provincia.create(:description => "Milano", :regione_id => r19.id, :sigla => "MI"){ |c| c.id = 97}.save
   Provincia.create(:description => "Pavia", :regione_id => r19.id, :sigla => "PV"){ |c| c.id = 98}.save
   Provincia.create(:description => "Sondrio", :regione_id => r19.id, :sigla => "SO"){ |c| c.id = 99}.save
   Provincia.create(:description => "Varese", :regione_id => r19.id, :sigla => "VA"){ |c| c.id = 100}.save
  r20 = Regione.create(:description => "Umbria", :stato_id => s1.id)
   Provincia.create(:description => "Perugia", :regione_id => r20.id, :sigla => "PG"){ |c| c.id = 88}.save
   Provincia.create(:description => "Terni", :regione_id => r20.id, :sigla => "TR"){ |c| c.id = 89}.save
 s28 = Stato.create( :description => "Kosovo", :continente_id => a.id, sigla: "JE", sigla_ext: "JEY")
  s28.translations.where(locale: "eu").first_or_create.update_attributes(description: "Jersey")
  s28.translations.where(locale: "it").first_or_create.update_attributes(description: "Kosovo")
  s28.translations.where(locale: "en").first_or_create.update_attributes(description: "Jersey")
  s28.translations.where(locale: "pt").first_or_create.update_attributes(description: "Jersey")
  s28.translations.where(locale: "de").first_or_create.update_attributes(description: "Jersey")
  s28.translations.where(locale: "es").first_or_create.update_attributes(description: "Jersez")
 s29 = Stato.create( :description => "Lettonia", :continente_id => a.id, sigla: "XK", sigla_ext: "KOS")
  s29.translations.where(locale: "eu").first_or_create.update_attributes(description: "Kosovo")
  s29.translations.where(locale: "it").first_or_create.update_attributes(description: "Lettonia")
  s29.translations.where(locale: "en").first_or_create.update_attributes(description: "Kosovo")
  s29.translations.where(locale: "pt").first_or_create.update_attributes(description: "Kosovo")
  s29.translations.where(locale: "de").first_or_create.update_attributes(description: "Kosowo")
  s29.translations.where(locale: "es").first_or_create.update_attributes(description: "Kosovo")
 s30 = Stato.create( :description => "Liechtenstein", :continente_id => a.id, sigla: "LV", sigla_ext: "LVA")
  s30.translations.where(locale: "eu").first_or_create.update_attributes(description: "Latvia")
  s30.translations.where(locale: "it").first_or_create.update_attributes(description: "Liechtenstein")
  s30.translations.where(locale: "en").first_or_create.update_attributes(description: "Latvia")
  s30.translations.where(locale: "pt").first_or_create.update_attributes(description: "Letónia")
  s30.translations.where(locale: "de").first_or_create.update_attributes(description: "Letland")
  s30.translations.where(locale: "es").first_or_create.update_attributes(description: "Letónia")
 s31 = Stato.create( :description => "Lituania", :continente_id => a.id, sigla: "LI", sigla_ext: "LIE")
  s31.translations.where(locale: "eu").first_or_create.update_attributes(description: "Liechtenstein")
  s31.translations.where(locale: "it").first_or_create.update_attributes(description: "Lituania")
  s31.translations.where(locale: "en").first_or_create.update_attributes(description: "Liechtenstein")
  s31.translations.where(locale: "pt").first_or_create.update_attributes(description: "Liechtenstein")
  s31.translations.where(locale: "de").first_or_create.update_attributes(description: "Liechtenstein")
  s31.translations.where(locale: "es").first_or_create.update_attributes(description: "Liechtenstein")
 s32 = Stato.create( :description => "Lussemburgo", :continente_id => a.id, sigla: "LT", sigla_ext: "LTU")
  s32.translations.where(locale: "eu").first_or_create.update_attributes(description: "Lithuania")
  s32.translations.where(locale: "it").first_or_create.update_attributes(description: "Lussemburgo")
  s32.translations.where(locale: "en").first_or_create.update_attributes(description: "Lithuania")
  s32.translations.where(locale: "pt").first_or_create.update_attributes(description: "Lituânia")
  s32.translations.where(locale: "de").first_or_create.update_attributes(description: "Litauen")
  s32.translations.where(locale: "es").first_or_create.update_attributes(description: "Lituânia")
 s33 = Stato.create( :description => "Macedonia", :continente_id => a.id, sigla: "LU", sigla_ext: "LUX")
  s33.translations.where(locale: "eu").first_or_create.update_attributes(description: "Luxembourg")
  s33.translations.where(locale: "en").first_or_create.update_attributes(description: "Luxembourg")
  s33.translations.where(locale: "it").first_or_create.update_attributes(description: "Macedonia")
  s33.translations.where(locale: "pt").first_or_create.update_attributes(description: "Luxemburgo")
  s33.translations.where(locale: "de").first_or_create.update_attributes(description: "Luxemburg")
  s33.translations.where(locale: "es").first_or_create.update_attributes(description: "Luxemburgo")
 s34 = Stato.create( :description => "Malta", :continente_id => a.id, sigla: "MK", sigla_ext: "MKD")
  s34.translations.where(locale: "eu").first_or_create.update_attributes(description: "Macedonia")
  s34.translations.where(locale: "en").first_or_create.update_attributes(description: "Macedonia")
  s34.translations.where(locale: "it").first_or_create.update_attributes(description: "Malta")
  s34.translations.where(locale: "pt").first_or_create.update_attributes(description: "Macedónia")
  s34.translations.where(locale: "de").first_or_create.update_attributes(description: "Mazedonien")
  s34.translations.where(locale: "es").first_or_create.update_attributes(description: "Macedónia")
 s35 = Stato.create( :description => "Moldavia", :continente_id => a.id, sigla: "MT", sigla_ext: "MLT")
  s35.translations.where(locale: "eu").first_or_create.update_attributes(description: "Malta")
  s35.translations.where(locale: "en").first_or_create.update_attributes(description: "Malta")
  s35.translations.where(locale: "it").first_or_create.update_attributes(description: "Moldavia")
  s35.translations.where(locale: "pt").first_or_create.update_attributes(description: "Malta")
  s35.translations.where(locale: "de").first_or_create.update_attributes(description: "Malta")
  s35.translations.where(locale: "es").first_or_create.update_attributes(description: "Malta")
 s36 = Stato.create( :description => "Monaco", :continente_id => a.id, sigla: "MD", sigla_ext: "MDA")
  s36.translations.where(locale: "eu").first_or_create.update_attributes(description: "Moldova")
  s36.translations.where(locale: "en").first_or_create.update_attributes(description: "Moldova")
  s36.translations.where(locale: "it").first_or_create.update_attributes(description: "Monaco")
  s36.translations.where(locale: "pt").first_or_create.update_attributes(description: "Moldávia")
  s36.translations.where(locale: "de").first_or_create.update_attributes(description: "Moldawien")
  s36.translations.where(locale: "es").first_or_create.update_attributes(description: "Moldávia")
 s37 = Stato.create( :description => "Montenegro", :continente_id => a.id, sigla: "MC", sigla_ext: "MCO")
  s37.translations.where(locale: "eu").first_or_create.update_attributes(description: "Monaco")
  s37.translations.where(locale: "en").first_or_create.update_attributes(description: "Monaco")
  s37.translations.where(locale: "it").first_or_create.update_attributes(description: "Montenegro")
  s37.translations.where(locale: "pt").first_or_create.update_attributes(description: "Mónaco")
  s37.translations.where(locale: "de").first_or_create.update_attributes(description: "Monaco")
  s37.translations.where(locale: "es").first_or_create.update_attributes(description: "Mónaco")
 s38 = Stato.create( :description => "Olanda", :continente_id => a.id, sigla: "ME", sigla_ext: "MNE")
  s38.translations.where(locale: "eu").first_or_create.update_attributes(description: "Montenegro")
  s38.translations.where(locale: "en").first_or_create.update_attributes(description: "Montenegro")
  s38.translations.where(locale: "it").first_or_create.update_attributes(description: "Olanda")
  s38.translations.where(locale: "pt").first_or_create.update_attributes(description: "Montenegro")
  s38.translations.where(locale: "de").first_or_create.update_attributes(description: "Montenegro")
  s38.translations.where(locale: "es").first_or_create.update_attributes(description: "Montenegro")
 s39 = Stato.create( :description => "Norvegia", :continente_id => a.id, sigla: "NL", sigla_ext: "NLD")
  s39.translations.where(locale: "eu").first_or_create.update_attributes(description: "Netherlands")
  s39.translations.where(locale: "en").first_or_create.update_attributes(description: "Netherlands")
  s39.translations.where(locale: "it").first_or_create.update_attributes(description: "Norvegia")
  s39.translations.where(locale: "pt").first_or_create.update_attributes(description: "Holanda")
  s39.translations.where(locale: "de").first_or_create.update_attributes(description: "Holland")
  s39.translations.where(locale: "es").first_or_create.update_attributes(description: "Holanda")
 s40 = Stato.create( :description => "Polonia", :continente_id => a.id, sigla: "NO", sigla_ext: "NOR")
  s40.translations.where(locale: "eu").first_or_create.update_attributes(description: "Norway")
  s40.translations.where(locale: "en").first_or_create.update_attributes(description: "Norway")
  s40.translations.where(locale: "it").first_or_create.update_attributes(description: "Polonia")
  s40.translations.where(locale: "pt").first_or_create.update_attributes(description: "Noruega")
  s40.translations.where(locale: "de").first_or_create.update_attributes(description: "Norwegen")
  s40.translations.where(locale: "es").first_or_create.update_attributes(description: "Noruega")
 s41 = Stato.create( :description => "Portogallo", :continente_id => a.id, sigla: "PL", sigla_ext: "POL")
  s41.translations.where(locale: "eu").first_or_create.update_attributes(description: "Poland")
  s41.translations.where(locale: "en").first_or_create.update_attributes(description: "Poland")
  s41.translations.where(locale: "it").first_or_create.update_attributes(description: "Portogallo")
  s41.translations.where(locale: "pt").first_or_create.update_attributes(description: "Polónia")
  s41.translations.where(locale: "de").first_or_create.update_attributes(description: "Polen")
  s41.translations.where(locale: "es").first_or_create.update_attributes(description: "Polónia")
 s42 = Stato.create( :description => "Romania", :continente_id => a.id, sigla: "PT", sigla_ext: "PRT")
  s42.translations.where(locale: "eu").first_or_create.update_attributes(description: "Portugal")
  s42.translations.where(locale: "en").first_or_create.update_attributes(description: "Portugal")
  s42.translations.where(locale: "it").first_or_create.update_attributes(description: "Romania")
  s42.translations.where(locale: "pt").first_or_create.update_attributes(description: "Portugal")
  s42.translations.where(locale: "de").first_or_create.update_attributes(description: "Portugal")
  s42.translations.where(locale: "es").first_or_create.update_attributes(description: "Portugal")
 s43 = Stato.create( :description => "Russia", :continente_id => a.id, sigla: "RO", sigla_ext: "ROU")
  s43.translations.where(locale: "eu").first_or_create.update_attributes(description: "Romania")
  s43.translations.where(locale: "en").first_or_create.update_attributes(description: "Romania")
  s43.translations.where(locale: "it").first_or_create.update_attributes(description: "Russia")
  s43.translations.where(locale: "pt").first_or_create.update_attributes(description: "Roménia")
  s43.translations.where(locale: "de").first_or_create.update_attributes(description: "Rumänien")
  s43.translations.where(locale: "es").first_or_create.update_attributes(description: "Roménia")
 s44 = Stato.create( :description => "Serbia", :continente_id => a.id, sigla: "RU", sigla_ext: "RUS")
  s44.translations.where(locale: "eu").first_or_create.update_attributes(description: "Russian Federation")
  s44.translations.where(locale: "en").first_or_create.update_attributes(description: "Russian Federation")
  s44.translations.where(locale: "it").first_or_create.update_attributes(description: "Serbia")
  s44.translations.where(locale: "pt").first_or_create.update_attributes(description: "Federação Russa")
  s44.translations.where(locale: "de").first_or_create.update_attributes(description: "Rußland")
  s44.translations.where(locale: "es").first_or_create.update_attributes(description: "Federación Rusa")
 s2 = Stato.create( :description => "San Marino", :continente_id => a.id, sigla: "SM", sigla_ext: "SMR")
  s2.translations.where(locale: "it").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "eu").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "en").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "pt").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "de").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "es").first_or_create.update_attributes(description: "San Marino")
 s45 = Stato.create( :description => "Slovacchia", :continente_id => a.id, sigla: "RS", sigla_ext: "SRB")
  s45.translations.where(locale: "eu").first_or_create.update_attributes(description: "Serbia")
  s45.translations.where(locale: "en").first_or_create.update_attributes(description: "Serbia")
  s45.translations.where(locale: "it").first_or_create.update_attributes(description: "Slovacchia")
  s45.translations.where(locale: "pt").first_or_create.update_attributes(description: "Sérvia")
  s45.translations.where(locale: "de").first_or_create.update_attributes(description: "Serbien")
  s45.translations.where(locale: "es").first_or_create.update_attributes(description: "Sérbia")
 s46 = Stato.create( :description => "Slovenia", :continente_id => a.id, sigla: "SK", sigla_ext: "SVK")
  s46.translations.where(locale: "eu").first_or_create.update_attributes(description: "Slovakia")
  s46.translations.where(locale: "en").first_or_create.update_attributes(description: "Slovakia")
  s46.translations.where(locale: "it").first_or_create.update_attributes(description: "Slovenia")
  s46.translations.where(locale: "pt").first_or_create.update_attributes(description: "Eslováquia")
  s46.translations.where(locale: "de").first_or_create.update_attributes(description: "Slowakei")
  s46.translations.where(locale: "es").first_or_create.update_attributes(description: "Eslovaquia")
 s47 = Stato.create( :description => "Spagna", :continente_id => a.id, sigla: "SI", sigla_ext: "SVN")
  s47.translations.where(locale: "eu").first_or_create.update_attributes(description: "Slovenia")
  s47.translations.where(locale: "en").first_or_create.update_attributes(description: "Slovenia")
  s47.translations.where(locale: "it").first_or_create.update_attributes(description: "Spagna")
  s47.translations.where(locale: "pt").first_or_create.update_attributes(description: "Eslovénia")
  s47.translations.where(locale: "de").first_or_create.update_attributes(description: "Slowenien")
  s47.translations.where(locale: "es").first_or_create.update_attributes(description: "Eslovénia")
 s48 = Stato.create( :description => "Svalbard e Jan Mayen", :continente_id => a.id, sigla: "ES", sigla_ext: "ESP")
  s48.translations.where(locale: "eu").first_or_create.update_attributes(description: "Spain")
  s48.translations.where(locale: "en").first_or_create.update_attributes(description: "Spain")
  s48.translations.where(locale: "it").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
  s48.translations.where(locale: "pt").first_or_create.update_attributes(description: "Espanha")
  s48.translations.where(locale: "de").first_or_create.update_attributes(description: "Spanien")
  s48.translations.where(locale: "es").first_or_create.update_attributes(description: "España")
 s49 = Stato.create( :description => "Svezia", :continente_id => a.id, sigla: "SJ", sigla_ext: "SJM")
  s49.translations.where(locale: "eu").first_or_create.update_attributes(description: "Svalbard and Jan Mayen")
  s49.translations.where(locale: "it").first_or_create.update_attributes(description: "Svezia")
  s49.translations.where(locale: "en").first_or_create.update_attributes(description: "Svalbard and Jan Mayen")
  s49.translations.where(locale: "pt").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
  s49.translations.where(locale: "de").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
  s49.translations.where(locale: "es").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
 s50 = Stato.create( :description => "Svizzera", :continente_id => a.id, sigla: "SE", sigla_ext: "SWE")
  s50.translations.where(locale: "eu").first_or_create.update_attributes(description: "Sweden")
  s50.translations.where(locale: "it").first_or_create.update_attributes(description: "Svizzera")
  s50.translations.where(locale: "en").first_or_create.update_attributes(description: "Sweden")
  s50.translations.where(locale: "pt").first_or_create.update_attributes(description: "Suécia")
  s50.translations.where(locale: "de").first_or_create.update_attributes(description: "Schweden")
  s50.translations.where(locale: "es").first_or_create.update_attributes(description: "Suécia")
 s51 = Stato.create( :description => "Ucraina", :continente_id => a.id, sigla: "CH", sigla_ext: "CHE")
  s51.translations.where(locale: "eu").first_or_create.update_attributes(description: "Switzerland")
  s51.translations.where(locale: "it").first_or_create.update_attributes(description: "Ucraina")
  s51.translations.where(locale: "en").first_or_create.update_attributes(description: "Switzerland")
  s51.translations.where(locale: "pt").first_or_create.update_attributes(description: "Suíça")
  s51.translations.where(locale: "de").first_or_create.update_attributes(description: "Schweiz")
  s51.translations.where(locale: "es").first_or_create.update_attributes(description: "Suiza")
 s52 = Stato.create( :description => "Inghilterra", :continente_id => a.id, sigla: "UA", sigla_ext: "UKR")
  s52.translations.where(locale: "eu").first_or_create.update_attributes(description: "Ukraine")
  s52.translations.where(locale: "it").first_or_create.update_attributes(description: "Inghilterra")
  s52.translations.where(locale: "en").first_or_create.update_attributes(description: "Ukraine")
  s52.translations.where(locale: "pt").first_or_create.update_attributes(description: "Ucrânia")
  s52.translations.where(locale: "de").first_or_create.update_attributes(description: "Ukraine")
  s52.translations.where(locale: "es").first_or_create.update_attributes(description: "Ucrania")
 s53 = Stato.create( :description => "", :continente_id => a.id, sigla: "GB", sigla_ext: "GBR")
  s53.translations.where(locale: "eu").first_or_create.update_attributes(description: "United Kingdom")
  s53.translations.where(locale: "en").first_or_create.update_attributes(description: "United Kingdom")
  s53.translations.where(locale: "pt").first_or_create.update_attributes(description: "Reino Unido")
  s53.translations.where(locale: "de").first_or_create.update_attributes(description: "Großbritannien")
  s53.translations.where(locale: "es").first_or_create.update_attributes(description: "Inglaterra")
 s3 = Stato.create( :description => "Città del Vaticano", :continente_id => a.id, sigla: "VA", sigla_ext: "VAT")
  s3.translations.where(locale: "it").first_or_create.update_attributes(description: "Città del Vaticano")
  s3.translations.where(locale: "eu").first_or_create.update_attributes(description: "Vatican City State")
  s3.translations.where(locale: "en").first_or_create.update_attributes(description: "Vatican City State")
  s3.translations.where(locale: "pt").first_or_create.update_attributes(description: "Cidade do Vaticano")
  s3.translations.where(locale: "de").first_or_create.update_attributes(description: "Vatikan")
  s3.translations.where(locale: "es").first_or_create.update_attributes(description: "Cuidad del Vaticaon")
