a2 = Continent.new
a2.attributes = {description: 'America', locale: 'en'}
a2.attributes = {description: 'America', locale: 'it'}
a2.attributes = {locale: 'en', description: 'America'}
a2.attributes = {locale: 'en-US', description: 'America'}
a2.attributes = {locale: 'es', description: 'América'}
a2.attributes = {locale: 'es-EC', description: 'América'}
a2.attributes = {locale: 'fr', description: 'Amérique'}
a2.attributes = {locale: 'pt', description: 'América'}
a2.attributes = {locale: 'pt-BR', description: 'América'}
a2.save
countries = []
s53 = Country.new(description: 'Ecuador', continent_id: a2.id, sigla: 'EC', sigla_ext: '')
s53.attributes = {locale: 'it', description: 'Ecuador'}
s53.attributes = {locale: 'en', description: 'Ecuador'}
s53.attributes = {locale: 'en-US', description: 'Ecuador'}
s53.attributes = {locale: 'es', description: 'Ecuador'}
s53.attributes = {locale: 'es-EC', description: 'Ecuador'}
s53.attributes = {locale: 'pt', description: 'Equador'}
s53.attributes = {locale: 'pt-BR', description: 'Equador'}
s53.attributes = {locale: 'fr', description: 'Équateur'}
s53.save
s54 = Country.new(description: 'Brazil', continent_id: a2.id, sigla: 'BR', sigla_ext: '')
s54.attributes = {locale: 'it', description: 'Brasile'}
s54.attributes = {locale: 'en', description: 'Brazil'}
s54.attributes = {locale: 'en-US', description: 'Brazil'}
s54.attributes = {locale: 'fr', description: 'Brésil'}
s54.attributes = {locale: 'pt', description: 'Brasil'}
s54.attributes = {locale: 'pt-BR', description: 'Brasil'}
s54.attributes = {locale: 'de', description: 'Brazil'}
s54.attributes = {locale: 'es', description: 'Brasil'}
s54.attributes = {locale: 'es-EC', description: 'Brasil'}
s54.save
s59 = Country.new(description: 'Anguilla', continent_id: a2.id, sigla: 'AI', sigla_ext: 'AIA')
s59.attributes = {locale: 'en', description: 'Anguilla'}
s59.save
s61 = Country.new(description: 'Antigua and Barbuda', continent_id: a2.id, sigla: 'AG', sigla_ext: 'ATG')
s61.attributes = {locale: 'en', description: 'Antigua and Barbuda'}
s61.save
s62 = Country.new(description: 'Argentina', continent_id: a2.id, sigla: 'AR', sigla_ext: 'ARG')
s62.attributes = {locale: 'en', description: 'Argentina'}
s62.save
s64 = Country.new(description: 'Aruba', continent_id: a2.id, sigla: 'AW', sigla_ext: 'ABW')
s64.attributes = {locale: 'en', description: 'Aruba'}
s64.save
s67 = Country.new(description: 'Bahamas', continent_id: a2.id, sigla: 'BS', sigla_ext: 'BHS')
s67.attributes = {locale: 'en', description: 'Bahamas'}
s67.save
s70 = Country.new(description: 'Barbados', continent_id: a2.id, sigla: 'BB', sigla_ext: 'BRB')
s70.attributes = {locale: 'en', description: 'Barbados'}
s70.save
s71 = Country.new(description: 'Belize', continent_id: a2.id, sigla: 'BZ', sigla_ext: 'BLZ')
s71.attributes = {locale: 'en', description: 'Belize'}
s71.save
s73 = Country.new(description: 'Bermuda', continent_id: a2.id, sigla: 'BM', sigla_ext: 'BMU')
s73.attributes = {locale: 'en', description: 'Bermuda'}
s73.save
s75 = Country.new(description: 'Bolivia, Plurinational State of', continent_id: a2.id, sigla: 'BO', sigla_ext: 'BOL')
s75.attributes = {locale: 'en', description: 'Bolivia, Plurinational State of'}
s75.save
s78 = Country.new(description: 'Brazil', continent_id: a2.id, sigla: 'BR', sigla_ext: 'BRA')
s78.attributes = {locale: 'en', description: 'Brazil'}
s78.save
s85 = Country.new(description: 'Canada', continent_id: a2.id, sigla: 'CA', sigla_ext: 'CAN')
s85.attributes = {locale: 'en', description: 'Canada'}
s85.save
s87 = Country.new(description: 'Cayman Islands', continent_id: a2.id, sigla: 'KY', sigla_ext: 'CYM')
s87.attributes = {locale: 'en', description: 'Cayman Islands'}
s87.save
s90 = Country.new(description: 'Chile', continent_id: a2.id, sigla: 'CL', sigla_ext: 'CHL')
s90.attributes = {locale: 'en', description: 'Chile'}
s90.attributes = {locale: 'es-CL', description: 'Chile'}
s90.save
s94 = Country.new(description: 'Colombia', continent_id: a2.id, sigla: 'CO', sigla_ext: 'COL')
s94.attributes = {locale: 'en', description: 'Colombia'}
s94.save
s99 = Country.new(description: 'Costa Rica', continent_id: a2.id, sigla: 'CR', sigla_ext: 'CRI')
s99.attributes = {locale: 'en', description: 'Costa Rica'}
s99.save
s101 = Country.new(description: 'Cuba', continent_id: a2.id, sigla: 'CU', sigla_ext: 'CUB')
s101.attributes = {locale: 'en', description: 'Cuba'}
s101.save
s104 = Country.new(description: 'Dominica', continent_id: a2.id, sigla: 'DM', sigla_ext: 'DMA')
s104.attributes = {locale: 'en', description: 'Dominica'}
s104.save
s105 = Country.new(description: 'Dominican Republic', continent_id: a2.id, sigla: 'DO', sigla_ext: 'DOM')
s105.attributes = {locale: 'en', description: 'Dominican Republic'}
s105.save
s106 = Country.new(description: 'Ecuador', continent_id: a2.id, sigla: 'EC', sigla_ext: 'ECU')
s106.attributes = {locale: 'en', description: 'Ecuador'}
s106.save
s108 = Country.new(description: 'El Salvador', continent_id: a2.id, sigla: 'SV', sigla_ext: 'SLV')
s108.attributes = {locale: 'en', description: 'El Salvador'}
s108.save
s112 = Country.new(description: 'Falkland Islands (Malvinas)', continent_id: a2.id, sigla: 'FK', sigla_ext: 'FLK')
s112.attributes = {locale: 'en', description: 'Falkland Islands (Malvinas)'}
s112.save
s114 = Country.new(description: 'French Guiana', continent_id: a2.id, sigla: 'GF', sigla_ext: 'GUF')
s114.attributes = {locale: 'en', description: 'French Guiana'}
s114.save
s121 = Country.new(description: 'Greenland', continent_id: a2.id, sigla: 'GL', sigla_ext: 'GRL')
s121.attributes = {locale: 'en', description: 'Greenland'}
s121.save
s122 = Country.new(description: 'Grenada', continent_id: a2.id, sigla: 'GD', sigla_ext: 'GRD')
s122.attributes = {locale: 'en', description: 'Grenada'}
s122.save
s123 = Country.new(description: 'Guadeloupe', continent_id: a2.id, sigla: 'GP', sigla_ext: 'GLP')
s123.attributes = {locale: 'en', description: 'Guadeloupe'}
s123.save
s125 = Country.new(description: 'Guatemala', continent_id: a2.id, sigla: 'GT', sigla_ext: 'GTM')
s125.attributes = {locale: 'en', description: 'Guatemala'}
s125.save
s128 = Country.new(description: 'Guyana', continent_id: a2.id, sigla: 'GY', sigla_ext: 'GUY')
s128.attributes = {locale: 'en', description: 'Guyana'}
s128.save
s129 = Country.new(description: 'Haiti', continent_id: a2.id, sigla: 'HT', sigla_ext: 'HTI')
s129.attributes = {locale: 'en', description: 'Haiti'}
s129.save
s131 = Country.new(description: 'Honduras', continent_id: a2.id, sigla: 'HN', sigla_ext: 'HND')
s131.attributes = {locale: 'en', description: 'Honduras'}
s131.save
s138 = Country.new(description: 'Jamaica', continent_id: a2.id, sigla: 'JM', sigla_ext: 'JAM')
s138.attributes = {locale: 'en', description: 'Jamaica'}
s138.save
s160 = Country.new(description: 'Martinique', continent_id: a2.id, sigla: 'MQ', sigla_ext: 'MTQ')
s160.attributes = {locale: 'en', description: 'Martinique'}
s160.save
s164 = Country.new(description: 'Mexico', continent_id: a2.id, sigla: 'MX', sigla_ext: 'MEX')
s164.attributes = {locale: 'en', description: 'Mexico'}
s164.save
s167 = Country.new(description: 'Montserrat', continent_id: a2.id, sigla: 'MS', sigla_ext: 'MSR')
s167.attributes = {locale: 'en', description: 'Montserrat'}
s167.save
s174 = Country.new(description: 'Netherlands Antilles', continent_id: a2.id, sigla: 'AN', sigla_ext: 'ANT')
s174.attributes = {locale: 'en', description: 'Netherlands Antilles'}
s174.save
s177 = Country.new(description: 'Nicaragua', continent_id: a2.id, sigla: 'NI', sigla_ext: 'NIC')
s177.attributes = {locale: 'en', description: 'Nicaragua'}
s177.save
s187 = Country.new(description: 'Panama', continent_id: a2.id, sigla: 'PA', sigla_ext: 'PAN')
s187.attributes = {locale: 'en', description: 'Panama'}
s187.save
s189 = Country.new(description: 'Paraguay', continent_id: a2.id, sigla: 'PY', sigla_ext: 'PRY')
s189.attributes = {locale: 'en', description: 'Paraguay'}
s189.save
s190 = Country.new(description: 'Peru', continent_id: a2.id, sigla: 'PE', sigla_ext: 'PER')
s190.attributes = {locale: 'en', description: 'Peru'}
s190.save
s193 = Country.new(description: 'Puerto Rico', continent_id: a2.id, sigla: 'PR', sigla_ext: 'PRI')
s193.attributes = {locale: 'en', description: 'Puerto Rico'}
s193.save
s197 = Country.new(description: 'Saint Barth', continent_id: a2.id, sigla: 'BL', sigla_ext: 'BLM')
s197.attributes = {locale: 'en', description: 'Saint Barth'}
s197.save
s199 = Country.new(description: 'Saint Kitts and Nevis', continent_id: a2.id, sigla: 'KN', sigla_ext: 'KNA')
s199.attributes = {locale: 'en', description: 'Saint Kitts and Nevis'}
s199.save
s200 = Country.new(description: 'Saint Lucia', continent_id: a2.id, sigla: 'LC', sigla_ext: 'LCA')
s200.attributes = {locale: 'en', description: 'Saint Lucia'}
s200.save
s201 = Country.new(description: 'Saint Martin (French part)', continent_id: a2.id, sigla: 'MF', sigla_ext: 'MAF')
s201.attributes = {locale: 'en', description: 'Saint Martin (French part)'}
s201.save
s202 = Country.new(description: 'Saint Pierre and Miquelon', continent_id: a2.id, sigla: 'PM', sigla_ext: 'SPM')
s202.attributes = {locale: 'en', description: 'Saint Pierre and Miquelon'}
s202.save
s203 = Country.new(description: 'Saint Vincent and the Grenadines', continent_id: a2.id, sigla: 'VC', sigla_ext: 'VCT')
s203.attributes = {locale: 'en', description: 'Saint Vincent and the Grenadines'}
s203.save
s217 = Country.new(description: 'Suriname', continent_id: a2.id, sigla: 'SR', sigla_ext: 'SUR')
s217.attributes = {locale: 'en', description: 'Suriname'}
s217.save
s228 = Country.new(description: 'Trinidad and Tobago', continent_id: a2.id, sigla: 'TT', sigla_ext: 'TTO')
s228.attributes = {locale: 'en', description: 'Trinidad and Tobago'}
s228.save
s232 = Country.new(description: 'Turks and Caicos Islands', continent_id: a2.id, sigla: 'TC', sigla_ext: 'TCA')
s232.attributes = {locale: 'en', description: 'Turks and Caicos Islands'}
s232.save
s236 = Country.new(description: 'United States', continent_id: a2.id, sigla: 'US', sigla_ext: 'USA')
s236.attributes = {locale: 'en', description: 'United States'}
s236.save
s238 = Country.new(description: 'Uruguay', continent_id: a2.id, sigla: 'UY', sigla_ext: 'URY')
s238.attributes = {locale: 'en', description: 'Uruguay'}
s238.save
s241 = Country.new(description: 'Venezuela, Bolivarian Republic of', continent_id: a2.id, sigla: 'VE', sigla_ext: 'VEN')
s241.attributes = {locale: 'en', description: 'Venezuela, Bolivarian Republic of'}
s241.save
s243 = Country.new(description: 'Virgin Islands, British', continent_id: a2.id, sigla: 'VG', sigla_ext: 'VGB')
s243.attributes = {locale: 'en', description: 'Virgin Islands, British'}
s243.save

