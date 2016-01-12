continent = Continent.find_by(description: 'Europe')
state = Country.find_by(description: 'France')
region = Region.create(description: "Alsace", country: state, continent: continent, geoname_id: 3038033)
province = region.provinces.create(description: "Bas-Rhin", country: state, continent: continent,  geoname_id: 3034720, population: 1113207)
municipalities = [
province.municipalities.new(description: "Haguenau", region: region, country: state, continent: continent, geoname_id: 3014077, population: 131950),
province.municipalities.new(description: "Molsheim", region: region, country: state, continent: continent, geoname_id: 2993475, population: 99581),
province.municipalities.new(description: "Saverne", region: region, country: state, continent: continent, geoname_id: 2975587, population: 95152),
province.municipalities.new(description: "Strasbourg-Campagne", region: region, country: state, continent: continent, geoname_id: 2973782, population: 285348),
province.municipalities.new(description: "Strasbourg-Ville", region: region, country: state, continent: continent, geoname_id: 2973781, population: 276136),
province.municipalities.new(description: "Sélestat-Erstein", region: region, country: state, continent: continent, geoname_id: 2975232, population: 155020),
province.municipalities.new(description: "Wissembourg", region: region, country: state, continent: continent, geoname_id: 2967324, population: 70020),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haut-Rhin", country: state, continent: continent,  geoname_id: 3013663, population: 764064)
municipalities = [
province.municipalities.new(description: "Colmar", region: region, country: state, continent: continent, geoname_id: 3024296, population: 151435),
province.municipalities.new(description: "Guebwiller", region: region, country: state, continent: continent, geoname_id: 3014432, population: 84574),
province.municipalities.new(description: "Mulhouse", region: region, country: state, continent: continent, geoname_id: 2991213, population: 323051),
province.municipalities.new(description: "Ribeauvillé", region: region, country: state, continent: continent, geoname_id: 2983703, population: 52398),
province.municipalities.new(description: "Thann", region: region, country: state, continent: continent, geoname_id: 2973012, population: 82841),
province.municipalities.new(description: "Altkirch", region: region, country: state, continent: continent, geoname_id: 3038011, population: 69765),
]
Municipality.import municipalities
region = Region.create(description: "Aquitaine", country: state, continent: continent, geoname_id: 3037350)
province = region.provinces.create(description: "Dordogne", country: state, continent: continent,  geoname_id: 3021042, population: 424456)
municipalities = [
province.municipalities.new(description: "Bergerac", region: region, country: state, continent: continent, geoname_id: 3033390, population: 113197),
province.municipalities.new(description: "Nontron", region: region, country: state, continent: continent, geoname_id: 2990139, population: 42802),
province.municipalities.new(description: "Périgueux", region: region, country: state, continent: continent, geoname_id: 2987966, population: 191663),
province.municipalities.new(description: "Sarlat-la-Canéda", region: region, country: state, continent: continent, geoname_id: 2976008, population: 76794),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gironde", country: state, continent: continent,  geoname_id: 3015948, population: 1464088)
municipalities = [
province.municipalities.new(description: "Arcachon", region: region, country: state, continent: continent, geoname_id: 6621469, population: 137329),
province.municipalities.new(description: "Blaye", region: region, country: state, continent: continent, geoname_id: 3032294, population: 84169),
province.municipalities.new(description: "Bordeaux", region: region, country: state, continent: continent, geoname_id: 3031580, population: 880388),
province.municipalities.new(description: "Langon", region: region, country: state, continent: continent, geoname_id: 3007688, population: 128066),
province.municipalities.new(description: "Lesparre-Médoc", region: region, country: state, continent: continent, geoname_id: 3000071, population: 82788),
province.municipalities.new(description: "Libourne", region: region, country: state, continent: continent, geoname_id: 2998516, population: 151348),
]
Municipality.import municipalities
province = region.provinces.create(description: "Landes", country: state, continent: continent,  geoname_id: 3007866, population: 392592)
municipalities = [
province.municipalities.new(description: "Dax", region: region, country: state, continent: continent, geoname_id: 3021669, population: 213924),
province.municipalities.new(description: "Mont-de-Marsan", region: region, country: state, continent: continent, geoname_id: 2992770, population: 178668),
]
Municipality.import municipalities
province = region.provinces.create(description: "Lot-et-Garonne", country: state, continent: continent,  geoname_id: 2997523, population: 341132)
municipalities = [
province.municipalities.new(description: "Marmande", region: region, country: state, continent: continent, geoname_id: 2995640, population: 84910),
province.municipalities.new(description: "Nérac", region: region, country: state, continent: continent, geoname_id: 2990779, population: 40446),
province.municipalities.new(description: "Villeneuve-sur-Lot", region: region, country: state, continent: continent, geoname_id: 2968514, population: 94255),
province.municipalities.new(description: "Agen", region: region, country: state, continent: continent, geoname_id: 3038633, population: 121521),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pyrénées-Atlantiques", country: state, continent: continent,  geoname_id: 2984887, population: 671644)
municipalities = [
province.municipalities.new(description: "Bayonne", region: region, country: state, continent: continent, geoname_id: 3034473, population: 282180),
province.municipalities.new(description: "Pau", region: region, country: state, continent: continent, geoname_id: 2988356, population: 311555),
province.municipalities.new(description: "Oloron-Sainte-Marie", region: region, country: state, continent: continent, geoname_id: 2989568, population: 77909),
]
Municipality.import municipalities
region = Region.create(description: "Auvergne", country: state, continent: continent, geoname_id: 3035876)
province = region.provinces.create(description: "Allier", country: state, continent: continent,  geoname_id: 3038111, population: 353362)
municipalities = [
province.municipalities.new(description: "Montluçon", region: region, country: state, continent: continent, geoname_id: 2992291, population: 119684),
province.municipalities.new(description: "Moulins", region: region, country: state, continent: continent, geoname_id: 2991477, population: 109603),
province.municipalities.new(description: "Vichy", region: region, country: state, continent: continent, geoname_id: 2969391, population: 124075),
]
Municipality.import municipalities
province = region.provinces.create(description: "Cantal", country: state, continent: continent,  geoname_id: 3028791, population: 154354)
municipalities = [
province.municipalities.new(description: "Mauriac", region: region, country: state, continent: continent, geoname_id: 2995023, population: 27913),
province.municipalities.new(description: "Saint-Flour", region: region, country: state, continent: continent, geoname_id: 2980102, population: 40333),
province.municipalities.new(description: "Aurillac", region: region, country: state, continent: continent, geoname_id: 3036015, population: 86108),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Loire", country: state, continent: continent,  geoname_id: 3013760, population: 231066)
municipalities = [
province.municipalities.new(description: "Brioude", region: region, country: state, continent: continent, geoname_id: 3029994, population: 48290),
province.municipalities.new(description: "Puy", region: region, country: state, continent: continent, geoname_id: 2985020, population: 98555),
province.municipalities.new(description: "Yssingeaux", region: region, country: state, continent: continent, geoname_id: 2967202, population: 84221),
]
Municipality.import municipalities
province = region.provinces.create(description: "Puy-de-Dôme", country: state, continent: continent,  geoname_id: 2984986, population: 646908)
municipalities = [
province.municipalities.new(description: "Clermont-Ferrand", region: region, country: state, continent: continent, geoname_id: 3024634, population: 376622),
province.municipalities.new(description: "Riom", region: region, country: state, continent: continent, geoname_id: 2983488, population: 120497),
province.municipalities.new(description: "Thiers", region: region, country: state, continent: continent, geoname_id: 2972855, population: 58478),
province.municipalities.new(description: "Ambert", region: region, country: state, continent: continent, geoname_id: 3037936, population: 28221),
province.municipalities.new(description: "Issoire", region: region, country: state, continent: continent, geoname_id: 3012661, population: 63090),
]
Municipality.import municipalities
region = Region.create(description: "Bretagne", country: state, continent: continent, geoname_id: 3030293)
province = region.provinces.create(description: "Côtes-d'Armor", country: state, continent: continent,  geoname_id: 3023414, population: 608356)
municipalities = [
province.municipalities.new(description: "Dinan", region: region, country: state, continent: continent, geoname_id: 3021353, population: 129573),
province.municipalities.new(description: "Guingamp", region: region, country: state, continent: continent, geoname_id: 3014220, population: 90366),
province.municipalities.new(description: "Lannion", region: region, country: state, continent: continent, geoname_id: 3007608, population: 104500),
province.municipalities.new(description: "Saint-Brieuc", region: region, country: state, continent: continent, geoname_id: 2981279, population: 283917),
]
Municipality.import municipalities
province = region.provinces.create(description: "Finistère", country: state, continent: continent,  geoname_id: 3018471, population: 925442)
municipalities = [
province.municipalities.new(description: "Brest", region: region, country: state, continent: continent, geoname_id: 3030299, population: 376907),
province.municipalities.new(description: "Châteaulin", region: region, country: state, continent: continent, geoname_id: 3026260, population: 89213),
province.municipalities.new(description: "Morlaix", region: region, country: state, continent: continent, geoname_id: 2991771, population: 133534),
province.municipalities.new(description: "Quimper", region: region, country: state, continent: continent, geoname_id: 2984700, population: 325788),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ille-et-Vilaine", country: state, continent: continent,  geoname_id: 3012849, population: 1003933)
municipalities = [
province.municipalities.new(description: "Fougères-Vitré", region: region, country: state, continent: continent, geoname_id: 3017608, population: 176020),
province.municipalities.new(description: "Redon", region: region, country: state, continent: continent, geoname_id: 2984191, population: 102755),
province.municipalities.new(description: "Rennes", region: region, country: state, continent: continent, geoname_id: 2983989, population: 567050),
province.municipalities.new(description: "Saint-Malo", region: region, country: state, continent: continent, geoname_id: 2978639, population: 158108),
]
Municipality.import municipalities
province = region.provinces.create(description: "Morbihan", country: state, continent: continent,  geoname_id: 2991879, population: 739144)
municipalities = [
province.municipalities.new(description: "Lorient", region: region, country: state, continent: continent, geoname_id: 2997576, population: 314289),
province.municipalities.new(description: "Pontivy", region: region, country: state, continent: continent, geoname_id: 2986159, population: 127332),
province.municipalities.new(description: "Vannes", region: region, country: state, continent: continent, geoname_id: 2970775, population: 297523),
]
Municipality.import municipalities
region = Region.create(description: "Corse", country: state, continent: continent, geoname_id: 3023519)
province = region.provinces.create(description: "Corse-du-Sud", country: state, continent: continent,  geoname_id: 3023514, population: 143724)
municipalities = [
province.municipalities.new(description: "Sartène", region: region, country: state, continent: continent, geoname_id: 2975930, population: 38427),
province.municipalities.new(description: "Ajaccio", region: region, country: state, continent: continent, geoname_id: 3038333, population: 105297),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Corse", country: state, continent: continent,  geoname_id: 3013793, population: 167103)
municipalities = [
province.municipalities.new(description: "Bastia", region: region, country: state, continent: continent, geoname_id: 3034639, population: 83202),
province.municipalities.new(description: "Calvi", region: region, country: state, continent: continent, geoname_id: 3029089, population: 28522),
province.municipalities.new(description: "Corte", region: region, country: state, continent: continent, geoname_id: 3023505, population: 55379),
]
Municipality.import municipalities
region = Region.create(description: "Guadeloupe", country: state, continent: continent, geoname_id: 6690363)
province = region.provinces.create(description: "Guadeloupe", country: state, continent: continent,  geoname_id: 6690364, population: 400584)
municipalities = [
province.municipalities.new(description: "Pointe-à-Pitre", region: region, country: state, continent: continent, geoname_id: 3578598, population: 211130),
province.municipalities.new(description: "Basse-Terre", region: region, country: state, continent: continent, geoname_id: 3579731, population: 189454),
]
Municipality.import municipalities
region = Region.create(description: "Guyane", country: state, continent: continent, geoname_id: 6690605)
province = region.provinces.create(description: "Guyane", country: state, continent: continent,  geoname_id: 6690606, population: 213031)
municipalities = [
province.municipalities.new(description: "Cayenne", region: region, country: state, continent: continent, geoname_id: 3382159, population: 151592),
province.municipalities.new(description: "Saint-Laurent-du-Maroni", region: region, country: state, continent: continent, geoname_id: 3380386, population: 61439),
]
Municipality.import municipalities
region = Region.create(description: "Lorraine", country: state, continent: continent, geoname_id: 2997551)
province = region.provinces.create(description: "Meurthe-et-Moselle", country: state, continent: continent,  geoname_id: 2994111, population: 745134)
municipalities = [
province.municipalities.new(description: "Briey", region: region, country: state, continent: continent, geoname_id: 3030070, population: 166577),
province.municipalities.new(description: "Lunéville", region: region, country: state, continent: continent, geoname_id: 2997109, population: 81274),
province.municipalities.new(description: "Nancy", region: region, country: state, continent: continent, geoname_id: 2990998, population: 427687),
province.municipalities.new(description: "Toul", region: region, country: state, continent: continent, geoname_id: 2972349, population: 69596),
]
Municipality.import municipalities
province = region.provinces.create(description: "Meuse", country: state, continent: continent,  geoname_id: 2994106, population: 200417)
municipalities = [
province.municipalities.new(description: "Bar-le-Duc", region: region, country: state, continent: continent, geoname_id: 3034910, population: 64328),
province.municipalities.new(description: "Commercy", region: region, country: state, continent: continent, geoname_id: 3024085, population: 46420),
province.municipalities.new(description: "Verdun", region: region, country: state, continent: continent, geoname_id: 2969963, population: 89669),
]
Municipality.import municipalities
province = region.provinces.create(description: "Moselle", country: state, continent: continent,  geoname_id: 2991627, population: 1066328)
municipalities = [
province.municipalities.new(description: "Boulay-Moselle", region: region, country: state, continent: continent, geoname_id: 3031181, population: 80240),
province.municipalities.new(description: "Château-Salins", region: region, country: state, continent: continent, geoname_id: 3026199, population: 31024),
province.municipalities.new(description: "Forbach", region: region, country: state, continent: continent, geoname_id: 3017804, population: 173226),
province.municipalities.new(description: "Metz-Campagne", region: region, country: state, continent: continent, geoname_id: 2994159, population: 224979),
province.municipalities.new(description: "Metz-Ville", region: region, country: state, continent: continent, geoname_id: 2994149, population: 124024),
province.municipalities.new(description: "Sarrebourg", region: region, country: state, continent: continent, geoname_id: 2975966, population: 65997),
province.municipalities.new(description: "Sarreguemines", region: region, country: state, continent: continent, geoname_id: 2975963, population: 103481),
province.municipalities.new(description: "Thionville-Est", region: region, country: state, continent: continent, geoname_id: 2972810, population: 141858),
province.municipalities.new(description: "Thionville-Ouest", region: region, country: state, continent: continent, geoname_id: 2972809, population: 121499),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vosges", country: state, continent: continent,  geoname_id: 2967681, population: 393474)
municipalities = [
province.municipalities.new(description: "Neufchâteau", region: region, country: state, continent: continent, geoname_id: 2990681, population: 62155),
province.municipalities.new(description: "Saint-Dié", region: region, country: state, continent: continent, geoname_id: 2980826, population: 98001),
province.municipalities.new(description: "Épinal", region: region, country: state, continent: continent, geoname_id: 3020034, population: 233318),
]
Municipality.import municipalities
region = Region.create(description: "Martinique", country: state, continent: continent, geoname_id: 6690603)
province = region.provinces.create(description: "Martinique", country: state, continent: continent,  geoname_id: 6690604, population: 397730)
municipalities = [
province.municipalities.new(description: "Fort-de-France", region: region, country: state, continent: continent, geoname_id: 3570674, population: 167961),
province.municipalities.new(description: "La Trinité", region: region, country: state, continent: continent, geoname_id: 3570445, population: 86704),
province.municipalities.new(description: "Saint-Pierre", region: region, country: state, continent: continent, geoname_id: 3569906, population: 23796),
province.municipalities.new(description: "Marin", region: region, country: state, continent: continent, geoname_id: 3570319, population: 119269),
]
Municipality.import municipalities
region = Region.create(description: "Provence-Alpes-Côte d'Azur", country: state, continent: continent, geoname_id: 2985244)
province = region.provinces.create(description: "Alpes-Maritimes", country: state, continent: continent,  geoname_id: 3038049, population: 1094596)
municipalities = [
province.municipalities.new(description: "Grasse", region: region, country: state, continent: continent, geoname_id: 3014855, population: 568439),
province.municipalities.new(description: "Nice", region: region, country: state, continent: continent, geoname_id: 2990439, population: 526157),
]
Municipality.import municipalities
province = region.provinces.create(description: "Alpes-de-Haute-Provence", country: state, continent: continent,  geoname_id: 3038050, population: 164519)
municipalities = [
province.municipalities.new(description: "Barcelonnette", region: region, country: state, continent: continent, geoname_id: 3034990, population: 8524),
province.municipalities.new(description: "Castellane", region: region, country: state, continent: continent, geoname_id: 3028381, population: 9707),
province.municipalities.new(description: "Digne", region: region, country: state, continent: continent, geoname_id: 3021381, population: 57689),
province.municipalities.new(description: "Forcalquier", region: region, country: state, continent: continent, geoname_id: 3017797, population: 88599),
]
Municipality.import municipalities
province = region.provinces.create(description: "Bouches-du-Rhône", country: state, continent: continent,  geoname_id: 3031359, population: 1995094)
municipalities = [
province.municipalities.new(description: "Istres", region: region, country: state, continent: continent, geoname_id: 6457359, population: 311381),
province.municipalities.new(description: "Marseille", region: region, country: state, continent: continent, geoname_id: 2995468, population: 1057717),
province.municipalities.new(description: "Aix-en-Provence", region: region, country: state, continent: continent, geoname_id: 3038353, population: 425822),
province.municipalities.new(description: "Arles", region: region, country: state, continent: continent, geoname_id: 3036937, population: 200174),
]
Municipality.import municipalities
province = region.provinces.create(description: "Hautes-Alpes", country: state, continent: continent,  geoname_id: 3013738, population: 141153)
municipalities = [
province.municipalities.new(description: "Briançon", region: region, country: state, continent: continent, geoname_id: 3030140, population: 35825),
province.municipalities.new(description: "Gap", region: region, country: state, continent: continent, geoname_id: 3016701, population: 105328),
]
Municipality.import municipalities
province = region.provinces.create(description: "Var", country: state, continent: continent,  geoname_id: 2970749, population: 1025201)
municipalities = [
province.municipalities.new(description: "Brignoles", region: region, country: state, continent: continent, geoname_id: 3030056, population: 142528),
province.municipalities.new(description: "Draguignan", region: region, country: state, continent: continent, geoname_id: 3020849, population: 312298),
province.municipalities.new(description: "Toulon", region: region, country: state, continent: continent, geoname_id: 2972326, population: 570375),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vaucluse", country: state, continent: continent,  geoname_id: 2970554, population: 551922)
municipalities = [
province.municipalities.new(description: "Carpentras", region: region, country: state, continent: continent, geoname_id: 3028541, population: 130059),
province.municipalities.new(description: "Apt", region: region, country: state, continent: continent, geoname_id: 3037351, population: 126868),
province.municipalities.new(description: "Avignon", region: region, country: state, continent: continent, geoname_id: 3035679, population: 294995),
]
Municipality.import municipalities
region = Region.create(description: "Région Basse-Normandie", country: state, continent: continent, geoname_id: 3034693)
province = region.provinces.create(description: "Calvados", country: state, continent: continent,  geoname_id: 3029094, population: 697054)
municipalities = [
province.municipalities.new(description: "Bayeux", region: region, country: state, continent: continent, geoname_id: 3034482, population: 68068),
province.municipalities.new(description: "Caen", region: region, country: state, continent: continent, geoname_id: 3029240, population: 418496),
province.municipalities.new(description: "Lisieux", region: region, country: state, continent: continent, geoname_id: 2998149, population: 151460),
province.municipalities.new(description: "Vire", region: region, country: state, continent: continent, geoname_id: 2967970, population: 59030),
]
Municipality.import municipalities
province = region.provinces.create(description: "Manche", country: state, continent: continent,  geoname_id: 2996268, population: 516065)
municipalities = [
province.municipalities.new(description: "Cherbourg", region: region, country: state, continent: continent, geoname_id: 3025465, population: 197588),
province.municipalities.new(description: "Coutances", region: region, country: state, continent: continent, geoname_id: 3022825, population: 86839),
province.municipalities.new(description: "Saint-Lô", region: region, country: state, continent: continent, geoname_id: 2978757, population: 104133),
province.municipalities.new(description: "Avranches", region: region, country: state, continent: continent, geoname_id: 3035638, population: 127505),
]
Municipality.import municipalities
province = region.provinces.create(description: "Orne", country: state, continent: continent,  geoname_id: 2989247, population: 302010)
municipalities = [
province.municipalities.new(description: "Mortagne-au-Perche", region: region, country: state, continent: continent, geoname_id: 2991703, population: 74260),
province.municipalities.new(description: "Alençon", region: region, country: state, continent: continent, geoname_id: 3038229, population: 105207),
province.municipalities.new(description: "Argentan", region: region, country: state, continent: continent, geoname_id: 3037050, population: 122543),
]
Municipality.import municipalities
region = Region.create(description: "Région Bourgogne", country: state, continent: continent, geoname_id: 3030967)
province = region.provinces.create(description: "Côte-d'Or", country: state, continent: continent,  geoname_id: 3023423, population: 538259)
municipalities = [
province.municipalities.new(description: "Beaune", region: region, country: state, continent: continent, geoname_id: 3034125, population: 99927),
province.municipalities.new(description: "Dijon", region: region, country: state, continent: continent, geoname_id: 3021371, population: 373839),
province.municipalities.new(description: "Montbard", region: region, country: state, continent: continent, geoname_id: 2992952, population: 64493),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nièvre", country: state, continent: continent,  geoname_id: 2990371, population: 227740)
municipalities = [
province.municipalities.new(description: "Château-Chinon", region: region, country: state, continent: continent, geoname_id: 3026297, population: 27831),
province.municipalities.new(description: "Clamecy", region: region, country: state, continent: continent, geoname_id: 3024780, population: 27463),
province.municipalities.new(description: "Cosne-Cours-sur-Loire", region: region, country: state, continent: continent, geoname_id: 3023475, population: 46447),
province.municipalities.new(description: "Nevers", region: region, country: state, continent: continent, geoname_id: 2990473, population: 125999),
]
Municipality.import municipalities
province = region.provinces.create(description: "Saône-et-Loire", country: state, continent: continent,  geoname_id: 2976082, population: 574002)
municipalities = [
province.municipalities.new(description: "Chalon-sur-Saône", region: region, country: state, continent: continent, geoname_id: 3027483, population: 205040),
province.municipalities.new(description: "Charolles", region: region, country: state, continent: continent, geoname_id: 3026514, population: 104511),
province.municipalities.new(description: "Louhans", region: region, country: state, continent: continent, geoname_id: 2997438, population: 55543),
province.municipalities.new(description: "Mâcon", region: region, country: state, continent: continent, geoname_id: 2996881, population: 116874),
province.municipalities.new(description: "Autun", region: region, country: state, continent: continent, geoname_id: 3035882, population: 92034),
]
Municipality.import municipalities
province = region.provinces.create(description: "Yonne", country: state, continent: continent,  geoname_id: 2967222, population: 354282)
municipalities = [
province.municipalities.new(description: "Sens", region: region, country: state, continent: continent, geoname_id: 2975049, population: 114102),
province.municipalities.new(description: "Auxerre", region: region, country: state, continent: continent, geoname_id: 3035842, population: 189195),
province.municipalities.new(description: "Avallon", region: region, country: state, continent: continent, geoname_id: 3035767, population: 50985),
]
Municipality.import municipalities
region = Region.create(description: "Région Centre", country: state, continent: continent, geoname_id: 3027939)
province = region.provinces.create(description: "Cher", country: state, continent: continent,  geoname_id: 3025480, population: 319423)
municipalities = [
province.municipalities.new(description: "Bourges", region: region, country: state, continent: continent, geoname_id: 3031004, population: 177197),
province.municipalities.new(description: "Saint-Amand-Montrond", region: region, country: state, continent: continent, geoname_id: 2981836, population: 68940),
province.municipalities.new(description: "Vierzon", region: region, country: state, continent: continent, geoname_id: 6457360, population: 73286),
]
Municipality.import municipalities
province = region.provinces.create(description: "Eure-et-Loir", country: state, continent: continent,  geoname_id: 3019316, population: 436966)
municipalities = [
province.municipalities.new(description: "Chartres", region: region, country: state, continent: continent, geoname_id: 3026466, population: 208376),
province.municipalities.new(description: "Châteaudun", region: region, country: state, continent: continent, geoname_id: 3026284, population: 61103),
province.municipalities.new(description: "Dreux", region: region, country: state, continent: continent, geoname_id: 3020809, population: 128650),
province.municipalities.new(description: "Nogent-le-Rotrou", region: region, country: state, continent: continent, geoname_id: 2990271, population: 38837),
]
Municipality.import municipalities
province = region.provinces.create(description: "Indre", country: state, continent: continent,  geoname_id: 3012805, population: 239443)
municipalities = [
province.municipalities.new(description: "Issoudun", region: region, country: state, continent: continent, geoname_id: 3012654, population: 36816),
province.municipalities.new(description: "Châteauroux", region: region, country: state, continent: continent, geoname_id: 3026202, population: 134290),
province.municipalities.new(description: "La Châtre", region: region, country: state, continent: continent, geoname_id: 3010153, population: 34276),
province.municipalities.new(description: "Blanc", region: region, country: state, continent: continent, geoname_id: 3032422, population: 34061),
]
Municipality.import municipalities
province = region.provinces.create(description: "Indre-et-Loire", country: state, continent: continent,  geoname_id: 3012804, population: 603337)
municipalities = [
province.municipalities.new(description: "Chinon", region: region, country: state, continent: continent, geoname_id: 3025131, population: 87602),
province.municipalities.new(description: "Loches", region: region, country: state, continent: continent, geoname_id: 2997995, population: 52540),
province.municipalities.new(description: "Tours", region: region, country: state, continent: continent, geoname_id: 2972190, population: 463195),
]
Municipality.import municipalities
province = region.provinces.create(description: "Loir-et-Cher", country: state, continent: continent,  geoname_id: 2997856, population: 338503)
municipalities = [
province.municipalities.new(description: "Blois", region: region, country: state, continent: continent, geoname_id: 3032212, population: 173963),
province.municipalities.new(description: "Romorantin-Lanthenay", region: region, country: state, continent: continent, geoname_id: 2982966, population: 91589),
province.municipalities.new(description: "Vendôme", region: region, country: state, continent: continent, geoname_id: 2970109, population: 72951),
]
Municipality.import municipalities
province = region.provinces.create(description: "Loiret", country: state, continent: continent,  geoname_id: 2997857, population: 672142)
municipalities = [
province.municipalities.new(description: "Montargis", region: region, country: state, continent: continent, geoname_id: 2993023, population: 175024),
province.municipalities.new(description: "Pithiviers", region: region, country: state, continent: continent, geoname_id: 2987002, population: 62701),
province.municipalities.new(description: "Orléans", region: region, country: state, continent: continent, geoname_id: 2989316, population: 434417),
]
Municipality.import municipalities
region = Region.create(description: "Région Champagne-Ardenne", country: state, continent: continent, geoname_id: 3027257)
province = region.provinces.create(description: "Ardennes", country: state, continent: continent,  geoname_id: 3037136, population: 291717)
municipalities = [
province.municipalities.new(description: "Charleville-Mézières", region: region, country: state, continent: continent, geoname_id: 3026612, population: 168427),
province.municipalities.new(description: "Rethel", region: region, country: state, continent: continent, geoname_id: 2983890, population: 37120),
province.municipalities.new(description: "Sedan", region: region, country: state, continent: continent, geoname_id: 2975347, population: 62939),
province.municipalities.new(description: "Vouziers", region: region, country: state, continent: continent, geoname_id: 2967602, population: 23231),
]
Municipality.import municipalities
province = region.provinces.create(description: "Aube", country: state, continent: continent,  geoname_id: 3036420, population: 311676)
municipalities = [
province.municipalities.new(description: "Bar-sur-Aube", region: region, country: state, continent: continent, geoname_id: 3034801, population: 30486),
province.municipalities.new(description: "Nogent-sur-Seine", region: region, country: state, continent: continent, geoname_id: 2990262, population: 54380),
province.municipalities.new(description: "Troyes", region: region, country: state, continent: continent, geoname_id: 2971548, population: 226810),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Marne", country: state, continent: continent,  geoname_id: 3013757, population: 192224)
municipalities = [
province.municipalities.new(description: "Chaumont", region: region, country: state, continent: continent, geoname_id: 3025888, population: 69623),
province.municipalities.new(description: "Langres", region: region, country: state, continent: continent, geoname_id: 3007679, population: 47458),
province.municipalities.new(description: "Saint-Dizier", region: region, country: state, continent: continent, geoname_id: 2980815, population: 75143),
]
Municipality.import municipalities
province = region.provinces.create(description: "Marne", country: state, continent: continent,  geoname_id: 2995603, population: 580402)
municipalities = [
province.municipalities.new(description: "Épernay", region: region, country: state, continent: continent, geoname_id: 3020061, population: 113334),
province.municipalities.new(description: "Châlons-en-Champagne", region: region, country: state, continent: continent, geoname_id: 3027486, population: 105366),
province.municipalities.new(description: "Reims", region: region, country: state, continent: continent, geoname_id: 2984113, population: 298297),
province.municipalities.new(description: "Sainte-Menehould", region: region, country: state, continent: continent, geoname_id: 2980399, population: 14531),
province.municipalities.new(description: "Vitry-le-François", region: region, country: state, continent: continent, geoname_id: 2967855, population: 48874),
]
Municipality.import municipalities
region = Region.create(description: "Région Franche-Comté", country: state, continent: continent, geoname_id: 3017372)
province = region.provinces.create(description: "Doubs", country: state, continent: continent,  geoname_id: 3020989, population: 539992)
municipalities = [
province.municipalities.new(description: "Besançon", region: region, country: state, continent: continent, geoname_id: 3033122, population: 250852),
province.municipalities.new(description: "Montbéliard", region: region, country: state, continent: continent, geoname_id: 2992937, population: 182070),
province.municipalities.new(description: "Pontarlier", region: region, country: state, continent: continent, geoname_id: 2986301, population: 107070),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Saône", country: state, continent: continent,  geoname_id: 3013737, population: 246975)
municipalities = [
province.municipalities.new(description: "Lure", region: region, country: state, continent: continent, geoname_id: 2997075, population: 112963),
province.municipalities.new(description: "Vesoul", region: region, country: state, continent: continent, geoname_id: 2969561, population: 134012),
]
Municipality.import municipalities
province = region.provinces.create(description: "Jura", country: state, continent: continent,  geoname_id: 3012051, population: 271680)
municipalities = [
province.municipalities.new(description: "Dole", region: region, country: state, continent: continent, geoname_id: 3021262, population: 86480),
province.municipalities.new(description: "Lons-le-Saunier", region: region, country: state, continent: continent, geoname_id: 2997625, population: 130999),
province.municipalities.new(description: "Saint-Claude", region: region, country: state, continent: continent, geoname_id: 2981076, population: 54201),
]
Municipality.import municipalities
province = region.provinces.create(description: "Territoire de Belfort", country: state, continent: continent,  geoname_id: 3033789, population: 145987)
municipalities = [
province.municipalities.new(description: "Belfort", region: region, country: state, continent: continent, geoname_id: 3033790, population: 145987),
]
Municipality.import municipalities
region = Region.create(description: "Région Haute-Normandie", country: state, continent: continent, geoname_id: 3013756)
province = region.provinces.create(description: "Eure", country: state, continent: continent,  geoname_id: 3019317, population: 599181)
municipalities = [
province.municipalities.new(description: "Bernay", region: region, country: state, continent: continent, geoname_id: 3033307, population: 163550),
province.municipalities.new(description: "Andelys", region: region, country: state, continent: continent, geoname_id: 3037730, population: 181969),
province.municipalities.new(description: "Évreux", region: region, country: state, continent: continent, geoname_id: 3019264, population: 253662),
]
Municipality.import municipalities
province = region.provinces.create(description: "Seine-Maritime", country: state, continent: continent,  geoname_id: 2975248, population: 1275483)
municipalities = [
province.municipalities.new(description: "Dieppe", region: region, country: state, continent: continent, geoname_id: 3021410, population: 241463),
province.municipalities.new(description: "Rouen", region: region, country: state, continent: continent, geoname_id: 2982651, population: 631402),
province.municipalities.new(description: "Havre", region: region, country: state, continent: continent, geoname_id: 3013633, population: 402618),
]
Municipality.import municipalities
region = Region.create(description: "Région Languedoc-Roussillon", country: state, continent: continent, geoname_id: 3007670)
province = region.provinces.create(description: "Aude", country: state, continent: continent,  geoname_id: 3036264, population: 363420)
municipalities = [
province.municipalities.new(description: "Carcassonne", region: region, country: state, continent: continent, geoname_id: 3028640, population: 163131),
province.municipalities.new(description: "Limoux", region: region, country: state, continent: continent, geoname_id: 2998262, population: 45905),
province.municipalities.new(description: "Narbonne", region: region, country: state, continent: continent, geoname_id: 2990918, population: 154384),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gard", country: state, continent: continent,  geoname_id: 3016670, population: 718181)
municipalities = [
province.municipalities.new(description: "Nîmes", region: region, country: state, continent: continent, geoname_id: 2990362, population: 529873),
province.municipalities.new(description: "Vigan", region: region, country: state, continent: continent, geoname_id: 2969157, population: 36055),
province.municipalities.new(description: "Alès", region: region, country: state, continent: continent, geoname_id: 3038223, population: 152253),
]
Municipality.import municipalities
province = region.provinces.create(description: "Hérault", country: state, continent: continent,  geoname_id: 3013500, population: 1050026)
municipalities = [
province.municipalities.new(description: "Béziers", region: region, country: state, continent: continent, geoname_id: 3032832, population: 300061),
province.municipalities.new(description: "Lodève", region: region, country: state, continent: continent, geoname_id: 2997935, population: 88842),
province.municipalities.new(description: "Montpellier", region: region, country: state, continent: continent, geoname_id: 2992165, population: 661123),
]
Municipality.import municipalities
province = region.provinces.create(description: "Lozère", country: state, continent: continent,  geoname_id: 2997288, population: 81312)
municipalities = [
province.municipalities.new(description: "Florac", region: region, country: state, continent: continent, geoname_id: 3018236, population: 13767),
province.municipalities.new(description: "Mende", region: region, country: state, continent: continent, geoname_id: 2994616, population: 67545),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pyrénées-Orientales", country: state, continent: continent,  geoname_id: 2984885, population: 454737)
municipalities = [
province.municipalities.new(description: "Céret", region: region, country: state, continent: continent, geoname_id: 3027887, population: 73052),
province.municipalities.new(description: "Perpignan", region: region, country: state, continent: continent, geoname_id: 2987913, population: 337487),
province.municipalities.new(description: "Prades", region: region, country: state, continent: continent, geoname_id: 2985643, population: 44198),
]
Municipality.import municipalities
region = Region.create(description: "Région Limousin", country: state, continent: continent, geoname_id: 2998268)
province = region.provinces.create(description: "Corrèze", country: state, continent: continent,  geoname_id: 3023532, population: 252116)
municipalities = [
province.municipalities.new(description: "Brive-la-Gaillarde", region: region, country: state, continent: continent, geoname_id: 3029973, population: 133392),
province.municipalities.new(description: "Tulle", region: region, country: state, continent: continent, geoname_id: 2971481, population: 83196),
province.municipalities.new(description: "Ussel", region: region, country: state, continent: continent, geoname_id: 2971297, population: 35528),
]
Municipality.import municipalities
province = region.provinces.create(description: "Creuse", country: state, continent: continent,  geoname_id: 3022516, population: 128435)
municipalities = [
province.municipalities.new(description: "Guéret", region: region, country: state, continent: continent, geoname_id: 3014382, population: 88454),
province.municipalities.new(description: "Aubusson", region: region, country: state, continent: continent, geoname_id: 3036293, population: 39981),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Vienne", country: state, continent: continent,  geoname_id: 3013719, population: 383418)
municipalities = [
province.municipalities.new(description: "Bellac", region: region, country: state, continent: continent, geoname_id: 3033765, population: 41802),
province.municipalities.new(description: "Limoges", region: region, country: state, continent: continent, geoname_id: 2998285, population: 303023),
province.municipalities.new(description: "Rochechouart", region: region, country: state, continent: continent, geoname_id: 2983290, population: 38593),
]
Municipality.import municipalities
region = Region.create(description: "Région Midi-Pyrénées", country: state, continent: continent, geoname_id: 2993955)
province = region.provinces.create(description: "Ariège", country: state, continent: continent,  geoname_id: 3036965, population: 156701)
municipalities = [
province.municipalities.new(description: "Foix", region: region, country: state, continent: continent, geoname_id: 3018172, population: 54359),
province.municipalities.new(description: "Pamiers", region: region, country: state, continent: continent, geoname_id: 2988669, population: 73459),
province.municipalities.new(description: "Saint-Girons", region: region, country: state, continent: continent, geoname_id: 2979655, population: 28883),
]
Municipality.import municipalities
province = region.provinces.create(description: "Aveyron", country: state, continent: continent,  geoname_id: 3035691, population: 288634)
municipalities = [
province.municipalities.new(description: "Millau", region: region, country: state, continent: continent, geoname_id: 2993874, population: 74056),
province.municipalities.new(description: "Rodez", region: region, country: state, continent: continent, geoname_id: 2983153, population: 147953),
province.municipalities.new(description: "Villefranche-de-Rouergue", region: region, country: state, continent: continent, geoname_id: 2968754, population: 66625),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gers", country: state, continent: continent,  geoname_id: 3016194, population: 194560)
municipalities = [
province.municipalities.new(description: "Condom", region: region, country: state, continent: continent, geoname_id: 3023942, population: 67363),
province.municipalities.new(description: "Mirande", region: region, country: state, continent: continent, geoname_id: 2993747, population: 40119),
province.municipalities.new(description: "Auch", region: region, country: state, continent: continent, geoname_id: 3036280, population: 87078),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Garonne", country: state, continent: continent,  geoname_id: 3013767, population: 1254347)
municipalities = [
province.municipalities.new(description: "Muret", region: region, country: state, continent: continent, geoname_id: 2991152, population: 202372),
province.municipalities.new(description: "Saint-Gaudens", region: region, country: state, continent: continent, geoname_id: 2980043, population: 79877),
province.municipalities.new(description: "Toulouse", region: region, country: state, continent: continent, geoname_id: 2972314, population: 972098),
]
Municipality.import municipalities
province = region.provinces.create(description: "Hautes-Pyrénées", country: state, continent: continent,  geoname_id: 3013726, population: 238031)
municipalities = [
province.municipalities.new(description: "Bagnères-de-Bigorre", region: region, country: state, continent: continent, geoname_id: 3035417, population: 48358),
province.municipalities.new(description: "Tarbes", region: region, country: state, continent: continent, geoname_id: 2973384, population: 148637),
province.municipalities.new(description: "Argelès-Gazost", region: region, country: state, continent: continent, geoname_id: 3037069, population: 41036),
]
Municipality.import municipalities
province = region.provinces.create(description: "Lot", country: state, continent: continent,  geoname_id: 2997524, population: 180305)
municipalities = [
province.municipalities.new(description: "Cahors", region: region, country: state, continent: continent, geoname_id: 3029212, population: 78833),
province.municipalities.new(description: "Figeac", region: region, country: state, continent: continent, geoname_id: 3018505, population: 56132),
province.municipalities.new(description: "Gourdon", region: region, country: state, continent: continent, geoname_id: 3015540, population: 45340),
]
Municipality.import municipalities
province = region.provinces.create(description: "Tarn", country: state, continent: continent,  geoname_id: 2973362, population: 385722)
municipalities = [
province.municipalities.new(description: "Castres", region: region, country: state, continent: continent, geoname_id: 3028260, population: 197664),
province.municipalities.new(description: "Albi", region: region, country: state, continent: continent, geoname_id: 3038260, population: 188058),
]
Municipality.import municipalities
province = region.provinces.create(description: "Tarn-et-Garonne", country: state, continent: continent,  geoname_id: 2973357, population: 245857)
municipalities = [
province.municipalities.new(description: "Castelsarrasin", region: region, country: state, continent: continent, geoname_id: 3028321, population: 76899),
province.municipalities.new(description: "Montauban", region: region, country: state, continent: continent, geoname_id: 2993000, population: 168958),
]
Municipality.import municipalities
region = Region.create(description: "Région Nord-Pas-de-Calais", country: state, continent: continent, geoname_id: 2990119)
province = region.provinces.create(description: "Nord", country: state, continent: continent,  geoname_id: 2990129, population: 2613285)
municipalities = [
province.municipalities.new(description: "Cambrai", region: region, country: state, continent: continent, geoname_id: 3029029, population: 163283),
province.municipalities.new(description: "Douai", region: region, country: state, continent: continent, geoname_id: 3020999, population: 252200),
province.municipalities.new(description: "Dunkerque", region: region, country: state, continent: continent, geoname_id: 3020685, population: 383715),
province.municipalities.new(description: "Lille", region: region, country: state, continent: continent, geoname_id: 2998323, population: 1222209),
province.municipalities.new(description: "Valenciennes", region: region, country: state, continent: continent, geoname_id: 2971040, population: 353488),
province.municipalities.new(description: "Avesnes-sur-Helpe", region: region, country: state, continent: continent, geoname_id: 3035697, population: 238390),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pas-de-Calais", country: state, continent: continent,  geoname_id: 2988430, population: 1488951)
municipalities = [
province.municipalities.new(description: "Boulogne-sur-Mer", region: region, country: state, continent: continent, geoname_id: 3031132, population: 165700),
province.municipalities.new(description: "Béthune", region: region, country: state, continent: continent, geoname_id: 3033000, population: 289037),
province.municipalities.new(description: "Calais", region: region, country: state, continent: continent, geoname_id: 3029161, population: 119979),
province.municipalities.new(description: "Lens", region: region, country: state, continent: continent, geoname_id: 3003091, population: 365782),
province.municipalities.new(description: "Montreuil", region: region, country: state, continent: continent, geoname_id: 2992088, population: 116554),
province.municipalities.new(description: "Saint-Omer", region: region, country: state, continent: continent, geoname_id: 2977844, population: 164984),
province.municipalities.new(description: "Arras", region: region, country: state, continent: continent, geoname_id: 3036783, population: 266915),
]
Municipality.import municipalities
region = Region.create(description: "Région Pays de la Loire", country: state, continent: continent, geoname_id: 2988289)
province = region.provinces.create(description: "Loire-Atlantique", country: state, continent: continent,  geoname_id: 2997861, population: 1301325)
municipalities = [
province.municipalities.new(description: "Châteaubriant", region: region, country: state, continent: continent, geoname_id: 3026302, population: 124748),
province.municipalities.new(description: "Nantes", region: region, country: state, continent: continent, geoname_id: 2990968, population: 801021),
province.municipalities.new(description: "Saint-Nazaire", region: region, country: state, continent: continent, geoname_id: 2977920, population: 315188),
province.municipalities.new(description: "Ancenis", region: region, country: state, continent: continent, geoname_id: 3037796, population: 60368),
]
Municipality.import municipalities
province = region.provinces.create(description: "Maine-et-Loire", country: state, continent: continent,  geoname_id: 2996663, population: 803573)
municipalities = [
province.municipalities.new(description: "Cholet", region: region, country: state, continent: continent, geoname_id: 3025052, population: 203685),
province.municipalities.new(description: "Saumur", region: region, country: state, continent: continent, geoname_id: 2975757, population: 140749),
province.municipalities.new(description: "Segré", region: region, country: state, continent: continent, geoname_id: 2975313, population: 62339),
province.municipalities.new(description: "Angers", region: region, country: state, continent: continent, geoname_id: 3037655, population: 396800),
]
Municipality.import municipalities
province = region.provinces.create(description: "Mayenne", country: state, continent: continent,  geoname_id: 2994932, population: 315303)
municipalities = [
province.municipalities.new(description: "Château-Gontier", region: region, country: state, continent: continent, geoname_id: 3026272, population: 65282),
province.municipalities.new(description: "Laval", region: region, country: state, continent: continent, geoname_id: 3005865, population: 157934),
province.municipalities.new(description: "Mayenne", region: region, country: state, continent: continent, geoname_id: 2994933, population: 92087),
]
Municipality.import municipalities
province = region.provinces.create(description: "Sarthe", country: state, continent: continent,  geoname_id: 2975926, population: 576741)
municipalities = [
province.municipalities.new(description: "La Flèche", region: region, country: state, continent: continent, geoname_id: 6457361, population: 155495),
province.municipalities.new(description: "Mamers", region: region, country: state, continent: continent, geoname_id: 2996290, population: 153819),
province.municipalities.new(description: "Mans", region: region, country: state, continent: continent, geoname_id: 2996175, population: 267427),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vendée", country: state, continent: continent,  geoname_id: 2970140, population: 645820)
municipalities = [
province.municipalities.new(description: "Fontenay-le-Comte", region: region, country: state, continent: continent, geoname_id: 3017920, population: 133323),
province.municipalities.new(description: "La Roche-sur-Yon", region: region, country: state, continent: continent, geoname_id: 3006766, population: 278567),
province.municipalities.new(description: "Sables-d’Olonne", region: region, country: state, continent: continent, geoname_id: 2982078, population: 233930),
]
Municipality.import municipalities
region = Region.create(description: "Région Picardie", country: state, continent: continent, geoname_id: 2987375)
province = region.provinces.create(description: "Aisne", country: state, continent: continent,  geoname_id: 3038375, population: 554521)
municipalities = [
province.municipalities.new(description: "Château-Thierry", region: region, country: state, continent: continent, geoname_id: 3026193, population: 74708),
province.municipalities.new(description: "Laon", region: region, country: state, continent: continent, geoname_id: 3007476, population: 170584),
province.municipalities.new(description: "Saint-Quentin", region: region, country: state, continent: continent, geoname_id: 2977293, population: 134551),
province.municipalities.new(description: "Soissons", region: region, country: state, continent: continent, geoname_id: 2974388, population: 105606),
province.municipalities.new(description: "Vervins", region: region, country: state, continent: continent, geoname_id: 2969598, population: 69072),
]
Municipality.import municipalities
province = region.provinces.create(description: "Oise", country: state, continent: continent,  geoname_id: 2989663, population: 821568)
municipalities = [
province.municipalities.new(description: "Beauvais", region: region, country: state, continent: continent, geoname_id: 3034005, population: 225465),
province.municipalities.new(description: "Clermont", region: region, country: state, continent: continent, geoname_id: 3024642, population: 129566),
province.municipalities.new(description: "Compiègne", region: region, country: state, continent: continent, geoname_id: 3024065, population: 186428),
province.municipalities.new(description: "Senlis", region: region, country: state, continent: continent, geoname_id: 2975086, population: 280109),
]
Municipality.import municipalities
province = region.provinces.create(description: "Somme", country: state, continent: continent,  geoname_id: 2974304, population: 582469)
municipalities = [
province.municipalities.new(description: "Montdidier", region: region, country: state, continent: continent, geoname_id: 2992759, population: 55751),
province.municipalities.new(description: "Péronne", region: region, country: state, continent: continent, geoname_id: 2987927, population: 82671),
province.municipalities.new(description: "Abbeville", region: region, country: state, continent: continent, geoname_id: 3038788, population: 138667),
province.municipalities.new(description: "Amiens", region: region, country: state, continent: continent, geoname_id: 3037853, population: 305380),
]
Municipality.import municipalities
region = Region.create(description: "Région Poitou-Charentes", country: state, continent: continent, geoname_id: 2986492)
province = region.provinces.create(description: "Charente", country: state, continent: continent,  geoname_id: 3026646, population: 363913)
municipalities = [
province.municipalities.new(description: "Cognac", region: region, country: state, continent: continent, geoname_id: 3024439, population: 94322),
province.municipalities.new(description: "Confolens", region: region, country: state, continent: continent, geoname_id: 3023918, population: 66938),
province.municipalities.new(description: "Angoulême", region: region, country: state, continent: continent, geoname_id: 3037597, population: 202653),
]
Municipality.import municipalities
province = region.provinces.create(description: "Charente-Maritime", country: state, continent: continent,  geoname_id: 3026644, population: 634928)
municipalities = [
province.municipalities.new(description: "Jonzac", region: region, country: state, continent: continent, geoname_id: 3012265, population: 57234),
province.municipalities.new(description: "La Rochelle", region: region, country: state, continent: continent, geoname_id: 3006783, population: 206728),
province.municipalities.new(description: "Rochefort", region: region, country: state, continent: continent, geoname_id: 2983272, population: 187721),
province.municipalities.new(description: "Saint-Jean-d’Angély", region: region, country: state, continent: continent, geoname_id: 2979362, population: 54699),
province.municipalities.new(description: "Saintes", region: region, country: state, continent: continent, geoname_id: 2980339, population: 128546),
]
Municipality.import municipalities
province = region.provinces.create(description: "Deux-Sèvres", country: state, continent: continent,  geoname_id: 3021501, population: 377784)
municipalities = [
province.municipalities.new(description: "Bressuire", region: region, country: state, continent: continent, geoname_id: 3030302, population: 97957),
province.municipalities.new(description: "Niort", region: region, country: state, continent: continent, geoname_id: 2990354, population: 213788),
province.municipalities.new(description: "Parthenay", region: region, country: state, continent: continent, geoname_id: 2988446, population: 66039),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vienne", country: state, continent: continent,  geoname_id: 2969280, population: 437411)
municipalities = [
province.municipalities.new(description: "Châtellerault", region: region, country: state, continent: continent, geoname_id: 3026140, population: 115253),
province.municipalities.new(description: "Montmorillon", region: region, country: state, continent: continent, geoname_id: 2992224, population: 77109),
province.municipalities.new(description: "Poitiers", region: region, country: state, continent: continent, geoname_id: 2986494, population: 245049),
]
Municipality.import municipalities
region = Region.create(description: "Région Rhône-Alpes", country: state, continent: continent, geoname_id: 2983751)
province = region.provinces.create(description: "Ain", country: state, continent: continent,  geoname_id: 3038422, population: 605892)
municipalities = [
province.municipalities.new(description: "Belley", region: region, country: state, continent: continent, geoname_id: 3033623, population: 94983),
province.municipalities.new(description: "Bourg-en-Bresse", region: region, country: state, continent: continent, geoname_id: 3031008, population: 345066),
province.municipalities.new(description: "Gex", region: region, country: state, continent: continent, geoname_id: 3016142, population: 78165),
province.municipalities.new(description: "Nantua", region: region, country: state, continent: continent, geoname_id: 2990931, population: 87678),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ardèche", country: state, continent: continent,  geoname_id: 3037147, population: 323516)
municipalities = [
province.municipalities.new(description: "Largentière", region: region, country: state, continent: continent, geoname_id: 3006956, population: 98094),
province.municipalities.new(description: "Privas", region: region, country: state, continent: continent, geoname_id: 2985289, population: 87282),
province.municipalities.new(description: "Tournon", region: region, country: state, continent: continent, geoname_id: 2972212, population: 138140),
]
Municipality.import municipalities
province = region.provinces.create(description: "Drôme", country: state, continent: continent,  geoname_id: 3020781, population: 497487)
municipalities = [
province.municipalities.new(description: "Die", region: region, country: state, continent: continent, geoname_id: 3021434, population: 43025),
province.municipalities.new(description: "Nyons", region: region, country: state, continent: continent, geoname_id: 2989818, population: 141482),
province.municipalities.new(description: "Valence", region: region, country: state, continent: continent, geoname_id: 2971049, population: 312980),
]
Municipality.import municipalities
province = region.provinces.create(description: "Haute-Savoie", country: state, continent: continent,  geoname_id: 3013736, population: 747965)
municipalities = [
province.municipalities.new(description: "Bonneville", region: region, country: state, continent: continent, geoname_id: 3031676, population: 184417),
province.municipalities.new(description: "Saint-Julien-en-Genevois", region: region, country: state, continent: continent, geoname_id: 2979071, population: 162750),
province.municipalities.new(description: "Thonon-les-Bains", region: region, country: state, continent: continent, geoname_id: 2972741, population: 136263),
province.municipalities.new(description: "Annecy", region: region, country: state, continent: continent, geoname_id: 3037542, population: 264535),
]
Municipality.import municipalities
province = region.provinces.create(description: "Isère", country: state, continent: continent,  geoname_id: 3012715, population: 1223730)
municipalities = [
province.municipalities.new(description: "Grenoble", region: region, country: state, continent: continent, geoname_id: 3014727, population: 753752),
province.municipalities.new(description: "La Tour-du-Pin", region: region, country: state, continent: continent, geoname_id: 3006201, population: 259507),
province.municipalities.new(description: "Vienne", region: region, country: state, continent: continent, geoname_id: 2969282, population: 210471),
]
Municipality.import municipalities
province = region.provinces.create(description: "Loire", country: state, continent: continent,  geoname_id: 2997870, population: 763867)
municipalities = [
province.municipalities.new(description: "Montbrison", region: region, country: state, continent: continent, geoname_id: 2992889, population: 184177),
province.municipalities.new(description: "Roanne", region: region, country: state, continent: continent, geoname_id: 2983360, population: 161499),
province.municipalities.new(description: "Saint-Étienne", region: region, country: state, continent: continent, geoname_id: 2980288, population: 418191),
]
Municipality.import municipalities
province = region.provinces.create(description: "Rhône", country: state, continent: continent,  geoname_id: 2987410, population: 1738949)
municipalities = [
province.municipalities.new(description: "Lyon", region: region, country: state, continent: continent, geoname_id: 2996943, population: 1541416),
province.municipalities.new(description: "Villefranche-sur-Saône", region: region, country: state, continent: continent, geoname_id: 2968747, population: 197533),
]
Municipality.import municipalities
province = region.provinces.create(description: "Savoie", country: state, continent: continent,  geoname_id: 2975517, population: 424578)
municipalities = [
province.municipalities.new(description: "Chambéry", region: region, country: state, continent: continent, geoname_id: 3027421, population: 263448),
province.municipalities.new(description: "Saint-Jean-de-Maurienne", region: region, country: state, continent: continent, geoname_id: 2979302, population: 46429),
province.municipalities.new(description: "Albertville", region: region, country: state, continent: continent, geoname_id: 3038265, population: 114701),
]
Municipality.import municipalities
region = Region.create(description: "Région Île-de-France", country: state, continent: continent, geoname_id: 3012874)
province = region.provinces.create(description: "Essonne", country: state, continent: continent,  geoname_id: 3019599, population: 1225717)
municipalities = [
province.municipalities.new(description: "Étampes", region: region, country: state, continent: continent, geoname_id: 6457365, population: 137809),
province.municipalities.new(description: "Évry", region: region, country: state, continent: continent, geoname_id: 6457366, population: 510310),
province.municipalities.new(description: "Palaiseau", region: region, country: state, continent: continent, geoname_id: 6457367, population: 577598),
]
Municipality.import municipalities
province = region.provinces.create(description: "Hauts-de-Seine", country: state, continent: continent,  geoname_id: 3013657, population: 1579457)
municipalities = [
province.municipalities.new(description: "Antony", region: region, country: state, continent: continent, geoname_id: 6457368, population: 417286),
province.municipalities.new(description: "Boulogne-Billancourt", region: region, country: state, continent: continent, geoname_id: 6457370, population: 318437),
province.municipalities.new(description: "Nanterre", region: region, country: state, continent: continent, geoname_id: 6457369, population: 843734),
]
Municipality.import municipalities
province = region.provinces.create(description: "Paris", country: state, continent: continent,  geoname_id: 2968815, population: 2257981)
municipalities = [
province.municipalities.new(description: "Paris", region: region, country: state, continent: continent, geoname_id: 2988506, population: 2257981),
]
Municipality.import municipalities
province = region.provinces.create(description: "Seine-Saint-Denis", country: state, continent: continent,  geoname_id: 2975246, population: 1528413)
municipalities = [
province.municipalities.new(description: "Bobigny", region: region, country: state, continent: continent, geoname_id: 6457371, population: 583153),
province.municipalities.new(description: "Saint-Denis", region: region, country: state, continent: continent, geoname_id: 2980915, population: 403833),
province.municipalities.new(description: "Raincy", region: region, country: state, continent: continent, geoname_id: 6457372, population: 541427),
]
Municipality.import municipalities
province = region.provinces.create(description: "Seine-et-Marne", country: state, continent: continent,  geoname_id: 2975249, population: 1335284)
municipalities = [
province.municipalities.new(description: "Fontainebleau", region: region, country: state, continent: continent, geoname_id: 6457362, population: 151774),
province.municipalities.new(description: "Meaux", region: region, country: state, continent: continent, geoname_id: 2994797, population: 275695),
province.municipalities.new(description: "Melun", region: region, country: state, continent: continent, geoname_id: 2994650, population: 345230),
province.municipalities.new(description: "Provins", region: region, country: state, continent: continent, geoname_id: 2985228, population: 161218),
province.municipalities.new(description: "Torcy", region: region, country: state, continent: continent, geoname_id: 6457363, population: 401367),
]
Municipality.import municipalities
province = region.provinces.create(description: "Val-d'Oise", country: state, continent: continent,  geoname_id: 2971071, population: 1185379)
municipalities = [
province.municipalities.new(description: "Argenteuil", region: region, country: state, continent: continent, geoname_id: 6457376, population: 231971),
province.municipalities.new(description: "Pontoise", region: region, country: state, continent: continent, geoname_id: 2986139, population: 497364),
province.municipalities.new(description: "Sarcelles", region: region, country: state, continent: continent, geoname_id: 6457377, population: 456044),
]
Municipality.import municipalities
province = region.provinces.create(description: "Val-de-Marne", country: state, continent: continent,  geoname_id: 2971090, population: 1331443)
municipalities = [
province.municipalities.new(description: "Créteil", region: region, country: state, continent: continent, geoname_id: 6457373, population: 684134),
province.municipalities.new(description: "L'Haÿ-les-Roses", region: region, country: state, continent: continent, geoname_id: 6457375, population: 257745),
province.municipalities.new(description: "Nogent-sur-Marne", region: region, country: state, continent: continent, geoname_id: 6457374, population: 389564),
]
Municipality.import municipalities
province = region.provinces.create(description: "Yvelines", country: state, continent: continent,  geoname_id: 2967196, population: 1433447)
municipalities = [
province.municipalities.new(description: "Mantes-la-Jolie", region: region, country: state, continent: continent, geoname_id: 2996147, population: 278383),
province.municipalities.new(description: "Rambouillet", region: region, country: state, continent: continent, geoname_id: 2984512, population: 229991),
province.municipalities.new(description: "Saint-Germain-en-Laye", region: region, country: state, continent: continent, geoname_id: 6457364, population: 562725),
province.municipalities.new(description: "Versailles", region: region, country: state, continent: continent, geoname_id: 2969678, population: 362348),
]
Municipality.import municipalities
region = Region.create(description: "Réunion", country: state, continent: continent, geoname_id: 6690283)
province = region.provinces.create(description: "Réunion", country: state, continent: continent,  geoname_id: 6690284, population: 794107)
municipalities = [
province.municipalities.new(description: "Saint-Benoît", region: region, country: state, continent: continent, geoname_id: 935266, population: 115239),
province.municipalities.new(description: "Saint-Denis", region: region, country: state, continent: continent, geoname_id: 935263, population: 193732),
province.municipalities.new(description: "Saint-Paul", region: region, country: state, continent: continent, geoname_id: 935220, population: 202862),
province.municipalities.new(description: "Saint-Pierre", region: region, country: state, continent: continent, geoname_id: 935213, population: 282274),
]
Municipality.import municipalities
