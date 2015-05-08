a2 = Continente.create(description: "America")
  a2.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "America")
  a2.translations.where(locale: "en").first_or_create.update_attributes(description: "America")
  a2.translations.where(locale: "en-US").first_or_create.update_attributes(description: "America")
  a2.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "América")
  a2.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "América")
  a2.translations.where(locale: "fr").first_or_create.update_attributes(description: "Amérique")
  a2.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "América")
  a2.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "América")
 s53 = Stato.create( description: "Ecuador", continente_id: a2.id, sigla: "EC", sigla_ext: "")
  s53.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Ecuador")
  s53.translations.where(locale: "en").first_or_create.update_attributes(description: "Ecuador")
  s53.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Ecuador")
  s53.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Ecuador")
  s53.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "Ecuador")
  s53.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Equador")
  s53.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "Equador")
  s53.translations.where(locale: "fr").first_or_create.update_attributes(description: "Équateur")
  r21 = Regione.create(description: "Norte", stato_id: s53.id, continente_id: a2.id)
  r22 = Regione.create(description: "Centro-Norte", stato_id: s53.id, continente_id: a2.id)
  r23 = Regione.create(description: "Centro", stato_id: s53.id, continente_id: a2.id)
  r24 = Regione.create(description: "Pacifico", stato_id: s53.id, continente_id: a2.id)
  r25 = Regione.create(description: "Litoral", stato_id: s53.id, continente_id: a2.id)
  r26 = Regione.create(description: "Centro-Sur", stato_id: s53.id, continente_id: a2.id)
  r27 = Regione.create(description: "Sur", stato_id: s53.id, continente_id: a2.id)
  r28 = Regione.create(description: "Galápagos", stato_id: s53.id, continente_id: a2.id)
 s54 = Stato.create( description: "Brazil", continente_id: a2.id, sigla: "BR", sigla_ext: "")
  s54.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Brasile")
  s54.translations.where(locale: "en").first_or_create.update_attributes(description: "Brazil")
  s54.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Brazil")
  s54.translations.where(locale: "fr").first_or_create.update_attributes(description: "Brésil")
  s54.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Brasil")
  s54.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "Brasil")
  s54.translations.where(locale: "de").first_or_create.update_attributes(description: "Brazil")
  s54.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Brasil")
  s54.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "Brasil")
 s59 = Stato.create( description: "Anguilla", continente_id: a2.id, sigla: "AI", sigla_ext: "AIA")
  s59.translations.where(locale: "en").first_or_create.update_attributes(description: "Anguilla")
 s61 = Stato.create( description: "Antigua and Barbuda", continente_id: a2.id, sigla: "AG", sigla_ext: "ATG")
  s61.translations.where(locale: "en").first_or_create.update_attributes(description: "Antigua and Barbuda")
 s62 = Stato.create( description: "Argentina", continente_id: a2.id, sigla: "AR", sigla_ext: "ARG")
  s62.translations.where(locale: "en").first_or_create.update_attributes(description: "Argentina")
 s64 = Stato.create( description: "Aruba", continente_id: a2.id, sigla: "AW", sigla_ext: "ABW")
  s64.translations.where(locale: "en").first_or_create.update_attributes(description: "Aruba")
 s67 = Stato.create( description: "Bahamas", continente_id: a2.id, sigla: "BS", sigla_ext: "BHS")
  s67.translations.where(locale: "en").first_or_create.update_attributes(description: "Bahamas")
 s70 = Stato.create( description: "Barbados", continente_id: a2.id, sigla: "BB", sigla_ext: "BRB")
  s70.translations.where(locale: "en").first_or_create.update_attributes(description: "Barbados")
 s71 = Stato.create( description: "Belize", continente_id: a2.id, sigla: "BZ", sigla_ext: "BLZ")
  s71.translations.where(locale: "en").first_or_create.update_attributes(description: "Belize")
 s73 = Stato.create( description: "Bermuda", continente_id: a2.id, sigla: "BM", sigla_ext: "BMU")
  s73.translations.where(locale: "en").first_or_create.update_attributes(description: "Bermuda")
 s75 = Stato.create( description: "Bolivia, Plurinational State of", continente_id: a2.id, sigla: "BO", sigla_ext: "BOL")
  s75.translations.where(locale: "en").first_or_create.update_attributes(description: "Bolivia, Plurinational State of")
 s78 = Stato.create( description: "Brazil", continente_id: a2.id, sigla: "BR", sigla_ext: "BRA")
  s78.translations.where(locale: "en").first_or_create.update_attributes(description: "Brazil")
 s85 = Stato.create( description: "Canada", continente_id: a2.id, sigla: "CA", sigla_ext: "CAN")
  s85.translations.where(locale: "en").first_or_create.update_attributes(description: "Canada")
 s87 = Stato.create( description: "Cayman Islands", continente_id: a2.id, sigla: "KY", sigla_ext: "CYM")
  s87.translations.where(locale: "en").first_or_create.update_attributes(description: "Cayman Islands")
 s90 = Stato.create( description: "Chile", continente_id: a2.id, sigla: "CL", sigla_ext: "CHL")
  s90.translations.where(locale: "en").first_or_create.update_attributes(description: "Chile")
  s90.translations.where(locale: "es-CL").first_or_create.update_attributes(description: "Chile")
  r38 = Regione.create(description: "Arica and Parinacota", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Arica", regione_id: r38.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 175}.save
   Provincia.create(description: "Parinacota", regione_id: r38.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 176}.save
  r39 = Regione.create(description: "Tarapacá", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Iquique", regione_id: r39.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 177}.save
   Provincia.create(description: "Tamarugal", regione_id: r39.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 178}.save
  r40 = Regione.create(description: "Antofagasta", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Antofagasta", regione_id: r40.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 179}.save
   Provincia.create(description: "El Loa", regione_id: r40.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 180}.save
   Provincia.create(description: "Tocopilla", regione_id: r40.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 181}.save
  r41 = Regione.create(description: "Atacama", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Chañaral", regione_id: r41.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 182}.save
   Provincia.create(description: "Copiapó", regione_id: r41.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 183}.save
   Provincia.create(description: "Huasco", regione_id: r41.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 184}.save
  r42 = Regione.create(description: "Coquimbo", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Choapa", regione_id: r42.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 185}.save
   Provincia.create(description: "Elqui", regione_id: r42.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 186}.save
   Provincia.create(description: "Limarí", regione_id: r42.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 187}.save
  r43 = Regione.create(description: "Valparaíso", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Isla de Pascua", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 188}.save
   Provincia.create(description: "Los Andes", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 189}.save
   Provincia.create(description: "Marga Marga", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 190}.save
   Provincia.create(description: "Petorca", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 191}.save
   Provincia.create(description: "Quillota", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 192}.save
   Provincia.create(description: "San Antonio", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 193}.save
   Provincia.create(description: "San Felipe", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 194}.save
   Provincia.create(description: "Valparaíso", regione_id: r43.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 195}.save
  r44 = Regione.create(description: "Metropolitana", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Chacabuco", regione_id: r44.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 196}.save
   Provincia.create(description: "Cordillera", regione_id: r44.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 197}.save
   Provincia.create(description: "Maipo", regione_id: r44.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 198}.save
   Provincia.create(description: "Melipilla", regione_id: r44.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 199}.save
   Provincia.create(description: "Santiago", regione_id: r44.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 200}.save
   Provincia.create(description: "Talagante", regione_id: r44.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 201}.save
  r45 = Regione.create(description: "O 'Higgins", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Cachapoal", regione_id: r45.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 202}.save
   Provincia.create(description: "Cardenal Caro", regione_id: r45.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 203}.save
   Provincia.create(description: "Colchagua", regione_id: r45.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 204}.save
  r46 = Regione.create(description: "Maule", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Cauquenes", regione_id: r46.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 205}.save
   Provincia.create(description: "Curicó", regione_id: r46.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 206}.save
   Provincia.create(description: "Linares", regione_id: r46.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 207}.save
   Provincia.create(description: "Talca", regione_id: r46.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 208}.save
  r47 = Regione.create(description: "Biobío", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Arauco", regione_id: r47.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 209}.save
   Provincia.create(description: "Biobío", regione_id: r47.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 210}.save
   Provincia.create(description: "Concepción", regione_id: r47.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 211}.save
   Provincia.create(description: "Ñuble", regione_id: r47.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 212}.save
  r48 = Regione.create(description: "Araucanía", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Cautín", regione_id: r48.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 213}.save
   Provincia.create(description: "Malleco", regione_id: r48.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 214}.save
  r49 = Regione.create(description: "Los Ríos", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Ranco", regione_id: r49.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 215}.save
   Provincia.create(description: "Valdivia", regione_id: r49.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 216}.save
  r50 = Regione.create(description: "Los Lagos", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Chiloé", regione_id: r50.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 217}.save
   Provincia.create(description: "Llanquihue", regione_id: r50.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 218}.save
   Provincia.create(description: "Osorno", regione_id: r50.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 219}.save
   Provincia.create(description: "Palena", regione_id: r50.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 220}.save
  r51 = Regione.create(description: "Aisén", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Aisén", regione_id: r51.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 221}.save
   Provincia.create(description: "Capitán Prat", regione_id: r51.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 222}.save
   Provincia.create(description: "Coihaique", regione_id: r51.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 223}.save
   Provincia.create(description: "General Carrera", regione_id: r51.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 224}.save
  r52 = Regione.create(description: "Magallanes and Antártica Chilena", stato_id: s90.id, continente_id: a2.id)
   Provincia.create(description: "Antártica Chilena", regione_id: r52.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 225}.save
   Provincia.create(description: "Magallanes", regione_id: r52.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 226}.save
   Provincia.create(description: "Tierra del Fuego", regione_id: r52.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 227}.save
   Provincia.create(description: "Última Esperanza", regione_id: r52.id, stato_id: s90.id, continente_id: a2.id, sigla: ""){ |c| c.id = 228}.save
 s94 = Stato.create( description: "Colombia", continente_id: a2.id, sigla: "CO", sigla_ext: "COL")
  s94.translations.where(locale: "en").first_or_create.update_attributes(description: "Colombia")
 s99 = Stato.create( description: "Costa Rica", continente_id: a2.id, sigla: "CR", sigla_ext: "CRI")
  s99.translations.where(locale: "en").first_or_create.update_attributes(description: "Costa Rica")
 s101 = Stato.create( description: "Cuba", continente_id: a2.id, sigla: "CU", sigla_ext: "CUB")
  s101.translations.where(locale: "en").first_or_create.update_attributes(description: "Cuba")
 s104 = Stato.create( description: "Dominica", continente_id: a2.id, sigla: "DM", sigla_ext: "DMA")
  s104.translations.where(locale: "en").first_or_create.update_attributes(description: "Dominica")
 s105 = Stato.create( description: "Dominican Republic", continente_id: a2.id, sigla: "DO", sigla_ext: "DOM")
  s105.translations.where(locale: "en").first_or_create.update_attributes(description: "Dominican Republic")
 s106 = Stato.create( description: "Ecuador", continente_id: a2.id, sigla: "EC", sigla_ext: "ECU")
  s106.translations.where(locale: "en").first_or_create.update_attributes(description: "Ecuador")
 s108 = Stato.create( description: "El Salvador", continente_id: a2.id, sigla: "SV", sigla_ext: "SLV")
  s108.translations.where(locale: "en").first_or_create.update_attributes(description: "El Salvador")
 s112 = Stato.create( description: "Falkland Islands (Malvinas)", continente_id: a2.id, sigla: "FK", sigla_ext: "FLK")
  s112.translations.where(locale: "en").first_or_create.update_attributes(description: "Falkland Islands (Malvinas)")
 s114 = Stato.create( description: "French Guiana", continente_id: a2.id, sigla: "GF", sigla_ext: "GUF")
  s114.translations.where(locale: "en").first_or_create.update_attributes(description: "French Guiana")
 s121 = Stato.create( description: "Greenland", continente_id: a2.id, sigla: "GL", sigla_ext: "GRL")
  s121.translations.where(locale: "en").first_or_create.update_attributes(description: "Greenland")
 s122 = Stato.create( description: "Grenada", continente_id: a2.id, sigla: "GD", sigla_ext: "GRD")
  s122.translations.where(locale: "en").first_or_create.update_attributes(description: "Grenada")
 s123 = Stato.create( description: "Guadeloupe", continente_id: a2.id, sigla: "GP", sigla_ext: "GLP")
  s123.translations.where(locale: "en").first_or_create.update_attributes(description: "Guadeloupe")
 s125 = Stato.create( description: "Guatemala", continente_id: a2.id, sigla: "GT", sigla_ext: "GTM")
  s125.translations.where(locale: "en").first_or_create.update_attributes(description: "Guatemala")
 s128 = Stato.create( description: "Guyana", continente_id: a2.id, sigla: "GY", sigla_ext: "GUY")
  s128.translations.where(locale: "en").first_or_create.update_attributes(description: "Guyana")
 s129 = Stato.create( description: "Haiti", continente_id: a2.id, sigla: "HT", sigla_ext: "HTI")
  s129.translations.where(locale: "en").first_or_create.update_attributes(description: "Haiti")
 s131 = Stato.create( description: "Honduras", continente_id: a2.id, sigla: "HN", sigla_ext: "HND")
  s131.translations.where(locale: "en").first_or_create.update_attributes(description: "Honduras")
 s138 = Stato.create( description: "Jamaica", continente_id: a2.id, sigla: "JM", sigla_ext: "JAM")
  s138.translations.where(locale: "en").first_or_create.update_attributes(description: "Jamaica")
 s160 = Stato.create( description: "Martinique", continente_id: a2.id, sigla: "MQ", sigla_ext: "MTQ")
  s160.translations.where(locale: "en").first_or_create.update_attributes(description: "Martinique")
 s164 = Stato.create( description: "Mexico", continente_id: a2.id, sigla: "MX", sigla_ext: "MEX")
  s164.translations.where(locale: "en").first_or_create.update_attributes(description: "Mexico")
 s167 = Stato.create( description: "Montserrat", continente_id: a2.id, sigla: "MS", sigla_ext: "MSR")
  s167.translations.where(locale: "en").first_or_create.update_attributes(description: "Montserrat")
 s174 = Stato.create( description: "Netherlands Antilles", continente_id: a2.id, sigla: "AN", sigla_ext: "ANT")
  s174.translations.where(locale: "en").first_or_create.update_attributes(description: "Netherlands Antilles")
 s177 = Stato.create( description: "Nicaragua", continente_id: a2.id, sigla: "NI", sigla_ext: "NIC")
  s177.translations.where(locale: "en").first_or_create.update_attributes(description: "Nicaragua")
 s187 = Stato.create( description: "Panama", continente_id: a2.id, sigla: "PA", sigla_ext: "PAN")
  s187.translations.where(locale: "en").first_or_create.update_attributes(description: "Panama")
 s189 = Stato.create( description: "Paraguay", continente_id: a2.id, sigla: "PY", sigla_ext: "PRY")
  s189.translations.where(locale: "en").first_or_create.update_attributes(description: "Paraguay")
 s190 = Stato.create( description: "Peru", continente_id: a2.id, sigla: "PE", sigla_ext: "PER")
  s190.translations.where(locale: "en").first_or_create.update_attributes(description: "Peru")
 s193 = Stato.create( description: "Puerto Rico", continente_id: a2.id, sigla: "PR", sigla_ext: "PRI")
  s193.translations.where(locale: "en").first_or_create.update_attributes(description: "Puerto Rico")
 s197 = Stato.create( description: "Saint Barth", continente_id: a2.id, sigla: "BL", sigla_ext: "BLM")
  s197.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Barth")
 s199 = Stato.create( description: "Saint Kitts and Nevis", continente_id: a2.id, sigla: "KN", sigla_ext: "KNA")
  s199.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Kitts and Nevis")
 s200 = Stato.create( description: "Saint Lucia", continente_id: a2.id, sigla: "LC", sigla_ext: "LCA")
  s200.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Lucia")
 s201 = Stato.create( description: "Saint Martin (French part)", continente_id: a2.id, sigla: "MF", sigla_ext: "MAF")
  s201.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Martin (French part)")
 s202 = Stato.create( description: "Saint Pierre and Miquelon", continente_id: a2.id, sigla: "PM", sigla_ext: "SPM")
  s202.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Pierre and Miquelon")
 s203 = Stato.create( description: "Saint Vincent and the Grenadines", continente_id: a2.id, sigla: "VC", sigla_ext: "VCT")
  s203.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Vincent and the Grenadines")
 s217 = Stato.create( description: "Suriname", continente_id: a2.id, sigla: "SR", sigla_ext: "SUR")
  s217.translations.where(locale: "en").first_or_create.update_attributes(description: "Suriname")
 s228 = Stato.create( description: "Trinidad and Tobago", continente_id: a2.id, sigla: "TT", sigla_ext: "TTO")
  s228.translations.where(locale: "en").first_or_create.update_attributes(description: "Trinidad and Tobago")
 s232 = Stato.create( description: "Turks and Caicos Islands", continente_id: a2.id, sigla: "TC", sigla_ext: "TCA")
  s232.translations.where(locale: "en").first_or_create.update_attributes(description: "Turks and Caicos Islands")
 s236 = Stato.create( description: "United States", continente_id: a2.id, sigla: "US", sigla_ext: "USA")
  s236.translations.where(locale: "en").first_or_create.update_attributes(description: "United States")
 s238 = Stato.create( description: "Uruguay", continente_id: a2.id, sigla: "UY", sigla_ext: "URY")
  s238.translations.where(locale: "en").first_or_create.update_attributes(description: "Uruguay")
 s241 = Stato.create( description: "Venezuela, Bolivarian Republic of", continente_id: a2.id, sigla: "VE", sigla_ext: "VEN")
  s241.translations.where(locale: "en").first_or_create.update_attributes(description: "Venezuela, Bolivarian Republic of")
 s243 = Stato.create( description: "Virgin Islands, British", continente_id: a2.id, sigla: "VG", sigla_ext: "VGB")
  s243.translations.where(locale: "en").first_or_create.update_attributes(description: "Virgin Islands, British")
a3 = Continente.create(description: "Africa")
  a3.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Africa")
  a3.translations.where(locale: "en").first_or_create.update_attributes(description: "Africa")
  a3.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Africa")
  a3.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "África")
  a3.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "África")
  a3.translations.where(locale: "fr").first_or_create.update_attributes(description: "Afrique")
  a3.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "África")
  a3.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "África")
 s56 = Stato.create( description: "Algeria", continente_id: a3.id, sigla: "DZ", sigla_ext: "DZA")
  s56.translations.where(locale: "en").first_or_create.update_attributes(description: "Algeria")
 s58 = Stato.create( description: "Angola", continente_id: a3.id, sigla: "AO", sigla_ext: "AGO")
  s58.translations.where(locale: "en").first_or_create.update_attributes(description: "Angola")
 s72 = Stato.create( description: "Benin", continente_id: a3.id, sigla: "BJ", sigla_ext: "BEN")
  s72.translations.where(locale: "en").first_or_create.update_attributes(description: "Benin")
 s76 = Stato.create( description: "Botswana", continente_id: a3.id, sigla: "BW", sigla_ext: "BWA")
  s76.translations.where(locale: "en").first_or_create.update_attributes(description: "Botswana")
 s81 = Stato.create( description: "Burkina Faso", continente_id: a3.id, sigla: "BF", sigla_ext: "BFA")
  s81.translations.where(locale: "en").first_or_create.update_attributes(description: "Burkina Faso")
 s82 = Stato.create( description: "Burundi", continente_id: a3.id, sigla: "BI", sigla_ext: "BDI")
  s82.translations.where(locale: "en").first_or_create.update_attributes(description: "Burundi")
 s84 = Stato.create( description: "Cameroon", continente_id: a3.id, sigla: "CM", sigla_ext: "CMR")
  s84.translations.where(locale: "en").first_or_create.update_attributes(description: "Cameroon")
 s86 = Stato.create( description: "Cape Verde", continente_id: a3.id, sigla: "CV", sigla_ext: "CPV")
  s86.translations.where(locale: "en").first_or_create.update_attributes(description: "Cape Verde")
 s88 = Stato.create( description: "Central African Republic", continente_id: a3.id, sigla: "CF", sigla_ext: "CAF")
  s88.translations.where(locale: "en").first_or_create.update_attributes(description: "Central African Republic")
 s89 = Stato.create( description: "Chad", continente_id: a3.id, sigla: "TD", sigla_ext: "TCD")
  s89.translations.where(locale: "en").first_or_create.update_attributes(description: "Chad")
 s95 = Stato.create( description: "Comoros", continente_id: a3.id, sigla: "KM", sigla_ext: "COM")
  s95.translations.where(locale: "en").first_or_create.update_attributes(description: "Comoros")
 s96 = Stato.create( description: "Congo", continente_id: a3.id, sigla: "CG", sigla_ext: "COG")
  s96.translations.where(locale: "en").first_or_create.update_attributes(description: "Congo")
 s97 = Stato.create( description: "Congo, the Democratic Republic of the", continente_id: a3.id, sigla: "CD", sigla_ext: "COD")
  s97.translations.where(locale: "en").first_or_create.update_attributes(description: "Congo, the Democratic Republic of the")
 s100 = Stato.create( description: "Cote d'Ivoire", continente_id: a3.id, sigla: "CI", sigla_ext: "CIV")
  s100.translations.where(locale: "en").first_or_create.update_attributes(description: "Cote d'Ivoire")
 s103 = Stato.create( description: "Djibouti", continente_id: a3.id, sigla: "DJ", sigla_ext: "DJI")
  s103.translations.where(locale: "en").first_or_create.update_attributes(description: "Djibouti")
 s107 = Stato.create( description: "Egypt", continente_id: a3.id, sigla: "EG", sigla_ext: "EGY")
  s107.translations.where(locale: "en").first_or_create.update_attributes(description: "Egypt")
 s109 = Stato.create( description: "Equatorial Guinea", continente_id: a3.id, sigla: "GQ", sigla_ext: "GNQ")
  s109.translations.where(locale: "en").first_or_create.update_attributes(description: "Equatorial Guinea")
 s110 = Stato.create( description: "Eritrea", continente_id: a3.id, sigla: "ER", sigla_ext: "ERI")
  s110.translations.where(locale: "en").first_or_create.update_attributes(description: "Eritrea")
 s111 = Stato.create( description: "Ethiopia", continente_id: a3.id, sigla: "ET", sigla_ext: "ETH")
  s111.translations.where(locale: "en").first_or_create.update_attributes(description: "Ethiopia")
 s117 = Stato.create( description: "Gabon", continente_id: a3.id, sigla: "GA", sigla_ext: "GAB")
  s117.translations.where(locale: "en").first_or_create.update_attributes(description: "Gabon")
 s118 = Stato.create( description: "Gambia", continente_id: a3.id, sigla: "GM", sigla_ext: "GMB")
  s118.translations.where(locale: "en").first_or_create.update_attributes(description: "Gambia")
 s120 = Stato.create( description: "Ghana", continente_id: a3.id, sigla: "GH", sigla_ext: "GHA")
  s120.translations.where(locale: "en").first_or_create.update_attributes(description: "Ghana")
 s126 = Stato.create( description: "Guinea", continente_id: a3.id, sigla: "GN", sigla_ext: "GIN")
  s126.translations.where(locale: "en").first_or_create.update_attributes(description: "Guinea")
 s127 = Stato.create( description: "Guinea-Bissau", continente_id: a3.id, sigla: "GW", sigla_ext: "GNB")
  s127.translations.where(locale: "en").first_or_create.update_attributes(description: "Guinea-Bissau")
 s142 = Stato.create( description: "Kenya", continente_id: a3.id, sigla: "KE", sigla_ext: "KEN")
  s142.translations.where(locale: "en").first_or_create.update_attributes(description: "Kenya")
 s150 = Stato.create( description: "Lesotho", continente_id: a3.id, sigla: "LS", sigla_ext: "LSO")
  s150.translations.where(locale: "en").first_or_create.update_attributes(description: "Lesotho")
 s151 = Stato.create( description: "Liberia", continente_id: a3.id, sigla: "LR", sigla_ext: "LBR")
  s151.translations.where(locale: "en").first_or_create.update_attributes(description: "Liberia")
 s152 = Stato.create( description: "Libyan Arab Jamahiriya", continente_id: a3.id, sigla: "LY", sigla_ext: "LBY")
  s152.translations.where(locale: "en").first_or_create.update_attributes(description: "Libyan Arab Jamahiriya")
 s154 = Stato.create( description: "Madagascar", continente_id: a3.id, sigla: "MG", sigla_ext: "MDG")
  s154.translations.where(locale: "en").first_or_create.update_attributes(description: "Madagascar")
 s155 = Stato.create( description: "Malawi", continente_id: a3.id, sigla: "MW", sigla_ext: "MWI")
  s155.translations.where(locale: "en").first_or_create.update_attributes(description: "Malawi")
 s158 = Stato.create( description: "Mali", continente_id: a3.id, sigla: "ML", sigla_ext: "MLI")
  s158.translations.where(locale: "en").first_or_create.update_attributes(description: "Mali")
 s161 = Stato.create( description: "Mauritania", continente_id: a3.id, sigla: "MR", sigla_ext: "MRT")
  s161.translations.where(locale: "en").first_or_create.update_attributes(description: "Mauritania")
 s162 = Stato.create( description: "Mauritius", continente_id: a3.id, sigla: "MU", sigla_ext: "MUS")
  s162.translations.where(locale: "en").first_or_create.update_attributes(description: "Mauritius")
 s163 = Stato.create( description: "Mayotte", continente_id: a3.id, sigla: "YT", sigla_ext: "MYT")
  s163.translations.where(locale: "en").first_or_create.update_attributes(description: "Mayotte")
 s168 = Stato.create( description: "Morocco", continente_id: a3.id, sigla: "MA", sigla_ext: "MAR")
  s168.translations.where(locale: "en").first_or_create.update_attributes(description: "Morocco")
 s169 = Stato.create( description: "Mozambique", continente_id: a3.id, sigla: "MZ", sigla_ext: "MOZ")
  s169.translations.where(locale: "en").first_or_create.update_attributes(description: "Mozambique")
 s171 = Stato.create( description: "Namibia", continente_id: a3.id, sigla: "NA", sigla_ext: "NAM")
  s171.translations.where(locale: "en").first_or_create.update_attributes(description: "Namibia")
 s178 = Stato.create( description: "Niger", continente_id: a3.id, sigla: "NE", sigla_ext: "NER")
  s178.translations.where(locale: "en").first_or_create.update_attributes(description: "Niger")
 s179 = Stato.create( description: "Nigeria", continente_id: a3.id, sigla: "NG", sigla_ext: "NGA")
  s179.translations.where(locale: "en").first_or_create.update_attributes(description: "Nigeria")
 s195 = Stato.create( description: "Reunion", continente_id: a3.id, sigla: "RE", sigla_ext: "REU")
  s195.translations.where(locale: "en").first_or_create.update_attributes(description: "Reunion")
 s196 = Stato.create( description: "Rwanda", continente_id: a3.id, sigla: "RW", sigla_ext: "RWA")
  s196.translations.where(locale: "en").first_or_create.update_attributes(description: "Rwanda")
 s198 = Stato.create( description: "Saint Helena, Ascension and Tristan da Cunha", continente_id: a3.id, sigla: "SH", sigla_ext: "SHN")
  s198.translations.where(locale: "en").first_or_create.update_attributes(description: "Saint Helena, Ascension and Tristan da Cunha")
 s205 = Stato.create( description: "Sao Tome and Principe", continente_id: a3.id, sigla: "ST", sigla_ext: "STP")
  s205.translations.where(locale: "en").first_or_create.update_attributes(description: "Sao Tome and Principe")
 s207 = Stato.create( description: "Senegal", continente_id: a3.id, sigla: "SN", sigla_ext: "SEN")
  s207.translations.where(locale: "en").first_or_create.update_attributes(description: "Senegal")
 s208 = Stato.create( description: "Seychelles", continente_id: a3.id, sigla: "SC", sigla_ext: "SYC")
  s208.translations.where(locale: "en").first_or_create.update_attributes(description: "Seychelles")
 s209 = Stato.create( description: "Sierra Leone", continente_id: a3.id, sigla: "SL", sigla_ext: "SLE")
  s209.translations.where(locale: "en").first_or_create.update_attributes(description: "Sierra Leone")
 s212 = Stato.create( description: "Somalia", continente_id: a3.id, sigla: "SO", sigla_ext: "SOM")
  s212.translations.where(locale: "en").first_or_create.update_attributes(description: "Somalia")
 s213 = Stato.create( description: "South Africa", continente_id: a3.id, sigla: "ZA", sigla_ext: "ZAF")
  s213.translations.where(locale: "en").first_or_create.update_attributes(description: "South Africa")
 s216 = Stato.create( description: "Sudan", continente_id: a3.id, sigla: "SD", sigla_ext: "SDN")
  s216.translations.where(locale: "en").first_or_create.update_attributes(description: "Sudan")
 s218 = Stato.create( description: "Swaziland", continente_id: a3.id, sigla: "SZ", sigla_ext: "SWZ")
  s218.translations.where(locale: "en").first_or_create.update_attributes(description: "Swaziland")
 s222 = Stato.create( description: "Tanzania, United Republic of", continente_id: a3.id, sigla: "TZ", sigla_ext: "TZA")
  s222.translations.where(locale: "en").first_or_create.update_attributes(description: "Tanzania, United Republic of")
 s225 = Stato.create( description: "Togo", continente_id: a3.id, sigla: "TG", sigla_ext: "TGO")
  s225.translations.where(locale: "en").first_or_create.update_attributes(description: "Togo")
 s229 = Stato.create( description: "Tunisia", continente_id: a3.id, sigla: "TN", sigla_ext: "TUN")
  s229.translations.where(locale: "en").first_or_create.update_attributes(description: "Tunisia")
 s234 = Stato.create( description: "Uganda", continente_id: a3.id, sigla: "UG", sigla_ext: "UGA")
  s234.translations.where(locale: "en").first_or_create.update_attributes(description: "Uganda")
 s246 = Stato.create( description: "Zambia", continente_id: a3.id, sigla: "ZM", sigla_ext: "ZMB")
  s246.translations.where(locale: "en").first_or_create.update_attributes(description: "Zambia")
 s247 = Stato.create( description: "Zimbabwe", continente_id: a3.id, sigla: "ZW", sigla_ext: "ZWE")
  s247.translations.where(locale: "en").first_or_create.update_attributes(description: "Zimbabwe")
a4 = Continente.create(description: "Asia")
  a4.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Asia")
  a4.translations.where(locale: "en").first_or_create.update_attributes(description: "Asia")
  a4.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Asia")
  a4.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Asia")
  a4.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "Asia")
  a4.translations.where(locale: "fr").first_or_create.update_attributes(description: "Asie")
  a4.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Ásia")
  a4.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "Ásia")
 s55 = Stato.create( description: "Afghanistan", continente_id: a4.id, sigla: "AF", sigla_ext: "AFG")
  s55.translations.where(locale: "en").first_or_create.update_attributes(description: "Afghanistan")
 s63 = Stato.create( description: "Armenia", continente_id: a4.id, sigla: "AM", sigla_ext: "ARM")
  s63.translations.where(locale: "en").first_or_create.update_attributes(description: "Armenia")
 s66 = Stato.create( description: "Azerbaijan", continente_id: a4.id, sigla: "AZ", sigla_ext: "AZE")
  s66.translations.where(locale: "en").first_or_create.update_attributes(description: "Azerbaijan")
 s68 = Stato.create( description: "Bahrain", continente_id: a4.id, sigla: "BH", sigla_ext: "BHR")
  s68.translations.where(locale: "en").first_or_create.update_attributes(description: "Bahrain")
 s69 = Stato.create( description: "Bangladesh", continente_id: a4.id, sigla: "BD", sigla_ext: "BGD")
  s69.translations.where(locale: "en").first_or_create.update_attributes(description: "Bangladesh")
 s74 = Stato.create( description: "Bhutan", continente_id: a4.id, sigla: "BT", sigla_ext: "BTN")
  s74.translations.where(locale: "en").first_or_create.update_attributes(description: "Bhutan")
 s79 = Stato.create( description: "British Indian Ocean Territory", continente_id: a4.id, sigla: "IO", sigla_ext: "IOT")
  s79.translations.where(locale: "en").first_or_create.update_attributes(description: "British Indian Ocean Territory")
 s80 = Stato.create( description: "Brunei Darussalam", continente_id: a4.id, sigla: "BN", sigla_ext: "BRN")
  s80.translations.where(locale: "en").first_or_create.update_attributes(description: "Brunei Darussalam")
 s83 = Stato.create( description: "Cambodia", continente_id: a4.id, sigla: "KH", sigla_ext: "KHM")
  s83.translations.where(locale: "en").first_or_create.update_attributes(description: "Cambodia")
 s91 = Stato.create( description: "China", continente_id: a4.id, sigla: "CN", sigla_ext: "CHN")
  s91.translations.where(locale: "en").first_or_create.update_attributes(description: "China")
 s92 = Stato.create( description: "Christmas Island", continente_id: a4.id, sigla: "CX", sigla_ext: "CXR")
  s92.translations.where(locale: "en").first_or_create.update_attributes(description: "Christmas Island")
 s93 = Stato.create( description: "Cocos (Keeling) Islands", continente_id: a4.id, sigla: "CC", sigla_ext: "CCK")
  s93.translations.where(locale: "en").first_or_create.update_attributes(description: "Cocos (Keeling) Islands")
 s102 = Stato.create( description: "Cyprus", continente_id: a4.id, sigla: "CY", sigla_ext: "CYP")
  s102.translations.where(locale: "en").first_or_create.update_attributes(description: "Cyprus")
 s119 = Stato.create( description: "Georgia", continente_id: a4.id, sigla: "GE", sigla_ext: "GEO")
  s119.translations.where(locale: "en").first_or_create.update_attributes(description: "Georgia")
 s132 = Stato.create( description: "Hong Kong", continente_id: a4.id, sigla: "HK", sigla_ext: "HKG")
  s132.translations.where(locale: "en").first_or_create.update_attributes(description: "Hong Kong")
 s133 = Stato.create( description: "India", continente_id: a4.id, sigla: "IN", sigla_ext: "IND")
  s133.translations.where(locale: "en").first_or_create.update_attributes(description: "India")
 s134 = Stato.create( description: "Indonesia", continente_id: a4.id, sigla: "ID", sigla_ext: "IDN")
  s134.translations.where(locale: "en").first_or_create.update_attributes(description: "Indonesia")
 s135 = Stato.create( description: "Iran, Islamic Republic of", continente_id: a4.id, sigla: "IR", sigla_ext: "IRN")
  s135.translations.where(locale: "en").first_or_create.update_attributes(description: "Iran, Islamic Republic of")
 s136 = Stato.create( description: "Iraq", continente_id: a4.id, sigla: "IQ", sigla_ext: "IRQ")
  s136.translations.where(locale: "en").first_or_create.update_attributes(description: "Iraq")
 s137 = Stato.create( description: "Israel", continente_id: a4.id, sigla: "IL", sigla_ext: "ISR")
  s137.translations.where(locale: "en").first_or_create.update_attributes(description: "Israel")
 s139 = Stato.create( description: "Japan", continente_id: a4.id, sigla: "JP", sigla_ext: "JPN")
  s139.translations.where(locale: "en").first_or_create.update_attributes(description: "Japan")
 s140 = Stato.create( description: "Jordan", continente_id: a4.id, sigla: "JO", sigla_ext: "JOR")
  s140.translations.where(locale: "en").first_or_create.update_attributes(description: "Jordan")
 s141 = Stato.create( description: "Kazakhstan", continente_id: a4.id, sigla: "KZ", sigla_ext: "KAZ")
  s141.translations.where(locale: "en").first_or_create.update_attributes(description: "Kazakhstan")
 s144 = Stato.create( description: "Korea, Democratic People's Republic of", continente_id: a4.id, sigla: "KP", sigla_ext: "PRK")
  s144.translations.where(locale: "en").first_or_create.update_attributes(description: "Korea, Democratic People's Republic of")
 s145 = Stato.create( description: "Korea, Republic of", continente_id: a4.id, sigla: "KR", sigla_ext: "KOR")
  s145.translations.where(locale: "en").first_or_create.update_attributes(description: "Korea, Republic of")
 s146 = Stato.create( description: "Kuwait", continente_id: a4.id, sigla: "KW", sigla_ext: "KWT")
  s146.translations.where(locale: "en").first_or_create.update_attributes(description: "Kuwait")
 s147 = Stato.create( description: "Kyrgyzstan", continente_id: a4.id, sigla: "KG", sigla_ext: "KGZ")
  s147.translations.where(locale: "en").first_or_create.update_attributes(description: "Kyrgyzstan")
 s148 = Stato.create( description: "Lao People's Democratic Republic", continente_id: a4.id, sigla: "LA", sigla_ext: "LAO")
  s148.translations.where(locale: "en").first_or_create.update_attributes(description: "Lao People's Democratic Republic")
 s149 = Stato.create( description: "Lebanon", continente_id: a4.id, sigla: "LB", sigla_ext: "LBN")
  s149.translations.where(locale: "en").first_or_create.update_attributes(description: "Lebanon")
 s153 = Stato.create( description: "Macao", continente_id: a4.id, sigla: "MO", sigla_ext: "MAC")
  s153.translations.where(locale: "en").first_or_create.update_attributes(description: "Macao")
 s156 = Stato.create( description: "Malaysia", continente_id: a4.id, sigla: "MY", sigla_ext: "MYS")
  s156.translations.where(locale: "en").first_or_create.update_attributes(description: "Malaysia")
 s157 = Stato.create( description: "Maldives", continente_id: a4.id, sigla: "MV", sigla_ext: "MDV")
  s157.translations.where(locale: "en").first_or_create.update_attributes(description: "Maldives")
 s166 = Stato.create( description: "Mongolia", continente_id: a4.id, sigla: "MN", sigla_ext: "MNG")
  s166.translations.where(locale: "en").first_or_create.update_attributes(description: "Mongolia")
 s170 = Stato.create( description: "Myanmar", continente_id: a4.id, sigla: "MM", sigla_ext: "MMR")
  s170.translations.where(locale: "en").first_or_create.update_attributes(description: "Myanmar")
 s173 = Stato.create( description: "Nepal", continente_id: a4.id, sigla: "NP", sigla_ext: "NPL")
  s173.translations.where(locale: "en").first_or_create.update_attributes(description: "Nepal")
 s183 = Stato.create( description: "Oman", continente_id: a4.id, sigla: "OM", sigla_ext: "OMN")
  s183.translations.where(locale: "en").first_or_create.update_attributes(description: "Oman")
 s184 = Stato.create( description: "Pakistan", continente_id: a4.id, sigla: "PK", sigla_ext: "PAK")
  s184.translations.where(locale: "en").first_or_create.update_attributes(description: "Pakistan")
 s186 = Stato.create( description: "Palestinian Territory", continente_id: a4.id, sigla: "PS", sigla_ext: "PSE")
  s186.translations.where(locale: "en").first_or_create.update_attributes(description: "Palestinian Territory")
 s191 = Stato.create( description: "Philippines", continente_id: a4.id, sigla: "PH", sigla_ext: "PHL")
  s191.translations.where(locale: "en").first_or_create.update_attributes(description: "Philippines")
 s194 = Stato.create( description: "Qatar", continente_id: a4.id, sigla: "QA", sigla_ext: "QAT")
  s194.translations.where(locale: "en").first_or_create.update_attributes(description: "Qatar")
 s206 = Stato.create( description: "Saudi Arabia", continente_id: a4.id, sigla: "SA", sigla_ext: "SAU")
  s206.translations.where(locale: "en").first_or_create.update_attributes(description: "Saudi Arabia")
 s210 = Stato.create( description: "Singapore", continente_id: a4.id, sigla: "SG", sigla_ext: "SGP")
  s210.translations.where(locale: "en").first_or_create.update_attributes(description: "Singapore")
 s215 = Stato.create( description: "Sri Lanka", continente_id: a4.id, sigla: "LK", sigla_ext: "LKA")
  s215.translations.where(locale: "en").first_or_create.update_attributes(description: "Sri Lanka")
 s219 = Stato.create( description: "Syrian Arab Republic", continente_id: a4.id, sigla: "SY", sigla_ext: "SYR")
  s219.translations.where(locale: "en").first_or_create.update_attributes(description: "Syrian Arab Republic")
 s220 = Stato.create( description: "Taiwan, Province of China", continente_id: a4.id, sigla: "TW", sigla_ext: "TWN")
  s220.translations.where(locale: "en").first_or_create.update_attributes(description: "Taiwan, Province of China")
 s221 = Stato.create( description: "Tajikistan", continente_id: a4.id, sigla: "TJ", sigla_ext: "TJK")
  s221.translations.where(locale: "en").first_or_create.update_attributes(description: "Tajikistan")
 s223 = Stato.create( description: "Thailand", continente_id: a4.id, sigla: "TH", sigla_ext: "THA")
  s223.translations.where(locale: "en").first_or_create.update_attributes(description: "Thailand")
 s224 = Stato.create( description: "Timor-Leste", continente_id: a4.id, sigla: "TL", sigla_ext: "TLS")
  s224.translations.where(locale: "en").first_or_create.update_attributes(description: "Timor-Leste")
 s230 = Stato.create( description: "Turkey", continente_id: a4.id, sigla: "TR", sigla_ext: "TUR")
  s230.translations.where(locale: "en").first_or_create.update_attributes(description: "Turkey")
 s231 = Stato.create( description: "Turkmenistan", continente_id: a4.id, sigla: "TM", sigla_ext: "TKM")
  s231.translations.where(locale: "en").first_or_create.update_attributes(description: "Turkmenistan")
 s235 = Stato.create( description: "United Arab Emirates", continente_id: a4.id, sigla: "AE", sigla_ext: "ARE")
  s235.translations.where(locale: "en").first_or_create.update_attributes(description: "United Arab Emirates")
 s239 = Stato.create( description: "Uzbekistan", continente_id: a4.id, sigla: "UZ", sigla_ext: "UZB")
  s239.translations.where(locale: "en").first_or_create.update_attributes(description: "Uzbekistan")
 s242 = Stato.create( description: "Viet Nam", continente_id: a4.id, sigla: "VN", sigla_ext: "VNM")
  s242.translations.where(locale: "en").first_or_create.update_attributes(description: "Viet Nam")
 s245 = Stato.create( description: "Yemen", continente_id: a4.id, sigla: "YE", sigla_ext: "YEM")
  s245.translations.where(locale: "en").first_or_create.update_attributes(description: "Yemen")
a5 = Continente.create(description: "Oceania")
  a5.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Oceania")
  a5.translations.where(locale: "en").first_or_create.update_attributes(description: "Oceania")
  a5.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Oceania")
  a5.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Oceanía")
  a5.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "Oceanía")
  a5.translations.where(locale: "fr").first_or_create.update_attributes(description: "Océanie")
  a5.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Oceania")
  a5.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "Oceania")
 s57 = Stato.create( description: "American Samoa", continente_id: a5.id, sigla: "AS", sigla_ext: "ASM")
  s57.translations.where(locale: "en").first_or_create.update_attributes(description: "American Samoa")
 s65 = Stato.create( description: "Australia", continente_id: a5.id, sigla: "AU", sigla_ext: "AUS")
  s65.translations.where(locale: "en").first_or_create.update_attributes(description: "Australia")
 s98 = Stato.create( description: "Cook Islands", continente_id: a5.id, sigla: "CK", sigla_ext: "COK")
  s98.translations.where(locale: "en").first_or_create.update_attributes(description: "Cook Islands")
 s113 = Stato.create( description: "Fiji", continente_id: a5.id, sigla: "FJ", sigla_ext: "FJI")
  s113.translations.where(locale: "en").first_or_create.update_attributes(description: "Fiji")
 s115 = Stato.create( description: "French Polynesia", continente_id: a5.id, sigla: "PF", sigla_ext: "PYF")
  s115.translations.where(locale: "en").first_or_create.update_attributes(description: "French Polynesia")
 s124 = Stato.create( description: "Guam", continente_id: a5.id, sigla: "GU", sigla_ext: "GUM")
  s124.translations.where(locale: "en").first_or_create.update_attributes(description: "Guam")
 s143 = Stato.create( description: "Kiribati", continente_id: a5.id, sigla: "KI", sigla_ext: "KIR")
  s143.translations.where(locale: "en").first_or_create.update_attributes(description: "Kiribati")
 s159 = Stato.create( description: "Marshall Islands", continente_id: a5.id, sigla: "MH", sigla_ext: "MHL")
  s159.translations.where(locale: "en").first_or_create.update_attributes(description: "Marshall Islands")
 s165 = Stato.create( description: "Micronesia, Federated States of", continente_id: a5.id, sigla: "FM", sigla_ext: "FSM")
  s165.translations.where(locale: "en").first_or_create.update_attributes(description: "Micronesia, Federated States of")
 s172 = Stato.create( description: "Nauru", continente_id: a5.id, sigla: "NR", sigla_ext: "NRU")
  s172.translations.where(locale: "en").first_or_create.update_attributes(description: "Nauru")
 s175 = Stato.create( description: "New Caledonia", continente_id: a5.id, sigla: "NC", sigla_ext: "NCL")
  s175.translations.where(locale: "en").first_or_create.update_attributes(description: "New Caledonia")
 s176 = Stato.create( description: "New Zealand", continente_id: a5.id, sigla: "NZ", sigla_ext: "NZL")
  s176.translations.where(locale: "en").first_or_create.update_attributes(description: "New Zealand")
 s180 = Stato.create( description: "Niue", continente_id: a5.id, sigla: "NU", sigla_ext: "NIU")
  s180.translations.where(locale: "en").first_or_create.update_attributes(description: "Niue")
 s181 = Stato.create( description: "Norfolk Island", continente_id: a5.id, sigla: "NF", sigla_ext: "NFK")
  s181.translations.where(locale: "en").first_or_create.update_attributes(description: "Norfolk Island")
 s182 = Stato.create( description: "Northern Mariana Islands", continente_id: a5.id, sigla: "MP", sigla_ext: "MNP")
  s182.translations.where(locale: "en").first_or_create.update_attributes(description: "Northern Mariana Islands")
 s185 = Stato.create( description: "Palau", continente_id: a5.id, sigla: "PW", sigla_ext: "PLW")
  s185.translations.where(locale: "en").first_or_create.update_attributes(description: "Palau")
 s188 = Stato.create( description: "Papua New Guinea", continente_id: a5.id, sigla: "PG", sigla_ext: "PNG")
  s188.translations.where(locale: "en").first_or_create.update_attributes(description: "Papua New Guinea")
 s192 = Stato.create( description: "Pitcairn", continente_id: a5.id, sigla: "PN", sigla_ext: "PCN")
  s192.translations.where(locale: "en").first_or_create.update_attributes(description: "Pitcairn")
 s204 = Stato.create( description: "Samoa", continente_id: a5.id, sigla: "WS", sigla_ext: "WSM")
  s204.translations.where(locale: "en").first_or_create.update_attributes(description: "Samoa")
 s211 = Stato.create( description: "Solomon Islands", continente_id: a5.id, sigla: "SB", sigla_ext: "SLB")
  s211.translations.where(locale: "en").first_or_create.update_attributes(description: "Solomon Islands")
 s226 = Stato.create( description: "Tokelau", continente_id: a5.id, sigla: "TK", sigla_ext: "TKL")
  s226.translations.where(locale: "en").first_or_create.update_attributes(description: "Tokelau")
 s227 = Stato.create( description: "Tonga", continente_id: a5.id, sigla: "TO", sigla_ext: "TON")
  s227.translations.where(locale: "en").first_or_create.update_attributes(description: "Tonga")
 s233 = Stato.create( description: "Tuvalu", continente_id: a5.id, sigla: "TV", sigla_ext: "TUV")
  s233.translations.where(locale: "en").first_or_create.update_attributes(description: "Tuvalu")
 s237 = Stato.create( description: "United States Minor Outlying Islands", continente_id: a5.id, sigla: "UM", sigla_ext: "UMI")
  s237.translations.where(locale: "en").first_or_create.update_attributes(description: "United States Minor Outlying Islands")
 s240 = Stato.create( description: "Vanuatu", continente_id: a5.id, sigla: "VU", sigla_ext: "VUT")
  s240.translations.where(locale: "en").first_or_create.update_attributes(description: "Vanuatu")
 s244 = Stato.create( description: "Wallis e Futuna", continente_id: a5.id, sigla: "WF", sigla_ext: "WLF")
  s244.translations.where(locale: "en").first_or_create.update_attributes(description: "Wallis e Futuna")
a1 = Continente.create(description: "Europe")
  a1.translations.where(locale: "en").first_or_create.update_attributes(description: "Europe")
  a1.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Europe")
  a1.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Europa")
  a1.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "Europa")
  a1.translations.where(locale: "fr").first_or_create.update_attributes(description: "Europe")
  a1.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Europa")
  a1.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "Europa")
  a1.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Europa")
 s4 = Stato.create( description: "Åland Islands", continente_id: a1.id, sigla: "AX", sigla_ext: "ALA")
  s4.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Åland Islands")
  s4.translations.where(locale: "en").first_or_create.update_attributes(description: "Åland Islands")
  s4.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Isole Åland")
  s4.translations.where(locale: "de").first_or_create.update_attributes(description: "Åland-Inseln")
  s4.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Islas Åland")
  s4.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Ilhas Aland")
 s5 = Stato.create( description: "Albania", continente_id: a1.id, sigla: "AL", sigla_ext: "ALB")
  s5.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Albania")
  s5.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Albania")
  s5.translations.where(locale: "en").first_or_create.update_attributes(description: "Albania")
  s5.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Albania")
  s5.translations.where(locale: "de").first_or_create.update_attributes(description: " Albanien")
  s5.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Albânia")
 s6 = Stato.create( description: "Andorra", continente_id: a1.id, sigla: "AD", sigla_ext: "AND")
  s6.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Andorra")
  s6.translations.where(locale: "en").first_or_create.update_attributes(description: "Andorra")
  s6.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Andorra")
  s6.translations.where(locale: "de").first_or_create.update_attributes(description: "Andorra")
  s6.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Andora")
  s6.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Andorra")
 s7 = Stato.create( description: "Austria", continente_id: a1.id, sigla: "AT", sigla_ext: "AUT")
  s7.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Austria")
  s7.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Austria")
  s7.translations.where(locale: "en").first_or_create.update_attributes(description: "Austria")
  s7.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Austria")
  s7.translations.where(locale: "de").first_or_create.update_attributes(description: "Österreich")
  s7.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Áustria")
 s8 = Stato.create( description: "Belarus", continente_id: a1.id, sigla: "BY", sigla_ext: "BLR")
  s8.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Belarus")
  s8.translations.where(locale: "en").first_or_create.update_attributes(description: "Belarus")
  s8.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Bielorussia")
  s8.translations.where(locale: "de").first_or_create.update_attributes(description: "Weissrußland")
  s8.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Bielorusia")
  s8.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Belarússia")
 s9 = Stato.create( description: "Belgium", continente_id: a1.id, sigla: "BE", sigla_ext: "BEL")
  s9.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Belgium")
  s9.translations.where(locale: "en").first_or_create.update_attributes(description: "Belgium")
  s9.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Belgio")
  s9.translations.where(locale: "de").first_or_create.update_attributes(description: "Belgien")
  s9.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Bélgica")
  s9.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Bélgica")
 s10 = Stato.create( description: "Bosnia and Herzegovina", continente_id: a1.id, sigla: "BA", sigla_ext: "BIH")
  s10.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Bosnia and Herzegovina")
  s10.translations.where(locale: "en").first_or_create.update_attributes(description: "Bosnia and Herzegovina")
  s10.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Bosnia ed Erzegovina")
  s10.translations.where(locale: "de").first_or_create.update_attributes(description: "Bosnien und Herzogowina")
  s10.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Bósnia Herzegovina")
  s10.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Bósnia Herzegovina")
 s11 = Stato.create( description: "Bulgaria", continente_id: a1.id, sigla: "BG", sigla_ext: "BGR")
  s11.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Bulgaria")
  s11.translations.where(locale: "en").first_or_create.update_attributes(description: "Bulgaria")
  s11.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Bulgaria")
  s11.translations.where(locale: "de").first_or_create.update_attributes(description: "Bulgarien")
  s11.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Bulgária")
  s11.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Bulgária")
 s12 = Stato.create( description: "Croatia", continente_id: a1.id, sigla: "HR", sigla_ext: "HRV")
  s12.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Croatia")
  s12.translations.where(locale: "en").first_or_create.update_attributes(description: "Croatia")
  s12.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Croazia")
  s12.translations.where(locale: "de").first_or_create.update_attributes(description: "Kroatien")
  s12.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Croácia")
  s12.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Croácia")
 s13 = Stato.create( description: "Czech Republic", continente_id: a1.id, sigla: "CZ", sigla_ext: "CZE")
  s13.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Repubblica Ceca")
  s13.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Czech Republic")
  s13.translations.where(locale: "en").first_or_create.update_attributes(description: "Czech Republic")
  s13.translations.where(locale: "de").first_or_create.update_attributes(description: "Tschechische Republik")
  s13.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "República Checa")
  s13.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "República Checa")
 s14 = Stato.create( description: "Denmark", continente_id: a1.id, sigla: "DK", sigla_ext: "DNK")
  s14.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Danimarca")
  s14.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Denmark")
  s14.translations.where(locale: "en").first_or_create.update_attributes(description: "Denmark")
  s14.translations.where(locale: "de").first_or_create.update_attributes(description: "Dänemark")
  s14.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Dinamarca")
  s14.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Dinamarca")
 s15 = Stato.create( description: "Estonia", continente_id: a1.id, sigla: "EE", sigla_ext: "EST")
  s15.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Estonia")
  s15.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Estonia")
  s15.translations.where(locale: "en").first_or_create.update_attributes(description: "Estonia")
  s15.translations.where(locale: "de").first_or_create.update_attributes(description: "Estland")
  s15.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Estónia")
  s15.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Estónia")
 s16 = Stato.create( description: "Faroe Islands", continente_id: a1.id, sigla: "FO", sigla_ext: "FRO")
  s16.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Isole Fær Øer")
  s16.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Faroe Islands")
  s16.translations.where(locale: "en").first_or_create.update_attributes(description: "Faroe Islands")
  s16.translations.where(locale: "de").first_or_create.update_attributes(description: "Faroe Inseln")
  s16.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Islas Faroe")
  s16.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Ilhas Faroe")
 s17 = Stato.create( description: "Finland", continente_id: a1.id, sigla: "FI", sigla_ext: "FIN")
  s17.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Finlandia")
  s17.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Finland")
  s17.translations.where(locale: "en").first_or_create.update_attributes(description: "Finland")
  s17.translations.where(locale: "de").first_or_create.update_attributes(description: "Finnland")
  s17.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Finlândia")
  s17.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Finlândia")
 s18 = Stato.create( description: "France", continente_id: a1.id, sigla: "FR", sigla_ext: "FRA")
  s18.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Francia")
  s18.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Francia")
  s18.translations.where(locale: "en-US").first_or_create.update_attributes(description: "France")
  s18.translations.where(locale: "en").first_or_create.update_attributes(description: "France")
  s18.translations.where(locale: "de").first_or_create.update_attributes(description: "Frankreich")
  s18.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "França")
 s19 = Stato.create( description: "Germany", continente_id: a1.id, sigla: "DE", sigla_ext: "DEU")
  s19.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Germania")
  s19.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Germany")
  s19.translations.where(locale: "en").first_or_create.update_attributes(description: "Germany")
  s19.translations.where(locale: "de").first_or_create.update_attributes(description: "Deutschland")
  s19.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Alemania")
  s19.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Alemanha")
 s20 = Stato.create( description: "Gibraltar", continente_id: a1.id, sigla: "GI", sigla_ext: "GIB")
  s20.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Gibilterra")
  s20.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Gibraltar")
  s20.translations.where(locale: "en").first_or_create.update_attributes(description: "Gibraltar")
  s20.translations.where(locale: "de").first_or_create.update_attributes(description: "Gibraltar")
  s20.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Gibraltar")
  s20.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Gibraltar")
 s21 = Stato.create( description: "Greece", continente_id: a1.id, sigla: "GR", sigla_ext: "GRC")
  s21.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Grecia")
  s21.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Greece")
  s21.translations.where(locale: "en").first_or_create.update_attributes(description: "Greece")
  s21.translations.where(locale: "de").first_or_create.update_attributes(description: "Griechenland")
  s21.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Grécia")
  s21.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Grécia")
 s22 = Stato.create( description: "Guernsey", continente_id: a1.id, sigla: "GG", sigla_ext: "GGY")
  s22.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Guernsey")
  s22.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Guernsey")
  s22.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Guernsey")
  s22.translations.where(locale: "en").first_or_create.update_attributes(description: "Guernsey")
  s22.translations.where(locale: "de").first_or_create.update_attributes(description: "Guernsey")
  s22.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Guernsey")
 s23 = Stato.create( description: "Hungary", continente_id: a1.id, sigla: "HU", sigla_ext: "HUN")
  s23.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Ungheria")
  s23.translations.where(locale: "en").first_or_create.update_attributes(description: "Hungary")
  s23.translations.where(locale: "de").first_or_create.update_attributes(description: "Ungarn")
  s23.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Hungary")
  s23.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Hungria")
  s23.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Hungria")
 s24 = Stato.create( description: "Iceland", continente_id: a1.id, sigla: "IS", sigla_ext: "ISL")
  s24.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Islanda")
  s24.translations.where(locale: "en").first_or_create.update_attributes(description: "Iceland")
  s24.translations.where(locale: "de").first_or_create.update_attributes(description: "Island")
  s24.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Iceland")
  s24.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Islândia")
  s24.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Islândia")
 s25 = Stato.create( description: "Ireland", continente_id: a1.id, sigla: "IE", sigla_ext: "IRL")
  s25.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Irlanda")
  s25.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Irlanda")
  s25.translations.where(locale: "en").first_or_create.update_attributes(description: "Ireland")
  s25.translations.where(locale: "de").first_or_create.update_attributes(description: "Irland")
  s25.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Ireland")
  s25.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Irlanda")
 s26 = Stato.create( description: "Isle of Man", continente_id: a1.id, sigla: "IM", sigla_ext: "IMN")
  s26.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Isola di Man")
  s26.translations.where(locale: "en").first_or_create.update_attributes(description: "Isle of Man")
  s26.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Isle of Man")
  s26.translations.where(locale: "de").first_or_create.update_attributes(description: "Isle of Man")
  s26.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Isla de Man")
  s26.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Ilha de Man")
 s1 = Stato.create( description: "Italy", continente_id: a1.id, sigla: "IT", sigla_ext: "ITA")
  s1.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Italia")
  s1.translations.where(locale: "en").first_or_create.update_attributes(description: "Italy")
  s1.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Italy")
  s1.translations.where(locale: "de").first_or_create.update_attributes(description: "Italien")
  s1.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Italia")
  s1.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Itália")
  r20 = Regione.create(description: "Umbria", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Perugia", regione_id: r20.id, stato_id: s1.id, continente_id: a1.id, sigla: "PG"){ |c| c.id = 88}.save
   Provincia.create(description: "Terni", regione_id: r20.id, stato_id: s1.id, continente_id: a1.id, sigla: "TR"){ |c| c.id = 89}.save
  r19 = Regione.create(description: "Lombardia", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Bergamo", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "BG"){ |c| c.id = 90}.save
   Provincia.create(description: "Brescia", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "BS"){ |c| c.id = 91}.save
   Provincia.create(description: "Como", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "CO"){ |c| c.id = 92}.save
   Provincia.create(description: "Cremona", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "CR"){ |c| c.id = 93}.save
   Provincia.create(description: "Lecco", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "LC"){ |c| c.id = 94}.save
   Provincia.create(description: "Lodi", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "LO"){ |c| c.id = 95}.save
   Provincia.create(description: "Mantova", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "MN"){ |c| c.id = 96}.save
   Provincia.create(description: "Milano", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "MI"){ |c| c.id = 97}.save
   Provincia.create(description: "Pavia", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "PV"){ |c| c.id = 98}.save
   Provincia.create(description: "Sondrio", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "SO"){ |c| c.id = 99}.save
   Provincia.create(description: "Varese", regione_id: r19.id, stato_id: s1.id, continente_id: a1.id, sigla: "VA"){ |c| c.id = 100}.save
  r18 = Regione.create(description: "Liguria", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Genova", regione_id: r18.id, stato_id: s1.id, continente_id: a1.id, sigla: "GE"){ |c| c.id = 82}.save
   Provincia.create(description: "Imperia", regione_id: r18.id, stato_id: s1.id, continente_id: a1.id, sigla: "IM"){ |c| c.id = 83}.save
   Provincia.create(description: "Savona", regione_id: r18.id, stato_id: s1.id, continente_id: a1.id, sigla: "SV"){ |c| c.id = 84}.save
   Provincia.create(description: "La Spezia", regione_id: r18.id, stato_id: s1.id, continente_id: a1.id, sigla: "SP"){ |c| c.id = 85}.save
  r17 = Regione.create(description: "Veneto", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Belluno", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "BL"){ |c| c.id = 66}.save
   Provincia.create(description: "Padova", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "PD"){ |c| c.id = 67}.save
   Provincia.create(description: "Rovigo", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "RO"){ |c| c.id = 68}.save
   Provincia.create(description: "Treviso", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "TV"){ |c| c.id = 69}.save
   Provincia.create(description: "Venezia", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "VE"){ |c| c.id = 70}.save
   Provincia.create(description: "Verona", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "VR"){ |c| c.id = 71}.save
   Provincia.create(description: "Vicenza", regione_id: r17.id, stato_id: s1.id, continente_id: a1.id, sigla: "VI"){ |c| c.id = 72}.save
  r16 = Regione.create(description: "Valle d'Aosta", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Aosta", regione_id: r16.id, stato_id: s1.id, continente_id: a1.id, sigla: "AO"){ |c| c.id = 77}.save
  r15 = Regione.create(description: "Friuli Venezia Giulia", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Gorizia", regione_id: r15.id, stato_id: s1.id, continente_id: a1.id, sigla: "GO"){ |c| c.id = 73}.save
   Provincia.create(description: "Pordenone", regione_id: r15.id, stato_id: s1.id, continente_id: a1.id, sigla: "PN"){ |c| c.id = 74}.save
   Provincia.create(description: "Udine", regione_id: r15.id, stato_id: s1.id, continente_id: a1.id, sigla: "UD"){ |c| c.id = 75}.save
   Provincia.create(description: "Trieste", regione_id: r15.id, stato_id: s1.id, continente_id: a1.id, sigla: "TS"){ |c| c.id = 76}.save
  r14 = Regione.create(description: "Emilia Romagna", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Bologna", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "BO"){ |c| c.id = 57}.save
   Provincia.create(description: "Ferrara", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "FE"){ |c| c.id = 58}.save
   Provincia.create(description: "Forlì Cesena", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "FC"){ |c| c.id = 59}.save
   Provincia.create(description: "Modena", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "MO"){ |c| c.id = 60}.save
   Provincia.create(description: "Parma", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "PR"){ |c| c.id = 61}.save
   Provincia.create(description: "Piacenza", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "PC"){ |c| c.id = 62}.save
   Provincia.create(description: "Ravenna", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "RA"){ |c| c.id = 63}.save
   Provincia.create(description: "Reggio Emilia", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "RE"){ |c| c.id = 64}.save
   Provincia.create(description: "Rimini", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "RN"){ |c| c.id = 65}.save
  r13 = Regione.create(description: "Piemonte", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Alessandria", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "AL"){ |c| c.id = 5}.save
   Provincia.create(description: "Asti", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "AT"){ |c| c.id = 6}.save
   Provincia.create(description: "Biella", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "BI"){ |c| c.id = 7}.save
   Provincia.create(description: "Cuneo", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "CN"){ |c| c.id = 8}.save
   Provincia.create(description: "Novara", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "NO"){ |c| c.id = 9}.save
   Provincia.create(description: "Vercelli", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "VC"){ |c| c.id = 10}.save
   Provincia.create(description: "Torino", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "TO"){ |c| c.id = 11}.save
   Provincia.create(description: "Verbania", regione_id: r13.id, stato_id: s1.id, continente_id: a1.id, sigla: "VB"){ |c| c.id = 104}.save
  r12 = Regione.create(description: "Toscana", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Arezzo", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "AR"){ |c| c.id = 48}.save
   Provincia.create(description: "Firenze", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "FI"){ |c| c.id = 49}.save
   Provincia.create(description: "Grosseto", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "GR"){ |c| c.id = 50}.save
   Provincia.create(description: "Livorno", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "LI"){ |c| c.id = 51}.save
   Provincia.create(description: "Lucca", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "LU"){ |c| c.id = 52}.save
   Provincia.create(description: "Massa Carrara", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "MS"){ |c| c.id = 53}.save
   Provincia.create(description: "Pisa", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "PI"){ |c| c.id = 54}.save
   Provincia.create(description: "Pistoia", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "PT"){ |c| c.id = 55}.save
   Provincia.create(description: "Siena", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "SI"){ |c| c.id = 56}.save
   Provincia.create(description: "Prato", regione_id: r12.id, stato_id: s1.id, continente_id: a1.id, sigla: "PO"){ |c| c.id = 103}.save
  r11 = Regione.create(description: "Sicilia", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Agrigento", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "AG"){ |c| c.id = 12}.save
   Provincia.create(description: "Caltanissetta", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "CL"){ |c| c.id = 13}.save
   Provincia.create(description: "Catania", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "CT"){ |c| c.id = 14}.save
   Provincia.create(description: "Enna", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "EN"){ |c| c.id = 15}.save
   Provincia.create(description: "Messina", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "ME"){ |c| c.id = 16}.save
   Provincia.create(description: "Palermo", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "PA"){ |c| c.id = 17}.save
   Provincia.create(description: "Ragusa", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "RG"){ |c| c.id = 18}.save
   Provincia.create(description: "Siracusa", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "SR"){ |c| c.id = 19}.save
   Provincia.create(description: "Trapani", regione_id: r11.id, stato_id: s1.id, continente_id: a1.id, sigla: "TP"){ |c| c.id = 20}.save
  r10 = Regione.create(description: "Sardegna", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Cagliari", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "CA"){ |c| c.id = 78}.save
   Provincia.create(description: "Nuoro", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "NU"){ |c| c.id = 79}.save
   Provincia.create(description: "Oristano", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "OR"){ |c| c.id = 80}.save
   Provincia.create(description: "Sassari", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "SS"){ |c| c.id = 81}.save
   Provincia.create(description: "Carbonia Iglesias", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "CI"){ |c| c.id = 105}.save
   Provincia.create(description: "Medio Campidano", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "VS"){ |c| c.id = 106}.save
   Provincia.create(description: "Ogliastra", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "OG"){ |c| c.id = 107}.save
   Provincia.create(description: "Olbia Tempio", regione_id: r10.id, stato_id: s1.id, continente_id: a1.id, sigla: "OT"){ |c| c.id = 108}.save
  r9 = Regione.create(description: "Lazio", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Frosinone", regione_id: r9.id, stato_id: s1.id, continente_id: a1.id, sigla: "FR"){ |c| c.id = 39}.save
   Provincia.create(description: "Latina", regione_id: r9.id, stato_id: s1.id, continente_id: a1.id, sigla: "LT"){ |c| c.id = 40}.save
   Provincia.create(description: "Rieti", regione_id: r9.id, stato_id: s1.id, continente_id: a1.id, sigla: "RI"){ |c| c.id = 41}.save
   Provincia.create(description: "Roma", regione_id: r9.id, stato_id: s1.id, continente_id: a1.id, sigla: "RM"){ |c| c.id = 42}.save
   Provincia.create(description: "Viterbo", regione_id: r9.id, stato_id: s1.id, continente_id: a1.id, sigla: "VT"){ |c| c.id = 43}.save
  r8 = Regione.create(description: "Campania", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Avellino", regione_id: r8.id, stato_id: s1.id, continente_id: a1.id, sigla: "AV"){ |c| c.id = 34}.save
   Provincia.create(description: "Benevento", regione_id: r8.id, stato_id: s1.id, continente_id: a1.id, sigla: "BN"){ |c| c.id = 35}.save
   Provincia.create(description: "Caserta", regione_id: r8.id, stato_id: s1.id, continente_id: a1.id, sigla: "CE"){ |c| c.id = 36}.save
   Provincia.create(description: "Napoli", regione_id: r8.id, stato_id: s1.id, continente_id: a1.id, sigla: "NA"){ |c| c.id = 37}.save
   Provincia.create(description: "Salerno", regione_id: r8.id, stato_id: s1.id, continente_id: a1.id, sigla: "SA"){ |c| c.id = 38}.save
  r7 = Regione.create(description: "Calabria", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Catanzaro", regione_id: r7.id, stato_id: s1.id, continente_id: a1.id, sigla: "CZ"){ |c| c.id = 21}.save
   Provincia.create(description: "Cosenza", regione_id: r7.id, stato_id: s1.id, continente_id: a1.id, sigla: "CS"){ |c| c.id = 22}.save
   Provincia.create(description: "Crotone", regione_id: r7.id, stato_id: s1.id, continente_id: a1.id, sigla: "KR"){ |c| c.id = 23}.save
   Provincia.create(description: "Reggio Calabria", regione_id: r7.id, stato_id: s1.id, continente_id: a1.id, sigla: "RC"){ |c| c.id = 24}.save
   Provincia.create(description: "Vibo Valentia", regione_id: r7.id, stato_id: s1.id, continente_id: a1.id, sigla: "VV"){ |c| c.id = 25}.save
  r6 = Regione.create(description: "Puglia", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Bari", regione_id: r6.id, stato_id: s1.id, continente_id: a1.id, sigla: "BA"){ |c| c.id = 29}.save
   Provincia.create(description: "Brindisi", regione_id: r6.id, stato_id: s1.id, continente_id: a1.id, sigla: "BR"){ |c| c.id = 30}.save
   Provincia.create(description: "Foggia", regione_id: r6.id, stato_id: s1.id, continente_id: a1.id, sigla: "FG"){ |c| c.id = 31}.save
   Provincia.create(description: "Lecce", regione_id: r6.id, stato_id: s1.id, continente_id: a1.id, sigla: "LE"){ |c| c.id = 32}.save
   Provincia.create(description: "Taranto", regione_id: r6.id, stato_id: s1.id, continente_id: a1.id, sigla: "TA"){ |c| c.id = 33}.save
  r5 = Regione.create(description: "Trentino Alto Adige", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Trento", regione_id: r5.id, stato_id: s1.id, continente_id: a1.id, sigla: "TN"){ |c| c.id = 101}.save
   Provincia.create(description: "Bolzano", regione_id: r5.id, stato_id: s1.id, continente_id: a1.id, sigla: "BZ"){ |c| c.id = 102}.save
  r4 = Regione.create(description: "Molise", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Isernia", regione_id: r4.id, stato_id: s1.id, continente_id: a1.id, sigla: "IS"){ |c| c.id = 86}.save
   Provincia.create(description: "Campobasso", regione_id: r4.id, stato_id: s1.id, continente_id: a1.id, sigla: "CB"){ |c| c.id = 87}.save
  r3 = Regione.create(description: "Basilicata", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Matera", regione_id: r3.id, stato_id: s1.id, continente_id: a1.id, sigla: "MT"){ |c| c.id = 27}.save
   Provincia.create(description: "Potenza", regione_id: r3.id, stato_id: s1.id, continente_id: a1.id, sigla: "PZ"){ |c| c.id = 28}.save
  r2 = Regione.create(description: "Abruzzo", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Chieti", regione_id: r2.id, stato_id: s1.id, continente_id: a1.id, sigla: "CH"){ |c| c.id = 44}.save
   Provincia.create(description: "L'Aquila", regione_id: r2.id, stato_id: s1.id, continente_id: a1.id, sigla: "AQ"){ |c| c.id = 45}.save
   Provincia.create(description: "Pescara", regione_id: r2.id, stato_id: s1.id, continente_id: a1.id, sigla: "PE"){ |c| c.id = 46}.save
   Provincia.create(description: "Teramo", regione_id: r2.id, stato_id: s1.id, continente_id: a1.id, sigla: "TE"){ |c| c.id = 47}.save
  r1 = Regione.create(description: "Marche", stato_id: s1.id, continente_id: a1.id)
   Provincia.create(description: "Ancona", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "AN"){ |c| c.id = 1}.save
   Provincia.create(description: "Macerata", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "MC"){ |c| c.id = 2}.save
   Provincia.create(description: "Pesaro Urbino", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "PU"){ |c| c.id = 3}.save
   Provincia.create(description: "Ascoli Piceno", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "AP"){ |c| c.id = 4}.save
   Provincia.create(description: "Carchi", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "CAR"){ |c| c.id = 109}.save
   Provincia.create(description: "Esmeraldas", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "ESM"){ |c| c.id = 110}.save
   Provincia.create(description: "Imbabura", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "IMB"){ |c| c.id = 111}.save
   Provincia.create(description: "Sucumbíos", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "SUC"){ |c| c.id = 112}.save
   Provincia.create(description: "Napo", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "NAP"){ |c| c.id = 113}.save
   Provincia.create(description: "Orellana", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "ORE"){ |c| c.id = 114}.save
   Provincia.create(description: "Pichincha", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "PIC"){ |c| c.id = 115}.save
   Provincia.create(description: "Chimborazo", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "CHI"){ |c| c.id = 116}.save
   Provincia.create(description: "Cotopaxi", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "COT"){ |c| c.id = 117}.save
   Provincia.create(description: "Pastaza", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "PAS"){ |c| c.id = 118}.save
   Provincia.create(description: "Tungurahua", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "TUN"){ |c| c.id = 119}.save
   Provincia.create(description: "Azuay", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "AZU"){ |c| c.id = 120}.save
   Provincia.create(description: "Cañar", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "CAN"){ |c| c.id = 121}.save
   Provincia.create(description: "Morona Santiago", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "MSA"){ |c| c.id = 122}.save
   Provincia.create(description: "El Oro", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "EOR"){ |c| c.id = 123}.save
   Provincia.create(description: "Loja", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "LOJ"){ |c| c.id = 124}.save
   Provincia.create(description: "Zamora Chinchipe", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "ZCH"){ |c| c.id = 125}.save
   Provincia.create(description: "Bolívar", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "BOL"){ |c| c.id = 126}.save
   Provincia.create(description: "Guayas", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "GUA"){ |c| c.id = 127}.save
   Provincia.create(description: "Los Ríos", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "LRI"){ |c| c.id = 128}.save
   Provincia.create(description: "Santa Elena", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "SEL"){ |c| c.id = 129}.save
   Provincia.create(description: "Manabí", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "MAN"){ |c| c.id = 130}.save
   Provincia.create(description: "Santo Domingo de los Tsáchilas", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "SDT"){ |c| c.id = 131}.save
   Provincia.create(description: "Galápagos", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: "GAL"){ |c| c.id = 132}.save
   Provincia.create(description: "Alba", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 133}.save
   Provincia.create(description: "Arad", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 134}.save
   Provincia.create(description: "Argeș", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 135}.save
   Provincia.create(description: "Bacău", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 136}.save
   Provincia.create(description: "Bihor", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 137}.save
   Provincia.create(description: "Bistrița-Năsăud", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 138}.save
   Provincia.create(description: "Botoșani", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 139}.save
   Provincia.create(description: "Brașov", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 140}.save
   Provincia.create(description: "Brăila", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 141}.save
   Provincia.create(description: "Buzău", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 142}.save
   Provincia.create(description: "Caraș-Severin", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 143}.save
   Provincia.create(description: "Călărași", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 144}.save
   Provincia.create(description: "Cluj", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 145}.save
   Provincia.create(description: "Constanța", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 146}.save
   Provincia.create(description: "Covasna", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 147}.save
   Provincia.create(description: "Dâmbovița", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 148}.save
   Provincia.create(description: "Dolj", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 149}.save
   Provincia.create(description: "Galați", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 150}.save
   Provincia.create(description: "Giurgiu", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 151}.save
   Provincia.create(description: "Gorj", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 152}.save
   Provincia.create(description: "Harghita", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 153}.save
   Provincia.create(description: "Hunedoara", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 154}.save
   Provincia.create(description: "Ialomița", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 155}.save
   Provincia.create(description: "Iași", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 156}.save
   Provincia.create(description: "Ilfov", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 157}.save
   Provincia.create(description: "Maramureș", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 158}.save
   Provincia.create(description: "Mehedinți", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 159}.save
   Provincia.create(description: "Mureș", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 160}.save
   Provincia.create(description: "Neamț", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 161}.save
   Provincia.create(description: "Olt", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 162}.save
   Provincia.create(description: "Prahova", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 163}.save
   Provincia.create(description: "Satu Mare", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 164}.save
   Provincia.create(description: "Sălaj", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 165}.save
   Provincia.create(description: "Sibiu", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 166}.save
   Provincia.create(description: "Suceava", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 167}.save
   Provincia.create(description: "Teleorman", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 168}.save
   Provincia.create(description: "Timiș", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 169}.save
   Provincia.create(description: "Tulcea", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 170}.save
   Provincia.create(description: "Vaslui", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 171}.save
   Provincia.create(description: "Vâlcea", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 172}.save
   Provincia.create(description: "Vrancea", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 173}.save
   Provincia.create(description: "Mun. Bucuresti", regione_id: r1.id, stato_id: s1.id, continente_id: a1.id, sigla: ""){ |c| c.id = 174}.save
 s27 = Stato.create( description: "Jersey", continente_id: a1.id, sigla: "JE", sigla_ext: "JEY")
  s27.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Jersey")
  s27.translations.where(locale: "en").first_or_create.update_attributes(description: "Jersey")
  s27.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Jersey")
  s27.translations.where(locale: "de").first_or_create.update_attributes(description: "Jersey")
  s27.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Jersez")
  s27.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Jersey")
 s28 = Stato.create( description: "Kosovo", continente_id: a1.id, sigla: "XK", sigla_ext: "KOS")
  s28.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Kosovo")
  s28.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Kosovo")
  s28.translations.where(locale: "en").first_or_create.update_attributes(description: "Kosovo")
  s28.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Kosovo")
  s28.translations.where(locale: "de").first_or_create.update_attributes(description: "Kosowo")
  s28.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Kosovo")
 s29 = Stato.create( description: "Latvia", continente_id: a1.id, sigla: "LV", sigla_ext: "LVA")
  s29.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Lettonia")
  s29.translations.where(locale: "en").first_or_create.update_attributes(description: "Latvia")
  s29.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Latvia")
  s29.translations.where(locale: "de").first_or_create.update_attributes(description: "Letland")
  s29.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Letónia")
  s29.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Letónia")
 s30 = Stato.create( description: "Liechtenstein", continente_id: a1.id, sigla: "LI", sigla_ext: "LIE")
  s30.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Liechtenstein")
  s30.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Liechtenstein")
  s30.translations.where(locale: "en").first_or_create.update_attributes(description: "Liechtenstein")
  s30.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Liechtenstein")
  s30.translations.where(locale: "de").first_or_create.update_attributes(description: "Liechtenstein")
  s30.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Liechtenstein")
 s31 = Stato.create( description: "Lithuania", continente_id: a1.id, sigla: "LT", sigla_ext: "LTU")
  s31.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Lituania")
  s31.translations.where(locale: "en").first_or_create.update_attributes(description: "Lithuania")
  s31.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Lithuania")
  s31.translations.where(locale: "de").first_or_create.update_attributes(description: "Litauen")
  s31.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Lituânia")
  s31.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Lituânia")
 s32 = Stato.create( description: "Luxembourg", continente_id: a1.id, sigla: "LU", sigla_ext: "LUX")
  s32.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Lussemburgo")
  s32.translations.where(locale: "en").first_or_create.update_attributes(description: "Luxembourg")
  s32.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Luxembourg")
  s32.translations.where(locale: "de").first_or_create.update_attributes(description: "Luxemburg")
  s32.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Luxemburgo")
  s32.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Luxemburgo")
 s33 = Stato.create( description: "Macedonia", continente_id: a1.id, sigla: "MK", sigla_ext: "MKD")
  s33.translations.where(locale: "en").first_or_create.update_attributes(description: "Macedonia")
  s33.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Macedonia")
  s33.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Macedonia")
  s33.translations.where(locale: "de").first_or_create.update_attributes(description: "Mazedonien")
  s33.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Macedónia")
  s33.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Macedónia")
 s34 = Stato.create( description: "Malta", continente_id: a1.id, sigla: "MT", sigla_ext: "MLT")
  s34.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Malta")
  s34.translations.where(locale: "en").first_or_create.update_attributes(description: "Malta")
  s34.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Malta")
  s34.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Malta")
  s34.translations.where(locale: "de").first_or_create.update_attributes(description: "Malta")
  s34.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Malta")
 s35 = Stato.create( description: "Moldova", continente_id: a1.id, sigla: "MD", sigla_ext: "MDA")
  s35.translations.where(locale: "en").first_or_create.update_attributes(description: "Moldova")
  s35.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Moldavia")
  s35.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Moldova")
  s35.translations.where(locale: "de").first_or_create.update_attributes(description: "Moldawien")
  s35.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Moldávia")
  s35.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Moldávia")
 s36 = Stato.create( description: "Monaco", continente_id: a1.id, sigla: "MC", sigla_ext: "MCO")
  s36.translations.where(locale: "en").first_or_create.update_attributes(description: "Monaco")
  s36.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Monaco")
  s36.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Monaco")
  s36.translations.where(locale: "de").first_or_create.update_attributes(description: "Monaco")
  s36.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Mónaco")
  s36.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Mónaco")
 s37 = Stato.create( description: "Montenegro", continente_id: a1.id, sigla: "ME", sigla_ext: "MNE")
  s37.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Montenegro")
  s37.translations.where(locale: "en").first_or_create.update_attributes(description: "Montenegro")
  s37.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Montenegro")
  s37.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Montenegro")
  s37.translations.where(locale: "de").first_or_create.update_attributes(description: "Montenegro")
  s37.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Montenegro")
 s38 = Stato.create( description: "Netherlands", continente_id: a1.id, sigla: "NL", sigla_ext: "NLD")
  s38.translations.where(locale: "en").first_or_create.update_attributes(description: "Netherlands")
  s38.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Olanda")
  s38.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Netherlands")
  s38.translations.where(locale: "de").first_or_create.update_attributes(description: "Holland")
  s38.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Holanda")
  s38.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Holanda")
 s39 = Stato.create( description: "Norway", continente_id: a1.id, sigla: "NO", sigla_ext: "NOR")
  s39.translations.where(locale: "en").first_or_create.update_attributes(description: "Norway")
  s39.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Norvegia")
  s39.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Norway")
  s39.translations.where(locale: "de").first_or_create.update_attributes(description: "Norwegen")
  s39.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Noruega")
  s39.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Noruega")
 s40 = Stato.create( description: "Poland", continente_id: a1.id, sigla: "PL", sigla_ext: "POL")
  s40.translations.where(locale: "en").first_or_create.update_attributes(description: "Poland")
  s40.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Polonia")
  s40.translations.where(locale: "de").first_or_create.update_attributes(description: "Polen")
  s40.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Polónia")
  s40.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Poland")
  s40.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Polónia")
 s41 = Stato.create( description: "Portugal", continente_id: a1.id, sigla: "PT", sigla_ext: "PRT")
  s41.translations.where(locale: "en").first_or_create.update_attributes(description: "Portugal")
  s41.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Portogallo")
  s41.translations.where(locale: "de").first_or_create.update_attributes(description: "Portugal")
  s41.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Portugal")
  s41.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Portugal")
  s41.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Portugal")
 s43 = Stato.create( description: "Russian Federation", continente_id: a1.id, sigla: "RU", sigla_ext: "RUS")
  s43.translations.where(locale: "en").first_or_create.update_attributes(description: "Russian Federation")
  s43.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Russia")
  s43.translations.where(locale: "de").first_or_create.update_attributes(description: "Rußland")
  s43.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Federación Rusa")
  s43.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Russian Federation")
  s43.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Federação Russa")
 s2 = Stato.create( description: "San Marino", continente_id: a1.id, sigla: "SM", sigla_ext: "SMR")
  s2.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "en").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "de").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "en-US").first_or_create.update_attributes(description: "San Marino")
  s2.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "San Marino")
 s44 = Stato.create( description: "Serbia", continente_id: a1.id, sigla: "RS", sigla_ext: "SRB")
  s44.translations.where(locale: "en").first_or_create.update_attributes(description: "Serbia")
  s44.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Serbia")
  s44.translations.where(locale: "de").first_or_create.update_attributes(description: "Serbien")
  s44.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Sérbia")
  s44.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Serbia")
  s44.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Sérvia")
 s45 = Stato.create( description: "Slovakia", continente_id: a1.id, sigla: "SK", sigla_ext: "SVK")
  s45.translations.where(locale: "en").first_or_create.update_attributes(description: "Slovakia")
  s45.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Slovacchia")
  s45.translations.where(locale: "de").first_or_create.update_attributes(description: "Slowakei")
  s45.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Eslovaquia")
  s45.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Slovakia")
  s45.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Eslováquia")
 s46 = Stato.create( description: "Slovenia", continente_id: a1.id, sigla: "SI", sigla_ext: "SVN")
  s46.translations.where(locale: "en").first_or_create.update_attributes(description: "Slovenia")
  s46.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Slovenia")
  s46.translations.where(locale: "de").first_or_create.update_attributes(description: "Slowenien")
  s46.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Eslovénia")
  s46.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Slovenia")
  s46.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Eslovénia")
 s47 = Stato.create( description: "Spain", continente_id: a1.id, sigla: "ES", sigla_ext: "ESP")
  s47.translations.where(locale: "en").first_or_create.update_attributes(description: "Spain")
  s47.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Spagna")
  s47.translations.where(locale: "de").first_or_create.update_attributes(description: "Spanien")
  s47.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "España")
  s47.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Spain")
  s47.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Espanha")
 s48 = Stato.create( description: "Svalbard and Jan Mayen", continente_id: a1.id, sigla: "SJ", sigla_ext: "SJM")
  s48.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
  s48.translations.where(locale: "en").first_or_create.update_attributes(description: "Svalbard and Jan Mayen")
  s48.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
  s48.translations.where(locale: "de").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
  s48.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Svalbard and Jan Mayen")
  s48.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Svalbard e Jan Mayen")
 s49 = Stato.create( description: "Sweden", continente_id: a1.id, sigla: "SE", sigla_ext: "SWE")
  s49.translations.where(locale: "en").first_or_create.update_attributes(description: "Sweden")
  s49.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Svezia")
  s49.translations.where(locale: "de").first_or_create.update_attributes(description: "Schweden")
  s49.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Suécia")
  s49.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Sweden")
  s49.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Suécia")
 s50 = Stato.create( description: "Switzerland", continente_id: a1.id, sigla: "CH", sigla_ext: "CHE")
  s50.translations.where(locale: "en").first_or_create.update_attributes(description: "Switzerland")
  s50.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Svizzera")
  s50.translations.where(locale: "de").first_or_create.update_attributes(description: "Schweiz")
  s50.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Suiza")
  s50.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Switzerland")
  s50.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Suíça")
 s51 = Stato.create( description: "Ukraine", continente_id: a1.id, sigla: "UA", sigla_ext: "UKR")
  s51.translations.where(locale: "en").first_or_create.update_attributes(description: "Ukraine")
  s51.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Ucraina")
  s51.translations.where(locale: "de").first_or_create.update_attributes(description: "Ukraine")
  s51.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Ucrania")
  s51.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Ukraine")
  s51.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Ucrânia")
 s52 = Stato.create( description: "United Kingdom", continente_id: a1.id, sigla: "GB", sigla_ext: "GBR")
  s52.translations.where(locale: "en").first_or_create.update_attributes(description: "United Kingdom")
  s52.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Inghilterra")
  s52.translations.where(locale: "de").first_or_create.update_attributes(description: "Großbritannien")
  s52.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Inglaterra")
  s52.translations.where(locale: "en-US").first_or_create.update_attributes(description: "United Kingdom")
  s52.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Reino Unido")
 s3 = Stato.create( description: "Vatican City State", continente_id: a1.id, sigla: "VA", sigla_ext: "VAT")
  s3.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Città del Vaticano")
  s3.translations.where(locale: "en").first_or_create.update_attributes(description: "Vatican City State")
  s3.translations.where(locale: "de").first_or_create.update_attributes(description: "Vatikan")
  s3.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Cuidad del Vaticaon")
  s3.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Vatican City State")
  s3.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Cidade do Vaticano")
 s42 = Stato.create( description: "Romania", continente_id: a1.id, sigla: "RO", sigla_ext: "ROU")
  s42.translations.where(locale: "en").first_or_create.update_attributes(description: "Romania")
  s42.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Romania")
  s42.translations.where(locale: "de").first_or_create.update_attributes(description: "Rumänien")
  s42.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Roménia")
  s42.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Romania")
  s42.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Roménia")
  s42.translations.where(locale: "ro-RO").first_or_create.update_attributes(description: "România")
  r29 = Regione.create(description: "Bucovina", stato_id: s42.id, continente_id: a1.id)
  r30 = Regione.create(description: "Crișana", stato_id: s42.id, continente_id: a1.id)
  r31 = Regione.create(description: "Dobrogea", stato_id: s42.id, continente_id: a1.id)
  r32 = Regione.create(description: "Oltenia", stato_id: s42.id, continente_id: a1.id)
  r33 = Regione.create(description: "Maramureș", stato_id: s42.id, continente_id: a1.id)
  r34 = Regione.create(description: "Moldova", stato_id: s42.id, continente_id: a1.id)
  r35 = Regione.create(description: "Muntenia", stato_id: s42.id, continente_id: a1.id)
  r36 = Regione.create(description: "Transilvania", stato_id: s42.id, continente_id: a1.id)
  r37 = Regione.create(description: "Banat", stato_id: s42.id, continente_id: a1.id)
a6 = Continente.create(description: "Antarctica")
  a6.translations.where(locale: "it-IT").first_or_create.update_attributes(description: "Antartide")
  a6.translations.where(locale: "en").first_or_create.update_attributes(description: "Antarctica")
  a6.translations.where(locale: "en-US").first_or_create.update_attributes(description: "Antarctica")
  a6.translations.where(locale: "fr").first_or_create.update_attributes(description: "Antarctique")
  a6.translations.where(locale: "pt-PT").first_or_create.update_attributes(description: "Antártida")
  a6.translations.where(locale: "pt-BR").first_or_create.update_attributes(description: "Antártida")
  a6.translations.where(locale: "de").first_or_create.update_attributes(description: "Antarktis")
  a6.translations.where(locale: "es-ES").first_or_create.update_attributes(description: "Antártida")
  a6.translations.where(locale: "es-EC").first_or_create.update_attributes(description: "Antártida")
 s60 = Stato.create( description: "Antarctica", continente_id: a6.id, sigla: "AQ", sigla_ext: "ATA")
  s60.translations.where(locale: "en").first_or_create.update_attributes(description: "Antarctica")
 s77 = Stato.create( description: "Bouvet Island", continente_id: a6.id, sigla: "BV", sigla_ext: "BVT")
  s77.translations.where(locale: "en").first_or_create.update_attributes(description: "Bouvet Island")
 s116 = Stato.create( description: "French Southern Territories", continente_id: a6.id, sigla: "TF", sigla_ext: "ATF")
  s116.translations.where(locale: "en").first_or_create.update_attributes(description: "French Southern Territories")
 s130 = Stato.create( description: "Heard Island and McDonald Islands", continente_id: a6.id, sigla: "HM", sigla_ext: "HMD")
  s130.translations.where(locale: "en").first_or_create.update_attributes(description: "Heard Island and McDonald Islands")
 s214 = Stato.create( description: "South Georgia and the South Sandwich Islands", continente_id: a6.id, sigla: "GS", sigla_ext: "SGS")
  s214.translations.where(locale: "en").first_or_create.update_attributes(description: "South Georgia and the South Sandwich Islands")