a3 = Continent.new
a3.attributes = {locale: 'it', description: 'Africa'}
a3.attributes = {locale: 'en', description: 'Africa'}
a3.attributes = {locale: 'en-US', description: 'Africa'}
a3.attributes = {locale: 'es', description: 'África'}
a3.attributes = {locale: 'es-EC', description: 'África'}
a3.attributes = {locale: 'fr', description: 'Afrique'}
a3.attributes = {locale: 'pt', description: 'África'}
a3.attributes = {locale: 'pt-BR', description: 'África'}
a3.save
countries = []
s56 = Country.new(description: 'Algeria', continent_id: a3.id, sigla: 'DZ', sigla_ext: 'DZA')
s56.attributes = {locale: 'en', description: 'Algeria'}
s56.save
s58 = Country.new(description: 'Angola', continent_id: a3.id, sigla: 'AO', sigla_ext: 'AGO')
s58.attributes = {locale: 'en', description: 'Angola'}
s58.save
s72 = Country.new(description: 'Benin', continent_id: a3.id, sigla: 'BJ', sigla_ext: 'BEN')
s72.attributes = {locale: 'en', description: 'Benin'}
s72.save
s76 = Country.new(description: 'Botswana', continent_id: a3.id, sigla: 'BW', sigla_ext: 'BWA')
s76.attributes = {locale: 'en', description: 'Botswana'}
s76.save
s81 = Country.new(description: 'Burkina Faso', continent_id: a3.id, sigla: 'BF', sigla_ext: 'BFA')
s81.attributes = {locale: 'en', description: 'Burkina Faso'}
s81.save
s82 = Country.new(description: 'Burundi', continent_id: a3.id, sigla: 'BI', sigla_ext: 'BDI')
s82.attributes = {locale: 'en', description: 'Burundi'}
s82.save
s84 = Country.new(description: 'Cameroon', continent_id: a3.id, sigla: 'CM', sigla_ext: 'CMR')
s84.attributes = {locale: 'en', description: 'Cameroon'}
s84.save
s86 = Country.new(description: 'Cape Verde', continent_id: a3.id, sigla: 'CV', sigla_ext: 'CPV')
s86.attributes = {locale: 'en', description: 'Cape Verde'}
s86.save
s88 = Country.new(description: 'Central African Republic', continent_id: a3.id, sigla: 'CF', sigla_ext: 'CAF')
s88.attributes = {locale: 'en', description: 'Central African Republic'}
s88.save
s89 = Country.new(description: 'Chad', continent_id: a3.id, sigla: 'TD', sigla_ext: 'TCD')
s89.attributes = {locale: 'en', description: 'Chad'}
s89.save
s95 = Country.new(description: 'Comoros', continent_id: a3.id, sigla: 'KM', sigla_ext: 'COM')
s95.attributes = {locale: 'en', description: 'Comoros'}
s95.save
s96 = Country.new(description: 'Congo', continent_id: a3.id, sigla: 'CG', sigla_ext: 'COG')
s96.attributes = {locale: 'en', description: 'Congo'}
s96.save
s97 = Country.new(description: 'Congo, the Democratic Republic of the', continent_id: a3.id, sigla: 'CD', sigla_ext: 'COD')
s97.attributes = {locale: 'en', description: 'Congo, the Democratic Republic of the'}
s97.save
s100 = Country.new(description: "Cote d'Ivoire", continent_id: a3.id, sigla: 'CI', sigla_ext: 'CIV')
s100.attributes = {locale: 'en', description: "Cote d'Ivoire"}
s100.save
s103 = Country.new(description: 'Djibouti', continent_id: a3.id, sigla: 'DJ', sigla_ext: 'DJI')
s103.attributes = {locale: 'en', description: 'Djibouti'}
s103.save
s107 = Country.new(description: 'Egypt', continent_id: a3.id, sigla: 'EG', sigla_ext: 'EGY')
s107.attributes = {locale: 'en', description: 'Egypt'}
s107.save
s109 = Country.new(description: 'Equatorial Guinea', continent_id: a3.id, sigla: 'GQ', sigla_ext: 'GNQ')
s109.attributes = {locale: 'en', description: 'Equatorial Guinea'}
s109.save
s110 = Country.new(description: 'Eritrea', continent_id: a3.id, sigla: 'ER', sigla_ext: 'ERI')
s110.attributes = {locale: 'en', description: 'Eritrea'}
s110.save
s111 = Country.new(description: 'Ethiopia', continent_id: a3.id, sigla: 'ET', sigla_ext: 'ETH')
s111.attributes = {locale: 'en', description: 'Ethiopia'}
s111.save
s117 = Country.new(description: 'Gabon', continent_id: a3.id, sigla: 'GA', sigla_ext: 'GAB')
s117.attributes = {locale: 'en', description: 'Gabon'}
s117.save
s118 = Country.new(description: 'Gambia', continent_id: a3.id, sigla: 'GM', sigla_ext: 'GMB')
s118.attributes = {locale: 'en', description: 'Gambia'}
s118.save
s120 = Country.new(description: 'Ghana', continent_id: a3.id, sigla: 'GH', sigla_ext: 'GHA')
s120.attributes = {locale: 'en', description: 'Ghana'}
s120.save
s126 = Country.new(description: 'Guinea', continent_id: a3.id, sigla: 'GN', sigla_ext: 'GIN')
s126.attributes = {locale: 'en', description: 'Guinea'}
s126.save
s127 = Country.new(description: 'Guinea-Bissau', continent_id: a3.id, sigla: 'GW', sigla_ext: 'GNB')
s127.attributes = {locale: 'en', description: 'Guinea-Bissau'}
s127.save
s142 = Country.new(description: 'Kenya', continent_id: a3.id, sigla: 'KE', sigla_ext: 'KEN')
s142.attributes = {locale: 'en', description: 'Kenya'}
s142.save
s150 = Country.new(description: 'Lesotho', continent_id: a3.id, sigla: 'LS', sigla_ext: 'LSO')
s150.attributes = {locale: 'en', description: 'Lesotho'}
s150.save
s151 = Country.new(description: 'Liberia', continent_id: a3.id, sigla: 'LR', sigla_ext: 'LBR')
s151.attributes = {locale: 'en', description: 'Liberia'}
s151.save
s152 = Country.new(description: 'Libyan Arab Jamahiriya', continent_id: a3.id, sigla: 'LY', sigla_ext: 'LBY')
s152.attributes = {locale: 'en', description: 'Libyan Arab Jamahiriya'}
s152.save
s154 = Country.new(description: 'Madagascar', continent_id: a3.id, sigla: 'MG', sigla_ext: 'MDG')
s154.attributes = {locale: 'en', description: 'Madagascar'}
s154.save
s155 = Country.new(description: 'Malawi', continent_id: a3.id, sigla: 'MW', sigla_ext: 'MWI')
s155.attributes = {locale: 'en', description: 'Malawi'}
s155.save
s158 = Country.new(description: 'Mali', continent_id: a3.id, sigla: 'ML', sigla_ext: 'MLI')
s158.attributes = {locale: 'en', description: 'Mali'}
s158.save
s161 = Country.new(description: 'Mauritania', continent_id: a3.id, sigla: 'MR', sigla_ext: 'MRT')
s161.attributes = {locale: 'en', description: 'Mauritania'}
s161.save
s162 = Country.new(description: 'Mauritius', continent_id: a3.id, sigla: 'MU', sigla_ext: 'MUS')
s162.attributes = {locale: 'en', description: 'Mauritius'}
s162.save
s163 = Country.new(description: 'Mayotte', continent_id: a3.id, sigla: 'YT', sigla_ext: 'MYT')
s163.attributes = {locale: 'en', description: 'Mayotte'}
s163.save
s168 = Country.new(description: 'Morocco', continent_id: a3.id, sigla: 'MA', sigla_ext: 'MAR')
s168.attributes = {locale: 'en', description: 'Morocco'}
s168.save
s169 = Country.new(description: 'Mozambique', continent_id: a3.id, sigla: 'MZ', sigla_ext: 'MOZ')
s169.attributes = {locale: 'en', description: 'Mozambique'}
s169.save
s171 = Country.new(description: 'Namibia', continent_id: a3.id, sigla: 'NA', sigla_ext: 'NAM')
s171.attributes = {locale: 'en', description: 'Namibia'}
s171.save
s178 = Country.new(description: 'Niger', continent_id: a3.id, sigla: 'NE', sigla_ext: 'NER')
s178.attributes = {locale: 'en', description: 'Niger'}
s178.save
s179 = Country.new(description: 'Nigeria', continent_id: a3.id, sigla: 'NG', sigla_ext: 'NGA')
s179.attributes = {locale: 'en', description: 'Nigeria'}
s179.save
s195 = Country.new(description: 'Reunion', continent_id: a3.id, sigla: 'RE', sigla_ext: 'REU')
s195.attributes = {locale: 'en', description: 'Reunion'}
s195.save
s196 = Country.new(description: 'Rwanda', continent_id: a3.id, sigla: 'RW', sigla_ext: 'RWA')
s196.attributes = {locale: 'en', description: 'Rwanda'}
s196.save
s198 = Country.new(description: 'Saint Helena, Ascension and Tristan da Cunha', continent_id: a3.id, sigla: 'SH', sigla_ext: 'SHN')
s198.attributes = {locale: 'en', description: 'Saint Helena, Ascension and Tristan da Cunha'}
s198.save
s205 = Country.new(description: 'Sao Tome and Principe', continent_id: a3.id, sigla: 'ST', sigla_ext: 'STP')
s205.attributes = {locale: 'en', description: 'Sao Tome and Principe'}
s205.save
s207 = Country.new(description: 'Senegal', continent_id: a3.id, sigla: 'SN', sigla_ext: 'SEN')
s207.attributes = {locale: 'en', description: 'Senegal'}
s207.save
s208 = Country.new(description: 'Seychelles', continent_id: a3.id, sigla: 'SC', sigla_ext: 'SYC')
s208.attributes = {locale: 'en', description: 'Seychelles'}
s208.save
s209 = Country.new(description: 'Sierra Leone', continent_id: a3.id, sigla: 'SL', sigla_ext: 'SLE')
s209.attributes = {locale: 'en', description: 'Sierra Leone'}
s209.save
s212 = Country.new(description: 'Somalia', continent_id: a3.id, sigla: 'SO', sigla_ext: 'SOM')
s212.attributes = {locale: 'en', description: 'Somalia'}
s212.save
s213 = Country.new(description: 'South Africa', continent_id: a3.id, sigla: 'ZA', sigla_ext: 'ZAF')
s213.attributes = {locale: 'en', description: 'South Africa'}
s213.save
s216 = Country.new(description: 'Sudan', continent_id: a3.id, sigla: 'SD', sigla_ext: 'SDN')
s216.attributes = {locale: 'en', description: 'Sudan'}
s216.save
s218 = Country.new(description: 'Swaziland', continent_id: a3.id, sigla: 'SZ', sigla_ext: 'SWZ')
s218.attributes = {locale: 'en', description: 'Swaziland'}
s218.save
s222 = Country.new(description: 'Tanzania, United Republic of', continent_id: a3.id, sigla: 'TZ', sigla_ext: 'TZA')
s222.attributes = {locale: 'en', description: 'Tanzania, United Republic of'}
s222.save
s225 = Country.new(description: 'Togo', continent_id: a3.id, sigla: 'TG', sigla_ext: 'TGO')
s225.attributes = {locale: 'en', description: 'Togo'}
s225.save
s229 = Country.new(description: 'Tunisia', continent_id: a3.id, sigla: 'TN', sigla_ext: 'TUN')
s229.attributes = {locale: 'en', description: 'Tunisia'}
s229.save
s234 = Country.new(description: 'Uganda', continent_id: a3.id, sigla: 'UG', sigla_ext: 'UGA')
s234.attributes = {locale: 'en', description: 'Uganda'}
s234.save
s246 = Country.new(description: 'Zambia', continent_id: a3.id, sigla: 'ZM', sigla_ext: 'ZMB')
s246.attributes = {locale: 'en', description: 'Zambia'}
s246.save
s247 = Country.new(description: 'Zimbabwe', continent_id: a3.id, sigla: 'ZW', sigla_ext: 'ZWE')
s247.attributes = {locale: 'en', description: 'Zimbabwe'}
s247.save

