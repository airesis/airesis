continent = Continent.find_by(description: 'Europe')
state = Country.find_by(description: 'Serbia')
region = Region.create(description: "Autonomna Pokrajina Vojvodina", country: state, continent: continent, geoname_id: 784272)
province = region.provinces.create(description: "Južnobanatski", country: state, continent: continent,  geoname_id: 7581797, population: 0)
municipalities = [
province.municipalities.new(description: "Alibunar", region: region, country: state, continent: continent, geoname_id: 793133, population: 0),
province.municipalities.new(description: "Bela Crkva", region: region, country: state, continent: continent, geoname_id: 792793, population: 0),
province.municipalities.new(description: "Kovačica", region: region, country: state, continent: continent, geoname_id: 789176, population: 0),
province.municipalities.new(description: "Kovin", region: region, country: state, continent: continent, geoname_id: 789167, population: 0),
province.municipalities.new(description: "Opovo", region: region, country: state, continent: continent, geoname_id: 787460, population: 0),
province.municipalities.new(description: "Pančevo", region: region, country: state, continent: continent, geoname_id: 787236, population: 0),
province.municipalities.new(description: "Plandište", region: region, country: state, continent: continent, geoname_id: 787031, population: 0),
province.municipalities.new(description: "Vršac", region: region, country: state, continent: continent, geoname_id: 784135, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Južnobački", country: state, continent: continent,  geoname_id: 7581796, population: 0)
municipalities = [
province.municipalities.new(description: "Bač", region: region, country: state, continent: continent, geoname_id: 3204690, population: 0),
province.municipalities.new(description: "Bačka Palanka", region: region, country: state, continent: continent, geoname_id: 3204673, population: 0),
province.municipalities.new(description: "Bački Petrovac", region: region, country: state, continent: continent, geoname_id: 3204664, population: 0),
province.municipalities.new(description: "Beočin", region: region, country: state, continent: continent, geoname_id: 3204287, population: 0),
province.municipalities.new(description: "Bečej", region: region, country: state, continent: continent, geoname_id: 3204390, population: 0),
province.municipalities.new(description: "Novi Sad", region: region, country: state, continent: continent, geoname_id: 3194359, population: 0),
province.municipalities.new(description: "Petrovaradin", region: region, country: state, continent: continent, geoname_id: 8260038, population: 0),
province.municipalities.new(description: "Srbobran", region: region, country: state, continent: continent, geoname_id: 3190168, population: 0),
province.municipalities.new(description: "Sremski Karlovci", region: region, country: state, continent: continent, geoname_id: 3343730, population: 0),
province.municipalities.new(description: "Temerin", region: region, country: state, continent: continent, geoname_id: 3189165, population: 0),
province.municipalities.new(description: "Titel", region: region, country: state, continent: continent, geoname_id: 785061, population: 0),
province.municipalities.new(description: "Vrbas", region: region, country: state, continent: continent, geoname_id: 3187295, population: 0),
province.municipalities.new(description: "Žabalj", region: region, country: state, continent: continent, geoname_id: 784067, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Severnobanatski", country: state, continent: continent,  geoname_id: 7581905, population: 0)
municipalities = [
province.municipalities.new(description: "Ada", region: region, country: state, continent: continent, geoname_id: 793170, population: 0),
province.municipalities.new(description: "Kanjiža", region: region, country: state, continent: continent, geoname_id: 789599, population: 0),
province.municipalities.new(description: "Kikinda", region: region, country: state, continent: continent, geoname_id: 789517, population: 0),
province.municipalities.new(description: "Novi Kneževac", region: region, country: state, continent: continent, geoname_id: 787599, population: 0),
province.municipalities.new(description: "Senta", region: region, country: state, continent: continent, geoname_id: 785964, population: 0),
province.municipalities.new(description: "Čoka", region: region, country: state, continent: continent, geoname_id: 791899, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Severnobački", country: state, continent: continent,  geoname_id: 7581808, population: 0)
municipalities = [
province.municipalities.new(description: "Bačka Topola", region: region, country: state, continent: continent, geoname_id: 3204671, population: 0),
province.municipalities.new(description: "Mali Iđoš", region: region, country: state, continent: continent, geoname_id: 3195706, population: 0),
province.municipalities.new(description: "Subotica", region: region, country: state, continent: continent, geoname_id: 3189594, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Srednjebanatski", country: state, continent: continent,  geoname_id: 7581906, population: 0)
municipalities = [
province.municipalities.new(description: "Novi Bečej Opština", region: region, country: state, continent: continent, geoname_id: 787609, population: 0),
province.municipalities.new(description: "Nova Crnja", region: region, country: state, continent: continent, geoname_id: 787620, population: 0),
province.municipalities.new(description: "Sečanj", region: region, country: state, continent: continent, geoname_id: 786034, population: 0),
province.municipalities.new(description: "Zrenjanin", region: region, country: state, continent: continent, geoname_id: 783813, population: 0),
province.municipalities.new(description: "Žitište", region: region, country: state, continent: continent, geoname_id: 783886, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Sremski", country: state, continent: continent,  geoname_id: 7581907, population: 0)
municipalities = [
province.municipalities.new(description: "Inđija", region: region, country: state, continent: continent, geoname_id: 790014, population: 0),
province.municipalities.new(description: "Irig", region: region, country: state, continent: continent, geoname_id: 3199102, population: 0),
province.municipalities.new(description: "Pećinci", region: region, country: state, continent: continent, geoname_id: 787151, population: 0),
province.municipalities.new(description: "Ruma", region: region, country: state, continent: continent, geoname_id: 3191428, population: 0),
province.municipalities.new(description: "Sremska Mitrovica", region: region, country: state, continent: continent, geoname_id: 3343729, population: 0),
province.municipalities.new(description: "Stara Pazova", region: region, country: state, continent: continent, geoname_id: 785558, population: 0),
province.municipalities.new(description: "Šid", region: region, country: state, continent: continent, geoname_id: 3343728, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Zapadnobački", country: state, continent: continent,  geoname_id: 7581911, population: 0)
municipalities = [
province.municipalities.new(description: "Apatin", region: region, country: state, continent: continent, geoname_id: 3204792, population: 0),
province.municipalities.new(description: "Kula", region: region, country: state, continent: continent, geoname_id: 3196972, population: 0),
province.municipalities.new(description: "Odžaci", region: region, country: state, continent: continent, geoname_id: 3194208, population: 0),
province.municipalities.new(description: "Sombor", region: region, country: state, continent: continent, geoname_id: 3190341, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Central Serbia", country: state, continent: continent, geoname_id: 785958)
province = region.provinces.create(description: "Belgrade", country: state, continent: continent,  geoname_id: 8199669, population: 0)
municipalities = [
province.municipalities.new(description: "Barajevo", region: region, country: state, continent: continent, geoname_id: 792891, population: 0),
province.municipalities.new(description: "Beograd-Rakovica", region: region, country: state, continent: continent, geoname_id: 865080, population: 0),
province.municipalities.new(description: "Grocka", region: region, country: state, continent: continent, geoname_id: 790131, population: 0),
province.municipalities.new(description: "Lazarevac", region: region, country: state, continent: continent, geoname_id: 788770, population: 0),
province.municipalities.new(description: "Mladenovac", region: region, country: state, continent: continent, geoname_id: 787891, population: 0),
province.municipalities.new(description: "Novi Beograd", region: region, country: state, continent: continent, geoname_id: 787606, population: 0),
province.municipalities.new(description: "Obrenovac", region: region, country: state, continent: continent, geoname_id: 787515, population: 0),
province.municipalities.new(description: "Palilula", region: region, country: state, continent: continent, geoname_id: 787252, population: 0),
province.municipalities.new(description: "Savski Venac", region: region, country: state, continent: continent, geoname_id: 786048, population: 0),
province.municipalities.new(description: "Sopot", region: region, country: state, continent: continent, geoname_id: 785670, population: 0),
province.municipalities.new(description: "Stari Grad", region: region, country: state, continent: continent, geoname_id: 785533, population: 0),
province.municipalities.new(description: "Surčin", region: region, country: state, continent: continent, geoname_id: 8260098, population: 0),
province.municipalities.new(description: "Voždovac", region: region, country: state, continent: continent, geoname_id: 784255, population: 0),
province.municipalities.new(description: "Vračar", region: region, country: state, continent: continent, geoname_id: 784251, population: 0),
province.municipalities.new(description: "Zemun", region: region, country: state, continent: continent, geoname_id: 783919, population: 0),
province.municipalities.new(description: "Zvezdara", region: region, country: state, continent: continent, geoname_id: 783763, population: 0),
province.municipalities.new(description: "Čukarica", region: region, country: state, continent: continent, geoname_id: 791703, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Borski", country: state, continent: continent,  geoname_id: 7581582, population: 0)
municipalities = [
province.municipalities.new(description: "Bor", region: region, country: state, continent: continent, geoname_id: 792455, population: 0),
province.municipalities.new(description: "Kladovo", region: region, country: state, continent: continent, geoname_id: 789484, population: 0),
province.municipalities.new(description: "Majdanpek", region: region, country: state, continent: continent, geoname_id: 788356, population: 0),
province.municipalities.new(description: "Negotin", region: region, country: state, continent: continent, geoname_id: 787717, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Braničevski", country: state, continent: continent,  geoname_id: 7581794, population: 0)
municipalities = [
province.municipalities.new(description: "Golubac", region: region, country: state, continent: continent, geoname_id: 790558, population: 0),
province.municipalities.new(description: "Kostolac", region: region, country: state, continent: continent, geoname_id: 8260148, population: 0),
province.municipalities.new(description: "Kučevo", region: region, country: state, continent: continent, geoname_id: 788936, population: 0),
province.municipalities.new(description: "Malo Crniće", region: region, country: state, continent: continent, geoname_id: 788217, population: 0),
province.municipalities.new(description: "Petrovac", region: region, country: state, continent: continent, geoname_id: 787077, population: 0),
province.municipalities.new(description: "Požarevac", region: region, country: state, continent: continent, geoname_id: 786826, population: 0),
province.municipalities.new(description: "Veliko Gradište", region: region, country: state, continent: continent, geoname_id: 784534, population: 0),
province.municipalities.new(description: "Žabari", region: region, country: state, continent: continent, geoname_id: 784063, population: 0),
province.municipalities.new(description: "Žagubica", region: region, country: state, continent: continent, geoname_id: 784030, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Jablanički", country: state, continent: continent,  geoname_id: 7581795, population: 0)
municipalities = [
province.municipalities.new(description: "Bojnik", region: region, country: state, continent: continent, geoname_id: 792480, population: 0),
province.municipalities.new(description: "Crna Trava", region: region, country: state, continent: continent, geoname_id: 791839, population: 0),
province.municipalities.new(description: "Lebane", region: region, country: state, continent: continent, geoname_id: 788761, population: 0),
province.municipalities.new(description: "Leskovac", region: region, country: state, continent: continent, geoname_id: 788705, population: 0),
province.municipalities.new(description: "Medveđa", region: region, country: state, continent: continent, geoname_id: 788054, population: 0),
province.municipalities.new(description: "Vlasotince", region: region, country: state, continent: continent, geoname_id: 784317, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kolubarski", country: state, continent: continent,  geoname_id: 7581798, population: 0)
municipalities = [
province.municipalities.new(description: "Lajkovac", region: region, country: state, continent: continent, geoname_id: 788811, population: 0),
province.municipalities.new(description: "Ljig", region: region, country: state, continent: continent, geoname_id: 788582, population: 0),
province.municipalities.new(description: "Mionica", region: region, country: state, continent: continent, geoname_id: 787934, population: 0),
province.municipalities.new(description: "Osečina", region: region, country: state, continent: continent, geoname_id: 3343742, population: 0),
province.municipalities.new(description: "Ub", region: region, country: state, continent: continent, geoname_id: 784793, population: 0),
province.municipalities.new(description: "Valjevo", region: region, country: state, continent: continent, geoname_id: 3188401, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Mačvanski", country: state, continent: continent,  geoname_id: 7581799, population: 0)
municipalities = [
province.municipalities.new(description: "Bogatić", region: region, country: state, continent: continent, geoname_id: 3343735, population: 0),
province.municipalities.new(description: "Koceljeva", region: region, country: state, continent: continent, geoname_id: 3197945, population: 0),
province.municipalities.new(description: "Krupanj", region: region, country: state, continent: continent, geoname_id: 3343741, population: 0),
province.municipalities.new(description: "Ljubovija", region: region, country: state, continent: continent, geoname_id: 3343743, population: 0),
province.municipalities.new(description: "Loznica", region: region, country: state, continent: continent, geoname_id: 3343738, population: 0),
province.municipalities.new(description: "Mali Zvornik", region: region, country: state, continent: continent, geoname_id: 3343739, population: 0),
province.municipalities.new(description: "Vladimirci", region: region, country: state, continent: continent, geoname_id: 3343734, population: 0),
province.municipalities.new(description: "Šabac", region: region, country: state, continent: continent, geoname_id: 3343732, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Moravički", country: state, continent: continent,  geoname_id: 7581800, population: 0)
municipalities = [
province.municipalities.new(description: "Gornji Milanovac", region: region, country: state, continent: continent, geoname_id: 790366, population: 0),
province.municipalities.new(description: "Ivanjica", region: region, country: state, continent: continent, geoname_id: 789987, population: 0),
province.municipalities.new(description: "Lučani", region: region, country: state, continent: continent, geoname_id: 788451, population: 0),
province.municipalities.new(description: "Čačak", region: region, country: state, continent: continent, geoname_id: 792077, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nišavski", country: state, continent: continent,  geoname_id: 7581801, population: 0)
municipalities = [
province.municipalities.new(description: "Aleksinac", region: region, country: state, continent: continent, geoname_id: 793137, population: 0),
province.municipalities.new(description: "Doljevac", region: region, country: state, continent: continent, geoname_id: 791372, population: 0),
province.municipalities.new(description: "Gadžin Han", region: region, country: state, continent: continent, geoname_id: 790794, population: 0),
province.municipalities.new(description: "Merošina", region: region, country: state, continent: continent, geoname_id: 788025, population: 0),
province.municipalities.new(description: "Niš", region: region, country: state, continent: continent, geoname_id: 787656, population: 0),
province.municipalities.new(description: "Niš-Crveni Krst", region: region, country: state, continent: continent, geoname_id: 8260102, population: 0),
province.municipalities.new(description: "Niš-Medijana", region: region, country: state, continent: continent, geoname_id: 8260099, population: 0),
province.municipalities.new(description: "Niš-Palilula", region: region, country: state, continent: continent, geoname_id: 8260101, population: 0),
province.municipalities.new(description: "Niš-Pantelej", region: region, country: state, continent: continent, geoname_id: 8260100, population: 0),
province.municipalities.new(description: "Ražanj", region: region, country: state, continent: continent, geoname_id: 786389, population: 0),
province.municipalities.new(description: "Svrljig", region: region, country: state, continent: continent, geoname_id: 785162, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pirotski", country: state, continent: continent,  geoname_id: 7581803, population: 0)
municipalities = [
province.municipalities.new(description: "Babušnica", region: region, country: state, continent: continent, geoname_id: 793033, population: 0),
province.municipalities.new(description: "Bela Palanka", region: region, country: state, continent: continent, geoname_id: 792783, population: 0),
province.municipalities.new(description: "Dimitrovgrad", region: region, country: state, continent: continent, geoname_id: 791486, population: 0),
province.municipalities.new(description: "Pirot", region: region, country: state, continent: continent, geoname_id: 787049, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Podunavski", country: state, continent: continent,  geoname_id: 7581804, population: 0)
municipalities = [
province.municipalities.new(description: "Smederevo", region: region, country: state, continent: continent, geoname_id: 785755, population: 0),
province.municipalities.new(description: "Smederevska Palanka", region: region, country: state, continent: continent, geoname_id: 785752, population: 58000),
province.municipalities.new(description: "Velika Plana", region: region, country: state, continent: continent, geoname_id: 784629, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pomoravski", country: state, continent: continent,  geoname_id: 7581805, population: 0)
municipalities = [
province.municipalities.new(description: "Despotovac", region: region, country: state, continent: continent, geoname_id: 791515, population: 0),
province.municipalities.new(description: "Jagodina", region: region, country: state, continent: continent, geoname_id: 785186, population: 0),
province.municipalities.new(description: "Paraćin", region: region, country: state, continent: continent, geoname_id: 787214, population: 0),
province.municipalities.new(description: "Rekovac", region: region, country: state, continent: continent, geoname_id: 786357, population: 0),
province.municipalities.new(description: "Svilajnac", region: region, country: state, continent: continent, geoname_id: 785183, population: 0),
province.municipalities.new(description: "Ćuprija", region: region, country: state, continent: continent, geoname_id: 791677, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pčinjski", country: state, continent: continent,  geoname_id: 7581802, population: 0)
municipalities = [
province.municipalities.new(description: "Bosilegrad", region: region, country: state, continent: continent, geoname_id: 792420, population: 0),
province.municipalities.new(description: "Bujanovac", region: region, country: state, continent: continent, geoname_id: 792172, population: 0),
province.municipalities.new(description: "Preševo", region: region, country: state, continent: continent, geoname_id: 786771, population: 0),
province.municipalities.new(description: "Surdulica", region: region, country: state, continent: continent, geoname_id: 785284, population: 0),
province.municipalities.new(description: "Trgovište", region: region, country: state, continent: continent, geoname_id: 784943, population: 0),
province.municipalities.new(description: "Vladičin Han", region: region, country: state, continent: continent, geoname_id: 784354, population: 0),
province.municipalities.new(description: "Vranje", region: region, country: state, continent: continent, geoname_id: 784226, population: 0),
province.municipalities.new(description: "Vranjska Banja", region: region, country: state, continent: continent, geoname_id: 8260214, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Rasinski", country: state, continent: continent,  geoname_id: 7581806, population: 0)
municipalities = [
province.municipalities.new(description: "Aleksandrovac", region: region, country: state, continent: continent, geoname_id: 793140, population: 0),
province.municipalities.new(description: "Brus", region: region, country: state, continent: continent, geoname_id: 792240, population: 0),
province.municipalities.new(description: "Kruševac", region: region, country: state, continent: continent, geoname_id: 788974, population: 0),
province.municipalities.new(description: "Trstenik", region: region, country: state, continent: continent, geoname_id: 784872, population: 0),
province.municipalities.new(description: "Varvarin", region: region, country: state, continent: continent, geoname_id: 784703, population: 0),
province.municipalities.new(description: "Ćićevac Opština", region: region, country: state, continent: continent, geoname_id: 791935, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Raški", country: state, continent: continent,  geoname_id: 7581807, population: 0)
municipalities = [
province.municipalities.new(description: "Kraljevo", region: region, country: state, continent: continent, geoname_id: 789106, population: 0),
province.municipalities.new(description: "Novi Pazar", region: region, country: state, continent: continent, geoname_id: 787594, population: 0),
province.municipalities.new(description: "Raška", region: region, country: state, continent: continent, geoname_id: 786458, population: 0),
province.municipalities.new(description: "Tutin", region: region, country: state, continent: continent, geoname_id: 784799, population: 0),
province.municipalities.new(description: "Vrnjačka Banja", region: region, country: state, continent: continent, geoname_id: 784140, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Toplički", country: state, continent: continent,  geoname_id: 7581909, population: 0)
municipalities = [
province.municipalities.new(description: "Blace", region: region, country: state, continent: continent, geoname_id: 792563, population: 0),
province.municipalities.new(description: "Kuršumlija", region: region, country: state, continent: continent, geoname_id: 788851, population: 0),
province.municipalities.new(description: "Prokuplje", region: region, country: state, continent: continent, geoname_id: 786689, population: 0),
province.municipalities.new(description: "Žitorađa", region: region, country: state, continent: continent, geoname_id: 783879, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Zaječarski", country: state, continent: continent,  geoname_id: 7581910, population: 0)
municipalities = [
province.municipalities.new(description: "Boljevac", region: region, country: state, continent: continent, geoname_id: 792469, population: 0),
province.municipalities.new(description: "Knjaževac", region: region, country: state, continent: continent, geoname_id: 789414, population: 0),
province.municipalities.new(description: "Sokobanja", region: region, country: state, continent: continent, geoname_id: 785703, population: 0),
province.municipalities.new(description: "Zaječar", region: region, country: state, continent: continent, geoname_id: 784023, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Zlatiborski", country: state, continent: continent,  geoname_id: 7581912, population: 0)
municipalities = [
province.municipalities.new(description: "Arilje", region: region, country: state, continent: continent, geoname_id: 793092, population: 0),
province.municipalities.new(description: "Bajina Bašta", region: region, country: state, continent: continent, geoname_id: 3343746, population: 0),
province.municipalities.new(description: "Kosjerić", region: region, country: state, continent: continent, geoname_id: 3343745, population: 0),
province.municipalities.new(description: "Nova Varoš", region: region, country: state, continent: continent, geoname_id: 3343750, population: 0),
province.municipalities.new(description: "Požega", region: region, country: state, continent: continent, geoname_id: 786823, population: 0),
province.municipalities.new(description: "Priboj", region: region, country: state, continent: continent, geoname_id: 3343749, population: 0),
province.municipalities.new(description: "Prijepolje", region: region, country: state, continent: continent, geoname_id: 3343751, population: 0),
province.municipalities.new(description: "Sjenica", region: region, country: state, continent: continent, geoname_id: 865081, population: 0),
province.municipalities.new(description: "Užice-grad", region: region, country: state, continent: continent, geoname_id: 3343747, population: 0),
province.municipalities.new(description: "Čajetina", region: region, country: state, continent: continent, geoname_id: 3343748, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Šumadijski", country: state, continent: continent,  geoname_id: 7581908, population: 0)
municipalities = [
province.municipalities.new(description: "Aranđelovac", region: region, country: state, continent: continent, geoname_id: 793110, population: 0),
province.municipalities.new(description: "Batočina", region: region, country: state, continent: continent, geoname_id: 792829, population: 0),
province.municipalities.new(description: "Knić", region: region, country: state, continent: continent, geoname_id: 789416, population: 0),
province.municipalities.new(description: "Kragujevac", region: region, country: state, continent: continent, geoname_id: 789127, population: 0),
province.municipalities.new(description: "Lapovo", region: region, country: state, continent: continent, geoname_id: 865082, population: 0),
province.municipalities.new(description: "Rača", region: region, country: state, continent: continent, geoname_id: 786622, population: 0),
province.municipalities.new(description: "Topola", region: region, country: state, continent: continent, geoname_id: 785012, population: 0),
]
Municipality.import municipalities
