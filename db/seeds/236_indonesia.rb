continent = Continent.find_by(description: 'Asia')
state = Country.find_by(description: 'Indonesia')
region = Region.create(description: "Bali", country: state, continent: continent, geoname_id: 1650535)
province = region.provinces.create(description: "Kabupaten Badung", country: state, continent: continent,  geoname_id: 1650818, population: 543332)
province = region.provinces.create(description: "Kabupaten Bangli", country: state, continent: continent,  geoname_id: 1650263, population: 215353)
province = region.provinces.create(description: "Kabupaten Buleleng", country: state, continent: continent,  geoname_id: 1647803, population: 624125)
province = region.provinces.create(description: "Kabupaten Gianyar", country: state, continent: continent,  geoname_id: 1644098, population: 469777)
municipalities = [
province.municipalities.new(description: "Ubud", region: region, country: state, continent: continent, geoname_id: 1622846, population: 28373),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Jembrana", country: state, continent: continent,  geoname_id: 1642584, population: 261638)
province = region.provinces.create(description: "Kabupaten Karangasem", country: state, continent: continent,  geoname_id: 7086954, population: 396487)
province = region.provinces.create(description: "Kabupaten Klungkung", country: state, continent: continent,  geoname_id: 1639849, population: 170543)
province = region.provinces.create(description: "Kabupaten Tabanan", country: state, continent: continent,  geoname_id: 1625707, population: 420913)
province = region.provinces.create(description: "Kotamayda Denpasar", country: state, continent: continent,  geoname_id: 1645527, population: 788589)
region = Region.create(description: "Daerah Khusus Ibukota Jakarta", country: state, continent: continent, geoname_id: 1642907)
province = region.provinces.create(description: "Kabupaten Administrasi Kepulauan Seribu", country: state, continent: continent,  geoname_id: 9849799, population: 21082)
province = region.provinces.create(description: "Kotamadya Jakarta Barat", country: state, continent: continent,  geoname_id: 1642909, population: 2365502)
province = region.provinces.create(description: "Kotamadya Jakarta Pusat", country: state, continent: continent,  geoname_id: 1642908, population: 931998)
province = region.provinces.create(description: "Kotamadya Jakarta Selatan", country: state, continent: continent,  geoname_id: 1642905, population: 2204395)
province = region.provinces.create(description: "Kotamadya Jakarta Timur", country: state, continent: continent,  geoname_id: 1642904, population: 2693896)
province = region.provinces.create(description: "Kotamadya Jakarta Utara", country: state, continent: continent,  geoname_id: 1642903, population: 1736143)
region = Region.create(description: "Jambi", country: state, continent: continent, geoname_id: 1642856)
province = region.provinces.create(description: "Kabupaten Batang Hari", country: state, continent: continent,  geoname_id: 1649863, population: 250436)
province = region.provinces.create(description: "Kabupaten Bungo", country: state, continent: continent,  geoname_id: 7910349, population: 319943)
province = region.provinces.create(description: "Kabupaten Kerinci", country: state, continent: continent,  geoname_id: 1640224, population: 240000)
province = region.provinces.create(description: "Kabupaten Merangin", country: state, continent: continent,  geoname_id: 9828959, population: 350049)
province = region.provinces.create(description: "Kabupaten Muaro Jambi", country: state, continent: continent,  geoname_id: 9782270, population: 356494)
province = region.provinces.create(description: "Kabupaten Sarolangun", country: state, continent: continent,  geoname_id: 1628580, population: 262688)
province = region.provinces.create(description: "Kabupaten Tanjung Jabung Barat", country: state, continent: continent,  geoname_id: 9845496, population: 289435)
province = region.provinces.create(description: "Kabupaten Tanjung Jabung Timur", country: state, continent: continent,  geoname_id: 9845498, population: 207129)
province = region.provinces.create(description: "Kabupaten Tebo", country: state, continent: continent,  geoname_id: 9845500, population: 317210)
province = region.provinces.create(description: "Kota Jambi", country: state, continent: continent,  geoname_id: 1642857, population: 566305)
province = region.provinces.create(description: "Kota Sungai Penuh", country: state, continent: continent,  geoname_id: 9845476, population: 89912)
region = Region.create(description: "Jawa Tengah", country: state, continent: continent, geoname_id: 1642669)
province = region.provinces.create(description: "Kabupaten Banjarnegara", country: state, continent: continent,  geoname_id: 6380795, population: 898264)
province = region.provinces.create(description: "Kabupaten Banyumas", country: state, continent: continent,  geoname_id: 1650094, population: 1641061)
province = region.provinces.create(description: "Kabupaten Batang", country: state, continent: continent,  geoname_id: 1649879, population: 761277)
province = region.provinces.create(description: "Kabupaten Blora", country: state, continent: continent,  geoname_id: 1648567, population: 869931)
province = region.provinces.create(description: "Kabupaten Boyolali", country: state, continent: continent,  geoname_id: 1648083, population: 979748)
province = region.provinces.create(description: "Kabupaten Brebes", country: state, continent: continent,  geoname_id: 1648064, population: 1817040)
province = region.provinces.create(description: "Kabupaten Cilacap", country: state, continent: continent,  geoname_id: 6384572, population: 1761387)
municipalities = [
province.municipalities.new(description: "Sidaurip", region: region, country: state, continent: continent, geoname_id: 7688426, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Demak", country: state, continent: continent,  geoname_id: 6739766, population: 1133846)
province = region.provinces.create(description: "Kabupaten Grobogan", country: state, continent: continent,  geoname_id: 1643768, population: 1387816)
province = region.provinces.create(description: "Kabupaten Jepara", country: state, continent: continent,  geoname_id: 1642545, population: 1150332)
province = region.provinces.create(description: "Kabupaten Karanganyar", country: state, continent: continent,  geoname_id: 6560140, population: 857721)
province = region.provinces.create(description: "Kabupaten Kebumen", country: state, continent: continent,  geoname_id: 6376498, population: 1218169)
province = region.provinces.create(description: "Kabupaten Kendal", country: state, continent: continent,  geoname_id: 6745680, population: 949565)
municipalities = [
province.municipalities.new(description: "Patukangan", region: region, country: state, continent: continent, geoname_id: 6732559, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Klaten", country: state, continent: continent,  geoname_id: 1639899, population: 1184319)
province = region.provinces.create(description: "Kabupaten Kudus", country: state, continent: continent,  geoname_id: 1639214, population: 822994)
province = region.provinces.create(description: "Kabupaten Magelang", country: state, continent: continent,  geoname_id: 6199035, population: 1228169)
province = region.provinces.create(description: "Kabupaten Pati", country: state, continent: continent,  geoname_id: 1631990, population: 1249795)
province = region.provinces.create(description: "Kabupaten Pekalongan", country: state, continent: continent,  geoname_id: 6792336, population: 875118)
province = region.provinces.create(description: "Kabupaten Pemalang", country: state, continent: continent,  geoname_id: 1631647, population: 1329344)
province = region.provinces.create(description: "Kabupaten Purbalingga", country: state, continent: continent,  geoname_id: 6390578, population: 890681)
province = region.provinces.create(description: "Kabupaten Purworejo", country: state, continent: continent,  geoname_id: 1630324, population: 741866)
province = region.provinces.create(description: "Kabupaten Rembang", country: state, continent: continent,  geoname_id: 1629746, population: 621354)
province = region.provinces.create(description: "Kabupaten Semarang", country: state, continent: continent,  geoname_id: 6410701, population: 995703)
province = region.provinces.create(description: "Kabupaten Sragen", country: state, continent: continent,  geoname_id: 6266177, population: 898327)
province = region.provinces.create(description: "Kabupaten Sukoharjo", country: state, continent: continent,  geoname_id: 1626271, population: 882707)
province = region.provinces.create(description: "Kabupaten Tegal", country: state, continent: continent,  geoname_id: 1624493, population: 1458226)
province = region.provinces.create(description: "Kabupaten Temanggung", country: state, continent: continent,  geoname_id: 1624237, population: 738490)
province = region.provinces.create(description: "Kabupaten Wonogiri", country: state, continent: continent,  geoname_id: 1621430, population: 965516)
municipalities = [
province.municipalities.new(description: "Senggolan", region: region, country: state, continent: continent, geoname_id: 6386832, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Wonosobo", country: state, continent: continent,  geoname_id: 6405140, population: 775639)
province = region.provinces.create(description: "Kota Magelang", country: state, continent: continent,  geoname_id: 1636882, population: 118227)
province = region.provinces.create(description: "Kota Salatiga", country: state, continent: continent,  geoname_id: 6257933, population: 170332)
province = region.provinces.create(description: "Kota Semarang", country: state, continent: continent,  geoname_id: 1627893, population: 1636949)
province = region.provinces.create(description: "Kota Surakarta", country: state, continent: continent,  geoname_id: 1625811, population: 521543)
province = region.provinces.create(description: "Kotamadya Pekalongan", country: state, continent: continent,  geoname_id: 1631763, population: 316093)
province = region.provinces.create(description: "Kotamadya Tegal", country: state, continent: continent,  geoname_id: 6769512, population: 239599)
region = Region.create(description: "Jawa Timur", country: state, continent: continent, geoname_id: 1642668)
province = region.provinces.create(description: "Kabupaten Bangkalan", country: state, continent: continent,  geoname_id: 1650297, population: 906761)
province = region.provinces.create(description: "Kabupaten Banyuwangi", country: state, continent: continent,  geoname_id: 1650076, population: 1556078)
province = region.provinces.create(description: "Kabupaten Blitar", country: state, continent: continent,  geoname_id: 1648579, population: 1116639)
province = region.provinces.create(description: "Kabupaten Bojonegoro", country: state, continent: continent,  geoname_id: 1648450, population: 1209973)
province = region.provinces.create(description: "Kabupaten Bondowoso", country: state, continent: continent,  geoname_id: 6829652, population: 736772)
province = region.provinces.create(description: "Kabupaten Gresik", country: state, continent: continent,  geoname_id: 6775904, population: 1177042)
province = region.provinces.create(description: "Kabupaten Jember", country: state, continent: continent,  geoname_id: 1642587, population: 2332726)
province = region.provinces.create(description: "Kabupaten Jombang", country: state, continent: continent,  geoname_id: 1642413, population: 1202407)
province = region.provinces.create(description: "Kabupaten Kediri", country: state, continent: continent,  geoname_id: 1640657, population: 1499768)
province = region.provinces.create(description: "Kabupaten Lamongan", country: state, continent: continent,  geoname_id: 8080464, population: 1179059)
province = region.provinces.create(description: "Kabupaten Lumajang", country: state, continent: continent,  geoname_id: 1637089, population: 1006458)
province = region.provinces.create(description: "Kabupaten Madiun", country: state, continent: continent,  geoname_id: 1636929, population: 662278)
province = region.provinces.create(description: "Kabupaten Magetan", country: state, continent: continent,  geoname_id: 6409167, population: 620442)
province = region.provinces.create(description: "Kabupaten Malang", country: state, continent: continent,  geoname_id: 1636713, population: 2446218)
province = region.provinces.create(description: "Kabupaten Mojokerto", country: state, continent: continent,  geoname_id: 1635110, population: 1025443)
province = region.provinces.create(description: "Kabupaten Nganjuk", country: state, continent: continent,  geoname_id: 1634130, population: 1017030)
province = region.provinces.create(description: "Kabupaten Ngawi", country: state, continent: continent,  geoname_id: 6410477, population: 817765)
province = region.provinces.create(description: "Kabupaten Pacitan", country: state, continent: continent,  geoname_id: 1633438, population: 542960)
province = region.provinces.create(description: "Kabupaten Pamekasan", country: state, continent: continent,  geoname_id: 1632977, population: 795918)
province = region.provinces.create(description: "Kabupaten Pasuruan", country: state, continent: continent,  geoname_id: 1632032, population: 1512468)
province = region.provinces.create(description: "Kabupaten Ponorogo", country: state, continent: continent,  geoname_id: 1630797, population: 855281)
province = region.provinces.create(description: "Kabupaten Probolinggo", country: state, continent: continent,  geoname_id: 1630633, population: 1096244)
province = region.provinces.create(description: "Kabupaten Sampang", country: state, continent: continent,  geoname_id: 1628896, population: 877772)
province = region.provinces.create(description: "Kabupaten Sidoarjo", country: state, continent: continent,  geoname_id: 1627252, population: 1941497)
province = region.provinces.create(description: "Kabupaten Situbondo", country: state, continent: continent,  geoname_id: 1632902, population: 647619)
province = region.provinces.create(description: "Kabupaten Sumenep", country: state, continent: continent,  geoname_id: 8541464, population: 1042312)
province = region.provinces.create(description: "Kabupaten Trenggalek", country: state, continent: continent,  geoname_id: 1623250, population: 674411)
province = region.provinces.create(description: "Kabupaten Tuban", country: state, continent: continent,  geoname_id: 1623178, population: 1118464)
province = region.provinces.create(description: "Kabupaten Tulungagung", country: state, continent: continent,  geoname_id: 1623079, population: 990158)
province = region.provinces.create(description: "Kota Batu", country: state, continent: continent,  geoname_id: 9849812, population: 190184)
province = region.provinces.create(description: "Kota Kediri", country: state, continent: continent,  geoname_id: 1640656, population: 268507)
province = region.provinces.create(description: "Kota Surabaya", country: state, continent: continent,  geoname_id: 1625820, population: 2765487)
municipalities = [
province.municipalities.new(description: "Kota Surabaya", region: region, country: state, continent: continent, geoname_id: 1625822, population: 2374658),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kotamadya Blitar", country: state, continent: continent,  geoname_id: 1648578, population: 131968)
province = region.provinces.create(description: "Kotamadya Madiun", country: state, continent: continent,  geoname_id: 1636927, population: 170964)
province = region.provinces.create(description: "Kotamadya Malang", country: state, continent: continent,  geoname_id: 1636712, population: 820243)
province = region.provinces.create(description: "Kotamadya Mojokerto", country: state, continent: continent,  geoname_id: 1635109, population: 120196)
province = region.provinces.create(description: "Kotamadya Pasuruan", country: state, continent: continent,  geoname_id: 1632031, population: 186262)
province = region.provinces.create(description: "Kotamadya Probolinggo", country: state, continent: continent,  geoname_id: 1630632, population: 217062)
region = Region.create(description: "Kalimantan Barat", country: state, continent: continent, geoname_id: 1641900)
province = region.provinces.create(description: "Kabupaten Bengkayang", country: state, continent: continent,  geoname_id: 8740064, population: 215277)
province = region.provinces.create(description: "Kabupaten Kapuas Hulu", country: state, continent: continent,  geoname_id: 1641395, population: 222160)
province = region.provinces.create(description: "Kabupaten Kayong Utara", country: state, continent: continent,  geoname_id: 9828031, population: 95594)
province = region.provinces.create(description: "Kabupaten Ketapang", country: state, continent: continent,  geoname_id: 1640126, population: 427460)
province = region.provinces.create(description: "Kabupaten Kubu Raya", country: state, continent: continent,  geoname_id: 9828037, population: 500970)
province = region.provinces.create(description: "Kabupaten Landak", country: state, continent: continent,  geoname_id: 8740062, population: 329649)
province = region.provinces.create(description: "Kabupaten Melawi", country: state, continent: continent,  geoname_id: 9828958, population: 178645)
province = region.provinces.create(description: "Kabupaten Pontianak", country: state, continent: continent,  geoname_id: 1630788, population: 234021)
province = region.provinces.create(description: "Kabupaten Sambas", country: state, continent: continent,  geoname_id: 1628978, population: 496120)
province = region.provinces.create(description: "Kabupaten Sanggau", country: state, continent: continent,  geoname_id: 1628799, population: 408468)
province = region.provinces.create(description: "Kabupaten Sekadau", country: state, continent: continent,  geoname_id: 9166118, population: 181634)
province = region.provinces.create(description: "Kabupaten Sintang", country: state, continent: continent,  geoname_id: 1626886, population: 364759)
province = region.provinces.create(description: "Kota Pontianak", country: state, continent: continent,  geoname_id: 1630787, population: 554764)
province = region.provinces.create(description: "Kota Singkawang", country: state, continent: continent,  geoname_id: 9845433, population: 186462)
region = Region.create(description: "Kalimantan Tengah", country: state, continent: continent, geoname_id: 1641898)
province = region.provinces.create(description: "Kabupaten Barito Selatan", country: state, continent: continent,  geoname_id: 1649991, population: 124128)
province = region.provinces.create(description: "Kabupaten Barito Timur", country: state, continent: continent,  geoname_id: 1649990, population: 97372)
province = region.provinces.create(description: "Kabupaten Barito Utara", country: state, continent: continent,  geoname_id: 1649989, population: 121573)
province = region.provinces.create(description: "Kabupaten Gunung Mas", country: state, continent: continent,  geoname_id: 1643597, population: 96990)
municipalities = [
province.municipalities.new(description: "Batu Badinging", region: region, country: state, continent: continent, geoname_id: 9405219, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Kapuas", country: state, continent: continent,  geoname_id: 1641398, population: 329646)
province = region.provinces.create(description: "Kabupaten Katingan", country: state, continent: continent,  geoname_id: 1640948, population: 146439)
province = region.provinces.create(description: "Kabupaten Kotawaringin Barat", country: state, continent: continent,  geoname_id: 1639476, population: 235803)
province = region.provinces.create(description: "Kabupaten Kotawaringin Timur", country: state, continent: continent,  geoname_id: 1639475, population: 374175)
province = region.provinces.create(description: "Kabupaten Lamandau", country: state, continent: continent,  geoname_id: 9165993, population: 63199)
province = region.provinces.create(description: "Kabupaten Murung Raya", country: state, continent: continent,  geoname_id: 1634654, population: 96857)
province = region.provinces.create(description: "Kabupaten Pulang Pisau", country: state, continent: continent,  geoname_id: 8741175, population: 120062)
province = region.provinces.create(description: "Kabupaten Seruyan", country: state, continent: continent,  geoname_id: 1627443, population: 139931)
municipalities = [
province.municipalities.new(description: "Halimaung Jaya (F-3)", region: region, country: state, continent: continent, geoname_id: 9405294, population: 0),
province.municipalities.new(description: "Halimaung Jaya (F-3) District", region: region, country: state, continent: continent, geoname_id: 9405300, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Sukamara", country: state, continent: continent,  geoname_id: 9166125, population: 44952)
municipalities = [
province.municipalities.new(description: "Sukamara", region: region, country: state, continent: continent, geoname_id: 1626345, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kota Palangka Raya", country: state, continent: continent,  geoname_id: 1633117, population: 220962)
region = Region.create(description: "Kalimantan Timur", country: state, continent: continent, geoname_id: 1641897)
province = region.provinces.create(description: "Kabupaten Berau", country: state, continent: continent,  geoname_id: 1649040, population: 179079)
province = region.provinces.create(description: "Kabupaten Kutai Barat", country: state, continent: continent,  geoname_id: 9828038, population: 165091)
province = region.provinces.create(description: "Kabupaten Kutai Kartanegara", country: state, continent: continent,  geoname_id: 9828039, population: 626680)
province = region.provinces.create(description: "Kabupaten Kutai Timur", country: state, continent: continent,  geoname_id: 9846668, population: 255637)
province = region.provinces.create(description: "Kabupaten Mahakam Hulu", country: state, continent: continent,  geoname_id: 9849855, population: 0)
province = region.provinces.create(description: "Kabupaten Paser", country: state, continent: continent,  geoname_id: 9843600, population: 230316)
province = region.provinces.create(description: "Kabupaten Penajam Paser Utara", country: state, continent: continent,  geoname_id: 9165729, population: 142922)
province = region.provinces.create(description: "Kota Balikpapan", country: state, continent: continent,  geoname_id: 1650526, population: 557579)
province = region.provinces.create(description: "Kota Bontang", country: state, continent: continent,  geoname_id: 9821952, population: 143683)
province = region.provinces.create(description: "Kota Samarinda", country: state, continent: continent,  geoname_id: 1629000, population: 727500)
region = Region.create(description: "Kepulauan Bangka Belitung", country: state, continent: continent, geoname_id: 1923047)
province = region.provinces.create(description: "Kabupaten Bangka", country: state, continent: continent,  geoname_id: 1650314, population: 282114)
province = region.provinces.create(description: "Kabupaten Bangka Barat", country: state, continent: continent,  geoname_id: 9821906, population: 181293)
province = region.provinces.create(description: "Kabupaten Bangka Selatan", country: state, continent: continent,  geoname_id: 9821904, population: 180216)
province = region.provinces.create(description: "Kabupaten Bangka Tengah", country: state, continent: continent,  geoname_id: 9821905, population: 172554)
province = region.provinces.create(description: "Kabupaten Belitung", country: state, continent: continent,  geoname_id: 1649281, population: 170381)
province = region.provinces.create(description: "Kabupaten Belitung Timur", country: state, continent: continent,  geoname_id: 9821907, population: 106463)
province = region.provinces.create(description: "Kota Pangkal Pinang", country: state, continent: continent,  geoname_id: 1632653, population: 183852)
region = Region.create(description: "Kepulauan Riau", country: state, continent: continent, geoname_id: 1996551)
province = region.provinces.create(description: "Kabupaten Bintan", country: state, continent: continent,  geoname_id: 9034776, population: 149777)
province = region.provinces.create(description: "Kabupaten Karimun", country: state, continent: continent,  geoname_id: 9821909, population: 223707)
province = region.provinces.create(description: "Kabupaten Lingga", country: state, continent: continent,  geoname_id: 8739779, population: 89456)
province = region.provinces.create(description: "Kabupaten Natuna", country: state, continent: continent,  geoname_id: 8740093, population: 70183)
province = region.provinces.create(description: "Kepulauan Anambas", country: state, continent: continent,  geoname_id: 8740095, population: 42040)
province = region.provinces.create(description: "Kota Batam", country: state, continent: continent,  geoname_id: 9849917, population: 985290)
province = region.provinces.create(description: "Kota Tanjung Pinang", country: state, continent: continent,  geoname_id: 9849940, population: 187359)
region = Region.create(description: "Lampung", country: state, continent: continent, geoname_id: 1638535)
province = region.provinces.create(description: "Kabupaten Lampung Barat", country: state, continent: continent,  geoname_id: 9166059, population: 437952)
province = region.provinces.create(description: "Kabupaten Lampung Selatan", country: state, continent: continent,  geoname_id: 7862296, population: 964504)
province = region.provinces.create(description: "Kabupaten Lampung Tengah", country: state, continent: continent,  geoname_id: 1638532, population: 1253001)
province = region.provinces.create(description: "Kabupaten Lampung Timur", country: state, continent: continent,  geoname_id: 9165778, population: 998257)
province = region.provinces.create(description: "Kabupaten Lampung Utara", country: state, continent: continent,  geoname_id: 1638531, population: 602062)
province = region.provinces.create(description: "Kabupaten Pesawaran", country: state, continent: continent,  geoname_id: 9843606, population: 416733)
province = region.provinces.create(description: "Kabupaten Pesisir Barat", country: state, continent: continent,  geoname_id: 9828028, population: 0)
province = region.provinces.create(description: "Kabupaten Pringsewu", country: state, continent: continent,  geoname_id: 9844898, population: 377813)
province = region.provinces.create(description: "Kabupaten Tanggamus", country: state, continent: continent,  geoname_id: 9845482, population: 561450)
province = region.provinces.create(description: "Kabupaten Tulang Bawang Barat", country: state, continent: continent,  geoname_id: 9846658, population: 265131)
province = region.provinces.create(description: "Kabupaten Tulangbawang", country: state, continent: continent,  geoname_id: 9164018, population: 416567)
province = region.provinces.create(description: "Kabupaten Way Kanan", country: state, continent: continent,  geoname_id: 9163828, population: 429062)
province = region.provinces.create(description: "Kecamatan Mesuji Lampung", country: state, continent: continent,  geoname_id: 8552411, population: 197437)
province = region.provinces.create(description: "Kota Metro", country: state, continent: continent,  geoname_id: 9828960, population: 152347)
province = region.provinces.create(description: "Kotamadya Bandarlampung", country: state, continent: continent,  geoname_id: 1624916, population: 913704)
region = Region.create(description: "North Kalimantan", country: state, continent: continent, geoname_id: 8604684)
province = region.provinces.create(description: "Bulungan", country: state, continent: continent,  geoname_id: 8613240, population: 0)
province = region.provinces.create(description: "Kabupaten Malinau", country: state, continent: continent,  geoname_id: 8613353, population: 0)
province = region.provinces.create(description: "Kabupaten Nunukan", country: state, continent: continent,  geoname_id: 8613360, population: 0)
province = region.provinces.create(description: "Kabupaten Tana Tidung", country: state, continent: continent,  geoname_id: 8613361, population: 0)
province = region.provinces.create(description: "Kota Tarakan", country: state, continent: continent,  geoname_id: 8613334, population: 0)
region = Region.create(description: "Papua", country: state, continent: continent, geoname_id: 1643012)
province = region.provinces.create(description: "Kabupaten Asmat", country: state, continent: continent,  geoname_id: 9165711, population: 76577)
municipalities = [
province.municipalities.new(description: "Ayr", region: region, country: state, continent: continent, geoname_id: 9881631, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Biak Numfor", country: state, continent: continent,  geoname_id: 8530432, population: 126798)
municipalities = [
province.municipalities.new(description: "Urami", region: region, country: state, continent: continent, geoname_id: 7651064, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Boven Digoel", country: state, continent: continent,  geoname_id: 9166001, population: 55784)
province = region.provinces.create(description: "Kabupaten Deiyai", country: state, continent: continent,  geoname_id: 9821956, population: 62119)
province = region.provinces.create(description: "Kabupaten Dogiyai", country: state, continent: continent,  geoname_id: 9821957, population: 84230)
province = region.provinces.create(description: "Kabupaten Intan Jaya", country: state, continent: continent,  geoname_id: 9846664, population: 40490)
province = region.provinces.create(description: "Kabupaten Jayapura", country: state, continent: continent,  geoname_id: 1642655, population: 111943)
province = region.provinces.create(description: "Kabupaten Jayawijaya", country: state, continent: continent,  geoname_id: 1631789, population: 196085)
province = region.provinces.create(description: "Kabupaten Keerom", country: state, continent: continent,  geoname_id: 8531252, population: 48536)
province = region.provinces.create(description: "Kabupaten Kepulauan Yapen", country: state, continent: continent,  geoname_id: 9172045, population: 82951)
province = region.provinces.create(description: "Kabupaten Lanny Jaya", country: state, continent: continent,  geoname_id: 9828040, population: 148522)
province = region.provinces.create(description: "Kabupaten Mamberamo Raya", country: state, continent: continent,  geoname_id: 9828781, population: 18365)
province = region.provinces.create(description: "Kabupaten Mamberamo Tengah", country: state, continent: continent,  geoname_id: 9828820, population: 39537)
province = region.provinces.create(description: "Kabupaten Mappi", country: state, continent: continent,  geoname_id: 9165710, population: 81658)
province = region.provinces.create(description: "Kabupaten Merauke", country: state, continent: continent,  geoname_id: 1635387, population: 195716)
municipalities = [
province.municipalities.new(description: "Merauke", region: region, country: state, continent: continent, geoname_id: 2082539, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Mimika", country: state, continent: continent,  geoname_id: 9172049, population: 182001)
province = region.provinces.create(description: "Kabupaten Nabire", country: state, continent: continent,  geoname_id: 7910937, population: 129893)
province = region.provinces.create(description: "Kabupaten Nduga", country: state, continent: continent,  geoname_id: 9828977, population: 79053)
province = region.provinces.create(description: "Kabupaten Paniai", country: state, continent: continent,  geoname_id: 1632622, population: 153432)
province = region.provinces.create(description: "Kabupaten Pegunungan Bintang", country: state, continent: continent,  geoname_id: 7910943, population: 65434)
province = region.provinces.create(description: "Kabupaten Puncak", country: state, continent: continent,  geoname_id: 9846669, population: 93218)
province = region.provinces.create(description: "Kabupaten Puncak Jaya", country: state, continent: continent,  geoname_id: 9172050, population: 101148)
province = region.provinces.create(description: "Kabupaten Sarmi", country: state, continent: continent,  geoname_id: 8531251, population: 32971)
municipalities = [
province.municipalities.new(description: "Nemporewa", region: region, country: state, continent: continent, geoname_id: 1634231, population: 0),
province.municipalities.new(description: "Sarmi", region: region, country: state, continent: continent, geoname_id: 1628587, population: 0),
province.municipalities.new(description: "Sarmi Selatan", region: region, country: state, continent: continent, geoname_id: 10228374, population: 0),
province.municipalities.new(description: "Sawar", region: region, country: state, continent: continent, geoname_id: 1628446, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Supiori", country: state, continent: continent,  geoname_id: 9172047, population: 15874)
province = region.provinces.create(description: "Kabupaten Tolikara", country: state, continent: continent,  geoname_id: 9846653, population: 114427)
province = region.provinces.create(description: "Kabupaten Waropen", country: state, continent: continent,  geoname_id: 1621238, population: 24639)
province = region.provinces.create(description: "Kabupaten Yahukimo", country: state, continent: continent,  geoname_id: 9846659, population: 164512)
province = region.provinces.create(description: "Kabupaten Yalimo", country: state, continent: continent,  geoname_id: 9846662, population: 50763)
province = region.provinces.create(description: "Kota Jayapura", country: state, continent: continent,  geoname_id: 7910936, population: 256705)
region = Region.create(description: "Propinsi Bengkulu", country: state, continent: continent, geoname_id: 1649147)
province = region.provinces.create(description: "Bengkulu Selatan", country: state, continent: continent,  geoname_id: 1649146, population: 148861)
province = region.provinces.create(description: "Kabupaten Bengkulu Tengah", country: state, continent: continent,  geoname_id: 9821946, population: 103512)
province = region.provinces.create(description: "Kabupaten Bengkulu Utara", country: state, continent: continent,  geoname_id: 1649145, population: 267234)
province = region.provinces.create(description: "Kabupaten Kaur", country: state, continent: continent,  geoname_id: 9828030, population: 111842)
province = region.provinces.create(description: "Kabupaten Kepahiang", country: state, continent: continent,  geoname_id: 9828032, population: 131139)
province = region.provinces.create(description: "Kabupaten Lebong", country: state, continent: continent,  geoname_id: 9828041, population: 103826)
province = region.provinces.create(description: "Kabupaten Mukomuko", country: state, continent: continent,  geoname_id: 9828963, population: 162194)
province = region.provinces.create(description: "Kabupaten Rejanglebong", country: state, continent: continent,  geoname_id: 1629764, population: 260571)
province = region.provinces.create(description: "Kabupaten Seluma", country: state, continent: continent,  geoname_id: 9845356, population: 182650)
province = region.provinces.create(description: "Kota Bengkulu", country: state, continent: continent,  geoname_id: 1649148, population: 321596)
region = Region.create(description: "Propinsi Gorontalo", country: state, continent: continent, geoname_id: 1923046)
province = region.provinces.create(description: "Kabupaten Boalemo", country: state, continent: continent,  geoname_id: 9165686, population: 129253)
province = region.provinces.create(description: "Kabupaten Bone Bolango", country: state, continent: continent,  geoname_id: 9165685, population: 141915)
province = region.provinces.create(description: "Kabupaten Gorontalo", country: state, continent: continent,  geoname_id: 6960133, population: 355988)
province = region.provinces.create(description: "Kabupaten Gorontalo Utara", country: state, continent: continent,  geoname_id: 9165866, population: 104133)
province = region.provinces.create(description: "Kabupaten Pohuwato", country: state, continent: continent,  geoname_id: 9165687, population: 128748)
province = region.provinces.create(description: "Kotamadya Gorontalo", country: state, continent: continent,  geoname_id: 1643836, population: 180127)
region = Region.create(description: "Propinsi Nusa Tenggara Barat", country: state, continent: continent, geoname_id: 1633792)
province = region.provinces.create(description: "Kabupaten Bima", country: state, continent: continent,  geoname_id: 1648758, population: 439228)
province = region.provinces.create(description: "Kabupaten Lombok Barat", country: state, continent: continent,  geoname_id: 1637367, population: 599986)
province = region.provinces.create(description: "Kabupaten Lombok Timur", country: state, continent: continent,  geoname_id: 1637365, population: 1105582)
province = region.provinces.create(description: "Kabupaten Lombok Utara", country: state, continent: continent,  geoname_id: 8659092, population: 200072)
province = region.provinces.create(description: "Kabupaten Sumbawa", country: state, continent: continent,  geoname_id: 8594735, population: 415789)
province = region.provinces.create(description: "Kabupaten Sumbawa Barat", country: state, continent: continent,  geoname_id: 6984549, population: 114951)
province = region.provinces.create(description: "Kebupatan Lombok Tengah", country: state, continent: continent,  geoname_id: 1637366, population: 860209)
province = region.provinces.create(description: "Kecamatan Dompu", country: state, continent: continent,  geoname_id: 7057508, population: 218973)
province = region.provinces.create(description: "Kota Administratip Mataram", country: state, continent: continent,  geoname_id: 1635881, population: 402843)
province = region.provinces.create(description: "Kotamadya Bima", country: state, continent: continent,  geoname_id: 8659101, population: 142579)
region = Region.create(description: "Provinsi Banten", country: state, continent: continent, geoname_id: 1923045)
province = region.provinces.create(description: "Kabupaten Lebak", country: state, continent: continent,  geoname_id: 1638238, population: 1204095)
province = region.provinces.create(description: "Kabupaten Pandeglang", country: state, continent: continent,  geoname_id: 1632822, population: 1149610)
province = region.provinces.create(description: "Kabupaten Serang", country: state, continent: continent,  geoname_id: 1627545, population: 1402818)
province = region.provinces.create(description: "Kabupaten Tangerang", country: state, continent: continent,  geoname_id: 1625083, population: 2834376)
province = region.provinces.create(description: "Kota Serang", country: state, continent: continent,  geoname_id: 9845383, population: 577785)
province = region.provinces.create(description: "Kota Tangerang", country: state, continent: continent,  geoname_id: 9849891, population: 1798601)
province = region.provinces.create(description: "Kota Tangerang Selatan", country: state, continent: continent,  geoname_id: 9845480, population: 1290322)
province = region.provinces.create(description: "Kotamadya Cilegon", country: state, continent: continent,  geoname_id: 6758625, population: 374559)
region = Region.create(description: "Provinsi Jawa Barat", country: state, continent: continent, geoname_id: 1642672)
province = region.provinces.create(description: "Kab. Bandung Barat", country: state, continent: continent,  geoname_id: 7910336, population: 1583031)
province = region.provinces.create(description: "Kabupaten Bandung", country: state, continent: continent,  geoname_id: 1650352, population: 3344169)
province = region.provinces.create(description: "Kabupaten Bekasi", country: state, continent: continent,  geoname_id: 1649377, population: 2739577)
province = region.provinces.create(description: "Kabupaten Bogor", country: state, continent: continent,  geoname_id: 1648471, population: 4985585)
province = region.provinces.create(description: "Kabupaten Ciamis", country: state, continent: continent,  geoname_id: 1647148, population: 1626611)
province = region.provinces.create(description: "Kabupaten Cianjur", country: state, continent: continent,  geoname_id: 6588980, population: 2323667)
province = region.provinces.create(description: "Kabupaten Cirebon", country: state, continent: continent,  geoname_id: 1646169, population: 2175108)
province = region.provinces.create(description: "Kabupaten Garut", country: state, continent: continent,  geoname_id: 1644408, population: 2526623)
province = region.provinces.create(description: "Kabupaten Indramayu", country: state, continent: continent,  geoname_id: 1643077, population: 1714184)
province = region.provinces.create(description: "Kabupaten Karawang", country: state, continent: continent,  geoname_id: 1641133, population: 2267233)
province = region.provinces.create(description: "Kabupaten Kuningan", country: state, continent: continent,  geoname_id: 1639093, population: 1096434)
province = region.provinces.create(description: "Kabupaten Majalengka", country: state, continent: continent,  geoname_id: 1636815, population: 1238218)
municipalities = [
province.municipalities.new(description: "Pancurendang Tonggoh", region: region, country: state, continent: continent, geoname_id: 1632864, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Pangandaran", country: state, continent: continent,  geoname_id: 9827974, population: 0)
province = region.provinces.create(description: "Kabupaten Purwakarta", country: state, continent: continent,  geoname_id: 1630340, population: 873804)
province = region.provinces.create(description: "Kabupaten Subang", country: state, continent: continent,  geoname_id: 6581948, population: 1566916)
province = region.provinces.create(description: "Kabupaten Sukabumi", country: state, continent: continent,  geoname_id: 1626380, population: 2442062)
province = region.provinces.create(description: "Kabupaten Sumedang", country: state, continent: continent,  geoname_id: 1626102, population: 1143500)
province = region.provinces.create(description: "Kabupaten Tasikmalaya", country: state, continent: continent,  geoname_id: 1624646, population: 1752628)
province = region.provinces.create(description: "Kodya Bogor", country: state, continent: continent,  geoname_id: 1648470, population: 1032949)
province = region.provinces.create(description: "Kota Banjar", country: state, continent: continent,  geoname_id: 9855467, population: 185503)
province = region.provinces.create(description: "Kota Cimahi", country: state, continent: continent,  geoname_id: 1646446, population: 541177)
province = region.provinces.create(description: "Kota Tasikmalaya", country: state, continent: continent,  geoname_id: 1624645, population: 669824)
province = region.provinces.create(description: "Kotamadya Bandung", country: state, continent: continent,  geoname_id: 6559695, population: 2544073)
province = region.provinces.create(description: "Kotamadya Bekasi", country: state, continent: continent,  geoname_id: 6599302, population: 2403118)
province = region.provinces.create(description: "Kotamadya Cirebon", country: state, continent: continent,  geoname_id: 1646168, population: 314464)
province = region.provinces.create(description: "Kotamadya Depok", country: state, continent: continent,  geoname_id: 6751097, population: 1876658)
province = region.provinces.create(description: "Kotamadya Sukabumi", country: state, continent: continent,  geoname_id: 1626379, population: 311628)
region = Region.create(description: "Provinsi Kalimantan Selatan", country: state, continent: continent, geoname_id: 1641899)
province = region.provinces.create(description: "Kabupaten Balangan", country: state, continent: continent,  geoname_id: 9165684, population: 112430)
province = region.provinces.create(description: "Kabupaten Banjar", country: state, continent: continent,  geoname_id: 1650231, population: 506839)
province = region.provinces.create(description: "Kabupaten Barito Kuala", country: state, continent: continent,  geoname_id: 1649992, population: 276147)
province = region.provinces.create(description: "Kabupaten Hulu Sungai Selatan", country: state, continent: continent,  geoname_id: 1643246, population: 212485)
province = region.provinces.create(description: "Kabupaten Hulu Sungai Tengah", country: state, continent: continent,  geoname_id: 1643245, population: 243460)
municipalities = [
province.municipalities.new(description: "Barikin", region: region, country: state, continent: continent, geoname_id: 9958154, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Hulu Sungai Utara", country: state, continent: continent,  geoname_id: 1643244, population: 209246)
province = region.provinces.create(description: "Kabupaten Kota Baru", country: state, continent: continent,  geoname_id: 1639532, population: 290142)
province = region.provinces.create(description: "Kabupaten Tabalong", country: state, continent: continent,  geoname_id: 1625714, population: 218620)
province = region.provinces.create(description: "Kabupaten Tanah Bumbu", country: state, continent: continent,  geoname_id: 9780988, population: 267929)
province = region.provinces.create(description: "Kabupaten Tanahlaut", country: state, continent: continent,  geoname_id: 1625166, population: 296333)
province = region.provinces.create(description: "Kabupaten Tapin", country: state, continent: continent,  geoname_id: 1624750, population: 167877)
province = region.provinces.create(description: "Kota Banjar Baru", country: state, continent: continent,  geoname_id: 1650216, population: 199627)
province = region.provinces.create(description: "Kota Banjarmasin", country: state, continent: continent,  geoname_id: 1650211, population: 625481)
region = Region.create(description: "Provinsi Maluku", country: state, continent: continent, geoname_id: 1636627)
province = region.provinces.create(description: "Kabupaten Buru", country: state, continent: continent,  geoname_id: 9165994, population: 108445)
province = region.provinces.create(description: "Kabupaten Buru Selatan", country: state, continent: continent,  geoname_id: 9821953, population: 53671)
province = region.provinces.create(description: "Kabupaten Kepulauan Aru", country: state, continent: continent,  geoname_id: 9165706, population: 84138)
province = region.provinces.create(description: "Kabupaten Maluku Barat Daya", country: state, continent: continent,  geoname_id: 9828043, population: 70714)
province = region.provinces.create(description: "Kabupaten Maluku Tengah", country: state, continent: continent,  geoname_id: 9165982, population: 361698)
province = region.provinces.create(description: "Kabupaten Maluku Tenggara", country: state, continent: continent,  geoname_id: 1636625, population: 96442)
province = region.provinces.create(description: "Kabupaten Maluku Tenggara Barat", country: state, continent: continent,  geoname_id: 9828704, population: 105341)
province = region.provinces.create(description: "Kabupaten Seram Bagian Barat", country: state, continent: continent,  geoname_id: 9165987, population: 164656)
province = region.provinces.create(description: "Kabupaten Seram Bagian Timur", country: state, continent: continent,  geoname_id: 9165999, population: 99065)
province = region.provinces.create(description: "Kota Ambon", country: state, continent: continent,  geoname_id: 1651530, population: 331254)
province = region.provinces.create(description: "Kota Tual", country: state, continent: continent,  geoname_id: 9846657, population: 58082)
region = Region.create(description: "Provinsi Maluku Utara", country: state, continent: continent, geoname_id: 1958070)
province = region.provinces.create(description: "Halmahera Barat", country: state, continent: continent,  geoname_id: 9165708, population: 100424)
province = region.provinces.create(description: "Halmahera Timur", country: state, continent: continent,  geoname_id: 9165995, population: 73109)
province = region.provinces.create(description: "Kabupaten Halmahera Selatan", country: state, continent: continent,  geoname_id: 7910927, population: 198911)
province = region.provinces.create(description: "Kabupaten Halmahera Tengah", country: state, continent: continent,  geoname_id: 1643475, population: 42815)
province = region.provinces.create(description: "Kabupaten Halmahera Utara", country: state, continent: continent,  geoname_id: 9165798, population: 161847)
municipalities = [
province.municipalities.new(description: "Galela", region: region, country: state, continent: continent, geoname_id: 1644608, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Kepulauan Sula", country: state, continent: continent,  geoname_id: 9172043, population: 132524)
province = region.provinces.create(description: "Kabupaten Pulau Morotai", country: state, continent: continent,  geoname_id: 9844899, population: 52697)
province = region.provinces.create(description: "Kabupaten Pulau Taliabu", country: state, continent: continent,  geoname_id: 9828029, population: 0)
province = region.provinces.create(description: "Kota Ternate", country: state, continent: continent,  geoname_id: 7910935, population: 185705)
province = region.provinces.create(description: "Kota Tidore Kepulauan", country: state, continent: continent,  geoname_id: 9845501, population: 90055)
region = Region.create(description: "Provinsi Nanggroe Aceh Darussalam", country: state, continent: continent, geoname_id: 1215638)
province = region.provinces.create(description: "Banda Aceh", country: state, continent: continent,  geoname_id: 1215501, population: 226608)
municipalities = [
province.municipalities.new(description: "Ateuk Deah Tanoh", region: region, country: state, continent: continent, geoname_id: 10177548, population: 0),
province.municipalities.new(description: "Ateuk Jowo", region: region, country: state, continent: continent, geoname_id: 6700831, population: 0),
province.municipalities.new(description: "Kota Banda Aceh", region: region, country: state, continent: continent, geoname_id: 1215502, population: 250757),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Aceh Barat", country: state, continent: continent,  geoname_id: 1215636, population: 187687)
province = region.provinces.create(description: "Kabupaten Aceh Barat Daya", country: state, continent: continent,  geoname_id: 6701674, population: 131019)
province = region.provinces.create(description: "Kabupaten Aceh Besar", country: state, continent: continent,  geoname_id: 1215635, population: 382582)
province = region.provinces.create(description: "Kabupaten Aceh Selatan", country: state, continent: continent,  geoname_id: 1215634, population: 211554)
municipalities = [
province.municipalities.new(description: "Gelombang", region: region, country: state, continent: continent, geoname_id: 6714965, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Aceh Singkil", country: state, continent: continent,  geoname_id: 6713333, population: 103711)
municipalities = [
province.municipalities.new(description: "Kayu Menang Baru", region: region, country: state, continent: continent, geoname_id: 6705753, population: 0),
province.municipalities.new(description: "Kuala Baru Laut", region: region, country: state, continent: continent, geoname_id: 6705750, population: 0),
province.municipalities.new(description: "Rantau Gedang", region: region, country: state, continent: continent, geoname_id: 6711738, population: 0),
province.municipalities.new(description: "Rimo", region: region, country: state, continent: continent, geoname_id: 6711705, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Aceh Tamiang", country: state, continent: continent,  geoname_id: 6701575, population: 262358)
province = region.provinces.create(description: "Kabupaten Aceh Tengah", country: state, continent: continent,  geoname_id: 1215633, population: 189939)
province = region.provinces.create(description: "Kabupaten Aceh Tenggara", country: state, continent: continent,  geoname_id: 1215632, population: 186880)
municipalities = [
province.municipalities.new(description: "Kutacane", region: region, country: state, continent: continent, geoname_id: 1214815, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Aceh Timur", country: state, continent: continent,  geoname_id: 1215631, population: 379455)
province = region.provinces.create(description: "Kabupaten Aceh Utara", country: state, continent: continent,  geoname_id: 1215630, population: 564428)
province = region.provinces.create(description: "Kabupaten Ache Jaya", country: state, continent: continent,  geoname_id: 6705241, population: 80472)
province = region.provinces.create(description: "Kabupaten Bener Meriah", country: state, continent: continent,  geoname_id: 6712486, population: 127228)
municipalities = [
province.municipalities.new(description: "Permata", region: region, country: state, continent: continent, geoname_id: 8572026, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Bireuen", country: state, continent: continent,  geoname_id: 6729814, population: 406786)
province = region.provinces.create(description: "Kabupaten Gayo Lues", country: state, continent: continent,  geoname_id: 8224054, population: 83466)
municipalities = [
province.municipalities.new(description: "Ketambe", region: region, country: state, continent: continent, geoname_id: 6705418, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Nagan Rayan", country: state, continent: continent,  geoname_id: 6703019, population: 147215)
province = region.provinces.create(description: "Kabupaten Pidie", country: state, continent: continent,  geoname_id: 8224055, population: 397698)
province = region.provinces.create(description: "Kabupaten Simeulue", country: state, continent: continent,  geoname_id: 6704825, population: 81164)
province = region.provinces.create(description: "Kota Langsa", country: state, continent: continent,  geoname_id: 8224053, population: 157853)
province = region.provinces.create(description: "Kota Lhokseumawe", country: state, continent: continent,  geoname_id: 6719204, population: 179481)
province = region.provinces.create(description: "Kota Sabang", country: state, continent: continent,  geoname_id: 1214025, population: 37486)
province = region.provinces.create(description: "Kota Subulussalam", country: state, continent: continent,  geoname_id: 8571638, population: 69297)
province = region.provinces.create(description: "Pidie Jaya", country: state, continent: continent,  geoname_id: 8571637, population: 138589)
region = Region.create(description: "Provinsi Nusa Tenggara Timur", country: state, continent: continent, geoname_id: 1633791)
province = region.provinces.create(description: "Kabupaten Alor", country: state, continent: continent,  geoname_id: 1651608, population: 190026)
province = region.provinces.create(description: "Kabupaten Belu", country: state, continent: continent,  geoname_id: 1649264, population: 352297)
province = region.provinces.create(description: "Kabupaten Ende", country: state, continent: continent,  geoname_id: 9165840, population: 260605)
province = region.provinces.create(description: "Kabupaten Flores Timur", country: state, continent: continent,  geoname_id: 1644743, population: 232605)
province = region.provinces.create(description: "Kabupaten Kupang", country: state, continent: continent,  geoname_id: 2057086, population: 304548)
province = region.provinces.create(description: "Kabupaten Lembata", country: state, continent: continent,  geoname_id: 9165593, population: 117829)
province = region.provinces.create(description: "Kabupaten Malaka", country: state, continent: continent,  geoname_id: 9846667, population: 0)
province = region.provinces.create(description: "Kabupaten Manggarai", country: state, continent: continent,  geoname_id: 1636422, population: 292451)
municipalities = [
province.municipalities.new(description: "KDS", region: region, country: state, continent: continent, geoname_id: 7569776, population: 500),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Manggarai Barat", country: state, continent: continent,  geoname_id: 9165681, population: 221703)
province = region.provinces.create(description: "Kabupaten Manggarai Timur", country: state, continent: continent,  geoname_id: 9828927, population: 252744)
province = region.provinces.create(description: "Kabupaten Nagekeo", country: state, continent: continent,  geoname_id: 9828965, population: 130120)
province = region.provinces.create(description: "Kabupaten Ngada", country: state, continent: continent,  geoname_id: 1634193, population: 142393)
province = region.provinces.create(description: "Kabupaten Rote Ndao", country: state, continent: continent,  geoname_id: 9165782, population: 119908)
province = region.provinces.create(description: "Kabupaten Sabu Raijua", country: state, continent: continent,  geoname_id: 9844902, population: 72960)
province = region.provinces.create(description: "Kabupaten Sikka", country: state, continent: continent,  geoname_id: 1627182, population: 300328)
province = region.provinces.create(description: "Kabupaten Sumba Barat", country: state, continent: continent,  geoname_id: 1626193, population: 110993)
province = region.provinces.create(description: "Kabupaten Sumba Barat Daya", country: state, continent: continent,  geoname_id: 9845472, population: 284903)
province = region.provinces.create(description: "Kabupaten Sumba Tengah", country: state, continent: continent,  geoname_id: 9845473, population: 62485)
province = region.provinces.create(description: "Kabupaten Sumba Timur", country: state, continent: continent,  geoname_id: 1626190, population: 227732)
province = region.provinces.create(description: "Kabupaten Timor Tengah Selatan", country: state, continent: continent,  geoname_id: 1623840, population: 441155)
province = region.provinces.create(description: "Kabupaten Timor Tengah Utara", country: state, continent: continent,  geoname_id: 1623839, population: 229803)
province = region.provinces.create(description: "Kotamadya Kupang", country: state, continent: continent,  geoname_id: 2057084, population: 336239)
region = Region.create(description: "Provinsi Papua Barat", country: state, continent: continent, geoname_id: 1996549)
province = region.provinces.create(description: "Kabupaten Fakfak", country: state, continent: continent,  geoname_id: 6619356, population: 66828)
province = region.provinces.create(description: "Kabupaten Kaimana", country: state, continent: continent,  geoname_id: 7910905, population: 46249)
province = region.provinces.create(description: "Kabupaten Manokwari", country: state, continent: continent,  geoname_id: 1636306, population: 187726)
province = region.provinces.create(description: "Kabupaten Manokwari Selatan", country: state, continent: continent,  geoname_id: 9827967, population: 0)
province = region.provinces.create(description: "Kabupaten Maybrat", country: state, continent: continent,  geoname_id: 9828956, population: 33081)
province = region.provinces.create(description: "Kabupaten Pegunungan Arfak", country: state, continent: continent,  geoname_id: 9828026, population: 0)
province = region.provinces.create(description: "Kabupaten Raja Ampat", country: state, continent: continent,  geoname_id: 1630210, population: 42507)
province = region.provinces.create(description: "Kabupaten Sorong", country: state, continent: continent,  geoname_id: 1626541, population: 70619)
province = region.provinces.create(description: "Kabupaten Sorong Selatan", country: state, continent: continent,  geoname_id: 7910924, population: 37900)
municipalities = [
province.municipalities.new(description: "Sailolof", region: region, country: state, continent: continent, geoname_id: 1629218, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Tambrauw", country: state, continent: continent,  geoname_id: 9845477, population: 6144)
province = region.provinces.create(description: "Kabupaten Teluk Bintuni", country: state, continent: continent,  geoname_id: 9166002, population: 52422)
province = region.provinces.create(description: "Kabupaten Teluk Wondama", country: state, continent: continent,  geoname_id: 7910908, population: 26321)
province = region.provinces.create(description: "Kota Sorong", country: state, continent: continent,  geoname_id: 9845465, population: 190625)
region = Region.create(description: "Provinsi Sulawesi Barat", country: state, continent: continent, geoname_id: 1996550)
province = region.provinces.create(description: "Kabupaten Majene", country: state, continent: continent,  geoname_id: 1636805, population: 151107)
province = region.provinces.create(description: "Kabupaten Mamasa", country: state, continent: continent,  geoname_id: 7910939, population: 140082)
province = region.provinces.create(description: "Kabupaten Mamuju", country: state, continent: continent,  geoname_id: 1636555, population: 336973)
province = region.provinces.create(description: "Kabupaten Mamuju Tengah", country: state, continent: continent,  geoname_id: 9827966, population: 0)
province = region.provinces.create(description: "Kabupaten Mamuju Utara", country: state, continent: continent,  geoname_id: 9828890, population: 134369)
province = region.provinces.create(description: "Kabupaten Polewali Mandar", country: state, continent: continent,  geoname_id: 1630933, population: 396120)
municipalities = [
province.municipalities.new(description: "Kecamatan Polewali", region: region, country: state, continent: continent, geoname_id: 7589545, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Provinsi Sulawesi Tenggara", country: state, continent: continent, geoname_id: 1626230)
province = region.provinces.create(description: "Kabupaten Bombana", country: state, continent: continent,  geoname_id: 9170724, population: 139235)
province = region.provinces.create(description: "Kabupaten Buton", country: state, continent: continent,  geoname_id: 1647498, population: 255712)
municipalities = [
province.municipalities.new(description: "Todanga", region: region, country: state, continent: continent, geoname_id: 6977226, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Buton Utara", country: state, continent: continent,  geoname_id: 9821954, population: 54736)
province = region.provinces.create(description: "Kabupaten Kolaka", country: state, continent: continent,  geoname_id: 1639753, population: 315232)
province = region.provinces.create(description: "Kabupaten Kolaka Timur", country: state, continent: continent,  geoname_id: 9846666, population: 0)
province = region.provinces.create(description: "Kabupaten Kolaka Utara", country: state, continent: continent,  geoname_id: 9165705, population: 121340)
province = region.provinces.create(description: "Kabupaten Konawe", country: state, continent: continent,  geoname_id: 9165997, population: 241982)
province = region.provinces.create(description: "Kabupaten Konawe Kepulauan", country: state, continent: continent,  geoname_id: 9827965, population: 0)
province = region.provinces.create(description: "Kabupaten Konawe Selatan", country: state, continent: continent,  geoname_id: 9165998, population: 264587)
province = region.provinces.create(description: "Kabupaten Konawe Utara", country: state, continent: continent,  geoname_id: 9828035, population: 51533)
province = region.provinces.create(description: "Kabupaten Muna", country: state, continent: continent,  geoname_id: 1634727, population: 268277)
province = region.provinces.create(description: "Kabupaten Wakatobi", country: state, continent: continent,  geoname_id: 9165996, population: 92995)
province = region.provinces.create(description: "Kota Administratip Baubau", country: state, continent: continent,  geoname_id: 6974096, population: 136991)
province = region.provinces.create(description: "Kotamadya Kendari", country: state, continent: continent,  geoname_id: 1640342, population: 289966)
municipalities = [
province.municipalities.new(description: "Unaaha", region: region, country: state, continent: continent, geoname_id: 1974329, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Riau", country: state, continent: continent, geoname_id: 1629652)
province = region.provinces.create(description: "Kabupaten Bengkalis", country: state, continent: continent,  geoname_id: 8597074, population: 525656)
province = region.provinces.create(description: "Kabupaten Indragiri Hilir", country: state, continent: continent,  geoname_id: 1643082, population: 681898)
province = region.provinces.create(description: "Kabupaten Indragiri Hulu", country: state, continent: continent,  geoname_id: 1643081, population: 382661)
province = region.provinces.create(description: "Kabupaten Kampar", country: state, continent: continent,  geoname_id: 6724202, population: 715641)
province = region.provinces.create(description: "Kabupaten Kepulauan Meranti", country: state, continent: continent,  geoname_id: 9828033, population: 176290)
province = region.provinces.create(description: "Kabupaten Kuantan Singingi", country: state, continent: continent,  geoname_id: 9163118, population: 301851)
province = region.provinces.create(description: "Kabupaten Pelalawan", country: state, continent: continent,  geoname_id: 9163207, population: 313378)
province = region.provinces.create(description: "Kabupaten Rokan Hilir", country: state, continent: continent,  geoname_id: 9844900, population: 558829)
province = region.provinces.create(description: "Kabupaten Rokan Hulu", country: state, continent: continent,  geoname_id: 6722476, population: 493129)
province = region.provinces.create(description: "Kabupaten Siak", country: state, continent: continent,  geoname_id: 9844901, population: 400148)
province = region.provinces.create(description: "Kota Dumai", country: state, continent: continent,  geoname_id: 9821955, population: 257330)
province = region.provinces.create(description: "Kota Pekanbaru", country: state, continent: continent,  geoname_id: 1631760, population: 907666)
region = Region.create(description: "Sulawesi Selatan", country: state, continent: continent, geoname_id: 1626232)
province = region.provinces.create(description: "Kabupaten Bantaeng", country: state, continent: continent,  geoname_id: 1650183, population: 176699)
province = region.provinces.create(description: "Kabupaten Barru", country: state, continent: continent,  geoname_id: 1649975, population: 165983)
province = region.provinces.create(description: "Kabupaten Bone", country: state, continent: continent,  geoname_id: 1648256, population: 717682)
province = region.provinces.create(description: "Kabupaten Bulukumba", country: state, continent: continent,  geoname_id: 1647738, population: 394560)
province = region.provinces.create(description: "Kabupaten Enrekang", country: state, continent: continent,  geoname_id: 1644905, population: 190248)
province = region.provinces.create(description: "Kabupaten Gowa", country: state, continent: continent,  geoname_id: 1643807, population: 652941)
province = region.provinces.create(description: "Kabupaten Jeneponto", country: state, continent: continent,  geoname_id: 1642569, population: 342700)
province = region.provinces.create(description: "Kabupaten Luwu", country: state, continent: continent,  geoname_id: 6965895, population: 332482)
province = region.provinces.create(description: "Kabupaten Luwu Timur", country: state, continent: continent,  geoname_id: 9165704, population: 243069)
municipalities = [
province.municipalities.new(description: "Nuha", region: region, country: state, continent: continent, geoname_id: 1633845, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Luwu Utara", country: state, continent: continent,  geoname_id: 9165788, population: 287472)
province = region.provinces.create(description: "Kabupaten Maros", country: state, continent: continent,  geoname_id: 1636028, population: 319002)
province = region.provinces.create(description: "Kabupaten Pangkajene dan Kepulauan", country: state, continent: continent,  geoname_id: 1632723, population: 305737)
province = region.provinces.create(description: "Kabupaten Pinrang", country: state, continent: continent,  geoname_id: 1631102, population: 351118)
province = region.provinces.create(description: "Kabupaten Selayar", country: state, continent: continent,  geoname_id: 1628015, population: 122055)
province = region.provinces.create(description: "Kabupaten Sidenreng Rappang", country: state, continent: continent,  geoname_id: 1627258, population: 271911)
province = region.provinces.create(description: "Kabupaten Sinjai", country: state, continent: continent,  geoname_id: 1626894, population: 228879)
province = region.provinces.create(description: "Kabupaten Soppeng", country: state, continent: continent,  geoname_id: 7063566, population: 223826)
province = region.provinces.create(description: "Kabupaten Takalar", country: state, continent: continent,  geoname_id: 1625545, population: 269603)
province = region.provinces.create(description: "Kabupaten Tana Toradja", country: state, continent: continent,  geoname_id: 1625123, population: 221081)
province = region.provinces.create(description: "Kabupaten Toraja Utara", country: state, continent: continent,  geoname_id: 9846656, population: 216762)
province = region.provinces.create(description: "Kabupaten Wajo", country: state, continent: continent,  geoname_id: 1622267, population: 385109)
province = region.provinces.create(description: "Kota Makassar", country: state, continent: continent,  geoname_id: 1622785, population: 1338663)
province = region.provinces.create(description: "Kota Palopo", country: state, continent: continent,  geoname_id: 9843582, population: 147932)
province = region.provinces.create(description: "Kotamadya Parepare", country: state, continent: continent,  geoname_id: 1632352, population: 129262)
region = Region.create(description: "Sulawesi Tengah", country: state, continent: continent, geoname_id: 1626231)
province = region.provinces.create(description: "Kabupaten Banggai", country: state, continent: continent,  geoname_id: 6983688, population: 323626)
province = region.provinces.create(description: "Kabupaten Banggai Kepulauan", country: state, continent: continent,  geoname_id: 9165691, population: 171627)
province = region.provinces.create(description: "Kabupaten Banggai Laut", country: state, continent: continent,  geoname_id: 9846665, population: 0)
province = region.provinces.create(description: "Kabupaten Buol Tolitoli", country: state, continent: continent,  geoname_id: 1647571, population: 132330)
province = region.provinces.create(description: "Kabupaten Donggala", country: state, continent: continent,  geoname_id: 1645322, population: 277620)
province = region.provinces.create(description: "Kabupaten Morowali", country: state, continent: continent,  geoname_id: 9165694, population: 206322)
province = region.provinces.create(description: "Kabupaten Morowali Utara", country: state, continent: continent,  geoname_id: 9827971, population: 0)
province = region.provinces.create(description: "Kabupaten Parigi Moutong", country: state, continent: continent,  geoname_id: 9165690, population: 413588)
province = region.provinces.create(description: "Kabupaten Poso", country: state, continent: continent,  geoname_id: 1630720, population: 209228)
province = region.provinces.create(description: "Kabupaten Sigi", country: state, continent: continent,  geoname_id: 9781856, population: 215030)
province = region.provinces.create(description: "Kabupaten Tojo Una-Una", country: state, continent: continent,  geoname_id: 9165688, population: 137810)
province = region.provinces.create(description: "Kabupaten Toli-Toli", country: state, continent: continent,  geoname_id: 9846654, population: 211296)
province = region.provinces.create(description: "Kota Palu", country: state, continent: continent,  geoname_id: 1633033, population: 336532)
region = Region.create(description: "Sulawesi Utara", country: state, continent: continent, geoname_id: 1626229)
province = region.provinces.create(description: "Kabupaten Bolaang Mongondow Selatan", country: state, continent: continent,  geoname_id: 9821949, population: 57001)
province = region.provinces.create(description: "Kabupaten Bolaang Mongondow Timur", country: state, continent: continent,  geoname_id: 9821950, population: 63654)
province = region.provinces.create(description: "Kabupaten Bolaang Mongondow Utara", country: state, continent: continent,  geoname_id: 9821951, population: 70693)
province = region.provinces.create(description: "Kabupaten Bolaangmongondow", country: state, continent: continent,  geoname_id: 1648339, population: 213484)
province = region.provinces.create(description: "Kabupaten Kepulauan Talaud", country: state, continent: continent,  geoname_id: 9828034, population: 83434)
province = region.provinces.create(description: "Kabupaten Minahasa", country: state, continent: continent,  geoname_id: 6755517, population: 310384)
province = region.provinces.create(description: "Kabupaten Minahasa Selatan", country: state, continent: continent,  geoname_id: 6698251, population: 195553)
province = region.provinces.create(description: "Kabupaten Minahasa Tenggara", country: state, continent: continent,  geoname_id: 9828962, population: 100443)
province = region.provinces.create(description: "Kabupaten Minahasa Utara", country: state, continent: continent,  geoname_id: 9165868, population: 188904)
province = region.provinces.create(description: "Kabupaten Siau Tagulandang Biaro", country: state, continent: continent,  geoname_id: 9846670, population: 63801)
province = region.provinces.create(description: "Kepulauan Sangihe dan Talaud", country: state, continent: continent,  geoname_id: 1628775, population: 126100)
province = region.provinces.create(description: "Kota Kotamobagu", country: state, continent: continent,  geoname_id: 9828036, population: 107459)
province = region.provinces.create(description: "Kota Tomohon", country: state, continent: continent,  geoname_id: 9846655, population: 91553)
province = region.provinces.create(description: "Kotamadya Bitung", country: state, continent: continent,  geoname_id: 1648633, population: 187652)
province = region.provinces.create(description: "Kotamadya Manado", country: state, continent: continent,  geoname_id: 1636543, population: 410481)
region = Region.create(description: "Sumatera Barat", country: state, continent: continent, geoname_id: 1626197)
province = region.provinces.create(description: "Kabupaten Agam", country: state, continent: continent,  geoname_id: 1651856, population: 460568)
province = region.provinces.create(description: "Kabupaten Dharmasraya", country: state, continent: continent,  geoname_id: 9166041, population: 203224)
province = region.provinces.create(description: "Kabupaten Kepulauan Mentawai", country: state, continent: continent,  geoname_id: 8740094, population: 78925)
province = region.provinces.create(description: "Kabupaten Limapuluhkota", country: state, continent: continent,  geoname_id: 8562628, population: 354547)
province = region.provinces.create(description: "Kabupaten Padang Pariaman", country: state, continent: continent,  geoname_id: 1633373, population: 432052)
province = region.provinces.create(description: "Kabupaten Pasaman", country: state, continent: continent,  geoname_id: 9163115, population: 277901)
province = region.provinces.create(description: "Kabupaten Pasaman Barat", country: state, continent: continent,  geoname_id: 9163116, population: 365129)
province = region.provinces.create(description: "Kabupaten Pesisir Selatan", country: state, continent: continent,  geoname_id: 1631300, population: 449064)
province = region.provinces.create(description: "Kabupaten Sawahlunto Sijunjung", country: state, continent: continent,  geoname_id: 8541932, population: 201823)
province = region.provinces.create(description: "Kabupaten Solok", country: state, continent: continent,  geoname_id: 1626646, population: 348566)
province = region.provinces.create(description: "Kabupaten Solok Selatan", country: state, continent: continent,  geoname_id: 9165770, population: 144281)
province = region.provinces.create(description: "Kabupaten Tanahdatar", country: state, continent: continent,  geoname_id: 8594799, population: 344923)
province = region.provinces.create(description: "Kota Padang Panjang", country: state, continent: continent,  geoname_id: 1633374, population: 47008)
province = region.provinces.create(description: "Kota Pariaman", country: state, continent: continent,  geoname_id: 9843591, population: 81512)
province = region.provinces.create(description: "Kotamadya Bukittinggi", country: state, continent: continent,  geoname_id: 1647865, population: 111312)
province = region.provinces.create(description: "Kotamadya Padang", country: state, continent: continent,  geoname_id: 1633407, population: 872063)
province = region.provinces.create(description: "Kotamadya Payakumbuh", country: state, continent: continent,  geoname_id: 1631904, population: 122540)
province = region.provinces.create(description: "Kotamadya Sawahlunto", country: state, continent: continent,  geoname_id: 1628471, population: 59278)
province = region.provinces.create(description: "Kotamadya Solok", country: state, continent: continent,  geoname_id: 1626645, population: 59396)
region = Region.create(description: "Sumatera Utara", country: state, continent: continent, geoname_id: 1213642)
province = region.provinces.create(description: "Kabupaten Asahan", country: state, continent: continent,  geoname_id: 1215554, population: 710498)
municipalities = [
province.municipalities.new(description: "Asahan", region: region, country: state, continent: continent, geoname_id: 6703622, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Batu Bara", country: state, continent: continent,  geoname_id: 9821911, population: 401477)
province = region.provinces.create(description: "Kabupaten Dairi", country: state, continent: continent,  geoname_id: 1215221, population: 283335)
municipalities = [
province.municipalities.new(description: "Pargambiran", region: region, country: state, continent: continent, geoname_id: 8639367, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Deli Serdang", country: state, continent: continent,  geoname_id: 1215200, population: 1886915)
province = region.provinces.create(description: "Kabupaten Humbang Hasundutan", country: state, continent: continent,  geoname_id: 9162086, population: 175548)
province = region.provinces.create(description: "Kabupaten Karo", country: state, continent: continent,  geoname_id: 1214929, population: 381603)
province = region.provinces.create(description: "Kabupaten Labuanbatu", country: state, continent: continent,  geoname_id: 8611929, population: 286173)
province = region.provinces.create(description: "Kabupaten Labuhan Batu", country: state, continent: continent,  geoname_id: 1214801, population: 445254)
municipalities = [
province.municipalities.new(description: "Kampungtempel", region: region, country: state, continent: continent, geoname_id: 6715400, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Labuhan Batu Utara", country: state, continent: continent,  geoname_id: 9821913, population: 354079)
province = region.provinces.create(description: "Kabupaten Langkat", country: state, continent: continent,  geoname_id: 1214728, population: 1027258)
municipalities = [
province.municipalities.new(description: "Stabat", region: region, country: state, continent: continent, geoname_id: 1213655, population: 26862),
province.municipalities.new(description: "Stabat", region: region, country: state, continent: continent, geoname_id: 1213654, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Mandailing Natal", country: state, continent: continent,  geoname_id: 9161518, population: 426194)
province = region.provinces.create(description: "Kabupaten Nias", country: state, continent: continent,  geoname_id: 1214405, population: 138360)
province = region.provinces.create(description: "Kabupaten Nias Barat", country: state, continent: continent,  geoname_id: 9828978, population: 89308)
province = region.provinces.create(description: "Kabupaten Nias Selatan", country: state, continent: continent,  geoname_id: 8224057, population: 305573)
province = region.provinces.create(description: "Kabupaten Nias Utara", country: state, continent: continent,  geoname_id: 9843567, population: 130335)
province = region.provinces.create(description: "Kabupaten Padang Lawas", country: state, continent: continent,  geoname_id: 9821912, population: 232215)
province = region.provinces.create(description: "Kabupaten Padang Lawas Utara", country: state, continent: continent,  geoname_id: 9821910, population: 241966)
province = region.provinces.create(description: "Kabupaten Pakpak Bharat", country: state, continent: continent,  geoname_id: 6725176, population: 40505)
province = region.provinces.create(description: "Kabupaten Samosir", country: state, continent: continent,  geoname_id: 9162842, population: 123869)
province = region.provinces.create(description: "Kabupaten Serdang Bedagai", country: state, continent: continent,  geoname_id: 6715130, population: 618294)
province = region.provinces.create(description: "Kabupaten Simalungun", country: state, continent: continent,  geoname_id: 1213765, population: 840629)
province = region.provinces.create(description: "Kabupaten Tapanuli Selatan", country: state, continent: continent,  geoname_id: 1213519, population: 272489)
province = region.provinces.create(description: "Kabupaten Tapanuli Tengah", country: state, continent: continent,  geoname_id: 1213518, population: 318550)
province = region.provinces.create(description: "Kabupaten Tapanuli Utara", country: state, continent: continent,  geoname_id: 6726149, population: 292797)
municipalities = [
province.municipalities.new(description: "Huta Raja Habinsaran", region: region, country: state, continent: continent, geoname_id: 8636559, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kabupaten Toba Samosir", country: state, continent: continent,  geoname_id: 9165769, population: 181371)
municipalities = [
province.municipalities.new(description: "Parapat", region: region, country: state, continent: continent, geoname_id: 1214135, population: 0),
province.municipalities.new(description: "Sibisa", region: region, country: state, continent: continent, geoname_id: 7743046, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kota Binjai", country: state, continent: continent,  geoname_id: 1648725, population: 261487)
province = region.provinces.create(description: "Kota Gunungsitoli", country: state, continent: continent,  geoname_id: 9846663, population: 134511)
province = region.provinces.create(description: "Kota Medan", country: state, continent: continent,  geoname_id: 1214519, population: 2246142)
province = region.provinces.create(description: "Kota Padangsidimpuan", country: state, continent: continent,  geoname_id: 9843575, population: 199656)
province = region.provinces.create(description: "Kota Sibolga", country: state, continent: continent,  geoname_id: 1213854, population: 84481)
province = region.provinces.create(description: "Kota Tanjung Balai", country: state, continent: continent,  geoname_id: 1213546, population: 161389)
province = region.provinces.create(description: "Kota Tebingtinggi", country: state, continent: continent,  geoname_id: 1213498, population: 151203)
province = region.provinces.create(description: "Kotamadya Pematangsiantar", country: state, continent: continent,  geoname_id: 1214203, population: 234698)
region = Region.create(description: "Sumatra Selatan", country: state, continent: continent, geoname_id: 1626196)
province = region.provinces.create(description: "Kabupaten Banyu Asin", country: state, continent: continent,  geoname_id: 9165775, population: 773587)
province = region.provinces.create(description: "Kabupaten Empat Lawang", country: state, continent: continent,  geoname_id: 9821958, population: 227604)
province = region.provinces.create(description: "Kabupaten Lahat", country: state, continent: continent,  geoname_id: 9166049, population: 382898)
province = region.provinces.create(description: "Kabupaten Muara Enim", country: state, continent: continent,  geoname_id: 8521769, population: 754687)
province = region.provinces.create(description: "Kabupaten Musi Banyuasin", country: state, continent: continent,  geoname_id: 1634644, population: 588996)
province = region.provinces.create(description: "Kabupaten Musi Rawas", country: state, continent: continent,  geoname_id: 1634643, population: 546945)
province = region.provinces.create(description: "Kabupaten Musi Rawas Utara", country: state, continent: continent,  geoname_id: 9827972, population: 0)
province = region.provinces.create(description: "Kabupaten Ogan Ilir", country: state, continent: continent,  geoname_id: 9163311, population: 396384)
province = region.provinces.create(description: "Kabupaten Ogan Komering Ilir", country: state, continent: continent,  geoname_id: 1633659, population: 756436)
province = region.provinces.create(description: "Kabupaten Ogan Komering Ulu", country: state, continent: continent,  geoname_id: 9166051, population: 628205)
province = region.provinces.create(description: "Kabupaten Ogan Komering Ulu", country: state, continent: continent,  geoname_id: 1633658, population: 337692)
province = region.provinces.create(description: "Kabupaten Ogan Komering Ulu Selatan", country: state, continent: continent,  geoname_id: 9165989, population: 329795)
province = region.provinces.create(description: "Kabupaten Penukal Abab Lematang Ilir", country: state, continent: continent,  geoname_id: 9828027, population: 0)
province = region.provinces.create(description: "Kota Lubuklinggau", country: state, continent: continent,  geoname_id: 9828042, population: 215120)
province = region.provinces.create(description: "Kota Pagar Alam", country: state, continent: continent,  geoname_id: 7932494, population: 131075)
province = region.provinces.create(description: "Kota Palembang", country: state, continent: continent,  geoname_id: 1633069, population: 1511444)
province = region.provinces.create(description: "Kota Prabumulih", country: state, continent: continent,  geoname_id: 7932496, population: 161984)
region = Region.create(description: "Yogyakarta", country: state, continent: continent, geoname_id: 1621176)
province = region.provinces.create(description: "Kabupaten Bantul", country: state, continent: continent,  geoname_id: 1650117, population: 936515)
province = region.provinces.create(description: "Kabupaten Gunung Kidul", country: state, continent: continent,  geoname_id: 1643604, population: 697215)
province = region.provinces.create(description: "Kabupaten Kulon Progo", country: state, continent: continent,  geoname_id: 7910930, population: 408811)
province = region.provinces.create(description: "Kabupaten Sleman", country: state, continent: continent,  geoname_id: 6258231, population: 1203939)
province = region.provinces.create(description: "Kota Yogyakarta", country: state, continent: continent,  geoname_id: 1621175, population: 418968)