a4 = Continent.new
a4.attributes = {locale: 'it', description: 'Asia'}
a4.attributes = {locale: 'en', description: 'Asia'}
a4.attributes = {locale: 'en-US', description: 'Asia'}
a4.attributes = {locale: 'es', description: 'Asia'}
a4.attributes = {locale: 'es-EC', description: 'Asia'}
a4.attributes = {locale: 'fr', description: 'Asie'}
a4.attributes = {locale: 'pt', description: 'Ásia'}
a4.attributes = {locale: 'pt-BR', description: 'Ásia'}
a4.save
countries = []
s55 = Country.new(description: 'Afghanistan', continent_id: a4.id, sigla: 'AF', sigla_ext: 'AFG')
s55.attributes = {locale: 'en', description: 'Afghanistan'}
s55.save
s63 = Country.new(description: 'Armenia', continent_id: a4.id, sigla: 'AM', sigla_ext: 'ARM')
s63.attributes = {locale: 'en', description: 'Armenia'}
s63.save
s66 = Country.new(description: 'Azerbaijan', continent_id: a4.id, sigla: 'AZ', sigla_ext: 'AZE')
s66.attributes = {locale: 'en', description: 'Azerbaijan'}
s66.save
s68 = Country.new(description: 'Bahrain', continent_id: a4.id, sigla: 'BH', sigla_ext: 'BHR')
s68.attributes = {locale: 'en', description: 'Bahrain'}
s68.save
s69 = Country.new(description: 'Bangladesh', continent_id: a4.id, sigla: 'BD', sigla_ext: 'BGD')
s69.attributes = {locale: 'en', description: 'Bangladesh'}
s69.save
s74 = Country.new(description: 'Bhutan', continent_id: a4.id, sigla: 'BT', sigla_ext: 'BTN')
s74.attributes = {locale: 'en', description: 'Bhutan'}
s74.save
s79 = Country.new(description: 'British Indian Ocean Territory', continent_id: a4.id, sigla: 'IO', sigla_ext: 'IOT')
s79.attributes = {locale: 'en', description: 'British Indian Ocean Territory'}
s79.save
s80 = Country.new(description: 'Brunei Darussalam', continent_id: a4.id, sigla: 'BN', sigla_ext: 'BRN')
s80.attributes = {locale: 'en', description: 'Brunei Darussalam'}
s80.save
s83 = Country.new(description: 'Cambodia', continent_id: a4.id, sigla: 'KH', sigla_ext: 'KHM')
s83.attributes = {locale: 'en', description: 'Cambodia'}
s83.save
s91 = Country.new(description: 'China', continent_id: a4.id, sigla: 'CN', sigla_ext: 'CHN')
s91.attributes = {locale: 'en', description: 'China'}
s91.save
s92 = Country.new(description: 'Christmas Island', continent_id: a4.id, sigla: 'CX', sigla_ext: 'CXR')
s92.attributes = {locale: 'en', description: 'Christmas Island'}
s92.save
s93 = Country.new(description: 'Cocos (Keeling) Islands', continent_id: a4.id, sigla: 'CC', sigla_ext: 'CCK')
s93.attributes = {locale: 'en', description: 'Cocos (Keeling) Islands'}
s93.save
s102 = Country.new(description: 'Cyprus', continent_id: a4.id, sigla: 'CY', sigla_ext: 'CYP')
s102.attributes = {locale: 'en', description: 'Cyprus'}
s102.save
s119 = Country.new(description: 'Georgia', continent_id: a4.id, sigla: 'GE', sigla_ext: 'GEO')
s119.attributes = {locale: 'en', description: 'Georgia'}
s119.save
s132 = Country.new(description: 'Hong Kong', continent_id: a4.id, sigla: 'HK', sigla_ext: 'HKG')
s132.attributes = {locale: 'en', description: 'Hong Kong'}
s132.save
s133 = Country.new(description: 'India', continent_id: a4.id, sigla: 'IN', sigla_ext: 'IND')
s133.attributes = {locale: 'en', description: 'India'}
s133.save
s134 = Country.new(description: 'Indonesia', continent_id: a4.id, sigla: 'ID', sigla_ext: 'IDN')
s134.attributes = {locale: 'en', description: 'Indonesia'}
s134.save
s135 = Country.new(description: 'Iran, Islamic Republic of', continent_id: a4.id, sigla: 'IR', sigla_ext: 'IRN')
s135.attributes = {locale: 'en', description: 'Iran, Islamic Republic of'}
s135.save
s136 = Country.new(description: 'Iraq', continent_id: a4.id, sigla: 'IQ', sigla_ext: 'IRQ')
s136.attributes = {locale: 'en', description: 'Iraq'}
s136.save
s137 = Country.new(description: 'Israel', continent_id: a4.id, sigla: 'IL', sigla_ext: 'ISR')
s137.attributes = {locale: 'en', description: 'Israel'}
s137.save
s139 = Country.new(description: 'Japan', continent_id: a4.id, sigla: 'JP', sigla_ext: 'JPN')
s139.attributes = {locale: 'en', description: 'Japan'}
s139.save
s140 = Country.new(description: 'Jordan', continent_id: a4.id, sigla: 'JO', sigla_ext: 'JOR')
s140.attributes = {locale: 'en', description: 'Jordan'}
s140.save
s141 = Country.new(description: 'Kazakhstan', continent_id: a4.id, sigla: 'KZ', sigla_ext: 'KAZ')
s141.attributes = {locale: 'en', description: 'Kazakhstan'}
s141.save
s144 = Country.new(description: "Korea, Democratic People's Republic of", continent_id: a4.id, sigla: 'KP', sigla_ext: 'PRK')
s144.attributes = {locale: 'en' , description: "Korea, Democratic People's Republic of"}
s144.save
s145 = Country.new(description: 'Korea, Republic of', continent_id: a4.id, sigla: 'KR', sigla_ext: 'KOR')
s145.attributes = {locale: 'en', description: 'Korea, Republic of'}
s145.save
s146 = Country.new(description: 'Kuwait', continent_id: a4.id, sigla: 'KW', sigla_ext: 'KWT')
s146.attributes = {locale: 'en', description: 'Kuwait'}
s146.save
s147 = Country.new(description: 'Kyrgyzstan', continent_id: a4.id, sigla: 'KG', sigla_ext: 'KGZ')
s147.attributes = {locale: 'en', description: 'Kyrgyzstan'}
s147.save
s148 = Country.new(description: "Lao People's Democratic Republic", continent_id: a4.id, sigla: 'LA', sigla_ext: 'LAO')
s148.attributes = {locale: 'en', description: "Lao People's Democratic Republic"}
s148.save
s149 = Country.new(description: 'Lebanon', continent_id: a4.id, sigla: 'LB', sigla_ext: 'LBN')
s149.attributes = {locale: 'en', description: 'Lebanon'}
s149.save
s153 = Country.new(description: 'Macao', continent_id: a4.id, sigla: 'MO', sigla_ext: 'MAC')
s153.attributes = {locale: 'en', description: 'Macao'}
s153.save
s156 = Country.new(description: 'Malaysia', continent_id: a4.id, sigla: 'MY', sigla_ext: 'MYS')
s156.attributes = {locale: 'en', description: 'Malaysia'}
s156.save
s157 = Country.new(description: 'Maldives', continent_id: a4.id, sigla: 'MV', sigla_ext: 'MDV')
s157.attributes = {locale: 'en', description: 'Maldives'}
s157.save
s166 = Country.new(description: 'Mongolia', continent_id: a4.id, sigla: 'MN', sigla_ext: 'MNG')
s166.attributes = {locale: 'en', description: 'Mongolia'}
s166.save
s170 = Country.new(description: 'Myanmar', continent_id: a4.id, sigla: 'MM', sigla_ext: 'MMR')
s170.attributes = {locale: 'en', description: 'Myanmar'}
s170.save
s173 = Country.new(description: 'Nepal', continent_id: a4.id, sigla: 'NP', sigla_ext: 'NPL')
s173.attributes = {locale: 'en', description: 'Nepal'}
s173.save
s183 = Country.new(description: 'Oman', continent_id: a4.id, sigla: 'OM', sigla_ext: 'OMN')
s183.attributes = {locale: 'en', description: 'Oman'}
s183.save
s184 = Country.new(description: 'Pakistan', continent_id: a4.id, sigla: 'PK', sigla_ext: 'PAK')
s184.attributes = {locale: 'en', description: 'Pakistan'}
s184.save
s186 = Country.new(description: 'Palestinian Territory', continent_id: a4.id, sigla: 'PS', sigla_ext: 'PSE')
s186.attributes = {locale: 'en', description: 'Palestinian Territory'}
s186.save
s191 = Country.new(description: 'Philippines', continent_id: a4.id, sigla: 'PH', sigla_ext: 'PHL')
s191.attributes = {locale: 'en', description: 'Philippines'}
s191.save
s194 = Country.new(description: 'Qatar', continent_id: a4.id, sigla: 'QA', sigla_ext: 'QAT')
s194.attributes = {locale: 'en', description: 'Qatar'}
s194.save
s206 = Country.new(description: 'Saudi Arabia', continent_id: a4.id, sigla: 'SA', sigla_ext: 'SAU')
s206.attributes = {locale: 'en', description: 'Saudi Arabia'}
s206.save
s210 = Country.new(description: 'Singapore', continent_id: a4.id, sigla: 'SG', sigla_ext: 'SGP')
s210.attributes = {locale: 'en', description: 'Singapore'}
s210.save
s215 = Country.new(description: 'Sri Lanka', continent_id: a4.id, sigla: 'LK', sigla_ext: 'LKA')
s215.attributes = {locale: 'en', description: 'Sri Lanka'}
s215.save
s219 = Country.new(description: 'Syrian Arab Republic', continent_id: a4.id, sigla: 'SY', sigla_ext: 'SYR')
s219.attributes = {locale: 'en', description: 'Syrian Arab Republic'}
s219.save
s220 = Country.new(description: 'Taiwan, Province of China', continent_id: a4.id, sigla: 'TW', sigla_ext: 'TWN')
s220.attributes = {locale: 'en', description: 'Taiwan, Province of China'}
s220.save
s221 = Country.new(description: 'Tajikistan', continent_id: a4.id, sigla: 'TJ', sigla_ext: 'TJK')
s221.attributes = {locale: 'en', description: 'Tajikistan'}
s221.save
s223 = Country.new(description: 'Thailand', continent_id: a4.id, sigla: 'TH', sigla_ext: 'THA')
s223.attributes = {locale: 'en', description: 'Thailand'}
s223.save
s224 = Country.new(description: 'Timor-Leste', continent_id: a4.id, sigla: 'TL', sigla_ext: 'TLS')
s224.attributes = {locale: 'en', description: 'Timor-Leste'}
s224.save
s230 = Country.new(description: 'Turkey', continent_id: a4.id, sigla: 'TR', sigla_ext: 'TUR')
s230.attributes = {locale: 'en', description: 'Turkey'}
s230.save
s231 = Country.new(description: 'Turkmenistan', continent_id: a4.id, sigla: 'TM', sigla_ext: 'TKM')
s231.attributes = {locale: 'en', description: 'Turkmenistan'}
s231.save
s235 = Country.new(description: 'United Arab Emirates', continent_id: a4.id, sigla: 'AE', sigla_ext: 'ARE')
s235.attributes = {locale: 'en', description: 'United Arab Emirates'}
s235.save
s239 = Country.new(description: 'Uzbekistan', continent_id: a4.id, sigla: 'UZ', sigla_ext: 'UZB')
s239.attributes = {locale: 'en', description: 'Uzbekistan'}
s239.save
s242 = Country.new(description: 'Viet Nam', continent_id: a4.id, sigla: 'VN', sigla_ext: 'VNM')
s242.attributes = {locale: 'en', description: 'Viet Nam'}
s242.save
s245 = Country.new(description: 'Yemen', continent_id: a4.id, sigla: 'YE', sigla_ext: 'YEM')
s245.attributes = {locale: 'en', description: 'Yemen'}
s245.save

