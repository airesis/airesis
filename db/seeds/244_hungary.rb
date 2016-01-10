continent = Continent.find_by(description: 'Europe')
state = Country.find_by(description: 'Hungary')
region = Region.create(description: "Baranya county", country: state, continent: continent, geoname_id: 3055399)
province = region.provinces.create(description: "Bólyi Járás", country: state, continent: continent,  geoname_id: 9644192, population: 0)
province = region.provinces.create(description: "Hegyháti Járás", country: state, continent: continent,  geoname_id: 9644195, population: 0)
province = region.provinces.create(description: "Komlói Járás", country: state, continent: continent,  geoname_id: 9644194, population: 0)
province = region.provinces.create(description: "Mohácsi Járás", country: state, continent: continent,  geoname_id: 9644191, population: 0)
province = region.provinces.create(description: "Pécsi Járás", country: state, continent: continent,  geoname_id: 9644190, population: 0)
province = region.provinces.create(description: "Pécsváradi Járás", country: state, continent: continent,  geoname_id: 9644193, population: 0)
province = region.provinces.create(description: "Sellyei Járás", country: state, continent: continent,  geoname_id: 9644260, population: 0)
province = region.provinces.create(description: "Siklósi Járás", country: state, continent: continent,  geoname_id: 9644189, population: 0)
province = region.provinces.create(description: "Szentlőrinci Járás", country: state, continent: continent,  geoname_id: 9644262, population: 0)
province = region.provinces.create(description: "Szigetvári Járás", country: state, continent: continent,  geoname_id: 9644261, population: 0)
region = Region.create(description: "Bekes County", country: state, continent: continent, geoname_id: 722433)
province = region.provinces.create(description: "Békéscsabai Járás", country: state, continent: continent,  geoname_id: 9644288, population: 0)
province = region.provinces.create(description: "Békési Járás", country: state, continent: continent,  geoname_id: 9644287, population: 0)
province = region.provinces.create(description: "Gyomaendrődi Járás", country: state, continent: continent,  geoname_id: 9644289, population: 0)
province = region.provinces.create(description: "Gyulai Járás", country: state, continent: continent,  geoname_id: 9644283, population: 0)
province = region.provinces.create(description: "Mezőkovácsházai Járás", country: state, continent: continent,  geoname_id: 9644284, population: 0)
province = region.provinces.create(description: "Orosházi Járás", country: state, continent: continent,  geoname_id: 9644285, population: 0)
province = region.provinces.create(description: "Sarkadi Járás", country: state, continent: continent,  geoname_id: 9644282, population: 0)
province = region.provinces.create(description: "Szarvasi Járás", country: state, continent: continent,  geoname_id: 9644286, population: 0)
province = region.provinces.create(description: "Szeghalmi Járás", country: state, continent: continent,  geoname_id: 9644281, population: 0)
region = Region.create(description: "Borsod-Abauj Zemplen county", country: state, continent: continent, geoname_id: 722064)
province = region.provinces.create(description: "Cigándi Járás", country: state, continent: continent,  geoname_id: 9644316, population: 0)
province = region.provinces.create(description: "Edelényi Járás", country: state, continent: continent,  geoname_id: 9644317, population: 0)
province = region.provinces.create(description: "Encsi Járás", country: state, continent: continent,  geoname_id: 9644318, population: 0)
province = region.provinces.create(description: "Gönci Járás", country: state, continent: continent,  geoname_id: 9644320, population: 0)
province = region.provinces.create(description: "Kazincbarcikai Járás", country: state, continent: continent,  geoname_id: 9644321, population: 0)
province = region.provinces.create(description: "Mezőcsáti Járás", country: state, continent: continent,  geoname_id: 9644322, population: 0)
province = region.provinces.create(description: "Mezőkövesdi Járás", country: state, continent: continent,  geoname_id: 9644323, population: 0)
province = region.provinces.create(description: "Miskolci Járás", country: state, continent: continent,  geoname_id: 9644324, population: 0)
province = region.provinces.create(description: "Putnoki Járás", country: state, continent: continent,  geoname_id: 9644326, population: 0)
province = region.provinces.create(description: "Szerencsi Járás", country: state, continent: continent,  geoname_id: 9644329, population: 0)
province = region.provinces.create(description: "Szikszói Járás", country: state, continent: continent,  geoname_id: 9644330, population: 0)
province = region.provinces.create(description: "Sárospataki Járás", country: state, continent: continent,  geoname_id: 9644327, population: 0)
province = region.provinces.create(description: "Sátoraljaújhelyi Járás", country: state, continent: continent,  geoname_id: 9644328, population: 0)
province = region.provinces.create(description: "Tiszaújvárosi Járás", country: state, continent: continent,  geoname_id: 9644331, population: 0)
province = region.provinces.create(description: "Tokaji Járás", country: state, continent: continent,  geoname_id: 9644332, population: 0)
province = region.provinces.create(description: "Ózdi Járás", country: state, continent: continent,  geoname_id: 9644325, population: 0)
region = Region.create(description: "Budapest főváros", country: state, continent: continent, geoname_id: 3054638)
province = region.provinces.create(description: "Budapest", country: state, continent: continent,  geoname_id: 3054643, population: 1741041)
municipalities = [
province.municipalities.new(description: "Adyliget", region: region, country: state, continent: continent, geoname_id: 3056402, population: 0),
province.municipalities.new(description: "Alagi Major", region: region, country: state, continent: continent, geoname_id: 3056334, population: 0),
province.municipalities.new(description: "Albertfalva", region: region, country: state, continent: continent, geoname_id: 3056327, population: 0),
province.municipalities.new(description: "Angyalföld", region: region, country: state, continent: continent, geoname_id: 3055970, population: 0),
province.municipalities.new(description: "Buda", region: region, country: state, continent: continent, geoname_id: 3054667, population: 0),
province.municipalities.new(description: "Budafok", region: region, country: state, continent: continent, geoname_id: 3054663, population: 0),
province.municipalities.new(description: "Budai vár", region: region, country: state, continent: continent, geoname_id: 3043197, population: 0),
province.municipalities.new(description: "Budapest I. kerület", region: region, country: state, continent: continent, geoname_id: 7284844, population: 24728),
province.municipalities.new(description: "Budapest II. kerület", region: region, country: state, continent: continent, geoname_id: 7284843, population: 88729),
province.municipalities.new(description: "Budapest III. kerület", region: region, country: state, continent: continent, geoname_id: 7284842, population: 123723),
province.municipalities.new(description: "Budapest IV. kerület", region: region, country: state, continent: continent, geoname_id: 7284831, population: 98374),
province.municipalities.new(description: "Budapest IX. kerület", region: region, country: state, continent: continent, geoname_id: 7284825, population: 61576),
province.municipalities.new(description: "Budapest V. kerület", region: region, country: state, continent: continent, geoname_id: 7117203, population: 0),
province.municipalities.new(description: "Budapest VI. kerület", region: region, country: state, continent: continent, geoname_id: 7284828, population: 42120),
province.municipalities.new(description: "Budapest VII. kerület", region: region, country: state, continent: continent, geoname_id: 7284827, population: 62530),
province.municipalities.new(description: "Budapest VIII. kerület", region: region, country: state, continent: continent, geoname_id: 7284826, population: 82222),
province.municipalities.new(description: "Budapest X. kerület", region: region, country: state, continent: continent, geoname_id: 7284834, population: 79270),
province.municipalities.new(description: "Budapest XI. kerület", region: region, country: state, continent: continent, geoname_id: 7284824, population: 139049),
province.municipalities.new(description: "Budapest XII. kerület", region: region, country: state, continent: continent, geoname_id: 7284823, population: 56544),
province.municipalities.new(description: "Budapest XIII. kerület", region: region, country: state, continent: continent, geoname_id: 7284830, population: 113531),
province.municipalities.new(description: "Budapest XIV. kerület", region: region, country: state, continent: continent, geoname_id: 7284829, population: 120148),
province.municipalities.new(description: "Budapest XIX. kerület", region: region, country: state, continent: continent, geoname_id: 7284835, population: 61610),
province.municipalities.new(description: "Budapest XV. kerület", region: region, country: state, continent: continent, geoname_id: 7284832, population: 80218),
province.municipalities.new(description: "Budapest XVI. kerület", region: region, country: state, continent: continent, geoname_id: 7284833, population: 68484),
province.municipalities.new(description: "Budapest XVII. kerület", region: region, country: state, continent: continent, geoname_id: 7284841, population: 78250),
province.municipalities.new(description: "Budapest XVIII. kerület", region: region, country: state, continent: continent, geoname_id: 7284836, population: 93225),
province.municipalities.new(description: "Budapest XX. kerület", region: region, country: state, continent: continent, geoname_id: 7284840, population: 63371),
province.municipalities.new(description: "Budapest XXI. kerület", region: region, country: state, continent: continent, geoname_id: 7284839, population: 76339),
province.municipalities.new(description: "Budapest XXII. kerület", region: region, country: state, continent: continent, geoname_id: 7284838, population: 50499),
province.municipalities.new(description: "Budapest XXIII. kerület", region: region, country: state, continent: continent, geoname_id: 7284837, population: 20387),
province.municipalities.new(description: "Budatétény", region: region, country: state, continent: continent, geoname_id: 3054630, population: 0),
province.municipalities.new(description: "Békásmegyer", region: region, country: state, continent: continent, geoname_id: 3055234, population: 0),
province.municipalities.new(description: "Cinkota", region: region, country: state, continent: continent, geoname_id: 3054484, population: 0),
province.municipalities.new(description: "Csepel", region: region, country: state, continent: continent, geoname_id: 3054269, population: 0),
province.municipalities.new(description: "Csillebérc", region: region, country: state, continent: continent, geoname_id: 3054063, population: 0),
province.municipalities.new(description: "Erzsébetpuszta", region: region, country: state, continent: continent, geoname_id: 3053180, population: 0),
province.municipalities.new(description: "Erzsébetváros", region: region, country: state, continent: continent, geoname_id: 3053176, population: 0),
province.municipalities.new(description: "Felsőhalom", region: region, country: state, continent: continent, geoname_id: 3052894, population: 0),
province.municipalities.new(description: "Ferencváros", region: region, country: state, continent: continent, geoname_id: 3052655, population: 0),
province.municipalities.new(description: "Gellérthegy", region: region, country: state, continent: continent, geoname_id: 3052342, population: 0),
province.municipalities.new(description: "Iharos", region: region, country: state, continent: continent, geoname_id: 3051194, population: 0),
province.municipalities.new(description: "Juliannamajor", region: region, country: state, continent: continent, geoname_id: 3050804, population: 0),
province.municipalities.new(description: "Kamaraerdő", region: region, country: state, continent: continent, geoname_id: 3050699, population: 0),
province.municipalities.new(description: "Kelenföld", region: region, country: state, continent: continent, geoname_id: 3050393, population: 0),
province.municipalities.new(description: "Kelenvölgy", region: region, country: state, continent: continent, geoname_id: 3050392, population: 0),
province.municipalities.new(description: "Kis-Gellérthegy", region: region, country: state, continent: continent, geoname_id: 3049998, population: 0),
province.municipalities.new(description: "Kispest", region: region, country: state, continent: continent, geoname_id: 3049795, population: 0),
province.municipalities.new(description: "Középhegy", region: region, country: state, continent: continent, geoname_id: 3049249, population: 0),
province.municipalities.new(description: "Kőbánya", region: region, country: state, continent: continent, geoname_id: 3049646, population: 0),
province.municipalities.new(description: "Lágymányos", region: region, country: state, continent: continent, geoname_id: 3049022, population: 0),
province.municipalities.new(description: "Makkosmária", region: region, country: state, continent: continent, geoname_id: 3048398, population: 0),
province.municipalities.new(description: "Mártonhegy", region: region, country: state, continent: continent, geoname_id: 3048331, population: 0),
province.municipalities.new(description: "Mátyásföld", region: region, country: state, continent: continent, geoname_id: 3048274, population: 0),
province.municipalities.new(description: "Nagytétény", region: region, country: state, continent: continent, geoname_id: 3047502, population: 0),
province.municipalities.new(description: "Naphegy", region: region, country: state, continent: continent, geoname_id: 3047450, population: 0),
province.municipalities.new(description: "Neu-Pest", region: region, country: state, continent: continent, geoname_id: 3043470, population: 0),
province.municipalities.new(description: "Pest", region: region, country: state, continent: continent, geoname_id: 3046446, population: 0),
province.municipalities.new(description: "Pesterzsébet", region: region, country: state, continent: continent, geoname_id: 3046445, population: 0),
province.municipalities.new(description: "Pesthidegkút", region: region, country: state, continent: continent, geoname_id: 3046442, population: 0),
province.municipalities.new(description: "Pestimre", region: region, country: state, continent: continent, geoname_id: 3046438, population: 0),
province.municipalities.new(description: "Pestlőrinc", region: region, country: state, continent: continent, geoname_id: 3046433, population: 0),
province.municipalities.new(description: "Pestújhely", region: region, country: state, continent: continent, geoname_id: 3046430, population: 0),
province.municipalities.new(description: "Remetekertváros", region: region, country: state, continent: continent, geoname_id: 3045898, population: 0),
province.municipalities.new(description: "Ráczug", region: region, country: state, continent: continent, geoname_id: 3046012, population: 0),
province.municipalities.new(description: "Rákoshegy", region: region, country: state, continent: continent, geoname_id: 3045974, population: 0),
province.municipalities.new(description: "Rákoskeresztúr", region: region, country: state, continent: continent, geoname_id: 3045971, population: 0),
province.municipalities.new(description: "Rákosliget", region: region, country: state, continent: continent, geoname_id: 3045968, population: 0),
province.municipalities.new(description: "Rákospalota", region: region, country: state, continent: continent, geoname_id: 3045965, population: 0),
province.municipalities.new(description: "Rákosszentmihály", region: region, country: state, continent: continent, geoname_id: 3045960, population: 0),
province.municipalities.new(description: "Rétipálya", region: region, country: state, continent: continent, geoname_id: 3045855, population: 0),
province.municipalities.new(description: "Rómaifürdő", region: region, country: state, continent: continent, geoname_id: 3045762, population: 0),
province.municipalities.new(description: "Sashalom", region: region, country: state, continent: continent, geoname_id: 3045476, population: 0),
province.municipalities.new(description: "Sikátorpuszta", region: region, country: state, continent: continent, geoname_id: 3045367, population: 0),
province.municipalities.new(description: "Soroksár", region: region, country: state, continent: continent, geoname_id: 3045154, population: 0),
province.municipalities.new(description: "Szabadságliget", region: region, country: state, continent: continent, geoname_id: 3045021, population: 0),
province.municipalities.new(description: "Széchenyitelep", region: region, country: state, continent: continent, geoname_id: 3044811, population: 0),
province.municipalities.new(description: "Tabán", region: region, country: state, continent: continent, geoname_id: 3044219, population: 0),
province.municipalities.new(description: "Teréziamajor", region: region, country: state, continent: continent, geoname_id: 3043965, population: 0),
province.municipalities.new(description: "Városmajor", region: region, country: state, continent: continent, geoname_id: 3043097, population: 0),
province.municipalities.new(description: "Zugliget", region: region, country: state, continent: continent, geoname_id: 3042431, population: 0),
province.municipalities.new(description: "Zugló", region: region, country: state, continent: continent, geoname_id: 3042430, population: 0),
province.municipalities.new(description: "Óbuda", region: region, country: state, continent: continent, geoname_id: 3047211, population: 0),
province.municipalities.new(description: "Újpalota", region: region, country: state, continent: continent, geoname_id: 6690770, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Bács-Kiskun county", country: state, continent: continent, geoname_id: 3055744)
province = region.provinces.create(description: "Bajai Járás", country: state, continent: continent,  geoname_id: 9644263, population: 0)
province = region.provinces.create(description: "Bácsalmási Járás", country: state, continent: continent,  geoname_id: 9644264, population: 0)
province = region.provinces.create(description: "Jánoshalmai Járás", country: state, continent: continent,  geoname_id: 9644265, population: 0)
province = region.provinces.create(description: "Kalocsai Járás", country: state, continent: continent,  geoname_id: 9644268, population: 0)
province = region.provinces.create(description: "Kecskeméti Járás", country: state, continent: continent,  geoname_id: 9644271, population: 0)
province = region.provinces.create(description: "Kiskunfélegyházi Járás", country: state, continent: continent,  geoname_id: 9644273, population: 0)
province = region.provinces.create(description: "Kiskunhalasi Járás", country: state, continent: continent,  geoname_id: 9644266, population: 0)
province = region.provinces.create(description: "Kiskunmajsai Járás", country: state, continent: continent,  geoname_id: 9644267, population: 0)
province = region.provinces.create(description: "Kiskőrösi Járás", country: state, continent: continent,  geoname_id: 9644269, population: 0)
province = region.provinces.create(description: "Kunszentmiklósi Járás", country: state, continent: continent,  geoname_id: 9644270, population: 0)
province = region.provinces.create(description: "Tiszakécskei Járás", country: state, continent: continent,  geoname_id: 9644272, population: 0)
region = Region.create(description: "Csongrád megye", country: state, continent: continent, geoname_id: 721589)
province = region.provinces.create(description: "Csongrádi Járás", country: state, continent: continent,  geoname_id: 9644279, population: 0)
province = region.provinces.create(description: "Hódmezővásárhelyi Járás", country: state, continent: continent,  geoname_id: 9644278, population: 0)
province = region.provinces.create(description: "Kisteleki Járás", country: state, continent: continent,  geoname_id: 9644277, population: 0)
province = region.provinces.create(description: "Makói Járás", country: state, continent: continent,  geoname_id: 9644276, population: 0)
province = region.provinces.create(description: "Mórahalmi Járás", country: state, continent: continent,  geoname_id: 9644274, population: 0)
province = region.provinces.create(description: "Szegedi Járás", country: state, continent: continent,  geoname_id: 9644275, population: 0)
province = region.provinces.create(description: "Szentesi Járás", country: state, continent: continent,  geoname_id: 9644280, population: 0)
region = Region.create(description: "Fejér megye", country: state, continent: continent, geoname_id: 3053028)
province = region.provinces.create(description: "Bicskei Járás", country: state, continent: continent,  geoname_id: 9644763, population: 0)
province = region.provinces.create(description: "Dunaújvárosi Járás", country: state, continent: continent,  geoname_id: 9644766, population: 0)
province = region.provinces.create(description: "Enyingi Járás", country: state, continent: continent,  geoname_id: 9644770, population: 0)
province = region.provinces.create(description: "Gárdonyi Járás", country: state, continent: continent,  geoname_id: 9644765, population: 0)
province = region.provinces.create(description: "Martonvásári Járás", country: state, continent: continent,  geoname_id: 9644764, population: 0)
province = region.provinces.create(description: "Móri Járás", country: state, continent: continent,  geoname_id: 9644771, population: 0)
province = region.provinces.create(description: "Polgárdi Járás", country: state, continent: continent,  geoname_id: 9644769, population: 0)
province = region.provinces.create(description: "Székesfehérvári Járás", country: state, continent: continent,  geoname_id: 9644767, population: 0)
province = region.provinces.create(description: "Sárbogárdi Járás", country: state, continent: continent,  geoname_id: 9644768, population: 0)
region = Region.create(description: "Győr-Moson-Sopron megye", country: state, continent: continent, geoname_id: 3051977)
province = region.provinces.create(description: "Csornai Járás", country: state, continent: continent,  geoname_id: 9644149, population: 0)
province = region.provinces.create(description: "Győri Járás", country: state, continent: continent,  geoname_id: 9644151, population: 0)
province = region.provinces.create(description: "Kapuvári Járás", country: state, continent: continent,  geoname_id: 9644148, population: 0)
province = region.provinces.create(description: "Mosonmagyaróvári Járás", country: state, continent: continent,  geoname_id: 9644150, population: 0)
province = region.provinces.create(description: "Pannonhalmi Járás", country: state, continent: continent,  geoname_id: 9644153, population: 0)
province = region.provinces.create(description: "Soproni Járás", country: state, continent: continent,  geoname_id: 9644140, population: 0)
province = region.provinces.create(description: "Téti Járás", country: state, continent: continent,  geoname_id: 9644152, population: 0)
region = Region.create(description: "Hajdú-Bihar", country: state, continent: continent, geoname_id: 720293)
province = region.provinces.create(description: "Balmazújvárosi Járás", country: state, continent: continent,  geoname_id: 9644296, population: 0)
province = region.provinces.create(description: "Berettyóújfalui Járás", country: state, continent: continent,  geoname_id: 9644294, population: 0)
province = region.provinces.create(description: "Debreceni Járás", country: state, continent: continent,  geoname_id: 9644292, population: 0)
province = region.provinces.create(description: "Derecskei Járás", country: state, continent: continent,  geoname_id: 9644298, population: 0)
province = region.provinces.create(description: "Hadjúszoboszlói Járás", country: state, continent: continent,  geoname_id: 9644295, population: 0)
province = region.provinces.create(description: "Hajdúböszörményi Járás", country: state, continent: continent,  geoname_id: 9644297, population: 0)
province = region.provinces.create(description: "Hajdúhadházi Járás", country: state, continent: continent,  geoname_id: 9644291, population: 0)
province = region.provinces.create(description: "Hajdúnánási Járás", country: state, continent: continent,  geoname_id: 9644299, population: 0)
province = region.provinces.create(description: "Nyíradonyi Járás", country: state, continent: continent,  geoname_id: 9644300, population: 0)
province = region.provinces.create(description: "Püspökladányi Járás", country: state, continent: continent,  geoname_id: 9644293, population: 0)
region = Region.create(description: "Heves megye", country: state, continent: continent, geoname_id: 720002)
province = region.provinces.create(description: "Bélapátfalvai Járás", country: state, continent: continent,  geoname_id: 9644333, population: 0)
province = region.provinces.create(description: "Egri Járás", country: state, continent: continent,  geoname_id: 9644334, population: 0)
province = region.provinces.create(description: "Füzesabonyi Járás", country: state, continent: continent,  geoname_id: 9644335, population: 0)
province = region.provinces.create(description: "Gyöngyösi Járás", country: state, continent: continent,  geoname_id: 9644336, population: 0)
province = region.provinces.create(description: "Hatvani Járás", country: state, continent: continent,  geoname_id: 9644337, population: 0)
province = region.provinces.create(description: "Hevesi Járás", country: state, continent: continent,  geoname_id: 9644338, population: 0)
province = region.provinces.create(description: "Pétervásárai Járás", country: state, continent: continent,  geoname_id: 9644339, population: 0)
region = Region.create(description: "Jász-Nagykun-Szolnok", country: state, continent: continent, geoname_id: 719637)
province = region.provinces.create(description: "Jászapáti Járás", country: state, continent: continent,  geoname_id: 9644780, population: 0)
province = region.provinces.create(description: "Jászberényi Járás", country: state, continent: continent,  geoname_id: 9644779, population: 0)
province = region.provinces.create(description: "Karcagi Járás", country: state, continent: continent,  geoname_id: 9644785, population: 0)
province = region.provinces.create(description: "Kunhegyesi Járás", country: state, continent: continent,  geoname_id: 9644787, population: 0)
province = region.provinces.create(description: "Kunszentmártoni Járás", country: state, continent: continent,  geoname_id: 9644783, population: 0)
province = region.provinces.create(description: "Mezőtúri Járás", country: state, continent: continent,  geoname_id: 9644784, population: 0)
province = region.provinces.create(description: "Szolnoki Járás", country: state, continent: continent,  geoname_id: 9644781, population: 0)
province = region.provinces.create(description: "Tiszafüredi Járás", country: state, continent: continent,  geoname_id: 9644786, population: 0)
province = region.provinces.create(description: "Törökszentmiklósi Járás", country: state, continent: continent,  geoname_id: 9644782, population: 0)
region = Region.create(description: "Komárom-Esztergom", country: state, continent: continent, geoname_id: 3049518)
province = region.provinces.create(description: "Esztergomi Járás", country: state, continent: continent,  geoname_id: 9644744, population: 0)
province = region.provinces.create(description: "Kisbéri Járás", country: state, continent: continent,  geoname_id: 9644748, population: 0)
province = region.provinces.create(description: "Komáromi Járás", country: state, continent: continent,  geoname_id: 9644747, population: 0)
province = region.provinces.create(description: "Oroszlányi Járás", country: state, continent: continent,  geoname_id: 9644749, population: 0)
province = region.provinces.create(description: "Tatabányai Járás", country: state, continent: continent,  geoname_id: 9644745, population: 0)
province = region.provinces.create(description: "Tatai Járás", country: state, continent: continent,  geoname_id: 9644746, population: 0)
region = Region.create(description: "Nógrád megye", country: state, continent: continent, geoname_id: 3047348)
province = region.provinces.create(description: "Balassagyarmati Járás", country: state, continent: continent,  geoname_id: 9644340, population: 0)
province = region.provinces.create(description: "Bátonyterenyei Járás", country: state, continent: continent,  geoname_id: 9644341, population: 0)
province = region.provinces.create(description: "Pásztói Járás", country: state, continent: continent,  geoname_id: 9644343, population: 0)
province = region.provinces.create(description: "Rétsági Járás", country: state, continent: continent,  geoname_id: 9644344, population: 0)
province = region.provinces.create(description: "Salgótarjáni Járás", country: state, continent: continent,  geoname_id: 9644345, population: 0)
province = region.provinces.create(description: "Szécsényi Járás", country: state, continent: continent,  geoname_id: 9644346, population: 0)
region = Region.create(description: "Pest megye", country: state, continent: continent, geoname_id: 3046431)
province = region.provinces.create(description: "Aszódi Járás", country: state, continent: continent,  geoname_id: 9644348, population: 0)
province = region.provinces.create(description: "Budakeszi Járás", country: state, continent: continent,  geoname_id: 9644349, population: 0)
province = region.provinces.create(description: "Ceglédi Járás", country: state, continent: continent,  geoname_id: 9644350, population: 0)
province = region.provinces.create(description: "Dabasi Járás", country: state, continent: continent,  geoname_id: 9644351, population: 0)
province = region.provinces.create(description: "Dunakeszi Járás", country: state, continent: continent,  geoname_id: 9644352, population: 0)
province = region.provinces.create(description: "Gyáli Járás", country: state, continent: continent,  geoname_id: 9644355, population: 0)
province = region.provinces.create(description: "Gödöllői Járás", country: state, continent: continent,  geoname_id: 9644354, population: 0)
province = region.provinces.create(description: "Monori Járás", country: state, continent: continent,  geoname_id: 9644356, population: 0)
province = region.provinces.create(description: "Nagykátai Járás", country: state, continent: continent,  geoname_id: 9644735, population: 0)
province = region.provinces.create(description: "Nagykőrösi Járás", country: state, continent: continent,  geoname_id: 9644742, population: 0)
province = region.provinces.create(description: "Pilisvörösvári Járás", country: state, continent: continent,  geoname_id: 9644739, population: 0)
province = region.provinces.create(description: "Ráckevei Járás", country: state, continent: continent,  geoname_id: 9644737, population: 0)
province = region.provinces.create(description: "Szentendrei Járás", country: state, continent: continent,  geoname_id: 9644738, population: 0)
province = region.provinces.create(description: "Szigetszentmiklósi Járás", country: state, continent: continent,  geoname_id: 9644736, population: 0)
province = region.provinces.create(description: "Szobi Járás", country: state, continent: continent,  geoname_id: 9644740, population: 0)
province = region.provinces.create(description: "Vecsési Járás", country: state, continent: continent,  geoname_id: 9644741, population: 0)
province = region.provinces.create(description: "Váci Járás", country: state, continent: continent,  geoname_id: 9644347, population: 0)
province = region.provinces.create(description: "Érdi Járás", country: state, continent: continent,  geoname_id: 9644353, population: 0)
region = Region.create(description: "Somogy megye", country: state, continent: continent, geoname_id: 3045226)
province = region.provinces.create(description: "Barcsi Járás", country: state, continent: continent,  geoname_id: 9644177, population: 0)
province = region.provinces.create(description: "Csurgói Járás", country: state, continent: continent,  geoname_id: 9644179, population: 0)
province = region.provinces.create(description: "Fonyódi Járás", country: state, continent: continent,  geoname_id: 9644182, population: 0)
province = region.provinces.create(description: "Kaposvári Járás", country: state, continent: continent,  geoname_id: 9644180, population: 0)
province = region.provinces.create(description: "Marcali Járás", country: state, continent: continent,  geoname_id: 9644181, population: 0)
province = region.provinces.create(description: "Nagyatádi Járás", country: state, continent: continent,  geoname_id: 9644178, population: 0)
province = region.provinces.create(description: "Siófoki Járás", country: state, continent: continent,  geoname_id: 9644187, population: 0)
province = region.provinces.create(description: "Tabi Járás", country: state, continent: continent,  geoname_id: 9644188, population: 0)
region = Region.create(description: "Szabolcs-Szatmár-Bereg", country: state, continent: continent, geoname_id: 715593)
province = region.provinces.create(description: "Baktalórántházai Járás", country: state, continent: continent,  geoname_id: 9644307, population: 0)
province = region.provinces.create(description: "Csengeri Járás", country: state, continent: continent,  geoname_id: 9644313, population: 0)
province = region.provinces.create(description: "Fehérgyarmati Járás", country: state, continent: continent,  geoname_id: 9644312, population: 0)
province = region.provinces.create(description: "Ibrányi Járás", country: state, continent: continent,  geoname_id: 9644314, population: 0)
province = region.provinces.create(description: "Kemecsei Járás", country: state, continent: continent,  geoname_id: 9644308, population: 0)
province = region.provinces.create(description: "Kisvárdai Járás", country: state, continent: continent,  geoname_id: 9644309, population: 0)
province = region.provinces.create(description: "Mátészalkai Járás", country: state, continent: continent,  geoname_id: 9644306, population: 0)
province = region.provinces.create(description: "Nagykállói Járás", country: state, continent: continent,  geoname_id: 9644304, population: 0)
province = region.provinces.create(description: "Nyírbátori Járás", country: state, continent: continent,  geoname_id: 9644305, population: 0)
province = region.provinces.create(description: "Nyíregyházi Járás", country: state, continent: continent,  geoname_id: 9644303, population: 0)
province = region.provinces.create(description: "Tiszavasvári Járás", country: state, continent: continent,  geoname_id: 9644302, population: 0)
province = region.provinces.create(description: "Vásárosnaményi Járás", country: state, continent: continent,  geoname_id: 9644311, population: 0)
province = region.provinces.create(description: "Záhonyi Járás", country: state, continent: continent,  geoname_id: 9644310, population: 0)
region = Region.create(description: "Tolna megye", country: state, continent: continent, geoname_id: 3043845)
province = region.provinces.create(description: "Bonyhádi Járás", country: state, continent: continent,  geoname_id: 9644774, population: 0)
province = region.provinces.create(description: "Dombóvári Járás", country: state, continent: continent,  geoname_id: 9644773, population: 0)
province = region.provinces.create(description: "Paksi Járás", country: state, continent: continent,  geoname_id: 9644777, population: 0)
province = region.provinces.create(description: "Szekszárdi Járás", country: state, continent: continent,  geoname_id: 9644776, population: 0)
province = region.provinces.create(description: "Tamási Járás", country: state, continent: continent,  geoname_id: 9644772, population: 0)
province = region.provinces.create(description: "Tolnai Járás", country: state, continent: continent,  geoname_id: 9644775, population: 0)
region = Region.create(description: "Vas megye", country: state, continent: continent, geoname_id: 3043047)
province = region.provinces.create(description: "Celldömölki Járás", country: state, continent: continent,  geoname_id: 9644160, population: 0)
province = region.provinces.create(description: "Körmendi Járás", country: state, continent: continent,  geoname_id: 9644157, population: 0)
province = region.provinces.create(description: "Kőszegi Járás", country: state, continent: continent,  geoname_id: 9644154, population: 0)
province = region.provinces.create(description: "Szentgotthárdi Járás", country: state, continent: continent,  geoname_id: 9644156, population: 0)
province = region.provinces.create(description: "Szombathelyi Járás", country: state, continent: continent,  geoname_id: 9644155, population: 0)
province = region.provinces.create(description: "Sárvári Járás", country: state, continent: continent,  geoname_id: 9644159, population: 0)
province = region.provinces.create(description: "Vasvári Járás", country: state, continent: continent,  geoname_id: 9644158, population: 0)
region = Region.create(description: "Veszprém megye", country: state, continent: continent, geoname_id: 3042925)
province = region.provinces.create(description: "Ajkai Járás", country: state, continent: continent,  geoname_id: 9644757, population: 0)
province = region.provinces.create(description: "Balatonalmádi Járás", country: state, continent: continent,  geoname_id: 9644753, population: 0)
province = region.provinces.create(description: "Balatonfüredi Járás", country: state, continent: continent,  geoname_id: 9644754, population: 0)
province = region.provinces.create(description: "Devecseri Járás", country: state, continent: continent,  geoname_id: 9644758, population: 0)
province = region.provinces.create(description: "Pápai Járás", country: state, continent: continent,  geoname_id: 9644750, population: 0)
province = region.provinces.create(description: "Sümegi Járás", country: state, continent: continent,  geoname_id: 9644756, population: 0)
province = region.provinces.create(description: "Tapolcai Járás", country: state, continent: continent,  geoname_id: 9644755, population: 0)
province = region.provinces.create(description: "Veszprémi Járás", country: state, continent: continent,  geoname_id: 9644759, population: 0)
province = region.provinces.create(description: "Várpalotai Járás", country: state, continent: continent,  geoname_id: 9644752, population: 0)
province = region.provinces.create(description: "Zirci Járás", country: state, continent: continent,  geoname_id: 9644751, population: 0)
region = Region.create(description: "Zala megye", country: state, continent: continent, geoname_id: 3042613)
province = region.provinces.create(description: "Keszthelyi Járás", country: state, continent: continent,  geoname_id: 9644171, population: 0)
province = region.provinces.create(description: "Lenti Járás", country: state, continent: continent,  geoname_id: 9644168, population: 0)
province = region.provinces.create(description: "Letenyei Járás", country: state, continent: continent,  geoname_id: 9644169, population: 0)
province = region.provinces.create(description: "Nagykanizsai Járás", country: state, continent: continent,  geoname_id: 9644172, population: 0)
province = region.provinces.create(description: "Zalaegerszegi Járás", country: state, continent: continent,  geoname_id: 9644167, population: 0)
province = region.provinces.create(description: "Zalaszentgróti Járás", country: state, continent: continent,  geoname_id: 9644170, population: 0)
