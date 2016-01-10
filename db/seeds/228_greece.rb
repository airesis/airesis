continent = Continent.find_by(description: 'Europe')
state = Country.find_by(description: 'Greece')
region = Region.create(description: "Ήπειρος", country: state, continent: continent, geoname_id: 6697804)
province = region.provinces.create(description: "Άρτα", country: state, continent: continent,  geoname_id: 264545, population: 0)
municipalities = [
province.municipalities.new(description: "Αρταίων", region: region, country: state, continent: continent, geoname_id: 6943434, population: 0),
province.municipalities.new(description: "Γεωργίου Καραϊσκάκη", region: region, country: state, continent: continent, geoname_id: 8133717, population: 7131),
province.municipalities.new(description: "Κεντρικών Τζουμέρκων", region: region, country: state, continent: continent, geoname_id: 8133816, population: 7862),
province.municipalities.new(description: "Νικολάου Σκουφά", region: region, country: state, continent: continent, geoname_id: 8133727, population: 14491),
]
Municipality.import municipalities
province = region.provinces.create(description: "Θεσπρωτία", country: state, continent: continent,  geoname_id: 252941, population: 0)
municipalities = [
province.municipalities.new(description: "Ηγουμενίτσας", region: region, country: state, continent: continent, geoname_id: 8133725, population: 24130),
province.municipalities.new(description: "Σουλίου", region: region, country: state, continent: continent, geoname_id: 8133726, population: 10379),
province.municipalities.new(description: "Φιλιατών", region: region, country: state, continent: continent, geoname_id: 8133728, population: 9092),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ιωάννινα", country: state, continent: continent,  geoname_id: 261777, population: 0)
municipalities = [
province.municipalities.new(description: "Βορείων Τζουμέρκων", region: region, country: state, continent: continent, geoname_id: 8133719, population: 4361),
province.municipalities.new(description: "Δωδώνης", region: region, country: state, continent: continent, geoname_id: 8133720, population: 10482),
province.municipalities.new(description: "Ζίτσας", region: region, country: state, continent: continent, geoname_id: 8133722, population: 14923),
province.municipalities.new(description: "Ζαγορίου", region: region, country: state, continent: continent, geoname_id: 8133721, population: 4348),
province.municipalities.new(description: "Ιωαννιτών", region: region, country: state, continent: continent, geoname_id: 7303595, population: 0),
province.municipalities.new(description: "Κόνιτσας", region: region, country: state, continent: continent, geoname_id: 8133734, population: 7648),
province.municipalities.new(description: "Μετσόβου", region: region, country: state, continent: continent, geoname_id: 8133735, population: 7177),
province.municipalities.new(description: "Πωγωνίου", region: region, country: state, continent: continent, geoname_id: 8133736, population: 8987),
]
Municipality.import municipalities
province = region.provinces.create(description: "Πρέβεζα", country: state, continent: continent,  geoname_id: 254695, population: 0)
municipalities = [
province.municipalities.new(description: "Ζηρού", region: region, country: state, continent: continent, geoname_id: 8133741, population: 15410),
province.municipalities.new(description: "Πάργας", region: region, country: state, continent: continent, geoname_id: 8133742, population: 12597),
province.municipalities.new(description: "Πρέβεζας", region: region, country: state, continent: continent, geoname_id: 8133743, population: 30137),
]
Municipality.import municipalities
region = Region.create(description: "Ανατολική Μακεδονία και Θράκη", country: state, continent: continent, geoname_id: 6697803)
province = region.provinces.create(description: "Έβρος", country: state, continent: continent,  geoname_id: 736287, population: 0)
municipalities = [
province.municipalities.new(description: "Αλεξανδρούπολης", region: region, country: state, continent: continent, geoname_id: 8133779, population: 66125),
province.municipalities.new(description: "Διδυμοτείχου", region: region, country: state, continent: continent, geoname_id: 8133778, population: 23380),
province.municipalities.new(description: "Ορεστιάδας", region: region, country: state, continent: continent, geoname_id: 8133900, population: 39375),
province.municipalities.new(description: "Σαμοθράκης", region: region, country: state, continent: continent, geoname_id: 8133889, population: 2712),
province.municipalities.new(description: "Σουφλίου", region: region, country: state, continent: continent, geoname_id: 8133890, population: 17961),
]
Municipality.import municipalities
province = region.provinces.create(description: "Δράμα", country: state, continent: continent,  geoname_id: 736363, population: 0)
municipalities = [
province.municipalities.new(description: "Δοξάτου", region: region, country: state, continent: continent, geoname_id: 8133891, population: 16883),
province.municipalities.new(description: "Δράμας", region: region, country: state, continent: continent, geoname_id: 8133892, population: 75367),
province.municipalities.new(description: "Κάτω Νευροκοπίου", region: region, country: state, continent: continent, geoname_id: 8133895, population: 7289),
province.municipalities.new(description: "Παρανεστίου", region: region, country: state, continent: continent, geoname_id: 8133896, population: 5114),
province.municipalities.new(description: "Προσοτσάνης", region: region, country: state, continent: continent, geoname_id: 8133897, population: 15531),
]
Municipality.import municipalities
province = region.provinces.create(description: "Καβάλα", country: state, continent: continent,  geoname_id: 735857, population: 0)
municipalities = [
province.municipalities.new(description: "Θάσος", region: region, country: state, continent: continent, geoname_id: 8133898, population: 13451),
province.municipalities.new(description: "Καβάλας", region: region, country: state, continent: continent, geoname_id: 8133899, population: 74186),
province.municipalities.new(description: "Νέστου", region: region, country: state, continent: continent, geoname_id: 8133878, population: 22218),
province.municipalities.new(description: "Παγγαίου", region: region, country: state, continent: continent, geoname_id: 8133879, population: 31644),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ξάνθη", country: state, continent: continent,  geoname_id: 733839, population: 0)
municipalities = [
province.municipalities.new(description: "Αβδήρων", region: region, country: state, continent: continent, geoname_id: 8133835, population: 18262),
province.municipalities.new(description: "Μύκης", region: region, country: state, continent: continent, geoname_id: 8133836, population: 16091),
province.municipalities.new(description: "Ξάνθης", region: region, country: state, continent: continent, geoname_id: 8133837, population: 56383),
province.municipalities.new(description: "Τοπείρου", region: region, country: state, continent: continent, geoname_id: 8133838, population: 12223),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ροδόπη", country: state, continent: continent,  geoname_id: 734375, population: 0)
municipalities = [
province.municipalities.new(description: "Αρριανών", region: region, country: state, continent: continent, geoname_id: 8133825, population: 18259),
province.municipalities.new(description: "Ιάσμου", region: region, country: state, continent: continent, geoname_id: 8133826, population: 14851),
province.municipalities.new(description: "Κομοτηνής", region: region, country: state, continent: continent, geoname_id: 8133827, population: 51501),
province.municipalities.new(description: "Μαρωνείας - Σαπών", region: region, country: state, continent: continent, geoname_id: 8133834, population: 16626),
]
Municipality.import municipalities
region = Region.create(description: "Αττική", country: state, continent: continent, geoname_id: 6692632)
province = region.provinces.create(description: "Nomarchía Anatolikís Attikís", country: state, continent: continent,  geoname_id: 445406, population: 0)
municipalities = [
province.municipalities.new(description: "Αχαρνών", region: region, country: state, continent: continent, geoname_id: 8133704, population: 100743),
province.municipalities.new(description: "Βάρης - Βούλας - Βουλιαγμένης", region: region, country: state, continent: continent, geoname_id: 8133946, population: 48399),
province.municipalities.new(description: "Διονύσου", region: region, country: state, continent: continent, geoname_id: 8133921, population: 40193),
province.municipalities.new(description: "Κρωπίας", region: region, country: state, continent: continent, geoname_id: 8133922, population: 30307),
province.municipalities.new(description: "Λαυρεωτικής", region: region, country: state, continent: continent, geoname_id: 8133923, population: 25102),
province.municipalities.new(description: "Μαραθώνος", region: region, country: state, continent: continent, geoname_id: 8133924, population: 33423),
province.municipalities.new(description: "Μαρκοπούλου Μεσογαίας", region: region, country: state, continent: continent, geoname_id: 8133947, population: 20040),
province.municipalities.new(description: "Παιανίας", region: region, country: state, continent: continent, geoname_id: 8133684, population: 26668),
province.municipalities.new(description: "Παλλήνης", region: region, country: state, continent: continent, geoname_id: 8133685, population: 54415),
province.municipalities.new(description: "Ραφήνας - Πικερμίου", region: region, country: state, continent: continent, geoname_id: 8133686, population: 20266),
province.municipalities.new(description: "Σαρωνικού", region: region, country: state, continent: continent, geoname_id: 8133687, population: 29002),
province.municipalities.new(description: "Σπάτων - Αρτέμιδος", region: region, country: state, continent: continent, geoname_id: 8133772, population: 33821),
province.municipalities.new(description: "Ωρωπού", region: region, country: state, continent: continent, geoname_id: 8133773, population: 33769),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nomarchía Dytikís Attikís", country: state, continent: continent,  geoname_id: 445407, population: 0)
municipalities = [
province.municipalities.new(description: "Ασπροπύργου", region: region, country: state, continent: continent, geoname_id: 8133961, population: 30251),
province.municipalities.new(description: "Ελευσίνας", region: region, country: state, continent: continent, geoname_id: 8133883, population: 29902),
province.municipalities.new(description: "Μάνδρας - Ειδυλλίας", region: region, country: state, continent: continent, geoname_id: 8133884, population: 17885),
province.municipalities.new(description: "Μεγαρέων", region: region, country: state, continent: continent, geoname_id: 8133885, population: 36924),
province.municipalities.new(description: "Φυλής", region: region, country: state, continent: continent, geoname_id: 8133808, population: 45965),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nomós Piraiós", country: state, continent: continent,  geoname_id: 406101, population: 0)
municipalities = [
province.municipalities.new(description: "Ύδρα", region: region, country: state, continent: continent, geoname_id: 8133769, population: 1966),
province.municipalities.new(description: "Αίγινας", region: region, country: state, continent: continent, geoname_id: 8133696, population: 13056),
province.municipalities.new(description: "Αγκιστρίου", region: region, country: state, continent: continent, geoname_id: 8133874, population: 1142),
province.municipalities.new(description: "Κερατσινίου - Δραπετσώνας", region: region, country: state, continent: continent, geoname_id: 8133965, population: 91045),
province.municipalities.new(description: "Κορυδαλλού", region: region, country: state, continent: continent, geoname_id: 8133688, population: 63445),
province.municipalities.new(description: "Κυθήρων", region: region, country: state, continent: continent, geoname_id: 8133702, population: 4041),
province.municipalities.new(description: "Νίκαιας - Αγίου Ι. Ρέντη", region: region, country: state, continent: continent, geoname_id: 8133809, population: 105430),
province.municipalities.new(description: "Πειραιώς", region: region, country: state, continent: continent, geoname_id: 8133777, population: 163688),
province.municipalities.new(description: "Περάματος", region: region, country: state, continent: continent, geoname_id: 8133974, population: 25389),
province.municipalities.new(description: "Πόρου", region: region, country: state, continent: continent, geoname_id: 8133709, population: 4282),
province.municipalities.new(description: "Σαλαμίνας", region: region, country: state, continent: continent, geoname_id: 8133766, population: 39283),
province.municipalities.new(description: "Σπετσών", region: region, country: state, continent: continent, geoname_id: 8133767, population: 4027),
province.municipalities.new(description: "Τροιζηνίας-Μεθάνων", region: region, country: state, continent: continent, geoname_id: 8133768, population: 7143),
]
Municipality.import municipalities
province = region.provinces.create(description: "Αττική", country: state, continent: continent,  geoname_id: 264353, population: 0)
municipalities = [
province.municipalities.new(description: "Kastélli", region: region, country: state, continent: continent, geoname_id: 260809, population: 0),
province.municipalities.new(description: "Khlóï", region: region, country: state, continent: continent, geoname_id: 259961, population: 0),
province.municipalities.new(description: "Áyios Spirídhon", region: region, country: state, continent: continent, geoname_id: 263733, population: 0),
province.municipalities.new(description: "Ζωγράφος", region: region, country: state, continent: continent, geoname_id: 8358544, population: 71026),
province.municipalities.new(description: "Πειραιάς", region: region, country: state, continent: continent, geoname_id: 255274, population: 163688),
]
Municipality.import municipalities
province = region.provinces.create(description: "Νομαρχία Αθήνας", country: state, continent: continent,  geoname_id: 445408, population: 0)
municipalities = [
province.municipalities.new(description: "Αγίας Βαρβάρας", region: region, country: state, continent: continent, geoname_id: 8133771, population: 26550),
province.municipalities.new(description: "Αγίας Παρασκευής", region: region, country: state, continent: continent, geoname_id: 8133828, population: 59704),
province.municipalities.new(description: "Αγίου Δημητρίου", region: region, country: state, continent: continent, geoname_id: 8133667, population: 71294),
province.municipalities.new(description: "Αγίων Αναργύρων - Καματερού", region: region, country: state, continent: continent, geoname_id: 8133819, population: 62529),
province.municipalities.new(description: "Αθήναι", region: region, country: state, continent: continent, geoname_id: 8133876, population: 664046),
province.municipalities.new(description: "Αιγάλεω", region: region, country: state, continent: continent, geoname_id: 8133973, population: 69946),
province.municipalities.new(description: "Αλίμου", region: region, country: state, continent: continent, geoname_id: 8133951, population: 41720),
province.municipalities.new(description: "Αμαρουσίου", region: region, country: state, continent: continent, geoname_id: 8133770, population: 72333),
province.municipalities.new(description: "Βριλησσίων", region: region, country: state, continent: continent, geoname_id: 8133807, population: 30741),
province.municipalities.new(description: "Βύρωνος", region: region, country: state, continent: continent, geoname_id: 8133859, population: 61308),
province.municipalities.new(description: "Γαλατσίου", region: region, country: state, continent: continent, geoname_id: 8133798, population: 59345),
province.municipalities.new(description: "Γλυφάδας", region: region, country: state, continent: continent, geoname_id: 8133886, population: 87305),
province.municipalities.new(description: "Δάφνης - Υμηττού", region: region, country: state, continent: continent, geoname_id: 8133710, population: 33628),
province.municipalities.new(description: "Ελληνικού - Αργυρούπολης", region: region, country: state, continent: continent, geoname_id: 8133982, population: 51356),
province.municipalities.new(description: "Ζωγράφου", region: region, country: state, continent: continent, geoname_id: 8133877, population: 71026),
province.municipalities.new(description: "Ηλιούπολης", region: region, country: state, continent: continent, geoname_id: 8133815, population: 78153),
province.municipalities.new(description: "Ηρακλείου", region: region, country: state, continent: continent, geoname_id: 8133693, population: 49642),
province.municipalities.new(description: "Ιλίου", region: region, country: state, continent: continent, geoname_id: 8133919, population: 84793),
province.municipalities.new(description: "Καισαριανής", region: region, country: state, continent: continent, geoname_id: 8133881, population: 26458),
province.municipalities.new(description: "Καλλιθέας", region: region, country: state, continent: continent, geoname_id: 8133880, population: 100641),
province.municipalities.new(description: "Κηφισιάς", region: region, country: state, continent: continent, geoname_id: 8133694, population: 70600),
province.municipalities.new(description: "Λυκόβρυσης - Πεύκης", region: region, country: state, continent: continent, geoname_id: 8133776, population: 31002),
province.municipalities.new(description: "Μεταμόρφωση", region: region, country: state, continent: continent, geoname_id: 8133888, population: 29891),
province.municipalities.new(description: "Μοσχάτου - Ταύρου", region: region, country: state, continent: continent, geoname_id: 8133676, population: 40413),
province.municipalities.new(description: "Νέας Ιωνίας", region: region, country: state, continent: continent, geoname_id: 8133780, population: 67134),
province.municipalities.new(description: "Νέας Σμύρνης", region: region, country: state, continent: continent, geoname_id: 8133665, population: 73076),
province.municipalities.new(description: "Παλαιού Φαλήρου", region: region, country: state, continent: continent, geoname_id: 8133960, population: 64021),
province.municipalities.new(description: "Παπάγου - Χολαργού", region: region, country: state, continent: continent, geoname_id: 8133839, population: 44539),
province.municipalities.new(description: "Πεντέλης", region: region, country: state, continent: continent, geoname_id: 8133840, population: 34934),
province.municipalities.new(description: "Περιστερίου", region: region, country: state, continent: continent, geoname_id: 8133783, population: 139981),
province.municipalities.new(description: "Πετρούπολης", region: region, country: state, continent: continent, geoname_id: 8133926, population: 58979),
province.municipalities.new(description: "Φιλαδελφείας - Χαλκηδόνος", region: region, country: state, continent: continent, geoname_id: 8133680, population: 35556),
province.municipalities.new(description: "Φιλοθέης - Ψυχικού", region: region, country: state, continent: continent, geoname_id: 8133782, population: 26968),
province.municipalities.new(description: "Χαλανδρίου", region: region, country: state, continent: continent, geoname_id: 8133842, population: 74192),
province.municipalities.new(description: "Χαϊδαρίου", region: region, country: state, continent: continent, geoname_id: 8133972, population: 46897),
]
Municipality.import municipalities
region = Region.create(description: "Αυτόνομη Μοναστική Πολιτεία Αγίου Όρους", country: state, continent: continent, geoname_id: 736572)
province = region.provinces.create(description: "Dáfni", country: state, continent: continent,  geoname_id: 736482, population: 0)
province = region.provinces.create(description: "Monoxilítai", country: state, continent: continent,  geoname_id: 735047, population: 0)
province = region.provinces.create(description: "Ελιά", country: state, continent: continent,  geoname_id: 736329, population: 0)
province = region.provinces.create(description: "Θηβαΐς", country: state, continent: continent,  geoname_id: 734068, population: 0)
province = region.provinces.create(description: "Καρυές", country: state, continent: continent,  geoname_id: 735972, population: 237)
region = Region.create(description: "Βόρειο Αιγαίο", country: state, continent: continent, geoname_id: 6697806)
province = region.provinces.create(description: "Λέσβος", country: state, continent: continent,  geoname_id: 258465, population: 0)
municipalities = [
province.municipalities.new(description: "Άγιος Ευστράτιος", region: region, country: state, continent: continent, geoname_id: 8133756, population: 307),
province.municipalities.new(description: "Λέσβος", region: region, country: state, continent: continent, geoname_id: 8133755, population: 90436),
province.municipalities.new(description: "Λήμνος", region: region, country: state, continent: continent, geoname_id: 8133757, population: 17545),
]
Municipality.import municipalities
province = region.provinces.create(description: "Σάμος", country: state, continent: continent,  geoname_id: 254112, population: 0)
municipalities = [
province.municipalities.new(description: "Ικαρία", region: region, country: state, continent: continent, geoname_id: 8133747, population: 8354),
province.municipalities.new(description: "Σάμος", region: region, country: state, continent: continent, geoname_id: 8133749, population: 34000),
province.municipalities.new(description: "Φούρνων Κορσεών", region: region, country: state, continent: continent, geoname_id: 8133748, population: 1487),
]
Municipality.import municipalities
province = region.provinces.create(description: "Χίος", country: state, continent: continent,  geoname_id: 259970, population: 0)
municipalities = [
province.municipalities.new(description: "Οινουσσών", region: region, country: state, continent: continent, geoname_id: 8133820, population: 855),
province.municipalities.new(description: "Χίου", region: region, country: state, continent: continent, geoname_id: 8133821, population: 51773),
province.municipalities.new(description: "Ψαρών", region: region, country: state, continent: continent, geoname_id: 8133829, population: 478),
]
Municipality.import municipalities
region = Region.create(description: "Δυτική Ελλάδα", country: state, continent: continent, geoname_id: 6697810)
province = region.provinces.create(description: "Αιτωλοακαρνανία", country: state, continent: continent,  geoname_id: 265508, population: 210802)
municipalities = [
province.municipalities.new(description: "Άκτιου - Βόνιτσας", region: region, country: state, continent: continent, geoname_id: 8133701, population: 17872),
province.municipalities.new(description: "Αγρινίου", region: region, country: state, continent: continent, geoname_id: 8133845, population: 96889),
province.municipalities.new(description: "Αμφιλοχίας", region: region, country: state, continent: continent, geoname_id: 8133705, population: 20491),
province.municipalities.new(description: "Θέρμου", region: region, country: state, continent: continent, geoname_id: 8133703, population: 7837),
province.municipalities.new(description: "Ιεράς Πόλης Μεσολογγίου", region: region, country: state, continent: continent, geoname_id: 8133706, population: 35805),
province.municipalities.new(description: "Ναυπακτίας", region: region, country: state, continent: continent, geoname_id: 8133707, population: 26840),
province.municipalities.new(description: "Ξηρομέρου", region: region, country: state, continent: continent, geoname_id: 8133708, population: 13358),
]
Municipality.import municipalities
province = region.provinces.create(description: "Αχαΐα", country: state, continent: continent,  geoname_id: 265491, population: 331316)
municipalities = [
province.municipalities.new(description: "Αιγιαλείας", region: region, country: state, continent: continent, geoname_id: 8133669, population: 53585),
province.municipalities.new(description: "Δυτικής Αχαΐας", region: region, country: state, continent: continent, geoname_id: 8133671, population: 29608),
province.municipalities.new(description: "Ερυμάνθου", region: region, country: state, continent: continent, geoname_id: 8133672, population: 11329),
province.municipalities.new(description: "Καλαβρύτων", region: region, country: state, continent: continent, geoname_id: 8133670, population: 13912),
province.municipalities.new(description: "Πατρέων", region: region, country: state, continent: continent, geoname_id: 8133690, population: 210494),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ηλεία", country: state, continent: continent,  geoname_id: 261797, population: 198763)
municipalities = [
province.municipalities.new(description: "Ήλιδας", region: region, country: state, continent: continent, geoname_id: 8133712, population: 36275),
province.municipalities.new(description: "Ανδρίτσαινας - Κρεστένων", region: region, country: state, continent: continent, geoname_id: 8133677, population: 21139),
province.municipalities.new(description: "Ανδραβίδας - Κυλλήνης", region: region, country: state, continent: continent, geoname_id: 8133691, population: 24668),
province.municipalities.new(description: "Αρχαίας Ολυμπίας", region: region, country: state, continent: continent, geoname_id: 8133692, population: 16431),
province.municipalities.new(description: "Ζαχάρως", region: region, country: state, continent: continent, geoname_id: 8133711, population: 13716),
province.municipalities.new(description: "Πηνειού", region: region, country: state, continent: continent, geoname_id: 8133689, population: 19658),
province.municipalities.new(description: "Πύργου", region: region, country: state, continent: continent, geoname_id: 8133887, population: 51634),
]
Municipality.import municipalities
region = Region.create(description: "Δυτική Μακεδονία", country: state, continent: continent, geoname_id: 6697811)
province = region.provinces.create(description: "Γρεβενά", country: state, continent: continent,  geoname_id: 736149, population: 0)
municipalities = [
province.municipalities.new(description: "Γρεβενών", region: region, country: state, continent: continent, geoname_id: 8133976, population: 25522),
province.municipalities.new(description: "Δεσκάτης", region: region, country: state, continent: continent, geoname_id: 8133858, population: 7045),
]
Municipality.import municipalities
province = region.provinces.create(description: "Καστοριά", country: state, continent: continent,  geoname_id: 735925, population: 0)
municipalities = [
province.municipalities.new(description: "Άργους Ορεστικού", region: region, country: state, continent: continent, geoname_id: 8133860, population: 13479),
province.municipalities.new(description: "Καστοριάς", region: region, country: state, continent: continent, geoname_id: 8133966, population: 37094),
province.municipalities.new(description: "Νεστορίου", region: region, country: state, continent: continent, geoname_id: 8133967, population: 3129),
]
Municipality.import municipalities
province = region.provinces.create(description: "Κοζάνη", country: state, continent: continent,  geoname_id: 735562, population: 0)
municipalities = [
province.municipalities.new(description: "Βοϊου", region: region, country: state, continent: continent, geoname_id: 8133797, population: 20430),
province.municipalities.new(description: "Εορδαίας", region: region, country: state, continent: continent, geoname_id: 8133857, population: 46555),
province.municipalities.new(description: "Κοζάνης", region: region, country: state, continent: continent, geoname_id: 8133764, population: 70220),
province.municipalities.new(description: "Σερβίων - Βελβεντού", region: region, country: state, continent: continent, geoname_id: 8133872, population: 16734),
]
Municipality.import municipalities
province = region.provinces.create(description: "Φλώρινα", country: state, continent: continent,  geoname_id: 736228, population: 0)
municipalities = [
province.municipalities.new(description: "Αμυνταίου", region: region, country: state, continent: continent, geoname_id: 8133871, population: 18357),
province.municipalities.new(description: "Πρεσπών", region: region, country: state, continent: continent, geoname_id: 8133873, population: 2164),
province.municipalities.new(description: "Φλώρινας", region: region, country: state, continent: continent, geoname_id: 8133716, population: 33588),
]
Municipality.import municipalities
region = Region.create(description: "Θεσσαλία", country: state, continent: continent, geoname_id: 6697809)
province = region.provinces.create(description: "Καρδίτσα", country: state, continent: continent,  geoname_id: 260988, population: 0)
municipalities = [
province.municipalities.new(description: "Αργιθέας", region: region, country: state, continent: continent, geoname_id: 8133980, population: 2488),
province.municipalities.new(description: "Καρδίτσας", region: region, country: state, continent: continent, geoname_id: 8133984, population: 57089),
province.municipalities.new(description: "Λίμνης Πλαστήρα", region: region, country: state, continent: continent, geoname_id: 8133733, population: 4022),
province.municipalities.new(description: "Μουζακίου", region: region, country: state, continent: continent, geoname_id: 8133792, population: 16407),
province.municipalities.new(description: "Παλαμά", region: region, country: state, continent: continent, geoname_id: 8133793, population: 18500),
province.municipalities.new(description: "Σοφάδων", region: region, country: state, continent: continent, geoname_id: 8133794, population: 21759),
]
Municipality.import municipalities
province = region.provinces.create(description: "Λάρισα", country: state, continent: continent,  geoname_id: 258575, population: 0)
municipalities = [
province.municipalities.new(description: "Αγιάς", region: region, country: state, continent: continent, geoname_id: 8133788, population: 13120),
province.municipalities.new(description: "Ελασσόνας", region: region, country: state, continent: continent, geoname_id: 8133784, population: 35358),
province.municipalities.new(description: "Κιλελέρ", region: region, country: state, continent: continent, geoname_id: 8133785, population: 22719),
province.municipalities.new(description: "Λαρισαίων", region: region, country: state, continent: continent, geoname_id: 8133786, population: 145981),
province.municipalities.new(description: "Τεμπών", region: region, country: state, continent: continent, geoname_id: 8133789, population: 15439),
province.municipalities.new(description: "Τυρνάβου", region: region, country: state, continent: continent, geoname_id: 8133787, population: 25864),
province.municipalities.new(description: "Φαρσάλων", region: region, country: state, continent: continent, geoname_id: 8133790, population: 23675),
]
Municipality.import municipalities
province = region.provinces.create(description: "Μαγνησία", country: state, continent: continent,  geoname_id: 258013, population: 0)
municipalities = [
province.municipalities.new(description: "Αλμυρού", region: region, country: state, continent: continent, geoname_id: 8133791, population: 20139),
province.municipalities.new(description: "Αλοννήσου", region: region, country: state, continent: continent, geoname_id: 8133938, population: 2425),
province.municipalities.new(description: "Βόλου", region: region, country: state, continent: continent, geoname_id: 8133894, population: 142923),
province.municipalities.new(description: "Ζαγοράς - Μουρεσίου", region: region, country: state, continent: continent, geoname_id: 8133935, population: 6449),
province.municipalities.new(description: "Νοτίου Πηλίου", region: region, country: state, continent: continent, geoname_id: 8133936, population: 10745),
province.municipalities.new(description: "Ρήγα Φερραίου", region: region, country: state, continent: continent, geoname_id: 8133937, population: 11830),
province.municipalities.new(description: "Σκιάθου", region: region, country: state, continent: continent, geoname_id: 8133939, population: 5788),
province.municipalities.new(description: "Σκοπέλου", region: region, country: state, continent: continent, geoname_id: 8133893, population: 4706),
]
Municipality.import municipalities
province = region.provinces.create(description: "Τρίκαλα", country: state, continent: continent,  geoname_id: 252661, population: 0)
municipalities = [
province.municipalities.new(description: "Καλαμπάκας", region: region, country: state, continent: continent, geoname_id: 8133942, population: 22853),
province.municipalities.new(description: "Πύλης", region: region, country: state, continent: continent, geoname_id: 8133843, population: 15886),
province.municipalities.new(description: "Τρικκαίων", region: region, country: state, continent: continent, geoname_id: 8133844, population: 78817),
province.municipalities.new(description: "Φαρκαδόνας", region: region, country: state, continent: continent, geoname_id: 8133853, population: 15133),
]
Municipality.import municipalities
region = Region.create(description: "Ιόνια Νησιά", country: state, continent: continent, geoname_id: 6697805)
province = region.provinces.create(description: "Ζάκυνθος", country: state, continent: continent,  geoname_id: 251276, population: 41472)
municipalities = [
province.municipalities.new(description: "Ζακύνθου", region: region, country: state, continent: continent, geoname_id: 8133854, population: 38883),
]
Municipality.import municipalities
province = region.provinces.create(description: "Κέρκυρα", country: state, continent: continent,  geoname_id: 2463676, population: 113658)
municipalities = [
province.municipalities.new(description: "Κέρκυρα", region: region, country: state, continent: continent, geoname_id: 8133855, population: 108652),
province.municipalities.new(description: "Παξών", region: region, country: state, continent: continent, geoname_id: 8133911, population: 2429),
]
Municipality.import municipalities
province = region.provinces.create(description: "Κεφαλονιά", country: state, continent: continent,  geoname_id: 260310, population: 0)
municipalities = [
province.municipalities.new(description: "Ιθάκης", region: region, country: state, continent: continent, geoname_id: 8133849, population: 3212),
province.municipalities.new(description: "Κεφαλονιάς", region: region, country: state, continent: continent, geoname_id: 8133850, population: 34544),
]
Municipality.import municipalities
province = region.provinces.create(description: "Λευκάδα", country: state, continent: continent,  geoname_id: 258445, population: 22879)
municipalities = [
province.municipalities.new(description: "Λευκάδας", region: region, country: state, continent: continent, geoname_id: 8133851, population: 20894),
province.municipalities.new(description: "Μεγανησίου", region: region, country: state, continent: continent, geoname_id: 8133852, population: 994),
]
Municipality.import municipalities
region = Region.create(description: "Κεντρική Ελλάδα", country: state, continent: continent, geoname_id: 6697800)
province = region.provinces.create(description: "Βοιωτία", country: state, continent: continent,  geoname_id: 251851, population: 0)
municipalities = [
province.municipalities.new(description: "Αλιάρτου", region: region, country: state, continent: continent, geoname_id: 8133875, population: 11686),
province.municipalities.new(description: "Διστόμου-Αράχοβας - Αντίκυρας", region: region, country: state, continent: continent, geoname_id: 8133907, population: 9802),
province.municipalities.new(description: "Θηβαίων", region: region, country: state, continent: continent, geoname_id: 8133908, population: 36086),
province.municipalities.new(description: "Λεβαδέων", region: region, country: state, continent: continent, geoname_id: 8133909, population: 36086),
province.municipalities.new(description: "Ορχομενού", region: region, country: state, continent: continent, geoname_id: 8133910, population: 13032),
province.municipalities.new(description: "Τανάγρας", region: region, country: state, continent: continent, geoname_id: 8133914, population: 21156),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ευρυτανία", country: state, continent: continent,  geoname_id: 262572, population: 34855)
municipalities = [
province.municipalities.new(description: "Αγράφων", region: region, country: state, continent: continent, geoname_id: 8133730, population: 7190),
province.municipalities.new(description: "Καρπενησίου", region: region, country: state, continent: continent, geoname_id: 8133731, population: 12328),
]
Municipality.import municipalities
province = region.provinces.create(description: "Εύβοια", country: state, continent: continent,  geoname_id: 262564, population: 0)
municipalities = [
province.municipalities.new(description: "Διρφύων - Μεσσαπίων", region: region, country: state, continent: continent, geoname_id: 8133901, population: 19443),
province.municipalities.new(description: "Ερέτριας", region: region, country: state, continent: continent, geoname_id: 8133902, population: 12218),
province.municipalities.new(description: "Ιστιαίας - Αιδηψού", region: region, country: state, continent: continent, geoname_id: 8133903, population: 22132),
province.municipalities.new(description: "Καρύστου", region: region, country: state, continent: continent, geoname_id: 8133904, population: 13602),
province.municipalities.new(description: "Κύμης - Αλιβερίου", region: region, country: state, continent: continent, geoname_id: 8133905, population: 30717),
province.municipalities.new(description: "Μαντουδίου - Λίμνης - Αγίας Άννας", region: region, country: state, continent: continent, geoname_id: 8133906, population: 13673),
province.municipalities.new(description: "Σκύρου", region: region, country: state, continent: continent, geoname_id: 8133975, population: 2711),
province.municipalities.new(description: "Χαλκιδέων", region: region, country: state, continent: continent, geoname_id: 8133729, population: 92809),
]
Municipality.import municipalities
province = region.provinces.create(description: "Φθιώτιδα", country: state, continent: continent,  geoname_id: 262187, population: 0)
municipalities = [
province.municipalities.new(description: "Αμφίκλειας - Ελάτειας", region: region, country: state, continent: continent, geoname_id: 8133732, population: 10922),
province.municipalities.new(description: "Δομοκού", region: region, country: state, continent: continent, geoname_id: 8133737, population: 11495),
province.municipalities.new(description: "Λαμιέων", region: region, country: state, continent: continent, geoname_id: 8133738, population: 75315),
province.municipalities.new(description: "Λοκρών", region: region, country: state, continent: continent, geoname_id: 8133739, population: 19623),
province.municipalities.new(description: "Μακρακώμης", region: region, country: state, continent: continent, geoname_id: 8133740, population: 16036),
province.municipalities.new(description: "Μώλου - Αγ. Κωνσταντίνου", region: region, country: state, continent: continent, geoname_id: 8133746, population: 13932),
province.municipalities.new(description: "Στυλίδας", region: region, country: state, continent: continent, geoname_id: 8133765, population: 14118),
]
Municipality.import municipalities
province = region.provinces.create(description: "Φωκίδα", country: state, continent: continent,  geoname_id: 262322, population: 49576)
municipalities = [
province.municipalities.new(description: "Δελφών", region: region, country: state, continent: continent, geoname_id: 8133744, population: 26992),
province.municipalities.new(description: "Δωρίδος", region: region, country: state, continent: continent, geoname_id: 8133745, population: 10874),
]
Municipality.import municipalities
region = Region.create(description: "Κεντρική Μακεδονία", country: state, continent: continent, geoname_id: 6697801)
province = region.provinces.create(description: "Ημαθία", country: state, continent: continent,  geoname_id: 736120, population: 0)
municipalities = [
province.municipalities.new(description: "Αλεξάνδρειας", region: region, country: state, continent: continent, geoname_id: 8133931, population: 42777),
province.municipalities.new(description: "Βέροιας", region: region, country: state, continent: continent, geoname_id: 8133932, population: 65530),
province.municipalities.new(description: "Νάουσας", region: region, country: state, continent: continent, geoname_id: 8133882, population: 34164),
]
Municipality.import municipalities
province = region.provinces.create(description: "Θεσσαλονίκη", country: state, continent: continent,  geoname_id: 734075, population: 0)
municipalities = [
province.municipalities.new(description: "Αμπελοκήπων - Μενεμένης", region: region, country: state, continent: continent, geoname_id: 8133985, population: 58149),
province.municipalities.new(description: "Βόλβης", region: region, country: state, continent: continent, geoname_id: 8133915, population: 24454),
province.municipalities.new(description: "Δέλτα", region: region, country: state, continent: continent, geoname_id: 8133916, population: 40206),
province.municipalities.new(description: "Θέρμης", region: region, country: state, continent: continent, geoname_id: 8133763, population: 34436),
province.municipalities.new(description: "Θερμαϊκού", region: region, country: state, continent: continent, geoname_id: 8133917, population: 37126),
province.municipalities.new(description: "Θεσσαλονίκης", region: region, country: state, continent: continent, geoname_id: 8133841, population: 397156),
province.municipalities.new(description: "Καλαμαριάς", region: region, country: state, continent: continent, geoname_id: 8133959, population: 90096),
province.municipalities.new(description: "Κορδελιού - Ευόσμου", region: region, country: state, continent: continent, geoname_id: 8133918, population: 77174),
province.municipalities.new(description: "Λαγκαδά", region: region, country: state, continent: continent, geoname_id: 8133981, population: 39160),
province.municipalities.new(description: "Νέαπολης - Συκεών", region: region, country: state, continent: continent, geoname_id: 8133678, population: 89274),
province.municipalities.new(description: "Παύλου Μελά", region: region, country: state, continent: continent, geoname_id: 8133666, population: 87587),
province.municipalities.new(description: "Πυλαίας - Χορτιάτη", region: region, country: state, continent: continent, geoname_id: 8133774, population: 49922),
province.municipalities.new(description: "Χαλκηδόνος", region: region, country: state, continent: continent, geoname_id: 8133775, population: 34299),
province.municipalities.new(description: "Ωραιοκάστρου", region: region, country: state, continent: continent, geoname_id: 8133795, population: 24962),
]
Municipality.import municipalities
province = region.provinces.create(description: "Κιλκίς", country: state, continent: continent,  geoname_id: 735735, population: 0)
municipalities = [
province.municipalities.new(description: "Κιλκίς", region: region, country: state, continent: continent, geoname_id: 8133969, population: 54750),
province.municipalities.new(description: "Παιονίας", region: region, country: state, continent: continent, geoname_id: 8133970, population: 31674),
]
Municipality.import municipalities
province = region.provinces.create(description: "Πέλλα", country: state, continent: continent,  geoname_id: 734725, population: 0)
municipalities = [
province.municipalities.new(description: "Έδεσσας", region: region, country: state, continent: continent, geoname_id: 8133912, population: 29568),
province.municipalities.new(description: "Αλμωπίας", region: region, country: state, continent: continent, geoname_id: 8133796, population: 28822),
province.municipalities.new(description: "Πέλλας", region: region, country: state, continent: continent, geoname_id: 8133848, population: 64847),
province.municipalities.new(description: "Σκύδρας", region: region, country: state, continent: continent, geoname_id: 8133913, population: 20720),
]
Municipality.import municipalities
province = region.provinces.create(description: "Πιερία", country: state, continent: continent,  geoname_id: 734649, population: 0)
municipalities = [
province.municipalities.new(description: "Δίου - Ολύμπου", region: region, country: state, continent: continent, geoname_id: 8133846, population: 25872),
province.municipalities.new(description: "Κατερίνης", region: region, country: state, continent: continent, geoname_id: 8133847, population: 83387),
province.municipalities.new(description: "Πύδνας - Κολινδρού", region: region, country: state, continent: continent, geoname_id: 8133861, population: 17153),
]
Municipality.import municipalities
province = region.provinces.create(description: "Σέρρες", country: state, continent: continent,  geoname_id: 734329, population: 0)
municipalities = [
province.municipalities.new(description: "Αμφίπολης", region: region, country: state, continent: continent, geoname_id: 8133862, population: 11860),
province.municipalities.new(description: "Βισαλτίας", region: region, country: state, continent: continent, geoname_id: 8133863, population: 23158),
province.municipalities.new(description: "Εμμανουήλ Παππά", region: region, country: state, continent: continent, geoname_id: 8133856, population: 19053),
province.municipalities.new(description: "Ηρακλείας", region: region, country: state, continent: continent, geoname_id: 8133864, population: 22695),
province.municipalities.new(description: "Νέας Ζίχνης", region: region, country: state, continent: continent, geoname_id: 8133865, population: 13813),
province.municipalities.new(description: "Σερρών", region: region, country: state, continent: continent, geoname_id: 8133866, population: 76472),
province.municipalities.new(description: "Σιντικής", region: region, country: state, continent: continent, geoname_id: 8133867, population: 27432),
]
Municipality.import municipalities
province = region.provinces.create(description: "Χαλκιδική", country: state, continent: continent,  geoname_id: 735804, population: 109587)
municipalities = [
province.municipalities.new(description: "Αριστοτέλη", region: region, country: state, continent: continent, geoname_id: 8133868, population: 17752),
province.municipalities.new(description: "Κασσάνδρας", region: region, country: state, continent: continent, geoname_id: 8133869, population: 14971),
province.municipalities.new(description: "Νέας Προποντίδας", region: region, country: state, continent: continent, geoname_id: 8133870, population: 30397),
province.municipalities.new(description: "Πολυγύρου", region: region, country: state, continent: continent, geoname_id: 8133962, population: 21931),
province.municipalities.new(description: "Σιθωνίας", region: region, country: state, continent: continent, geoname_id: 8133963, population: 11798),
]
Municipality.import municipalities
region = Region.create(description: "Κρήτη", country: state, continent: continent, geoname_id: 6697802)
province = region.provinces.create(description: "Ηράκλειο", country: state, continent: continent,  geoname_id: 261741, population: 302846)
municipalities = [
province.municipalities.new(description: "Αρχανών - Αστερουσίων", region: region, country: state, continent: continent, geoname_id: 8133817, population: 17531),
province.municipalities.new(description: "Βιάννου", region: region, country: state, continent: continent, geoname_id: 8133818, population: 5983),
province.municipalities.new(description: "Γόρτυνας", region: region, country: state, continent: continent, geoname_id: 8133944, population: 17423),
province.municipalities.new(description: "Ηρακλείου", region: region, country: state, continent: continent, geoname_id: 8133920, population: 163115),
province.municipalities.new(description: "Μαλεβιζίου", region: region, country: state, continent: continent, geoname_id: 8133945, population: 20735),
province.municipalities.new(description: "Μινώα Πεδιάδας", region: region, country: state, continent: continent, geoname_id: 8133810, population: 18692),
province.municipalities.new(description: "Φαιστού", region: region, country: state, continent: continent, geoname_id: 8133968, population: 23882),
province.municipalities.new(description: "Χερσονήσου", region: region, country: state, continent: continent, geoname_id: 8133695, population: 23864),
]
Municipality.import municipalities
province = region.provinces.create(description: "Λασίθι", country: state, continent: continent,  geoname_id: 258569, population: 0)
municipalities = [
province.municipalities.new(description: "Αγίου Νικολάου", region: region, country: state, continent: continent, geoname_id: 8133929, population: 26069),
province.municipalities.new(description: "Ιεράπετρας", region: region, country: state, continent: continent, geoname_id: 8133930, population: 27744),
province.municipalities.new(description: "Οροπεδίου Λασιθίου", region: region, country: state, continent: continent, geoname_id: 8133925, population: 3067),
province.municipalities.new(description: "Σητείας", region: region, country: state, continent: continent, geoname_id: 8133948, population: 27744),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ρέθυμνο", country: state, continent: continent,  geoname_id: 254353, population: 86532)
municipalities = [
province.municipalities.new(description: "Αγίου Βασιλείου", region: region, country: state, continent: continent, geoname_id: 8133949, population: 8648),
province.municipalities.new(description: "Αμάριου", region: region, country: state, continent: continent, geoname_id: 8133983, population: 5633),
province.municipalities.new(description: "Ανωγείων", region: region, country: state, continent: continent, geoname_id: 8133943, population: 4054),
province.municipalities.new(description: "Μυλοποτάμου", region: region, country: state, continent: continent, geoname_id: 8133758, population: 13350),
province.municipalities.new(description: "Ρεθύμνης", region: region, country: state, continent: continent, geoname_id: 8133759, population: 47272),
]
Municipality.import municipalities
province = region.provinces.create(description: "Χανιά", country: state, continent: continent,  geoname_id: 260096, population: 0)
municipalities = [
province.municipalities.new(description: "Αποκορώνου", region: region, country: state, continent: continent, geoname_id: 8133750, population: 12112),
province.municipalities.new(description: "Γαύδου", region: region, country: state, continent: continent, geoname_id: 8133751, population: 81),
province.municipalities.new(description: "Κίσσαμος", region: region, country: state, continent: continent, geoname_id: 8133753, population: 11470),
province.municipalities.new(description: "Καντάνου - Σέλινου", region: region, country: state, continent: continent, geoname_id: 8133752, population: 6302),
province.municipalities.new(description: "Πλατανιά", region: region, country: state, continent: continent, geoname_id: 8133754, population: 17864),
province.municipalities.new(description: "Σφακίων", region: region, country: state, continent: continent, geoname_id: 8133761, population: 2419),
province.municipalities.new(description: "Χανιά", region: region, country: state, continent: continent, geoname_id: 8133762, population: 98202),
]
Municipality.import municipalities
region = Region.create(description: "Νότιο Αιγαίο", country: state, continent: continent, geoname_id: 6697808)
province = region.provinces.create(description: "Δωδεκάνησα", country: state, continent: continent,  geoname_id: 263021, population: 0)
municipalities = [
province.municipalities.new(description: "Αγαθονήσι", region: region, country: state, continent: continent, geoname_id: 8133824, population: 152),
province.municipalities.new(description: "Αστυπαλαίας", region: region, country: state, continent: continent, geoname_id: 8133811, population: 1385),
province.municipalities.new(description: "Κάσου", region: region, country: state, continent: continent, geoname_id: 8133956, population: 1013),
province.municipalities.new(description: "Καλυμνίων", region: region, country: state, continent: continent, geoname_id: 8133812, population: 16576),
province.municipalities.new(description: "Καρπάθου", region: region, country: state, continent: continent, geoname_id: 8133955, population: 6565),
province.municipalities.new(description: "Κω", region: region, country: state, continent: continent, geoname_id: 8133957, population: 30828),
province.municipalities.new(description: "Λέρου", region: region, country: state, continent: continent, geoname_id: 8133814, population: 8172),
province.municipalities.new(description: "Λειψών", region: region, country: state, continent: continent, geoname_id: 8133813, population: 687),
province.municipalities.new(description: "Μεγίστης", region: region, country: state, continent: continent, geoname_id: 8133700, population: 403),
province.municipalities.new(description: "Νισύρου", region: region, country: state, continent: continent, geoname_id: 8133958, population: 928),
province.municipalities.new(description: "Πάτμου", region: region, country: state, continent: continent, geoname_id: 8133954, population: 3053),
province.municipalities.new(description: "Ρόδου", region: region, country: state, continent: continent, geoname_id: 8133781, population: 115334),
province.municipalities.new(description: "Σύμης", region: region, country: state, continent: continent, geoname_id: 8133940, population: 2594),
province.municipalities.new(description: "Τήλου", region: region, country: state, continent: continent, geoname_id: 8133941, population: 521),
province.municipalities.new(description: "Χάλκης", region: region, country: state, continent: continent, geoname_id: 8133964, population: 295),
]
Municipality.import municipalities
province = region.provinces.create(description: "Κυκλάδες", country: state, continent: continent,  geoname_id: 259819, population: 119549)
municipalities = [
province.municipalities.new(description: "Άνδρου", region: region, country: state, continent: continent, geoname_id: 8133830, population: 9285),
province.municipalities.new(description: "Αμοργού", region: region, country: state, continent: continent, geoname_id: 8133934, population: 1852),
province.municipalities.new(description: "Ανάφης", region: region, country: state, continent: continent, geoname_id: 8133831, population: 272),
province.municipalities.new(description: "Αντιπάρου", region: region, country: state, continent: continent, geoname_id: 8133698, population: 1011),
province.municipalities.new(description: "Ιητών", region: region, country: state, continent: continent, geoname_id: 8133833, population: 1862),
province.municipalities.new(description: "Κέας", region: region, country: state, continent: continent, geoname_id: 8133952, population: 2162),
province.municipalities.new(description: "Κίμωλος", region: region, country: state, continent: continent, geoname_id: 8133679, population: 910),
province.municipalities.new(description: "Κύθνου", region: region, country: state, continent: continent, geoname_id: 8133953, population: 1538),
province.municipalities.new(description: "Μήλος", region: region, country: state, continent: continent, geoname_id: 8133681, population: 4977),
province.municipalities.new(description: "Μύκονος", region: region, country: state, continent: continent, geoname_id: 8133933, population: 9274),
province.municipalities.new(description: "Νάξου & Μικρών Κυκλάδων", region: region, country: state, continent: continent, geoname_id: 8133697, population: 18229),
province.municipalities.new(description: "Πάρου", region: region, country: state, continent: continent, geoname_id: 8133699, population: 12514),
province.municipalities.new(description: "Σίφνου", region: region, country: state, continent: continent, geoname_id: 8133683, population: 2574),
province.municipalities.new(description: "Σαντορίνη", region: region, country: state, continent: continent, geoname_id: 8133832, population: 13725),
province.municipalities.new(description: "Σερίφου", region: region, country: state, continent: continent, geoname_id: 8133682, population: 1262),
province.municipalities.new(description: "Σικίνου", region: region, country: state, continent: continent, geoname_id: 8133822, population: 238),
province.municipalities.new(description: "Σύρος", region: region, country: state, continent: continent, geoname_id: 8133927, population: 19793),
province.municipalities.new(description: "Τήνος", region: region, country: state, continent: continent, geoname_id: 8133928, population: 8115),
province.municipalities.new(description: "Φολεγάνδρου", region: region, country: state, continent: continent, geoname_id: 8133823, population: 676),
]
Municipality.import municipalities
region = Region.create(description: "Πελοπόννησος", country: state, continent: continent, geoname_id: 6697807)
province = region.provinces.create(description: "Αργολίδα", country: state, continent: continent,  geoname_id: 264673, population: 0)
municipalities = [
province.municipalities.new(description: "Άργους - Μυκηνών", region: region, country: state, continent: continent, geoname_id: 8133979, population: 47745),
province.municipalities.new(description: "Επιδαύρου", region: region, country: state, continent: continent, geoname_id: 8133804, population: 8710),
province.municipalities.new(description: "Ερμιονίδας", region: region, country: state, continent: continent, geoname_id: 8133805, population: 14330),
province.municipalities.new(description: "Ναυπλιέων", region: region, country: state, continent: continent, geoname_id: 8133806, population: 31607),
]
Municipality.import municipalities
province = region.provinces.create(description: "Αρκαδία", country: state, continent: continent,  geoname_id: 264644, population: 0)
municipalities = [
province.municipalities.new(description: "Βόρειας Κυνουρίας", region: region, country: state, continent: continent, geoname_id: 8133800, population: 11589),
province.municipalities.new(description: "Γορτυνίας", region: region, country: state, continent: continent, geoname_id: 8133801, population: 12492),
province.municipalities.new(description: "Μεγαλόπολης", region: region, country: state, continent: continent, geoname_id: 8133802, population: 11044),
province.municipalities.new(description: "Νότιας Κυνουρίας", region: region, country: state, continent: continent, geoname_id: 8133803, population: 7633),
province.municipalities.new(description: "Τρίπολης", region: region, country: state, continent: continent, geoname_id: 8133668, population: 48568),
]
Municipality.import municipalities
province = region.provinces.create(description: "Κορινθία", country: state, continent: continent,  geoname_id: 259290, population: 0)
municipalities = [
province.municipalities.new(description: "Βέλου - Βόχας", region: region, country: state, continent: continent, geoname_id: 8133799, population: 17251),
province.municipalities.new(description: "Κορινθίων", region: region, country: state, continent: continent, geoname_id: 8133673, population: 58523),
province.municipalities.new(description: "Λουτρακίου-Περαχώρας-Αγίων Θεοδώρων", region: region, country: state, continent: continent, geoname_id: 8133977, population: 20040),
province.municipalities.new(description: "Νεμέας", region: region, country: state, continent: continent, geoname_id: 8133674, population: 7286),
province.municipalities.new(description: "Ξυλοκάστρου - Ευρωστίνης", region: region, country: state, continent: continent, geoname_id: 8133978, population: 18224),
province.municipalities.new(description: "Σικυωνίων", region: region, country: state, continent: continent, geoname_id: 8133675, population: 23203),
]
Municipality.import municipalities
province = region.provinces.create(description: "Λακωνία", country: state, continent: continent,  geoname_id: 258657, population: 0)
municipalities = [
province.municipalities.new(description: "Ανατολικής Μάνης", region: region, country: state, continent: continent, geoname_id: 8133713, population: 14308),
province.municipalities.new(description: "Ελαφονήσου", region: region, country: state, continent: continent, geoname_id: 8133714, population: 746),
province.municipalities.new(description: "Ευρώτα", region: region, country: state, continent: continent, geoname_id: 8133715, population: 19319),
province.municipalities.new(description: "Μονεμβασιάς", region: region, country: state, continent: continent, geoname_id: 8133723, population: 21898),
province.municipalities.new(description: "Σπάρτης", region: region, country: state, continent: continent, geoname_id: 8133718, population: 36540),
]
Municipality.import municipalities
province = region.provinces.create(description: "Μεσσηνία", country: state, continent: continent,  geoname_id: 257149, population: 0)
municipalities = [
province.municipalities.new(description: "Δυτικής Μάνης", region: region, country: state, continent: continent, geoname_id: 8133724, population: 6658),
province.municipalities.new(description: "Καλαμάτας", region: region, country: state, continent: continent, geoname_id: 8133971, population: 70006),
province.municipalities.new(description: "Μεσσήνης", region: region, country: state, continent: continent, geoname_id: 8133986, population: 25859),
province.municipalities.new(description: "Οιχαλίας", region: region, country: state, continent: continent, geoname_id: 8133987, population: 11681),
province.municipalities.new(description: "Πύλου - Νέστορος", region: region, country: state, continent: continent, geoname_id: 8133988, population: 21172),
province.municipalities.new(description: "Τριφυλίας", region: region, country: state, continent: continent, geoname_id: 8133760, population: 31190),
]
Municipality.import municipalities