a5 = Continent.new
a5.attributes = {locale: 'it', description: 'Oceania'}
a5.attributes = {locale: 'en', description: 'Oceania'}
a5.attributes = {locale: 'en-US', description: 'Oceania'}
a5.attributes = {locale: 'es', description: 'Oceanía'}
a5.attributes = {locale: 'es-EC', description: 'Oceanía'}
a5.attributes = {locale: 'fr', description: 'Océanie'}
a5.attributes = {locale: 'pt', description: 'Oceania'}
a5.attributes = {locale: 'pt-BR', description: 'Oceania'}
a5.save
countries = []
s57 = Country.new(description: 'American Samoa', continent_id: a5.id, sigla: 'AS', sigla_ext: 'ASM')
s57.attributes = {locale: 'en', description: 'American Samoa'}
s57.save
s65 = Country.new(description: 'Australia', continent_id: a5.id, sigla: 'AU', sigla_ext: 'AUS')
s65.attributes = {locale: 'en', description: 'Australia'}
s65.save
s98 = Country.new(description: 'Cook Islands', continent_id: a5.id, sigla: 'CK', sigla_ext: 'COK')
s98.attributes = {locale: 'en', description: 'Cook Islands'}
s98.save
s113 = Country.new(description: 'Fiji', continent_id: a5.id, sigla: 'FJ', sigla_ext: 'FJI')
s113.attributes = {locale: 'en', description: 'Fiji'}
s113.save
s115 = Country.new(description: 'French Polynesia', continent_id: a5.id, sigla: 'PF', sigla_ext: 'PYF')
s115.attributes = {locale: 'en', description: 'French Polynesia'}
s115.save
s124 = Country.new(description: 'Guam', continent_id: a5.id, sigla: 'GU', sigla_ext: 'GUM')
s124.attributes = {locale: 'en', description: 'Guam'}
s124.save
s143 = Country.new(description: 'Kiribati', continent_id: a5.id, sigla: 'KI', sigla_ext: 'KIR')
s143.attributes = {locale: 'en', description: 'Kiribati'}
s143.save
s159 = Country.new(description: 'Marshall Islands', continent_id: a5.id, sigla: 'MH', sigla_ext: 'MHL')
s159.attributes = {locale: 'en', description: 'Marshall Islands'}
s159.save
s165 = Country.new(description: 'Micronesia, Federated States of', continent_id: a5.id, sigla: 'FM', sigla_ext: 'FSM')
s165.attributes = {locale: 'en', description: 'Micronesia, Federated States of'}
s165.save
s172 = Country.new(description: 'Nauru', continent_id: a5.id, sigla: 'NR', sigla_ext: 'NRU')
s172.attributes = {locale: 'en', description: 'Nauru'}
s172.save
s175 = Country.new(description: 'New Caledonia', continent_id: a5.id, sigla: 'NC', sigla_ext: 'NCL')
s175.attributes = {locale: 'en', description: 'New Caledonia'}
s175.save
s176 = Country.new(description: 'New Zealand', continent_id: a5.id, sigla: 'NZ', sigla_ext: 'NZL')
s176.attributes = {locale: 'en', description: 'New Zealand'}
s176.save
s180 = Country.new(description: 'Niue', continent_id: a5.id, sigla: 'NU', sigla_ext: 'NIU')
s180.attributes = {locale: 'en', description: 'Niue'}
s180.save
s181 = Country.new(description: 'Norfolk Island', continent_id: a5.id, sigla: 'NF', sigla_ext: 'NFK')
s181.attributes = {locale: 'en', description: 'Norfolk Island'}
s181.save
s182 = Country.new(description: 'Northern Mariana Islands', continent_id: a5.id, sigla: 'MP', sigla_ext: 'MNP')
s182.attributes = {locale: 'en', description: 'Northern Mariana Islands'}
s182.save
s185 = Country.new(description: 'Palau', continent_id: a5.id, sigla: 'PW', sigla_ext: 'PLW')
s185.attributes = {locale: 'en', description: 'Palau'}
s185.save
s188 = Country.new(description: 'Papua New Guinea', continent_id: a5.id, sigla: 'PG', sigla_ext: 'PNG')
s188.attributes = {locale: 'en', description: 'Papua New Guinea'}
s188.save
s192 = Country.new(description: 'Pitcairn', continent_id: a5.id, sigla: 'PN', sigla_ext: 'PCN')
s192.attributes = {locale: 'en', description: 'Pitcairn'}
s192.save
s204 = Country.new(description: 'Samoa', continent_id: a5.id, sigla: 'WS', sigla_ext: 'WSM')
s204.attributes = {locale: 'en', description: 'Samoa'}
s204.save
s211 = Country.new(description: 'Solomon Islands', continent_id: a5.id, sigla: 'SB', sigla_ext: 'SLB')
s211.attributes = {locale: 'en', description: 'Solomon Islands'}
s211.save
s226 = Country.new(description: 'Tokelau', continent_id: a5.id, sigla: 'TK', sigla_ext: 'TKL')
s226.attributes = {locale: 'en', description: 'Tokelau'}
s226.save
s227 = Country.new(description: 'Tonga', continent_id: a5.id, sigla: 'TO', sigla_ext: 'TON')
s227.attributes = {locale: 'en', description: 'Tonga'}
s227.save
s233 = Country.new(description: 'Tuvalu', continent_id: a5.id, sigla: 'TV', sigla_ext: 'TUV')
s233.attributes = {locale: 'en', description: 'Tuvalu'}
s233.save
s237 = Country.new(description: 'United States Minor Outlying Islands', continent_id: a5.id, sigla: 'UM', sigla_ext: 'UMI')
s237.attributes = {locale: 'en', description: 'United States Minor Outlying Islands'}
s237.save
s240 = Country.new(description: 'Vanuatu', continent_id: a5.id, sigla: 'VU', sigla_ext: 'VUT')
s240.attributes = {locale: 'en', description: 'Vanuatu'}
s240.save
s244 = Country.new(description: 'Wallis e Futuna', continent_id: a5.id, sigla: 'WF', sigla_ext: 'WLF')
s244.attributes = {locale: 'en', description: 'Wallis e Futuna'}
s244.save

