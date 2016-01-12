continent = Continent.find_by(description: 'Europe')
state = Country.find_by(description: 'Croatia')
region = Region.create(description: "Bjelovarsko-Bilogorska Županija", country: state, continent: continent, geoname_id: 3337511)
province = region.provinces.create(description: "Grad Bjelovar", country: state, continent: continent,  geoname_id: 3203981, population: 0)
province = region.provinces.create(description: "Grad Daruvar", country: state, continent: continent,  geoname_id: 3202183, population: 0)
municipalities = [
province.municipalities.new(description: "Daruvar", region: region, country: state, continent: continent, geoname_id: 3202184, population: 9863),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Garešnica", country: state, continent: continent,  geoname_id: 3200709, population: 0)
province = region.provinces.create(description: "Grad Grubišno Polje", country: state, continent: continent,  geoname_id: 3199514, population: 0)
municipalities = [
province.municipalities.new(description: "Mala Barna", region: region, country: state, continent: continent, geoname_id: 3195876, population: 30),
province.municipalities.new(description: "Mala Peratovica", region: region, country: state, continent: continent, geoname_id: 3195811, population: 0),
province.municipalities.new(description: "Mali Zdenci", region: region, country: state, continent: continent, geoname_id: 3195595, population: 0),
province.municipalities.new(description: "Velika Barna", region: region, country: state, continent: continent, geoname_id: 3188275, population: 333),
province.municipalities.new(description: "Velika Jasenovača", region: region, country: state, continent: continent, geoname_id: 3188230, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Čazma", country: state, continent: continent,  geoname_id: 3202819, population: 0)
municipalities = [
province.municipalities.new(description: "Čazma", region: region, country: state, continent: continent, geoname_id: 3202820, population: 2892),
]
Municipality.import municipalities
region = Region.create(description: "Brodsko-Posavska Županija", country: state, continent: continent, geoname_id: 3337512)
province = region.provinces.create(description: "Grad Nova Gradiška", country: state, continent: continent,  geoname_id: 3194448, population: 0)
province = region.provinces.create(description: "Grad Slavonski Brod", country: state, continent: continent,  geoname_id: 3190585, population: 0)
municipalities = [
province.municipalities.new(description: "Slavonski Brod", region: region, country: state, continent: continent, geoname_id: 3190586, population: 60742),
]
Municipality.import municipalities
region = Region.create(description: "Dubrovačko-Neretvanska Županija", country: state, continent: continent, geoname_id: 3337513)
province = region.provinces.create(description: "Grad Dubrovnik", country: state, continent: continent,  geoname_id: 7577034, population: 43770)
municipalities = [
province.municipalities.new(description: "Blace", region: region, country: state, continent: continent, geoname_id: 3214573, population: 0),
province.municipalities.new(description: "Bosanka", region: region, country: state, continent: continent, geoname_id: 3263666, population: 0),
province.municipalities.new(description: "Brsečine", region: region, country: state, continent: continent, geoname_id: 3203217, population: 99),
province.municipalities.new(description: "Dubravica", region: region, country: state, continent: continent, geoname_id: 3201059, population: 37),
province.municipalities.new(description: "Dubrovnik", region: region, country: state, continent: continent, geoname_id: 3201047, population: 28428),
province.municipalities.new(description: "Gruda", region: region, country: state, continent: continent, geoname_id: 3199511, population: 0),
province.municipalities.new(description: "Koločep", region: region, country: state, continent: continent, geoname_id: 3265134, population: 0),
province.municipalities.new(description: "Metković", region: region, country: state, continent: continent, geoname_id: 3195222, population: 13941),
province.municipalities.new(description: "Mokošica", region: region, country: state, continent: continent, geoname_id: 3194919, population: 1494),
province.municipalities.new(description: "Mrčevo", region: region, country: state, continent: continent, geoname_id: 3194749, population: 86),
province.municipalities.new(description: "Opuzen", region: region, country: state, continent: continent, geoname_id: 3194075, population: 2743),
province.municipalities.new(description: "Orašac", region: region, country: state, continent: continent, geoname_id: 3194044, population: 300),
province.municipalities.new(description: "Plat", region: region, country: state, continent: continent, geoname_id: 3193235, population: 0),
province.municipalities.new(description: "Putniković", region: region, country: state, continent: continent, geoname_id: 3192181, population: 0),
province.municipalities.new(description: "Sudurad", region: region, country: state, continent: continent, geoname_id: 3189580, population: 0),
province.municipalities.new(description: "Trpanj", region: region, country: state, continent: continent, geoname_id: 3188734, population: 0),
province.municipalities.new(description: "Trsteno", region: region, country: state, continent: continent, geoname_id: 3188708, population: 0),
province.municipalities.new(description: "Vela Luka", region: region, country: state, continent: continent, geoname_id: 3188326, population: 4380),
province.municipalities.new(description: "Vid", region: region, country: state, continent: continent, geoname_id: 3187815, population: 0),
province.municipalities.new(description: "Viganj", region: region, country: state, continent: continent, geoname_id: 3187777, population: 0),
province.municipalities.new(description: "Štikovica", region: region, country: state, continent: continent, geoname_id: 3189881, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Korčula", country: state, continent: continent,  geoname_id: 3197709, population: 0)
municipalities = [
province.municipalities.new(description: "Zavalatica", region: region, country: state, continent: continent, geoname_id: 3186722, population: 0),
province.municipalities.new(description: "Čara", region: region, country: state, continent: continent, geoname_id: 3202868, population: 0),
province.municipalities.new(description: "Žrnovo", region: region, country: state, continent: continent, geoname_id: 3186331, population: 1302),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Ploče", country: state, continent: continent,  geoname_id: 3193146, population: 0)
municipalities = [
province.municipalities.new(description: "Ploče", region: region, country: state, continent: continent, geoname_id: 3193150, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Općina Lastovo", country: state, continent: continent,  geoname_id: 3196753, population: 0)
municipalities = [
province.municipalities.new(description: "Lastovo", region: region, country: state, continent: continent, geoname_id: 3196754, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Grad Zagreb", country: state, continent: continent, geoname_id: 3337532)
province = region.provinces.create(description: "Gradska cetvrt Pescenica - Zitnjak", country: state, continent: continent,  geoname_id: 8531823, population: 0)
province = region.provinces.create(description: "Gradska četvrt Brezovica", country: state, continent: continent,  geoname_id: 8531834, population: 0)
province = region.provinces.create(description: "Gradska četvrt Donja Dubrava", country: state, continent: continent,  geoname_id: 8531830, population: 0)
province = region.provinces.create(description: "Gradska četvrt Donji grad", country: state, continent: continent,  geoname_id: 8531816, population: 0)
province = region.provinces.create(description: "Gradska četvrt Gornja Dubrava", country: state, continent: continent,  geoname_id: 8531829, population: 0)
province = region.provinces.create(description: "Gradska četvrt Gornji Grad - Medvescak", country: state, continent: continent,  geoname_id: 8531817, population: 0)
province = region.provinces.create(description: "Gradska četvrt Maksimir", country: state, continent: continent,  geoname_id: 8531822, population: 0)
province = region.provinces.create(description: "Gradska četvrt Novi Zagreb - zapad", country: state, continent: continent,  geoname_id: 8531825, population: 0)
province = region.provinces.create(description: "Gradska četvrt Podsljeme", country: state, continent: continent,  geoname_id: 8531833, population: 0)
province = region.provinces.create(description: "Gradska četvrt Stenjevec", country: state, continent: continent,  geoname_id: 8531831, population: 0)
province = region.provinces.create(description: "Gradska četvrt Tresnjevka - jug", country: state, continent: continent,  geoname_id: 8531827, population: 0)
province = region.provinces.create(description: "Gradska četvrt Tresnjevka - sjever", country: state, continent: continent,  geoname_id: 8531826, population: 0)
province = region.provinces.create(description: "Gradska četvrt Trnje", country: state, continent: continent,  geoname_id: 8531820, population: 0)
province = region.provinces.create(description: "Gradska četvrt Črnomerec", country: state, continent: continent,  geoname_id: 8531828, population: 0)
province = region.provinces.create(description: "New Zagreb - east", country: state, continent: continent,  geoname_id: 8531824, population: 0)
province = region.provinces.create(description: "Podsused - Vrapce", country: state, continent: continent,  geoname_id: 8531832, population: 0)
province = region.provinces.create(description: "Sesvete", country: state, continent: continent,  geoname_id: 3190965, population: 70000)
municipalities = [
province.municipalities.new(description: "Sesvete", region: region, country: state, continent: continent, geoname_id: 3190966, population: 52411),
]
Municipality.import municipalities
region = Region.create(description: "Istarska Županija", country: state, continent: continent, geoname_id: 3337514)
province = region.provinces.create(description: "Grad Buje", country: state, continent: continent,  geoname_id: 3203088, population: 0)
province = region.provinces.create(description: "Grad Buzet", country: state, continent: continent,  geoname_id: 3202941, population: 0)
municipalities = [
province.municipalities.new(description: "Hum", region: region, country: state, continent: continent, geoname_id: 3199205, population: 17),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Labin", country: state, continent: continent,  geoname_id: 3196833, population: 0)
municipalities = [
province.municipalities.new(description: "Labin", region: region, country: state, continent: continent, geoname_id: 3196834, population: 7943),
province.municipalities.new(description: "Rabac", region: region, country: state, continent: continent, geoname_id: 3192174, population: 1479),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Pazin", country: state, continent: continent,  geoname_id: 3193560, population: 0)
province = region.provinces.create(description: "Grad Poreč", country: state, continent: continent,  geoname_id: 3192696, population: 0)
municipalities = [
province.municipalities.new(description: "Nova Vas", region: region, country: state, continent: continent, geoname_id: 3194406, population: 0),
province.municipalities.new(description: "Poreč", region: region, country: state, continent: continent, geoname_id: 3192699, population: 10499),
province.municipalities.new(description: "Tar", region: region, country: state, continent: continent, geoname_id: 3189204, population: 890),
province.municipalities.new(description: "Višnjan", region: region, country: state, continent: continent, geoname_id: 3187662, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Pula", country: state, continent: continent,  geoname_id: 3192222, population: 0)
municipalities = [
province.municipalities.new(description: "Pula", region: region, country: state, continent: continent, geoname_id: 3192224, population: 59078),
province.municipalities.new(description: "Štinjan", region: region, country: state, continent: continent, geoname_id: 3189873, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Rovinj", country: state, continent: continent,  geoname_id: 3191516, population: 0)
municipalities = [
province.municipalities.new(description: "Rovinj", region: region, country: state, continent: continent, geoname_id: 3191518, population: 13533),
province.municipalities.new(description: "Rovinjsko Selo", region: region, country: state, continent: continent, geoname_id: 3191515, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Karlovačka Županija", country: state, continent: continent, geoname_id: 3337515)
province = region.provinces.create(description: "Grad Duga Resa", country: state, continent: continent,  geoname_id: 3201029, population: 0)
province = region.provinces.create(description: "Grad Karlovac", country: state, continent: continent,  geoname_id: 3198257, population: 142480)
municipalities = [
province.municipalities.new(description: "Cerovac Vukmanicki", region: region, country: state, continent: continent, geoname_id: 7732831, population: 0),
province.municipalities.new(description: "Gornji Zvečaj", region: region, country: state, continent: continent, geoname_id: 3199888, population: 0),
province.municipalities.new(description: "Josipdol", region: region, country: state, continent: continent, geoname_id: 3198578, population: 998),
province.municipalities.new(description: "Karlovac", region: region, country: state, continent: continent, geoname_id: 3198259, population: 48123),
province.municipalities.new(description: "Ribnik", region: region, country: state, continent: continent, geoname_id: 3191677, population: 0),
province.municipalities.new(description: "Slunj", region: region, country: state, continent: continent, geoname_id: 3190523, population: 1785),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Ogulin", country: state, continent: continent,  geoname_id: 3194182, population: 0)
municipalities = [
province.municipalities.new(description: "Ogulin", region: region, country: state, continent: continent, geoname_id: 3194183, population: 8755),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Ozalj", country: state, continent: continent,  geoname_id: 3193753, population: 0)
province = region.provinces.create(description: "Grad Slunj", country: state, continent: continent,  geoname_id: 3190522, population: 0)
province = region.provinces.create(description: "Općina Vojnić", country: state, continent: continent,  geoname_id: 3187450, population: 0)
region = Region.create(description: "Koprivničko-Križevačka Županija", country: state, continent: continent, geoname_id: 3337518)
province = region.provinces.create(description: "Grad Koprivnica", country: state, continent: continent,  geoname_id: 3197726, population: 0)
municipalities = [
province.municipalities.new(description: "Koprivnica", region: region, country: state, continent: continent, geoname_id: 3197728, population: 25579),
province.municipalities.new(description: "Koprivnička Rijeka", region: region, country: state, continent: continent, geoname_id: 3197724, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Križevci", country: state, continent: continent,  geoname_id: 3197228, population: 0)
province = region.provinces.create(description: "Grad Đurđevac", country: state, continent: continent,  geoname_id: 3200960, population: 0)
region = Region.create(description: "Krapinsko-Zagorska Županija", country: state, continent: continent, geoname_id: 3337519)
province = region.provinces.create(description: "Grad Donja Stubica", country: state, continent: continent,  geoname_id: 3201620, population: 0)
province = region.provinces.create(description: "Grad Klanjec", country: state, continent: continent,  geoname_id: 3198102, population: 0)
province = region.provinces.create(description: "Grad Krapina", country: state, continent: continent,  geoname_id: 3197366, population: 0)
municipalities = [
province.municipalities.new(description: "Krapina", region: region, country: state, continent: continent, geoname_id: 3197369, population: 4725),
province.municipalities.new(description: "Tuhelj", region: region, country: state, continent: continent, geoname_id: 3188668, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Zabok", country: state, continent: continent,  geoname_id: 3186983, population: 0)
province = region.provinces.create(description: "Grad Zlatar", country: state, continent: continent,  geoname_id: 3186405, population: 0)
region = Region.create(description: "Ličko-Senjska Županija", country: state, continent: continent, geoname_id: 3337520)
province = region.provinces.create(description: "Ajduković Brdo", country: state, continent: continent,  geoname_id: 3217191, population: 0)
province = region.provinces.create(description: "Alivojvodići", country: state, continent: continent,  geoname_id: 3217551, population: 0)
province = region.provinces.create(description: "Basarića Draga", country: state, continent: continent,  geoname_id: 3217246, population: 0)
province = region.provinces.create(description: "Basarići", country: state, continent: continent,  geoname_id: 3217229, population: 0)
province = region.provinces.create(description: "Baste", country: state, continent: continent,  geoname_id: 3217198, population: 0)
province = region.provinces.create(description: "Birovača", country: state, continent: continent,  geoname_id: 3217187, population: 0)
province = region.provinces.create(description: "Bjelopolje", country: state, continent: continent,  geoname_id: 3203989, population: 0)
province = region.provinces.create(description: "Bogdanovići", country: state, continent: continent,  geoname_id: 3218053, population: 0)
province = region.provinces.create(description: "Boričevac", country: state, continent: continent,  geoname_id: 3203720, population: 0)
province = region.provinces.create(description: "Brdo Dragaševo", country: state, continent: continent,  geoname_id: 3217492, population: 0)
province = region.provinces.create(description: "Brdo Vejnoviča", country: state, continent: continent,  geoname_id: 3217205, population: 0)
province = region.provinces.create(description: "Brezovac Dobroselski", country: state, continent: continent,  geoname_id: 3203358, population: 0)
province = region.provinces.create(description: "Brinje", country: state, continent: continent,  geoname_id: 3203298, population: 1715)
province = region.provinces.create(description: "Bunić", country: state, continent: continent,  geoname_id: 3202986, population: 0)
province = region.provinces.create(description: "Cesarica", country: state, continent: continent,  geoname_id: 3202668, population: 0)
province = region.provinces.create(description: "Crni Dabar", country: state, continent: continent,  geoname_id: 3202430, population: 0)
province = region.provinces.create(description: "Dmitrašinovići", country: state, continent: continent,  geoname_id: 3217498, population: 0)
province = region.provinces.create(description: "Dnopolje", country: state, continent: continent,  geoname_id: 3201996, population: 0)
province = region.provinces.create(description: "Dobroselo", country: state, continent: continent,  geoname_id: 3201907, population: 0)
province = region.provinces.create(description: "Dokozići", country: state, continent: continent,  geoname_id: 3217312, population: 0)
province = region.provinces.create(description: "Donji Babin Potok", country: state, continent: continent,  geoname_id: 3201512, population: 0)
province = region.provinces.create(description: "Donji Doljani", country: state, continent: continent,  geoname_id: 3201573, population: 0)
province = region.provinces.create(description: "Donji Filipovići", country: state, continent: continent,  geoname_id: 3217628, population: 0)
province = region.provinces.create(description: "Donji Frkašić", country: state, continent: continent,  geoname_id: 3275950, population: 0)
province = region.provinces.create(description: "Donji Jošan", country: state, continent: continent,  geoname_id: 3284350, population: 0)
province = region.provinces.create(description: "Donji Lapac", country: state, continent: continent,  geoname_id: 3201450, population: 0)
province = region.provinces.create(description: "Donji Rebić", country: state, continent: continent,  geoname_id: 3201404, population: 0)
province = region.provinces.create(description: "Donji Vaganac", country: state, continent: continent,  geoname_id: 3201377, population: 0)
province = region.provinces.create(description: "Drakulića Rijeka", country: state, continent: continent,  geoname_id: 3276264, population: 0)
province = region.provinces.create(description: "Drenov Klanac", country: state, continent: continent,  geoname_id: 3201202, population: 0)
province = region.provinces.create(description: "Drenovac Radučki", country: state, continent: continent,  geoname_id: 3201213, population: 0)
province = region.provinces.create(description: "Dugi Do", country: state, continent: continent,  geoname_id: 3201024, population: 0)
province = region.provinces.create(description: "Fadljevići", country: state, continent: continent,  geoname_id: 3217579, population: 0)
province = region.provinces.create(description: "Frkašić", country: state, continent: continent,  geoname_id: 3200812, population: 0)
province = region.provinces.create(description: "Gerići", country: state, continent: continent,  geoname_id: 3273978, population: 0)
province = region.provinces.create(description: "Glavaši", country: state, continent: continent,  geoname_id: 3218112, population: 0)
province = region.provinces.create(description: "Glibodol", country: state, continent: continent,  geoname_id: 3200602, population: 0)
province = region.provinces.create(description: "Gornja Dubrava", country: state, continent: continent,  geoname_id: 3218060, population: 0)
province = region.provinces.create(description: "Gornja Ploča", country: state, continent: continent,  geoname_id: 3200205, population: 0)
province = region.provinces.create(description: "Gornje Vrhovine", country: state, continent: continent,  geoname_id: 3273555, population: 0)
province = region.provinces.create(description: "Gornji Babin Potok", country: state, continent: continent,  geoname_id: 3200055, population: 0)
province = region.provinces.create(description: "Gornji Doljani", country: state, continent: continent,  geoname_id: 3200134, population: 0)
province = region.provinces.create(description: "Gornji Jošan", country: state, continent: continent,  geoname_id: 3284351, population: 0)
province = region.provinces.create(description: "Gornji Kosinj", country: state, continent: continent,  geoname_id: 3199993, population: 0)
province = region.provinces.create(description: "Gornji Lapac", country: state, continent: continent,  geoname_id: 3199979, population: 0)
province = region.provinces.create(description: "Gornji Prozor", country: state, continent: continent,  geoname_id: 3192278, population: 940)
province = region.provinces.create(description: "Gospić", country: state, continent: continent,  geoname_id: 3199873, population: 6118)
province = region.provinces.create(description: "Hećimovići", country: state, continent: continent,  geoname_id: 3217782, population: 0)
province = region.provinces.create(description: "Hinići", country: state, continent: continent,  geoname_id: 3217775, population: 0)
province = region.provinces.create(description: "Homoljac", country: state, continent: continent,  geoname_id: 3199350, population: 0)
province = region.provinces.create(description: "Ivaniševići", country: state, continent: continent,  geoname_id: 3217734, population: 0)
province = region.provinces.create(description: "Jablanac", country: state, continent: continent,  geoname_id: 3199010, population: 0)
province = region.provinces.create(description: "Jelići", country: state, continent: continent,  geoname_id: 3217280, population: 0)
province = region.provinces.create(description: "Jerbić Brdo", country: state, continent: continent,  geoname_id: 3217773, population: 0)
province = region.provinces.create(description: "Jezerane", country: state, continent: continent,  geoname_id: 3198632, population: 0)
province = region.provinces.create(description: "Jezerce", country: state, continent: continent,  geoname_id: 3193171, population: 4668)
province = region.provinces.create(description: "Jezerce", country: state, continent: continent,  geoname_id: 3198630, population: 0)
province = region.provinces.create(description: "Jošan", country: state, continent: continent,  geoname_id: 3198595, population: 0)
province = region.provinces.create(description: "Jurišići", country: state, continent: continent,  geoname_id: 3217584, population: 0)
province = region.provinces.create(description: "Jurjevo", country: state, continent: continent,  geoname_id: 3198539, population: 0)
province = region.provinces.create(description: "Jurčić Dolac", country: state, continent: continent,  geoname_id: 3217635, population: 0)
province = region.provinces.create(description: "Kaluđerovac", country: state, continent: continent,  geoname_id: 3198433, population: 0)
province = region.provinces.create(description: "Kapela Korenička", country: state, continent: continent,  geoname_id: 3198319, population: 0)
province = region.provinces.create(description: "Karlobag", country: state, continent: continent,  geoname_id: 3198261, population: 1019)
province = region.provinces.create(description: "Klašnjica", country: state, continent: continent,  geoname_id: 3217481, population: 0)
province = region.provinces.create(description: "Klobučari", country: state, continent: continent,  geoname_id: 3217848, population: 0)
province = region.provinces.create(description: "Konjsko Brdo", country: state, continent: continent,  geoname_id: 3197774, population: 0)
province = region.provinces.create(description: "Končarev Kraj", country: state, continent: continent,  geoname_id: 3197808, population: 0)
province = region.provinces.create(description: "Kosa Janjačka", country: state, continent: continent,  geoname_id: 3272503, population: 0)
province = region.provinces.create(description: "Kosanović Gaj", country: state, continent: continent,  geoname_id: 3217212, population: 0)
province = region.provinces.create(description: "Krasno Polje", country: state, continent: continent,  geoname_id: 3197347, population: 0)
province = region.provinces.create(description: "Krbavica", country: state, continent: continent,  geoname_id: 3197331, population: 0)
province = region.provinces.create(description: "Krivi Put", country: state, continent: continent,  geoname_id: 3197250, population: 0)
province = region.provinces.create(description: "Križpolje", country: state, continent: continent,  geoname_id: 3197210, population: 0)
province = region.provinces.create(description: "Krpani", country: state, continent: continent,  geoname_id: 3217244, population: 0)
province = region.provinces.create(description: "Kruge", country: state, continent: continent,  geoname_id: 3197122, population: 0)
province = region.provinces.create(description: "Krš", country: state, continent: continent,  geoname_id: 3271873, population: 0)
province = region.provinces.create(description: "Kuterevo", country: state, continent: continent,  geoname_id: 3196871, population: 0)
province = region.provinces.create(description: "Kućišta", country: state, continent: continent,  geoname_id: 3197021, population: 0)
province = region.provinces.create(description: "Kućišta", country: state, continent: continent,  geoname_id: 3217854, population: 0)
province = region.provinces.create(description: "Kvarte", country: state, continent: continent,  geoname_id: 3217549, population: 0)
province = region.provinces.create(description: "Ledenik", country: state, continent: continent,  geoname_id: 3196708, population: 0)
province = region.provinces.create(description: "Lemić Dolac", country: state, continent: continent,  geoname_id: 3218118, population: 0)
province = region.provinces.create(description: "Lipice", country: state, continent: continent,  geoname_id: 3196535, population: 0)
province = region.provinces.create(description: "Lipovo Polje", country: state, continent: continent,  geoname_id: 3275475, population: 0)
province = region.provinces.create(description: "Lički Osik", country: state, continent: continent,  geoname_id: 3196595, population: 0)
province = region.provinces.create(description: "Lički Ribnik", country: state, continent: continent,  geoname_id: 3196594, population: 0)
province = region.provinces.create(description: "Lički Čitluk", country: state, continent: continent,  geoname_id: 3196597, population: 0)
province = region.provinces.create(description: "Ličko Cerje", country: state, continent: continent,  geoname_id: 3196593, population: 0)
province = region.provinces.create(description: "Ličko Lešće", country: state, continent: continent,  geoname_id: 3196592, population: 0)
province = region.provinces.create(description: "Ličko Petrovo Selo", country: state, continent: continent,  geoname_id: 3196590, population: 0)
province = region.provinces.create(description: "Ljubovića Poljana", country: state, continent: continent,  geoname_id: 3217474, population: 0)
province = region.provinces.create(description: "Lovinac", country: state, continent: continent,  geoname_id: 3196182, population: 0)
province = region.provinces.create(description: "Lukovo", country: state, continent: continent,  geoname_id: 3196046, population: 0)
province = region.provinces.create(description: "Lukovo Šugarje", country: state, continent: continent,  geoname_id: 3196043, population: 0)
province = region.provinces.create(description: "Lun", country: state, continent: continent,  geoname_id: 3196038, population: 0)
province = region.provinces.create(description: "Maljkovići", country: state, continent: continent,  geoname_id: 3273894, population: 0)
province = region.provinces.create(description: "Malo Polje", country: state, continent: continent,  geoname_id: 3217582, population: 0)
province = region.provinces.create(description: "Malo Selo", country: state, continent: continent,  geoname_id: 3217542, population: 0)
province = region.provinces.create(description: "Markovo Selo", country: state, continent: continent,  geoname_id: 3189316, population: 0)
province = region.provinces.create(description: "Matići", country: state, continent: continent,  geoname_id: 3217199, population: 0)
province = region.provinces.create(description: "Mašića Budžak", country: state, continent: continent,  geoname_id: 3217777, population: 0)
province = region.provinces.create(description: "Melinovac", country: state, continent: continent,  geoname_id: 3212390, population: 0)
province = region.provinces.create(description: "Metajna", country: state, continent: continent,  geoname_id: 3195229, population: 0)
province = region.provinces.create(description: "Mezinovac", country: state, continent: continent,  geoname_id: 3195201, population: 0)
province = region.provinces.create(description: "Milinkovića Nuga", country: state, continent: continent,  geoname_id: 3217615, population: 0)
province = region.provinces.create(description: "Mogorić", country: state, continent: continent,  geoname_id: 3194933, population: 0)
province = region.provinces.create(description: "Muharev Brijeg", country: state, continent: continent,  geoname_id: 3217627, population: 0)
province = region.provinces.create(description: "Nebljusi", country: state, continent: continent,  geoname_id: 3194569, population: 0)
province = region.provinces.create(description: "Nehaj", country: state, continent: continent,  geoname_id: 3218396, population: 0)
province = region.provinces.create(description: "Novalja", country: state, continent: continent,  geoname_id: 3194422, population: 2088)
province = region.provinces.create(description: "Novo Selo", country: state, continent: continent,  geoname_id: 3194327, population: 0)
province = region.provinces.create(description: "Novoselo Bilajsko", country: state, continent: continent,  geoname_id: 3217064, population: 0)
province = region.provinces.create(description: "Obljajac", country: state, continent: continent,  geoname_id: 3217278, population: 0)
province = region.provinces.create(description: "Otočac", country: state, continent: continent,  geoname_id: 3193788, population: 4375)
province = region.provinces.create(description: "Oštra", country: state, continent: continent,  geoname_id: 3217260, population: 0)
province = region.provinces.create(description: "Pavlovac", country: state, continent: continent,  geoname_id: 3187248, population: 0)
province = region.provinces.create(description: "Pejnovići", country: state, continent: continent,  geoname_id: 3217495, population: 0)
province = region.provinces.create(description: "Perinovići", country: state, continent: continent,  geoname_id: 3217560, population: 0)
province = region.provinces.create(description: "Perušić", country: state, continent: continent,  geoname_id: 3193476, population: 962)
province = region.provinces.create(description: "Plitvički Ljeskovac", country: state, continent: continent,  geoname_id: 3193169, population: 0)
province = region.provinces.create(description: "Pocrnići", country: state, continent: continent,  geoname_id: 3217559, population: 0)
province = region.provinces.create(description: "Podastrana", country: state, continent: continent,  geoname_id: 3217256, population: 0)
province = region.provinces.create(description: "Podastrana", country: state, continent: continent,  geoname_id: 3217620, population: 0)
province = region.provinces.create(description: "Podbrdo", country: state, continent: continent,  geoname_id: 3218371, population: 0)
province = region.provinces.create(description: "Podkuk", country: state, continent: continent,  geoname_id: 3276143, population: 0)
province = region.provinces.create(description: "Podlapac", country: state, continent: continent,  geoname_id: 3192987, population: 0)
province = region.provinces.create(description: "Poljana", country: state, continent: continent,  geoname_id: 3218080, population: 0)
province = region.provinces.create(description: "Poljice", country: state, continent: continent,  geoname_id: 3218070, population: 0)
province = region.provinces.create(description: "Polovine", country: state, continent: continent,  geoname_id: 3217247, population: 0)
province = region.provinces.create(description: "Ponor Korenički", country: state, continent: continent,  geoname_id: 3192729, population: 0)
province = region.provinces.create(description: "Potkoviljača", country: state, continent: continent,  geoname_id: 3217202, population: 0)
province = region.provinces.create(description: "Potkrčana", country: state, continent: continent,  geoname_id: 3217208, population: 0)
province = region.provinces.create(description: "Počučići", country: state, continent: continent,  geoname_id: 3217242, population: 0)
province = region.provinces.create(description: "Pribići", country: state, continent: continent,  geoname_id: 3275790, population: 0)
province = region.provinces.create(description: "Prijeboj", country: state, continent: continent,  geoname_id: 3192411, population: 0)
province = region.provinces.create(description: "Prizna", country: state, continent: continent,  geoname_id: 3192342, population: 0)
province = region.provinces.create(description: "Prpići", country: state, continent: continent,  geoname_id: 3217289, population: 0)
province = region.provinces.create(description: "Prvan Selo", country: state, continent: continent,  geoname_id: 3192261, population: 0)
province = region.provinces.create(description: "Pupavci", country: state, continent: continent,  geoname_id: 3218054, population: 0)
province = region.provinces.create(description: "Raduč", country: state, continent: continent,  geoname_id: 3192059, population: 0)
province = region.provinces.create(description: "Ramljani", country: state, continent: continent,  geoname_id: 3191977, population: 0)
province = region.provinces.create(description: "Rapain Dol", country: state, continent: continent,  geoname_id: 3218369, population: 0)
province = region.provinces.create(description: "Rapain Klanac", country: state, continent: continent,  geoname_id: 3218368, population: 0)
province = region.provinces.create(description: "Rapaići", country: state, continent: continent,  geoname_id: 3218370, population: 0)
province = region.provinces.create(description: "Rapajića Kraj", country: state, continent: continent,  geoname_id: 3217736, population: 0)
province = region.provinces.create(description: "Rasovača", country: state, continent: continent,  geoname_id: 3217273, population: 0)
province = region.provinces.create(description: "Ravni Dabar", country: state, continent: continent,  geoname_id: 3191820, population: 0)
province = region.provinces.create(description: "Ribnik", country: state, continent: continent,  geoname_id: 3217607, population: 0)
province = region.provinces.create(description: "Rizvanuša", country: state, continent: continent,  geoname_id: 3191613, population: 0)
province = region.provinces.create(description: "Rudopolje", country: state, continent: continent,  geoname_id: 3191446, population: 0)
province = region.provinces.create(description: "Rukavine", country: state, continent: continent,  geoname_id: 3217261, population: 0)
province = region.provinces.create(description: "Rukavine", country: state, continent: continent,  geoname_id: 3217786, population: 0)
province = region.provinces.create(description: "Senj", country: state, continent: continent,  geoname_id: 3191055, population: 5518)
province = region.provinces.create(description: "Serdari", country: state, continent: continent,  geoname_id: 3217511, population: 0)
province = region.provinces.create(description: "Sinac", country: state, continent: continent,  geoname_id: 3190870, population: 0)
province = region.provinces.create(description: "Smiljan", country: state, continent: continent,  geoname_id: 3190482, population: 0)
province = region.provinces.create(description: "Smiljaniči", country: state, continent: continent,  geoname_id: 3218359, population: 0)
province = region.provinces.create(description: "Staništa", country: state, continent: continent,  geoname_id: 3190040, population: 0)
province = region.provinces.create(description: "Stara Novalja", country: state, continent: continent,  geoname_id: 3190004, population: 0)
province = region.provinces.create(description: "Starigrad", country: state, continent: continent,  geoname_id: 3189963, population: 0)
province = region.provinces.create(description: "Stinica", country: state, continent: continent,  geoname_id: 3189878, population: 0)
province = region.provinces.create(description: "Stupačinovo", country: state, continent: continent,  geoname_id: 3217288, population: 0)
province = region.provinces.create(description: "Sušanj", country: state, continent: continent,  geoname_id: 3189467, population: 0)
province = region.provinces.create(description: "Sveti Rok", country: state, continent: continent,  geoname_id: 3189283, population: 0)
province = region.provinces.create(description: "Titova Korenica", country: state, continent: continent,  geoname_id: 3189076, population: 0)
province = region.provinces.create(description: "Tišmin Varoš", country: state, continent: continent,  geoname_id: 3217213, population: 0)
province = region.provinces.create(description: "Trnavac", country: state, continent: continent,  geoname_id: 3188809, population: 0)
province = region.provinces.create(description: "Trnovac", country: state, continent: continent,  geoname_id: 3188793, population: 0)
province = region.provinces.create(description: "Trolokve", country: state, continent: continent,  geoname_id: 3217856, population: 0)
province = region.provinces.create(description: "Tuk Bjelopoljski", country: state, continent: continent,  geoname_id: 3188660, population: 0)
province = region.provinces.create(description: "Tupale", country: state, continent: continent,  geoname_id: 3218066, population: 0)
province = region.provinces.create(description: "Udbina", country: state, continent: continent,  geoname_id: 3188554, population: 0)
province = region.provinces.create(description: "Uremovići", country: state, continent: continent,  geoname_id: 3217787, population: 0)
province = region.provinces.create(description: "Varićaci", country: state, continent: continent,  geoname_id: 3217739, population: 0)
province = region.provinces.create(description: "Vedro Polje", country: state, continent: continent,  geoname_id: 3217241, population: 0)
province = region.provinces.create(description: "Velika Rudinka", country: state, continent: continent,  geoname_id: 3217850, population: 0)
province = region.provinces.create(description: "Velike Brisnice", country: state, continent: continent,  geoname_id: 3188135, population: 0)
province = region.provinces.create(description: "Veljun", country: state, continent: continent,  geoname_id: 3213570, population: 0)
province = region.provinces.create(description: "Vidovac", country: state, continent: continent,  geoname_id: 3187796, population: 0)
province = region.provinces.create(description: "Volarice", country: state, continent: continent,  geoname_id: 3217248, population: 0)
province = region.provinces.create(description: "Vranovača", country: state, continent: continent,  geoname_id: 3217743, population: 0)
province = region.provinces.create(description: "Vranovine", country: state, continent: continent,  geoname_id: 3217591, population: 0)
province = region.provinces.create(description: "Vrelo Koreničko", country: state, continent: continent,  geoname_id: 3187240, population: 0)
province = region.provinces.create(description: "Vrhovine", country: state, continent: continent,  geoname_id: 3187195, population: 0)
province = region.provinces.create(description: "Vrišti", country: state, continent: continent,  geoname_id: 3276182, population: 0)
province = region.provinces.create(description: "Vukmirovići", country: state, continent: continent,  geoname_id: 3218044, population: 0)
province = region.provinces.create(description: "Vukobratovići", country: state, continent: continent,  geoname_id: 3217494, population: 0)
province = region.provinces.create(description: "Vučjak", country: state, continent: continent,  geoname_id: 3217250, population: 0)
province = region.provinces.create(description: "Zabare", country: state, continent: continent,  geoname_id: 3218317, population: 0)
province = region.provinces.create(description: "Zalužnica", country: state, continent: continent,  geoname_id: 3186816, population: 0)
province = region.provinces.create(description: "Zelenike", country: state, continent: continent,  geoname_id: 3217310, population: 0)
province = region.provinces.create(description: "Čačić-Draga", country: state, continent: continent,  geoname_id: 3217298, population: 0)
province = region.provinces.create(description: "Čojluk", country: state, continent: continent,  geoname_id: 3217200, population: 0)
province = region.provinces.create(description: "Čovići", country: state, continent: continent,  geoname_id: 3202530, population: 0)
province = region.provinces.create(description: "Šalamunić", country: state, continent: continent,  geoname_id: 3191341, population: 0)
province = region.provinces.create(description: "Šarić Brdo", country: state, continent: continent,  geoname_id: 3217211, population: 0)
province = region.provinces.create(description: "Šikić- Dražica", country: state, continent: continent,  geoname_id: 3217287, population: 0)
province = region.provinces.create(description: "Štikada", country: state, continent: continent,  geoname_id: 3189882, population: 0)
province = region.provinces.create(description: "Žuta Lokva", country: state, continent: continent,  geoname_id: 3186276, population: 0)
region = Region.create(description: "Međimurska Županija", country: state, continent: continent, geoname_id: 3337521)
province = region.provinces.create(description: "Grad Čakovec", country: state, continent: continent,  geoname_id: 3202887, population: 0)
region = Region.create(description: "Osječko-Baranjska Županija", country: state, continent: continent, geoname_id: 3337522)
province = region.provinces.create(description: "Grad Beli Manastir", country: state, continent: continent,  geoname_id: 3204319, population: 0)
province = region.provinces.create(description: "Grad Donji Miholjac", country: state, continent: continent,  geoname_id: 3201431, population: 10000)
province = region.provinces.create(description: "Grad Našice", country: state, continent: continent,  geoname_id: 3194580, population: 0)
province = region.provinces.create(description: "Grad Osijek", country: state, continent: continent,  geoname_id: 3193934, population: 0)
municipalities = [
province.municipalities.new(description: "Bilje", region: region, country: state, continent: continent, geoname_id: 3204145, population: 3282),
province.municipalities.new(description: "Karanac", region: region, country: state, continent: continent, geoname_id: 3198286, population: 1070),
province.municipalities.new(description: "Osijek", region: region, country: state, continent: continent, geoname_id: 3193935, population: 88140),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Valpovo", country: state, continent: continent,  geoname_id: 3188394, population: 0)
province = region.provinces.create(description: "Grad Đakovo", country: state, continent: continent,  geoname_id: 3202219, population: 0)
region = Region.create(description: "Požeško-Slavonska Županija", country: state, continent: continent, geoname_id: 3337523)
province = region.provinces.create(description: "Grad Pakrac", country: state, continent: continent,  geoname_id: 3193705, population: 0)
province = region.provinces.create(description: "Grad Požega", country: state, continent: continent,  geoname_id: 3190588, population: 0)
region = Region.create(description: "Primorsko-Goranska Županija", country: state, continent: continent, geoname_id: 3337524)
province = region.provinces.create(description: "Grad Crikvenica", country: state, continent: continent,  geoname_id: 3202506, population: 0)
municipalities = [
province.municipalities.new(description: "Crikvenica", region: region, country: state, continent: continent, geoname_id: 3202507, population: 7156),
province.municipalities.new(description: "Dramalj", region: region, country: state, continent: continent, geoname_id: 7870346, population: 0),
province.municipalities.new(description: "Jadranovo", region: region, country: state, continent: continent, geoname_id: 3198964, population: 1154),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Delnice", country: state, continent: continent,  geoname_id: 3202102, population: 0)
municipalities = [
province.municipalities.new(description: "Delnice", region: region, country: state, continent: continent, geoname_id: 3202104, population: 4473),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Krk", country: state, continent: continent,  geoname_id: 3197207, population: 0)
municipalities = [
province.municipalities.new(description: "Krk", region: region, country: state, continent: continent, geoname_id: 3197208, population: 3380),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Opatija", country: state, continent: continent,  geoname_id: 3194097, population: 0)
municipalities = [
province.municipalities.new(description: "Ičići", region: region, country: state, continent: continent, geoname_id: 3199174, population: 0),
province.municipalities.new(description: "Opatija", region: region, country: state, continent: continent, geoname_id: 3194099, population: 7888),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Rijeka", country: state, continent: continent,  geoname_id: 3191647, population: 0)
municipalities = [
province.municipalities.new(description: "Rijeka", region: region, country: state, continent: continent, geoname_id: 3189469, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Vrbovsko", country: state, continent: continent,  geoname_id: 3187256, population: 0)
province = region.provinces.create(description: "Grad Čabar", country: state, continent: continent,  geoname_id: 3202931, population: 0)
municipalities = [
province.municipalities.new(description: "Dobrinj", region: region, country: state, continent: continent, geoname_id: 3201934, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Sisačko-Moslavačka Županija", country: state, continent: continent, geoname_id: 3337526)
province = region.provinces.create(description: "Grad Glina", country: state, continent: continent,  geoname_id: 3200597, population: 0)
province = region.provinces.create(description: "Grad Hrvatska Kostajnica", country: state, continent: continent,  geoname_id: 3197593, population: 0)
province = region.provinces.create(description: "Grad Kutina", country: state, continent: continent,  geoname_id: 3196862, population: 0)
province = region.provinces.create(description: "Grad Novska", country: state, continent: continent,  geoname_id: 3194318, population: 0)
province = region.provinces.create(description: "Grad Petrinja", country: state, continent: continent,  geoname_id: 3193419, population: 0)
province = region.provinces.create(description: "Grad Sisak", country: state, continent: continent,  geoname_id: 3190812, population: 0)
municipalities = [
province.municipalities.new(description: "Krapje", region: region, country: state, continent: continent, geoname_id: 3197363, population: 0),
province.municipalities.new(description: "Sisak", region: region, country: state, continent: continent, geoname_id: 3190813, population: 35748),
]
Municipality.import municipalities
province = region.provinces.create(description: "Općina Dvor", country: state, continent: continent,  geoname_id: 3200915, population: 0)
province = region.provinces.create(description: "Općina Gvozd", country: state, continent: continent,  geoname_id: 3187231, population: 0)
region = Region.create(description: "Splitsko-Dalmatinska Županija", country: state, continent: continent, geoname_id: 3337527)
province = region.provinces.create(description: "Dugi Rat Općina", country: state, continent: continent,  geoname_id: 9076752, population: 7305)
province = region.provinces.create(description: "Grad Hvar", country: state, continent: continent,  geoname_id: 3199178, population: 0)
municipalities = [
province.municipalities.new(description: "Hvar", region: region, country: state, continent: continent, geoname_id: 3199180, population: 3690),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Imotski", country: state, continent: continent,  geoname_id: 3199110, population: 0)
province = region.provinces.create(description: "Grad Makarska", country: state, continent: continent,  geoname_id: 3195888, population: 0)
municipalities = [
province.municipalities.new(description: "Makarska", region: region, country: state, continent: continent, geoname_id: 3195890, population: 13446),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Omiš", country: state, continent: continent,  geoname_id: 3194113, population: 0)
municipalities = [
province.municipalities.new(description: "Lokva Rogoznica", region: region, country: state, continent: continent, geoname_id: 3214741, population: 0),
province.municipalities.new(description: "Mimice", region: region, country: state, continent: continent, geoname_id: 8063832, population: 0),
province.municipalities.new(description: "Nemira", region: region, country: state, continent: continent, geoname_id: 8643047, population: 0),
province.municipalities.new(description: "Omiš", region: region, country: state, continent: continent, geoname_id: 3194114, population: 6597),
province.municipalities.new(description: "Pisak", region: region, country: state, continent: continent, geoname_id: 3193328, population: 0),
province.municipalities.new(description: "Ravnice", region: region, country: state, continent: continent, geoname_id: 3191823, population: 0),
province.municipalities.new(description: "Stanići", region: region, country: state, continent: continent, geoname_id: 8643049, population: 0),
province.municipalities.new(description: "Tice", region: region, country: state, continent: continent, geoname_id: 3214753, population: 0),
province.municipalities.new(description: "Čelina", region: region, country: state, continent: continent, geoname_id: 3214748, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Sinj", country: state, continent: continent,  geoname_id: 3190864, population: 0)
municipalities = [
province.municipalities.new(description: "Povlja", region: region, country: state, continent: continent, geoname_id: 3192623, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Split", country: state, continent: continent,  geoname_id: 3190259, population: 0)
municipalities = [
province.municipalities.new(description: "Slatine", region: region, country: state, continent: continent, geoname_id: 3190610, population: 1000),
province.municipalities.new(description: "Split", region: region, country: state, continent: continent, geoname_id: 3190261, population: 176314),
province.municipalities.new(description: "Stobreč", region: region, country: state, continent: continent, geoname_id: 3189844, population: 5866),
province.municipalities.new(description: "Stomorska", region: region, country: state, continent: continent, geoname_id: 3189812, population: 0),
province.municipalities.new(description: "Sućuraj", region: region, country: state, continent: continent, geoname_id: 3189587, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Supetar", country: state, continent: continent,  geoname_id: 3203595, population: 0)
municipalities = [
province.municipalities.new(description: "Mirca", region: region, country: state, continent: continent, geoname_id: 3195055, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Trogir", country: state, continent: continent,  geoname_id: 3188762, population: 0)
municipalities = [
province.municipalities.new(description: "Mastrinka", region: region, country: state, continent: continent, geoname_id: 3215309, population: 0),
province.municipalities.new(description: "Trogir", region: region, country: state, continent: continent, geoname_id: 3188763, population: 10960),
province.municipalities.new(description: "Žedno", region: region, country: state, continent: continent, geoname_id: 3186632, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Vis", country: state, continent: continent,  geoname_id: 3187684, population: 0)
municipalities = [
province.municipalities.new(description: "Vis", region: region, country: state, continent: continent, geoname_id: 3187685, population: 1785),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Vrgorac", country: state, continent: continent,  geoname_id: 3187229, population: 0)
region = Region.create(description: "Varaždinska Županija", country: state, continent: continent, geoname_id: 3337528)
province = region.provinces.create(description: "Grad Ivanec", country: state, continent: continent,  geoname_id: 3199075, population: 0)
province = region.provinces.create(description: "Grad Ludbreg", country: state, continent: continent,  geoname_id: 3196119, population: 0)
province = region.provinces.create(description: "Grad Novi Marof", country: state, continent: continent,  geoname_id: 3194366, population: 0)
province = region.provinces.create(description: "Grad Varaždin", country: state, continent: continent,  geoname_id: 3188382, population: 185672)
region = Region.create(description: "Virovitičko-Podravska Županija", country: state, continent: continent, geoname_id: 3337533)
province = region.provinces.create(description: "Grad Orahovica", country: state, continent: continent,  geoname_id: 3194063, population: 0)
province = region.provinces.create(description: "Grad Slatina", country: state, continent: continent,  geoname_id: 3192931, population: 0)
province = region.provinces.create(description: "Grad Virovitica", country: state, continent: continent,  geoname_id: 3187693, population: 0)
municipalities = [
province.municipalities.new(description: "Virovitica", region: region, country: state, continent: continent, geoname_id: 3187694, population: 15665),
]
Municipality.import municipalities
region = Region.create(description: "Vukovarsko-Srijemska Županija", country: state, continent: continent, geoname_id: 3337529)
province = region.provinces.create(description: "Grad Vinkovci", country: state, continent: continent,  geoname_id: 3187718, population: 0)
province = region.provinces.create(description: "Grad Vukovar", country: state, continent: continent,  geoname_id: 3187046, population: 0)
province = region.provinces.create(description: "Grad Županja", country: state, continent: continent,  geoname_id: 3186293, population: 0)
region = Region.create(description: "Zadarska Županija", country: state, continent: continent, geoname_id: 3337530)
province = region.provinces.create(description: "Grad Biograd na Moru", country: state, continent: continent,  geoname_id: 3204122, population: 0)
province = region.provinces.create(description: "Novigrad Općina", country: state, continent: continent,  geoname_id: 9077071, population: 2368)
region = Region.create(description: "Zagreb County", country: state, continent: continent, geoname_id: 3337531)
province = region.provinces.create(description: "Grad Dugo Selo", country: state, continent: continent,  geoname_id: 3201007, population: 0)
province = region.provinces.create(description: "Grad Jastrebarsko", country: state, continent: continent,  geoname_id: 3198798, population: 0)
province = region.provinces.create(description: "Grad Samobor", country: state, continent: continent,  geoname_id: 3191315, population: 0)
municipalities = [
province.municipalities.new(description: "Samobor", region: region, country: state, continent: continent, geoname_id: 3191316, population: 15221),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Sveti Ivan Zelina", country: state, continent: continent,  geoname_id: 3186602, population: 0)
province = region.provinces.create(description: "Grad Velika Gorica", country: state, continent: continent,  geoname_id: 3188243, population: 0)
municipalities = [
province.municipalities.new(description: "Velika Gorica", region: region, country: state, continent: continent, geoname_id: 3188244, population: 35072),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Vrbovec", country: state, continent: continent,  geoname_id: 3187264, population: 4862)
municipalities = [
province.municipalities.new(description: "Vrbovec", region: region, country: state, continent: continent, geoname_id: 3187265, population: 4886),
]
Municipality.import municipalities
province = region.provinces.create(description: "Grad Zaprešić", country: state, continent: continent,  geoname_id: 3186780, population: 0)
province = region.provinces.create(description: "Ivanić-Grad", country: state, continent: continent,  geoname_id: 3199068, population: 0)
municipalities = [
province.municipalities.new(description: "Graberje Ivanićko", region: region, country: state, continent: continent, geoname_id: 3199828, population: 0),
province.municipalities.new(description: "Ivanić-Grad", region: region, country: state, continent: continent, geoname_id: 3199069, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Općina Dubrava", country: state, continent: continent,  geoname_id: 8260123, population: 0)
region = Region.create(description: "Šibensko-Kninska Županija", country: state, continent: continent, geoname_id: 3337525)
province = region.provinces.create(description: "Grad Drniš", country: state, continent: continent,  geoname_id: 3201161, population: 0)
province = region.provinces.create(description: "Grad Šibenik", country: state, continent: continent,  geoname_id: 3190938, population: 0)
municipalities = [
province.municipalities.new(description: "Betina", region: region, country: state, continent: continent, geoname_id: 3204251, population: 0),
province.municipalities.new(description: "Brodarica", region: region, country: state, continent: continent, geoname_id: 3213267, population: 2366),
province.municipalities.new(description: "Grebaštica", region: region, country: state, continent: continent, geoname_id: 3199613, population: 897),
province.municipalities.new(description: "Lozovac", region: region, country: state, continent: continent, geoname_id: 3196145, population: 0),
province.municipalities.new(description: "Pirovac", region: region, country: state, continent: continent, geoname_id: 3193331, population: 1616),
province.municipalities.new(description: "Prvić Luka", region: region, country: state, continent: continent, geoname_id: 3192257, population: 190),
province.municipalities.new(description: "Ražanj", region: region, country: state, continent: continent, geoname_id: 3213284, population: 0),
province.municipalities.new(description: "Tisno", region: region, country: state, continent: continent, geoname_id: 3189120, population: 1384),
province.municipalities.new(description: "Zaboric", region: region, country: state, continent: continent, geoname_id: 8261470, population: 0),
province.municipalities.new(description: "Šibenik", region: region, country: state, continent: continent, geoname_id: 3190941, population: 37112),
province.municipalities.new(description: "Žirje", region: region, country: state, continent: continent, geoname_id: 3186448, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Rogoznica Općina", country: state, continent: continent,  geoname_id: 9076750, population: 2391)