a1 = Continent.new
a1.attributes = {locale: 'en', description: 'Europe'}
a1.attributes = {locale: 'en-US', description: 'Europe'}
a1.attributes = {locale: 'es', description: 'Europa'}
a1.attributes = {locale: 'es-EC', description: 'Europa'}
a1.attributes = {locale: 'fr', description: 'Europe'}
a1.attributes = {locale: 'pt', description: 'Europa'}
a1.attributes = {locale: 'pt-BR', description: 'Europa'}
a1.attributes = {locale: 'it', description: 'Europa'}
a1.save
countries = []
s4 = Country.new(description: 'Åland Islands', continent_id: a1.id, sigla: 'AX', sigla_ext: 'ALA')
s4.attributes = {locale: 'en-US', description: 'Åland Islands'}
s4.attributes = {locale: 'en', description: 'Åland Islands'}
s4.attributes = {locale: 'it', description: 'Isole Åland'}
s4.attributes = {locale: 'de', description: 'Åland-Inseln'}
s4.attributes = {locale: 'es', description: 'Islas Åland'}
s4.attributes = {locale: 'pt', description: 'Ilhas Aland'}
s4.save
s5 = Country.new(description: 'Albania', continent_id: a1.id, sigla: 'AL', sigla_ext: 'ALB')
s5.attributes = {locale: 'es', description: 'Albania'}
s5.attributes = {locale: 'en-US', description: 'Albania'}
s5.attributes = {locale: 'en', description: 'Albania'}
s5.attributes = {locale: 'it', description: 'Albania'}
s5.attributes = {locale: 'de', description: ' Albanien'}
s5.attributes = {locale: 'pt', description: 'Albânia'}
s5.save
s6 = Country.new(description: 'Andorra', continent_id: a1.id, sigla: 'AD', sigla_ext: 'AND')
s6.attributes = {locale: 'en-US', description: 'Andorra'}
s6.attributes = {locale: 'en', description: 'Andorra'}
s6.attributes = {locale: 'it', description: 'Andorra'}
s6.attributes = {locale: 'de', description: 'Andorra'}
s6.attributes = {locale: 'es', description: 'Andora'}
s6.attributes = {locale: 'pt', description: 'Andorra'}
s6.save
s7 = Country.new(description: 'Austria', continent_id: a1.id, sigla: 'AT', sigla_ext: 'AUT')
s7.attributes = {locale: 'es', description: 'Austria'}
s7.attributes = {locale: 'en-US', description: 'Austria'}
s7.attributes = {locale: 'en', description: 'Austria'}
s7.attributes = {locale: 'it', description: 'Austria'}
s7.attributes = {locale: 'de', description: 'Österreich'}
s7.attributes = {locale: 'pt', description: 'Áustria'}
s7.save
s8 = Country.new(description: 'Belarus', continent_id: a1.id, sigla: 'BY', sigla_ext: 'BLR')
s8.attributes = {locale: 'en-US', description: 'Belarus'}
s8.attributes = {locale: 'en', description: 'Belarus'}
s8.attributes = {locale: 'it', description: 'Bielorussia'}
s8.attributes = {locale: 'de', description: 'Weissrußland'}
s8.attributes = {locale: 'es', description: 'Bielorusia'}
s8.attributes = {locale: 'pt', description: 'Belarússia'}
s8.save
s9 = Country.new(description: 'Belgium', continent_id: a1.id, sigla: 'BE', sigla_ext: 'BEL')
s9.attributes = {locale: 'en-US', description: 'Belgium'}
s9.attributes = {locale: 'en', description: 'Belgium'}
s9.attributes = {locale: 'it', description: 'Belgio'}
s9.attributes = {locale: 'de', description: 'Belgien'}
s9.attributes = {locale: 'es', description: 'Bélgica'}
s9.attributes = {locale: 'pt', description: 'Bélgica'}
s9.save
s10 = Country.new(description: 'Bosnia and Herzegovina', continent_id: a1.id, sigla: 'BA', sigla_ext: 'BIH')
s10.attributes = {locale: 'en-US', description: 'Bosnia and Herzegovina'}
s10.attributes = {locale: 'en', description: 'Bosnia and Herzegovina'}
s10.attributes = {locale: 'it', description: 'Bosnia ed Erzegovina'}
s10.attributes = {locale: 'de', description: 'Bosnien und Herzogowina'}
s10.attributes = {locale: 'es', description: 'Bósnia Herzegovina'}
s10.attributes = {locale: 'pt', description: 'Bósnia Herzegovina'}
s10.save
s11 = Country.new(description: 'Bulgaria', continent_id: a1.id, sigla: 'BG', sigla_ext: 'BGR')
s11.attributes = {locale: 'en-US', description: 'Bulgaria'}
s11.attributes = {locale: 'en', description: 'Bulgaria'}
s11.attributes = {locale: 'it', description: 'Bulgaria'}
s11.attributes = {locale: 'de', description: 'Bulgarien'}
s11.attributes = {locale: 'es', description: 'Bulgária'}
s11.attributes = {locale: 'pt', description: 'Bulgária'}
s11.save
s12 = Country.new(description: 'Croatia', continent_id: a1.id, sigla: 'HR', sigla_ext: 'HRV')
s12.attributes = {locale: 'en-US', description: 'Croatia'}
s12.attributes = {locale: 'en', description: 'Croatia'}
s12.attributes = {locale: 'it', description: 'Croazia'}
s12.attributes = {locale: 'de', description: 'Kroatien'}
s12.attributes = {locale: 'es', description: 'Croácia'}
s12.attributes = {locale: 'pt', description: 'Croácia'}
s12.save
s13 = Country.new(description: 'Czech Republic', continent_id: a1.id, sigla: 'CZ', sigla_ext: 'CZE')
s13.attributes = {locale: 'it', description: 'Repubblica Ceca'}
s13.attributes = {locale: 'en-US', description: 'Czech Republic'}
s13.attributes = {locale: 'en', description: 'Czech Republic'}
s13.attributes = {locale: 'de', description: 'Tschechische Republik'}
s13.attributes = {locale: 'es', description: 'República Checa'}
s13.attributes = {locale: 'pt', description: 'República Checa'}
s13.save
s14 = Country.new(description: 'Denmark', continent_id: a1.id, sigla: 'DK', sigla_ext: 'DNK')
s14.attributes = {locale: 'it', description: 'Danimarca'}
s14.attributes = {locale: 'en-US', description: 'Denmark'}
s14.attributes = {locale: 'en', description: 'Denmark'}
s14.attributes = {locale: 'de', description: 'Dänemark'}
s14.attributes = {locale: 'es', description: 'Dinamarca'}
s14.attributes = {locale: 'pt', description: 'Dinamarca'}
s14.save
s15 = Country.new(description: 'Estonia', continent_id: a1.id, sigla: 'EE', sigla_ext: 'EST')
s15.attributes = {locale: 'it', description: 'Estonia'}
s15.attributes = {locale: 'en-US', description: 'Estonia'}
s15.attributes = {locale: 'en', description: 'Estonia'}
s15.attributes = {locale: 'de', description: 'Estland'}
s15.attributes = {locale: 'es', description: 'Estónia'}
s15.attributes = {locale: 'pt', description: 'Estónia'}
s15.save
s16 = Country.new(description: 'Faroe Islands', continent_id: a1.id, sigla: 'FO', sigla_ext: 'FRO')
s16.attributes = {locale: 'it', description: 'Isole Fær Øer'}
s16.attributes = {locale: 'en-US', description: 'Faroe Islands'}
s16.attributes = {locale: 'en', description: 'Faroe Islands'}
s16.attributes = {locale: 'de', description: 'Faroe Inseln'}
s16.attributes = {locale: 'es', description: 'Islas Faroe'}
s16.attributes = {locale: 'pt', description: 'Ilhas Faroe'}
s16.save
s17 = Country.new(description: 'Finland', continent_id: a1.id, sigla: 'FI', sigla_ext: 'FIN')
s17.attributes = {locale: 'it', description: 'Finlandia'}
s17.attributes = {locale: 'en-US', description: 'Finland'}
s17.attributes = {locale: 'en', description: 'Finland'}
s17.attributes = {locale: 'de', description: 'Finnland'}
s17.attributes = {locale: 'es', description: 'Finlândia'}
s17.attributes = {locale: 'pt', description: 'Finlândia'}
s17.save
s18 = Country.new(description: 'France', continent_id: a1.id, sigla: 'FR', sigla_ext: 'FRA')
s18.attributes = {locale: 'it', description: 'Francia'}
s18.attributes = {locale: 'es', description: 'Francia'}
s18.attributes = {locale: 'en-US', description: 'France'}
s18.attributes = {locale: 'en', description: 'France'}
s18.attributes = {locale: 'de', description: 'Frankreich'}
s18.attributes = {locale: 'pt', description: 'França'}
s18.save
s19 = Country.new(description: 'Germany', continent_id: a1.id, sigla: 'DE', sigla_ext: 'DEU')
s19.attributes = {locale: 'it', description: 'Germania'}
s19.attributes = {locale: 'en-US', description: 'Germany'}
s19.attributes = {locale: 'en', description: 'Germany'}
s19.attributes = {locale: 'de', description: 'Deutschland'}
s19.attributes = {locale: 'es', description: 'Alemania'}
s19.attributes = {locale: 'pt', description: 'Alemanha'}
s19.save
s20 = Country.new(description: 'Gibraltar', continent_id: a1.id, sigla: 'GI', sigla_ext: 'GIB')
s20.attributes = {locale: 'it', description: 'Gibilterra'}
s20.attributes = {locale: 'en-US', description: 'Gibraltar'}
s20.attributes = {locale: 'en', description: 'Gibraltar'}
s20.attributes = {locale: 'de', description: 'Gibraltar'}
s20.attributes = {locale: 'es', description: 'Gibraltar'}
s20.attributes = {locale: 'pt', description: 'Gibraltar'}
s20.save
s21 = Country.new(description: 'Greece', continent_id: a1.id, sigla: 'GR', sigla_ext: 'GRC')
s21.attributes = {locale: 'it', description: 'Grecia'}
s21.attributes = {locale: 'en-US', description: 'Greece'}
s21.attributes = {locale: 'en', description: 'Greece'}
s21.attributes = {locale: 'de', description: 'Griechenland'}
s21.attributes = {locale: 'es', description: 'Grécia'}
s21.attributes = {locale: 'pt', description: 'Grécia'}
s21.save
s22 = Country.new(description: 'Guernsey', continent_id: a1.id, sigla: 'GG', sigla_ext: 'GGY')
s22.attributes = {locale: 'it', description: 'Guernsey'}
s22.attributes = {locale: 'es', description: 'Guernsey'}
s22.attributes = {locale: 'en-US', description: 'Guernsey'}
s22.attributes = {locale: 'en', description: 'Guernsey'}
s22.attributes = {locale: 'de', description: 'Guernsey'}
s22.attributes = {locale: 'pt', description: 'Guernsey'}
s22.save
s23 = Country.new(description: 'Hungary', continent_id: a1.id, sigla: 'HU', sigla_ext: 'HUN')
s23.attributes = {locale: 'it', description: 'Ungheria'}
s23.attributes = {locale: 'en', description: 'Hungary'}
s23.attributes = {locale: 'de', description: 'Ungarn'}
s23.attributes = {locale: 'en-US', description: 'Hungary'}
s23.attributes = {locale: 'es', description: 'Hungria'}
s23.attributes = {locale: 'pt', description: 'Hungria'}
s23.save
s24 = Country.new(description: 'Iceland', continent_id: a1.id, sigla: 'IS', sigla_ext: 'ISL')
s24.attributes = {locale: 'it', description: 'Islanda'}
s24.attributes = {locale: 'en', description: 'Iceland'}
s24.attributes = {locale: 'de', description: 'Island'}
s24.attributes = {locale: 'en-US', description: 'Iceland'}
s24.attributes = {locale: 'es', description: 'Islândia'}
s24.attributes = {locale: 'pt', description: 'Islândia'}
s24.save
s25 = Country.new(description: 'Ireland', continent_id: a1.id, sigla: 'IE', sigla_ext: 'IRL')
s25.attributes = {locale: 'it', description: 'Irlanda'}
s25.attributes = {locale: 'es', description: 'Irlanda'}
s25.attributes = {locale: 'en', description: 'Ireland'}
s25.attributes = {locale: 'de', description: 'Irland'}
s25.attributes = {locale: 'en-US', description: 'Ireland'}
s25.attributes = {locale: 'pt', description: 'Irlanda'}
s25.save
s26 = Country.new(description: 'Isle of Man', continent_id: a1.id, sigla: 'IM', sigla_ext: 'IMN')
s26.attributes = {locale: 'it', description: 'Isola di Man'}
s26.attributes = {locale: 'en', description: 'Isle of Man'}
s26.attributes = {locale: 'en-US', description: 'Isle of Man'}
s26.attributes = {locale: 'de', description: 'Isle of Man'}
s26.attributes = {locale: 'es', description: 'Isla de Man'}
s26.attributes = {locale: 'pt', description: 'Ilha de Man'}
s26.save
s1 = Country.new(description: 'Italy', continent_id: a1.id, sigla: 'IT', sigla_ext: 'ITA')
s1.attributes = {locale: 'it', description: 'Italia'}
s1.attributes = {locale: 'en', description: 'Italy'}
s1.attributes = {locale: 'en-US', description: 'Italy'}
s1.attributes = {locale: 'de', description: 'Italien'}
s1.attributes = {locale: 'es', description: 'Italia'}
s1.attributes = {locale: 'pt', description: 'Itália'}
s1.save
s27 = Country.new(description: 'Jersey', continent_id: a1.id, sigla: 'JE', sigla_ext: 'JEY')
s27.attributes = {locale: 'it', description: 'Jersey'}
s27.attributes = {locale: 'en', description: 'Jersey'}
s27.attributes = {locale: 'en-US', description: 'Jersey'}
s27.attributes = {locale: 'de', description: 'Jersey'}
s27.attributes = {locale: 'es', description: 'Jersez'}
s27.attributes = {locale: 'pt', description: 'Jersey'}
s27.save
s28 = Country.new(description: 'Kosovo', continent_id: a1.id, sigla: 'XK', sigla_ext: 'KOS')
s28.attributes = {locale: 'it', description: 'Kosovo'}
s28.attributes = {locale: 'es', description: 'Kosovo'}
s28.attributes = {locale: 'en', description: 'Kosovo'}
s28.attributes = {locale: 'en-US', description: 'Kosovo'}
s28.attributes = {locale: 'de', description: 'Kosowo'}
s28.attributes = {locale: 'pt', description: 'Kosovo'}
s28.save
s29 = Country.new(description: 'Latvia', continent_id: a1.id, sigla: 'LV', sigla_ext: 'LVA')
s29.attributes = {locale: 'it', description: 'Lettonia'}
s29.attributes = {locale: 'en', description: 'Latvia'}
s29.attributes = {locale: 'en-US', description: 'Latvia'}
s29.attributes = {locale: 'de', description: 'Letland'}
s29.attributes = {locale: 'es', description: 'Letónia'}
s29.attributes = {locale: 'pt', description: 'Letónia'}
s29.save
s30 = Country.new(description: 'Liechtenstein', continent_id: a1.id, sigla: 'LI', sigla_ext: 'LIE')
s30.attributes = {locale: 'it', description: 'Liechtenstein'}
s30.attributes = {locale: 'es', description: 'Liechtenstein'}
s30.attributes = {locale: 'en', description: 'Liechtenstein'}
s30.attributes = {locale: 'en-US', description: 'Liechtenstein'}
s30.attributes = {locale: 'de', description: 'Liechtenstein'}
s30.attributes = {locale: 'pt', description: 'Liechtenstein'}
s30.save
s31 = Country.new(description: 'Lithuania', continent_id: a1.id, sigla: 'LT', sigla_ext: 'LTU')
s31.attributes = {locale: 'it', description: 'Lituania'}
s31.attributes = {locale: 'en', description: 'Lithuania'}
s31.attributes = {locale: 'en-US', description: 'Lithuania'}
s31.attributes = {locale: 'de', description: 'Litauen'}
s31.attributes = {locale: 'es', description: 'Lituânia'}
s31.attributes = {locale: 'pt', description: 'Lituânia'}
s31.save
s32 = Country.new(description: 'Luxembourg', continent_id: a1.id, sigla: 'LU', sigla_ext: 'LUX')
s32.attributes = {locale: 'it', description: 'Lussemburgo'}
s32.attributes = {locale: 'en', description: 'Luxembourg'}
s32.attributes = {locale: 'en-US', description: 'Luxembourg'}
s32.attributes = {locale: 'de', description: 'Luxemburg'}
s32.attributes = {locale: 'es', description: 'Luxemburgo'}
s32.attributes = {locale: 'pt', description: 'Luxemburgo'}
s32.save
s33 = Country.new(description: 'Macedonia', continent_id: a1.id, sigla: 'MK', sigla_ext: 'MKD')
s33.attributes = {locale: 'en', description: 'Macedonia'}
s33.attributes = {locale: 'it', description: 'Macedonia'}
s33.attributes = {locale: 'en-US', description: 'Macedonia'}
s33.attributes = {locale: 'de', description: 'Mazedonien'}
s33.attributes = {locale: 'es', description: 'Macedónia'}
s33.attributes = {locale: 'pt', description: 'Macedónia'}
s33.save
s34 = Country.new(description: 'Malta', continent_id: a1.id, sigla: 'MT', sigla_ext: 'MLT')
s34.attributes = {locale: 'es', description: 'Malta'}
s34.attributes = {locale: 'en', description: 'Malta'}
s34.attributes = {locale: 'it', description: 'Malta'}
s34.attributes = {locale: 'en-US', description: 'Malta'}
s34.attributes = {locale: 'de', description: 'Malta'}
s34.attributes = {locale: 'pt', description: 'Malta'}
s34.save
s35 = Country.new(description: 'Moldova', continent_id: a1.id, sigla: 'MD', sigla_ext: 'MDA')
s35.attributes = {locale: 'en', description: 'Moldova'}
s35.attributes = {locale: 'it', description: 'Moldavia'}
s35.attributes = {locale: 'en-US', description: 'Moldova'}
s35.attributes = {locale: 'de', description: 'Moldawien'}
s35.attributes = {locale: 'es', description: 'Moldávia'}
s35.attributes = {locale: 'pt', description: 'Moldávia'}
s35.save
s36 = Country.new(description: 'Monaco', continent_id: a1.id, sigla: 'MC', sigla_ext: 'MCO')
s36.attributes = {locale: 'en', description: 'Monaco'}
s36.attributes = {locale: 'it', description: 'Monaco'}
s36.attributes = {locale: 'en-US', description: 'Monaco'}
s36.attributes = {locale: 'de', description: 'Monaco'}
s36.attributes = {locale: 'es', description: 'Mónaco'}
s36.attributes = {locale: 'pt', description: 'Mónaco'}
s36.save
s37 = Country.new(description: 'Montenegro', continent_id: a1.id, sigla: 'ME', sigla_ext: 'MNE')
s37.attributes = {locale: 'es', description: 'Montenegro'}
s37.attributes = {locale: 'en', description: 'Montenegro'}
s37.attributes = {locale: 'it', description: 'Montenegro'}
s37.attributes = {locale: 'en-US', description: 'Montenegro'}
s37.attributes = {locale: 'de', description: 'Montenegro'}
s37.attributes = {locale: 'pt', description: 'Montenegro'}
s37.save
s38 = Country.new(description: 'Netherlands', continent_id: a1.id, sigla: 'NL', sigla_ext: 'NLD')
s38.attributes = {locale: 'en', description: 'Netherlands'}
s38.attributes = {locale: 'it', description: 'Olanda'}
s38.attributes = {locale: 'en-US', description: 'Netherlands'}
s38.attributes = {locale: 'de', description: 'Holland'}
s38.attributes = {locale: 'es', description: 'Holanda'}
s38.attributes = {locale: 'pt', description: 'Holanda'}
s38.save
s39 = Country.new(description: 'Norway', continent_id: a1.id, sigla: 'NO', sigla_ext: 'NOR')
s39.attributes = {locale: 'en', description: 'Norway'}
s39.attributes = {locale: 'it', description: 'Norvegia'}
s39.attributes = {locale: 'en-US', description: 'Norway'}
s39.attributes = {locale: 'de', description: 'Norwegen'}
s39.attributes = {locale: 'es', description: 'Noruega'}
s39.attributes = {locale: 'pt', description: 'Noruega'}
s39.save
s40 = Country.new(description: 'Poland', continent_id: a1.id, sigla: 'PL', sigla_ext: 'POL')
s40.attributes = {locale: 'en', description: 'Poland'}
s40.attributes = {locale: 'it', description: 'Polonia'}
s40.attributes = {locale: 'de', description: 'Polen'}
s40.attributes = {locale: 'es', description: 'Polónia'}
s40.attributes = {locale: 'en-US', description: 'Poland'}
s40.attributes = {locale: 'pt', description: 'Polónia'}
s40.save
s41 = Country.new(description: 'Portugal', continent_id: a1.id, sigla: 'PT', sigla_ext: 'PRT')
s41.attributes = {locale: 'en', description: 'Portugal'}
s41.attributes = {locale: 'it', description: 'Portogallo'}
s41.attributes = {locale: 'de', description: 'Portugal'}
s41.attributes = {locale: 'es', description: 'Portugal'}
s41.attributes = {locale: 'en-US', description: 'Portugal'}
s41.attributes = {locale: 'pt', description: 'Portugal'}
s41.save
s43 = Country.new(description: 'Russian Federation', continent_id: a1.id, sigla: 'RU', sigla_ext: 'RUS')
s43.attributes = {locale: 'en', description: 'Russian Federation'}
s43.attributes = {locale: 'it', description: 'Russia'}
s43.attributes = {locale: 'de', description: 'Rußland'}
s43.attributes = {locale: 'es', description: 'Federación Rusa'}
s43.attributes = {locale: 'en-US', description: 'Russian Federation'}
s43.attributes = {locale: 'pt', description: 'Federação Russa'}
s43.save
s2 = Country.new(description: 'San Marino', continent_id: a1.id, sigla: 'SM', sigla_ext: 'SMR')
s2.attributes = {locale: 'it', description: 'San Marino'}
s2.attributes = {locale: 'en', description: 'San Marino'}
s2.attributes = {locale: 'de', description: 'San Marino'}
s2.attributes = {locale: 'es', description: 'San Marino'}
s2.attributes = {locale: 'en-US', description: 'San Marino'}
s2.attributes = {locale: 'pt', description: 'San Marino'}
s2.save
s44 = Country.new(description: 'Serbia', continent_id: a1.id, sigla: 'RS', sigla_ext: 'SRB')
s44.attributes = {locale: 'en', description: 'Serbia'}
s44.attributes = {locale: 'it', description: 'Serbia'}
s44.attributes = {locale: 'de', description: 'Serbien'}
s44.attributes = {locale: 'es', description: 'Sérbia'}
s44.attributes = {locale: 'en-US', description: 'Serbia'}
s44.attributes = {locale: 'pt', description: 'Sérvia'}
s44.save
s45 = Country.new(description: 'Slovakia', continent_id: a1.id, sigla: 'SK', sigla_ext: 'SVK')
s45.attributes = {locale: 'en', description: 'Slovakia'}
s45.attributes = {locale: 'it', description: 'Slovacchia'}
s45.attributes = {locale: 'de', description: 'Slowakei'}
s45.attributes = {locale: 'es', description: 'Eslovaquia'}
s45.attributes = {locale: 'en-US', description: 'Slovakia'}
s45.attributes = {locale: 'pt', description: 'Eslováquia'}
s45.save
s46 = Country.new(description: 'Slovenia', continent_id: a1.id, sigla: 'SI', sigla_ext: 'SVN')
s46.attributes = {locale: 'en', description: 'Slovenia'}
s46.attributes = {locale: 'it', description: 'Slovenia'}
s46.attributes = {locale: 'de', description: 'Slowenien'}
s46.attributes = {locale: 'es', description: 'Eslovénia'}
s46.attributes = {locale: 'en-US', description: 'Slovenia'}
s46.attributes = {locale: 'pt', description: 'Eslovénia'}
s46.save
s47 = Country.new(description: 'Spain', continent_id: a1.id, sigla: 'ES', sigla_ext: 'ESP')
s47.attributes = {locale: 'en', description: 'Spain'}
s47.attributes = {locale: 'it', description: 'Spagna'}
s47.attributes = {locale: 'de', description: 'Spanien'}
s47.attributes = {locale: 'es', description: 'España'}
s47.attributes = {locale: 'en-US', description: 'Spain'}
s47.attributes = {locale: 'pt', description: 'Espanha'}
s47.save
s48 = Country.new(description: 'Svalbard and Jan Mayen', continent_id: a1.id, sigla: 'SJ', sigla_ext: 'SJM')
s48.attributes = {locale: 'es', description: 'Svalbard e Jan Mayen'}
s48.attributes = {locale: 'en', description: 'Svalbard and Jan Mayen'}
s48.attributes = {locale: 'it', description: 'Svalbard e Jan Mayen'}
s48.attributes = {locale: 'de', description: 'Svalbard e Jan Mayen'}
s48.attributes = {locale: 'en-US', description: 'Svalbard and Jan Mayen'}
s48.attributes = {locale: 'pt', description: 'Svalbard e Jan Mayen'}
s48.save
s49 = Country.new(description: 'Sweden', continent_id: a1.id, sigla: 'SE', sigla_ext: 'SWE')
s49.attributes = {locale: 'en', description: 'Sweden'}
s49.attributes = {locale: 'it', description: 'Svezia'}
s49.attributes = {locale: 'de', description: 'Schweden'}
s49.attributes = {locale: 'es', description: 'Suécia'}
s49.attributes = {locale: 'en-US', description: 'Sweden'}
s49.attributes = {locale: 'pt', description: 'Suécia'}
s49.save
s50 = Country.new(description: 'Switzerland', continent_id: a1.id, sigla: 'CH', sigla_ext: 'CHE')
s50.attributes = {locale: 'en', description: 'Switzerland'}
s50.attributes = {locale: 'it', description: 'Svizzera'}
s50.attributes = {locale: 'de', description: 'Schweiz'}
s50.attributes = {locale: 'es', description: 'Suiza'}
s50.attributes = {locale: 'en-US', description: 'Switzerland'}
s50.attributes = {locale: 'pt', description: 'Suíça'}
s50.save
s51 = Country.new(description: 'Ukraine', continent_id: a1.id, sigla: 'UA', sigla_ext: 'UKR')
s51.attributes = {locale: 'en', description: 'Ukraine'}
s51.attributes = {locale: 'it', description: 'Ucraina'}
s51.attributes = {locale: 'de', description: 'Ukraine'}
s51.attributes = {locale: 'es', description: 'Ucrania'}
s51.attributes = {locale: 'en-US', description: 'Ukraine'}
s51.attributes = {locale: 'pt', description: 'Ucrânia'}
s51.save
s52 = Country.new(description: 'United Kingdom', continent_id: a1.id, sigla: 'GB', sigla_ext: 'GBR')
s52.attributes = {locale: 'en', description: 'United Kingdom'}
s52.attributes = {locale: 'it', description: 'Inghilterra'}
s52.attributes = {locale: 'de', description: 'Großbritannien'}
s52.attributes = {locale: 'es', description: 'Inglaterra'}
s52.attributes = {locale: 'en-US', description: 'United Kingdom'}
s52.attributes = {locale: 'pt', description: 'Reino Unido'}
s52.save
s3 = Country.new(description: 'Vatican City State', continent_id: a1.id, sigla: 'VA', sigla_ext: 'VAT')
s3.attributes = {locale: 'it', description: 'Città del Vaticano'}
s3.attributes = {locale: 'en', description: 'Vatican City State'}
s3.attributes = {locale: 'de', description: 'Vatikan'}
s3.attributes = {locale: 'es', description: 'Cuidad del Vaticaon'}
s3.attributes = {locale: 'en-US', description: 'Vatican City State'}
s3.attributes = {locale: 'pt', description: 'Cidade do Vaticano'}
s3.save
s42 = Country.new(description: 'Romania', continent_id: a1.id, sigla: 'RO', sigla_ext: 'ROU')
s42.attributes = {locale: 'en', description: 'Romania'}
s42.attributes = {locale: 'it', description: 'Romania'}
s42.attributes = {locale: 'de', description: 'Rumänien'}
s42.attributes = {locale: 'es', description: 'Roménia'}
s42.attributes = {locale: 'en-US', description: 'Romania'}
s42.attributes = {locale: 'pt', description: 'Roménia'}
s42.attributes = {locale: 'ro-RO', description: 'România'}
s42.save

a6 = Continent.new
a6.attributes = {locale: 'it', description: 'Antartide'}
a6.attributes = {locale: 'en', description: 'Antarctica'}
a6.attributes = {locale: 'en-US', description: 'Antarctica'}
a6.attributes = {locale: 'fr', description: 'Antarctique'}
a6.attributes = {locale: 'pt', description: 'Antártida'}
a6.attributes = {locale: 'pt-BR', description: 'Antártida'}
a6.attributes = {locale: 'de', description: 'Antarktis'}
a6.attributes = {locale: 'es', description: 'Antártida'}
a6.attributes = {locale: 'es-EC', description: 'Antártida'}
a6.save
countries = []
s60 = Country.new(description: 'Antarctica', continent_id: a6.id, sigla: 'AQ', sigla_ext: 'ATA')
s60.attributes = {locale: 'en', description: 'Antarctica'}
s60.save
s77 = Country.new(description: 'Bouvet Island', continent_id: a6.id, sigla: 'BV', sigla_ext: 'BVT')
s77.attributes = {locale: 'en', description: 'Bouvet Island'}
s77.save
s116 = Country.new(description: 'French Southern Territories', continent_id: a6.id, sigla: 'TF', sigla_ext: 'ATF')
s116.attributes = {locale: 'en', description: 'French Southern Territories'}
s116.save
s130 = Country.new(description: 'Heard Island and McDonald Islands', continent_id: a6.id, sigla: 'HM', sigla_ext: 'HMD')
s130.attributes = {locale: 'en', description: 'Heard Island and McDonald Islands'}
s130.save
s214 = Country.new(description: 'South Georgia and the South Sandwich Islands', continent_id: a6.id, sigla: 'GS', sigla_ext: 'SGS')
s214.attributes = {locale: 'en', description: 'South Georgia and the South Sandwich Islands'}
s214.save

