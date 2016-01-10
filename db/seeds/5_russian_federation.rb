continent = Continent.find_by(description: 'Europe')
state = Country.find_by(description: 'Russian Federation')
region = Region.create(description: "Altai Krai", country: state, continent: continent, geoname_id: 1511732)
province = region.provinces.create(description: "Aleyskiy Rayon", country: state, continent: continent,  geoname_id: 1511780, population: 0)
province = region.provinces.create(description: "Altayskiy Rayon", country: state, continent: continent,  geoname_id: 1511731, population: 0)
province = region.provinces.create(description: "Bayevskiy Rayon", country: state, continent: continent,  geoname_id: 1510708, population: 0)
province = region.provinces.create(description: "Biyskiy Rayon", country: state, continent: continent,  geoname_id: 1510016, population: 0)
province = region.provinces.create(description: "Blagoveshchenskiy Rayon", country: state, continent: continent,  geoname_id: 1509987, population: 0)
province = region.provinces.create(description: "Burlinskiy Rayon", country: state, continent: continent,  geoname_id: 1508628, population: 0)
province = region.provinces.create(description: "Bystroistokskiy Rayon", country: state, continent: continent,  geoname_id: 1508527, population: 0)
province = region.provinces.create(description: "Charyshskiy Rayon", country: state, continent: continent,  geoname_id: 1508428, population: 0)
province = region.provinces.create(description: "Gorod Barnaulskiy", country: state, continent: continent,  geoname_id: 1535931, population: 0)
province = region.provinces.create(description: "Kalmanskiy Rayon", country: state, continent: continent,  geoname_id: 1504979, population: 0)
province = region.provinces.create(description: "Kamenskiy Rayon", country: state, continent: continent,  geoname_id: 1504833, population: 0)
province = region.provinces.create(description: "Khabarskiy Rayon", country: state, continent: continent,  geoname_id: 1503857, population: 0)
province = region.provinces.create(description: "Klyuchevskiy Rayon", country: state, continent: continent,  geoname_id: 1503166, population: 0)
province = region.provinces.create(description: "Kosikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1502386, population: 0)
province = region.provinces.create(description: "Krasnogorskiy Rayon", country: state, continent: continent,  geoname_id: 1502107, population: 0)
province = region.provinces.create(description: "Krasnoshchekovskiy Rayon", country: state, continent: continent,  geoname_id: 1502065, population: 0)
province = region.provinces.create(description: "Krutikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1501693, population: 0)
province = region.provinces.create(description: "Kulundinskiy Rayon", country: state, continent: continent,  geoname_id: 1501455, population: 0)
province = region.provinces.create(description: "Kur'inskiy Rayon", country: state, continent: continent,  geoname_id: 1501302, population: 0)
province = region.provinces.create(description: "Kytmanovskiy Rayon", country: state, continent: continent,  geoname_id: 1500989, population: 0)
province = region.provinces.create(description: "Loktevskiy Rayon", country: state, continent: continent,  geoname_id: 1500386, population: 0)
province = region.provinces.create(description: "Mamontovskiy Rayon", country: state, continent: continent,  geoname_id: 1499425, population: 0)
province = region.provinces.create(description: "Mikhaylovskiy Rayon", country: state, continent: continent,  geoname_id: 1498753, population: 0)
province = region.provinces.create(description: "Natsional'nyy Rayon Nemetskiy", country: state, continent: continent,  geoname_id: 1535928, population: 0)
province = region.provinces.create(description: "Novichikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1497219, population: 0)
province = region.provinces.create(description: "Pankrushikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1495612, population: 0)
province = region.provinces.create(description: "Pavlovskiy Rayon", country: state, continent: continent,  geoname_id: 1495439, population: 0)
province = region.provinces.create(description: "Pervomayskiy Rayon", country: state, continent: continent,  geoname_id: 1495265, population: 0)
province = region.provinces.create(description: "Petropavlovskiy Rayon", country: state, continent: continent,  geoname_id: 1495102, population: 0)
province = region.provinces.create(description: "Pospelikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1494329, population: 0)
province = region.provinces.create(description: "Rebrikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1493721, population: 0)
province = region.provinces.create(description: "Rodinskiy Rayon", country: state, continent: continent,  geoname_id: 1493622, population: 0)
province = region.provinces.create(description: "Romanovskiy Rayon", country: state, continent: continent,  geoname_id: 1493563, population: 0)
province = region.provinces.create(description: "Rubtsovskiy Rayon", country: state, continent: continent,  geoname_id: 1493465, population: 0)
province = region.provinces.create(description: "Shelabolikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1535930, population: 0)
province = region.provinces.create(description: "Shipunovskiy Rayon", country: state, continent: continent,  geoname_id: 1492151, population: 0)
province = region.provinces.create(description: "Slavgorodskiy Rayon", country: state, continent: continent,  geoname_id: 1491705, population: 0)
province = region.provinces.create(description: "Smolenskiy Rayon", country: state, continent: continent,  geoname_id: 1491634, population: 0)
province = region.provinces.create(description: "Soloneshenskiy Rayon", country: state, continent: continent,  geoname_id: 1491462, population: 0)
province = region.provinces.create(description: "Soltonskiy Rayon", country: state, continent: continent,  geoname_id: 1491425, population: 0)
province = region.provinces.create(description: "Sovetskiy Rayon", country: state, continent: continent,  geoname_id: 1491227, population: 0)
province = region.provinces.create(description: "Suyetskiy Rayon", country: state, continent: continent,  geoname_id: 1535929, population: 0)
province = region.provinces.create(description: "Tabunskiy Rayon", country: state, continent: continent,  geoname_id: 1490357, population: 0)
province = region.provinces.create(description: "Tal'menskiy Rayon", country: state, continent: continent,  geoname_id: 1490259, population: 0)
province = region.provinces.create(description: "Togul'skiy Rayon", country: state, continent: continent,  geoname_id: 1489502, population: 0)
province = region.provinces.create(description: "Topchikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1489397, population: 0)
province = region.provinces.create(description: "Tret'yakovskiy Rayon", country: state, continent: continent,  geoname_id: 1489264, population: 0)
province = region.provinces.create(description: "Troitskiy Rayon", country: state, continent: continent,  geoname_id: 1489214, population: 0)
province = region.provinces.create(description: "Tselinnyy Rayon", country: state, continent: continent,  geoname_id: 1489128, population: 0)
province = region.provinces.create(description: "Tyumentsevskiy Rayon", country: state, continent: continent,  geoname_id: 1488739, population: 0)
province = region.provinces.create(description: "Uglovskiy Rayon", country: state, continent: continent,  geoname_id: 1488635, population: 0)
province = region.provinces.create(description: "Ust'-Kalmanskiy Rayon", country: state, continent: continent,  geoname_id: 1488199, population: 0)
province = region.provinces.create(description: "Ust'-Pristanskiy Rayon", country: state, continent: continent,  geoname_id: 1488114, population: 0)
province = region.provinces.create(description: "Volchikhinskiy Rayon", country: state, continent: continent,  geoname_id: 1486980, population: 0)
province = region.provinces.create(description: "Yegor'yevskiy Rayon", country: state, continent: continent,  geoname_id: 1486214, population: 0)
province = region.provinces.create(description: "Yel'tsovskiy Rayon", country: state, continent: continent,  geoname_id: 1486053, population: 0)
province = region.provinces.create(description: "Zalesovskiy Rayon", country: state, continent: continent,  geoname_id: 1485525, population: 0)
province = region.provinces.create(description: "Zarinskiy Rayon", country: state, continent: continent,  geoname_id: 1485438, population: 0)
province = region.provinces.create(description: "Zav'yalovskiy Rayon", country: state, continent: continent,  geoname_id: 1485333, population: 0)
province = region.provinces.create(description: "Zmeinogorskiy Rayon", country: state, continent: continent,  geoname_id: 1485041, population: 0)
province = region.provinces.create(description: "Zonal'nyy Rayon", country: state, continent: continent,  geoname_id: 1484980, population: 0)
region = Region.create(description: "Amurskaya Oblast'", country: state, continent: continent, geoname_id: 2027748)
province = region.provinces.create(description: "Arkharinskiy Rayon", country: state, continent: continent,  geoname_id: 2027485, population: 0)
province = region.provinces.create(description: "Belogorskiy Rayon", country: state, continent: continent,  geoname_id: 2026893, population: 23267)
province = region.provinces.create(description: "Blagoveshchenskiy Rayon", country: state, continent: continent,  geoname_id: 2026607, population: 0)
province = region.provinces.create(description: "Bureyskiy Rayon", country: state, continent: continent,  geoname_id: 2025915, population: 28221)
province = region.provinces.create(description: "Gorod Blagoveshchensk", country: state, continent: continent,  geoname_id: 2050916, population: 0)
province = region.provinces.create(description: "Gorod Raychikhinsk", country: state, continent: continent,  geoname_id: 2050917, population: 0)
province = region.provinces.create(description: "Ivanovskiy Rayon", country: state, continent: continent,  geoname_id: 2023386, population: 29750)
province = region.provinces.create(description: "Konstantinovskiy Rayon", country: state, continent: continent,  geoname_id: 2021792, population: 0)
province = region.provinces.create(description: "Magdagachinskiy Rayon", country: state, continent: continent,  geoname_id: 2020589, population: 0)
province = region.provinces.create(description: "Mazanovskiy Rayon", country: state, continent: continent,  geoname_id: 2020117, population: 0)
province = region.provinces.create(description: "Mikhaylovskiy Rayon", country: state, continent: continent,  geoname_id: 2019985, population: 0)
province = region.provinces.create(description: "Oktyabr'skiy Rayon", country: state, continent: continent,  geoname_id: 2018608, population: 22614)
province = region.provinces.create(description: "Romnenskiy Rayon", country: state, continent: continent,  geoname_id: 2017411, population: 11098)
province = region.provinces.create(description: "Selemdzhinskiy Rayon", country: state, continent: continent,  geoname_id: 2017066, population: 0)
province = region.provinces.create(description: "Seryshevskiy Rayon", country: state, continent: continent,  geoname_id: 2016941, population: 28421)
province = region.provinces.create(description: "Shimanovskiy Rayon", country: state, continent: continent,  geoname_id: 2016700, population: 0)
province = region.provinces.create(description: "Skovorodinskiy Rayon", country: state, continent: continent,  geoname_id: 2016442, population: 0)
province = region.provinces.create(description: "Svobodnenskiy Rayon", country: state, continent: continent,  geoname_id: 2015840, population: 0)
province = region.provinces.create(description: "Tambovskiy Rayon", country: state, continent: continent,  geoname_id: 2015607, population: 24987)
province = region.provinces.create(description: "Tyndinskiy Rayon", country: state, continent: continent,  geoname_id: 2014714, population: 0)
province = region.provinces.create(description: "Zavitinskiy Rayon", country: state, continent: continent,  geoname_id: 2012624, population: 19086)
province = region.provinces.create(description: "Zeyskiy Rayon", country: state, continent: continent,  geoname_id: 2012589, population: 0)
region = Region.create(description: "Arkhangelskaya", country: state, continent: continent, geoname_id: 581043)
province = region.provinces.create(description: "Kotlasskiy Rayon", country: state, continent: continent,  geoname_id: 543702, population: 0)
province = region.provinces.create(description: "Krasnoborskiy Rayon", country: state, continent: continent,  geoname_id: 542421, population: 0)
province = region.provinces.create(description: "Velsky District", country: state, continent: continent,  geoname_id: 475937, population: 0)
province = region.provinces.create(description: "Vilegodskiy Rayon", country: state, continent: continent,  geoname_id: 473668, population: 0)
region = Region.create(description: "Astrakhanskaya Oblast'", country: state, continent: continent, geoname_id: 580491)
province = region.provinces.create(description: "Akhtubinskiy Rayon", country: state, continent: continent,  geoname_id: 583796, population: 0)
province = region.provinces.create(description: "Chernoyarskiy Rayon", country: state, continent: continent,  geoname_id: 568698, population: 0)
province = region.provinces.create(description: "Gorod Astrakhan'", country: state, continent: continent,  geoname_id: 824964, population: 0)
municipalities = [
province.municipalities.new(description: "Astrakhan", region: region, country: state, continent: continent, geoname_id: 580497, population: 502533),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ikryaninskiy Rayon", country: state, continent: continent,  geoname_id: 557391, population: 0)
province = region.provinces.create(description: "Kamyzyakskiy Rayon", country: state, continent: continent,  geoname_id: 553246, population: 0)
province = region.provinces.create(description: "Kharabalinskiy Rayon", country: state, continent: continent,  geoname_id: 550669, population: 0)
province = region.provinces.create(description: "Krasnoyarskiy Rayon", country: state, continent: continent,  geoname_id: 542131, population: 0)
province = region.provinces.create(description: "Limanskiy Rayon", country: state, continent: continent,  geoname_id: 535210, population: 0)
province = region.provinces.create(description: "Narimanovskiy Rayon", country: state, continent: continent,  geoname_id: 523439, population: 0)
province = region.provinces.create(description: "Privolzhskiy Rayon", country: state, continent: continent,  geoname_id: 505051, population: 0)
province = region.provinces.create(description: "Volodarskiy Rayon", country: state, continent: continent,  geoname_id: 472484, population: 0)
province = region.provinces.create(description: "Yenotayevskiy Rayon", country: state, continent: continent,  geoname_id: 467477, population: 0)
region = Region.create(description: "Bashkortostan", country: state, continent: continent, geoname_id: 578853)
province = region.provinces.create(description: "Belokatayskiy Rayon", country: state, continent: continent,  geoname_id: 577943, population: 0)
municipalities = [
province.municipalities.new(description: "Kusimovo", region: region, country: state, continent: continent, geoname_id: 538332, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Khaybullinskiy Rayon", country: state, continent: continent,  geoname_id: 550406, population: 0)
region = Region.create(description: "Belgorodskaya Oblast'", country: state, continent: continent, geoname_id: 578071)
province = region.provinces.create(description: "Alekseyevskiy Rayon", country: state, continent: continent,  geoname_id: 582787, population: 0)
province = region.provinces.create(description: "Belgorodskiy Rayon", country: state, continent: continent,  geoname_id: 578070, population: 77700)
municipalities = [
province.municipalities.new(description: "Belgorod", region: region, country: state, continent: continent, geoname_id: 578072, population: 345289),
]
Municipality.import municipalities
province = region.provinces.create(description: "Borisovskiy Rayon", country: state, continent: continent,  geoname_id: 572391, population: 26000)
province = region.provinces.create(description: "Chernyanskiy Rayon", country: state, continent: continent,  geoname_id: 568584, population: 32918)
province = region.provinces.create(description: "Gorod Alekseyevka", country: state, continent: continent,  geoname_id: 824989, population: 0)
province = region.provinces.create(description: "Grayvoronskiy Rayon", country: state, continent: continent,  geoname_id: 824990, population: 0)
province = region.provinces.create(description: "Gubkinskiy Rayon", country: state, continent: continent,  geoname_id: 558141, population: 0)
province = region.provinces.create(description: "Ivnyanskiy Rayon", country: state, continent: continent,  geoname_id: 554969, population: 23968)
province = region.provinces.create(description: "Korochanskiy Rayon", country: state, continent: continent,  geoname_id: 544704, population: 39086)
province = region.provinces.create(description: "Krasnenskiy Rayon", country: state, continent: continent,  geoname_id: 824991, population: 0)
province = region.provinces.create(description: "Krasnogvardeyskiy Rayon", country: state, continent: continent,  geoname_id: 542337, population: 0)
province = region.provinces.create(description: "Krasnoyaruzhskiy Rayon", country: state, continent: continent,  geoname_id: 824992, population: 0)
province = region.provinces.create(description: "Novooskol'skiy Rayon", country: state, continent: continent,  geoname_id: 518413, population: 46231)
province = region.provinces.create(description: "Prokhorovskiy Rayon", country: state, continent: continent,  geoname_id: 504908, population: 0)
province = region.provinces.create(description: "Rakityanskiy Rayon", country: state, continent: continent,  geoname_id: 503055, population: 0)
province = region.provinces.create(description: "Roven'skiy Rayon", country: state, continent: continent,  geoname_id: 501124, population: 0)
province = region.provinces.create(description: "Shebekinskiy Rayon", country: state, continent: continent,  geoname_id: 495111, population: 47556)
province = region.provinces.create(description: "Starooskol'skiy Rayon", country: state, continent: continent,  geoname_id: 488709, population: 0)
province = region.provinces.create(description: "Valuyskiy Rayon", country: state, continent: continent,  geoname_id: 477189, population: 35400)
province = region.provinces.create(description: "Veydelevskiy Rayon", country: state, continent: continent,  geoname_id: 473855, population: 0)
province = region.provinces.create(description: "Volokonovskiy Rayon", country: state, continent: continent,  geoname_id: 472424, population: 34821)
province = region.provinces.create(description: "Yakovlevskiy Rayon", country: state, continent: continent,  geoname_id: 469534, population: 52931)
region = Region.create(description: "Bryanskaya Oblast'", country: state, continent: continent, geoname_id: 571473)
province = region.provinces.create(description: "Brasovskiy Rayon", country: state, continent: continent,  geoname_id: 571745, population: 0)
province = region.provinces.create(description: "Bryanskiy Rayon", country: state, continent: continent,  geoname_id: 571467, population: 0)
municipalities = [
province.municipalities.new(description: "Bryansk", region: region, country: state, continent: continent, geoname_id: 571476, population: 427236),
]
Municipality.import municipalities
province = region.provinces.create(description: "Dubrovskiy Rayon", country: state, continent: continent,  geoname_id: 564343, population: 0)
province = region.provinces.create(description: "Dyat'kovskiy Rayon", country: state, continent: continent,  geoname_id: 563821, population: 0)
province = region.provinces.create(description: "Gordeyevskiy Rayon", country: state, continent: continent,  geoname_id: 824993, population: 0)
province = region.provinces.create(description: "Gorod Bryansk", country: state, continent: continent,  geoname_id: 824997, population: 1351463)
province = region.provinces.create(description: "Gorod Dyat'kovo", country: state, continent: continent,  geoname_id: 824998, population: 0)
province = region.provinces.create(description: "Gorod Novozybkov", country: state, continent: continent,  geoname_id: 824996, population: 0)
province = region.provinces.create(description: "Karachevskiy Rayon", country: state, continent: continent,  geoname_id: 552912, population: 0)
province = region.provinces.create(description: "Kletnyanskiy Rayon", country: state, continent: continent,  geoname_id: 547680, population: 0)
province = region.provinces.create(description: "Klimovskiy Rayon", country: state, continent: continent,  geoname_id: 547551, population: 0)
province = region.provinces.create(description: "Klintsovskiy Rayon", country: state, continent: continent,  geoname_id: 547477, population: 0)
province = region.provinces.create(description: "Komarichskiy Rayon", country: state, continent: continent,  geoname_id: 545945, population: 0)
province = region.provinces.create(description: "Krasnogorskiy Rayon", country: state, continent: continent,  geoname_id: 542364, population: 0)
province = region.provinces.create(description: "Mglinskiy Rayon", country: state, continent: continent,  geoname_id: 527216, population: 0)
province = region.provinces.create(description: "Navlinskiy Rayon", country: state, continent: continent,  geoname_id: 523187, population: 0)
province = region.provinces.create(description: "Novozybkovskiy Rayon", country: state, continent: continent,  geoname_id: 517267, population: 0)
province = region.provinces.create(description: "Pochepskiy Rayon", country: state, continent: continent,  geoname_id: 508648, population: 0)
municipalities = [
province.municipalities.new(description: "Pochep", region: region, country: state, continent: continent, geoname_id: 508656, population: 15100),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pogarskiy Rayon", country: state, continent: continent,  geoname_id: 507867, population: 0)
province = region.provinces.create(description: "Rognedinskiy Rayon", country: state, continent: continent,  geoname_id: 501624, population: 0)
province = region.provinces.create(description: "Sevskiy Rayon", country: state, continent: continent,  geoname_id: 496244, population: 0)
municipalities = [
province.municipalities.new(description: "Dobrovod'ye", region: region, country: state, continent: continent, geoname_id: 565822, population: 150),
]
Municipality.import municipalities
province = region.provinces.create(description: "Starodubskiy Rayon", country: state, continent: continent,  geoname_id: 488848, population: 0)
province = region.provinces.create(description: "Surazhskiy Rayon", country: state, continent: continent,  geoname_id: 486147, population: 0)
province = region.provinces.create(description: "Suzemskiy Rayon", country: state, continent: continent,  geoname_id: 485815, population: 0)
province = region.provinces.create(description: "Trubchevskiy Rayon", country: state, continent: continent,  geoname_id: 481349, population: 0)
province = region.provinces.create(description: "Unechskiy Rayon", country: state, continent: continent,  geoname_id: 479010, population: 0)
province = region.provinces.create(description: "Vygonichskiy Rayon", country: state, continent: continent,  geoname_id: 470470, population: 0)
province = region.provinces.create(description: "Zhiryatinskiy Rayon", country: state, continent: continent,  geoname_id: 824994, population: 0)
province = region.provinces.create(description: "Zhukovskiy Rayon", country: state, continent: continent,  geoname_id: 462753, population: 0)
province = region.provinces.create(description: "Zlynkovskiy Rayon", country: state, continent: continent,  geoname_id: 824995, population: 0)
region = Region.create(description: "Chechnya", country: state, continent: continent, geoname_id: 569665)
province = region.provinces.create(description: "Achkhoy-Martanovskiy Rayon", country: state, continent: continent,  geoname_id: 584297, population: 68410)
province = region.provinces.create(description: "Gudermesskiy Rayon", country: state, continent: continent,  geoname_id: 558115, population: 72881)
municipalities = [
province.municipalities.new(description: "Ergbatoy", region: region, country: state, continent: continent, geoname_id: 796769, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nadterechnyy Rayon", country: state, continent: continent,  geoname_id: 523654, population: 53823)
province = region.provinces.create(description: "Naurskiy Rayon", country: state, continent: continent,  geoname_id: 523209, population: 51967)
province = region.provinces.create(description: "Nozhay-Yurtovskiy Rayon", country: state, continent: continent,  geoname_id: 516779, population: 42443)
municipalities = [
province.municipalities.new(description: "Amir-Kort", region: region, country: state, continent: continent, geoname_id: 796377, population: 0),
province.municipalities.new(description: "Asmal", region: region, country: state, continent: continent, geoname_id: 796502, population: 0),
province.municipalities.new(description: "Chachanki", region: region, country: state, continent: continent, geoname_id: 858650, population: 0),
province.municipalities.new(description: "Galayty", region: region, country: state, continent: continent, geoname_id: 562183, population: 0),
province.municipalities.new(description: "Gurzhi-Mokhk", region: region, country: state, continent: continent, geoname_id: 557945, population: 0),
province.municipalities.new(description: "Khayedy", region: region, country: state, continent: continent, geoname_id: 796479, population: 0),
province.municipalities.new(description: "Laley Mokhk", region: region, country: state, continent: continent, geoname_id: 796500, population: 0),
province.municipalities.new(description: "Manal", region: region, country: state, continent: continent, geoname_id: 796499, population: 0),
province.municipalities.new(description: "Tasha", region: region, country: state, continent: continent, geoname_id: 796475, population: 0),
province.municipalities.new(description: "Umarovo", region: region, country: state, continent: continent, geoname_id: 796508, population: 0),
province.municipalities.new(description: "Zamay Khutor", region: region, country: state, continent: continent, geoname_id: 796276, population: 0),
province.municipalities.new(description: "Амдук", region: region, country: state, continent: continent, geoname_id: 797619, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Shalinskiy Rayon", country: state, continent: continent,  geoname_id: 495940, population: 70354)
municipalities = [
province.municipalities.new(description: "Alleroy", region: region, country: state, continent: continent, geoname_id: 582462, population: 10247),
province.municipalities.new(description: "Avtury", region: region, country: state, continent: continent, geoname_id: 580218, population: 18370),
province.municipalities.new(description: "Bachi-Yurt", region: region, country: state, continent: continent, geoname_id: 579831, population: 14788),
]
Municipality.import municipalities
province = region.provinces.create(description: "Shelkovskiy Rayon", country: state, continent: continent,  geoname_id: 494999, population: 51783)
province = region.provinces.create(description: "Vedenskiy Rayon", country: state, continent: continent,  geoname_id: 476248, population: 0)
region = Region.create(description: "Chelyabinsk", country: state, continent: continent, geoname_id: 1508290)
province = region.provinces.create(description: "Agapovskiy Rayon", country: state, continent: continent,  geoname_id: 584048, population: 0)
province = region.provinces.create(description: "Argayashskiy Rayon", country: state, continent: continent,  geoname_id: 1511424, population: 0)
province = region.provinces.create(description: "Ashinskiy Rayon", country: state, continent: continent,  geoname_id: 580620, population: 0)
province = region.provinces.create(description: "Bredinskiy Rayon", country: state, continent: continent,  geoname_id: 1508812, population: 0)
province = region.provinces.create(description: "Chebarkul'skiy Rayon", country: state, continent: continent,  geoname_id: 1508346, population: 0)
province = region.provinces.create(description: "Chesmenskiy Rayon", country: state, continent: continent,  geoname_id: 1507924, population: 0)
province = region.provinces.create(description: "Gorod Chelyabinsk", country: state, continent: continent,  geoname_id: 1535932, population: 3577253)
municipalities = [
province.municipalities.new(description: "Chelyabinsk", region: region, country: state, continent: continent, geoname_id: 1508291, population: 1062919),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Karabash", country: state, continent: continent,  geoname_id: 1535935, population: 0)
province = region.provinces.create(description: "Gorod Kopeysk", country: state, continent: continent,  geoname_id: 1535936, population: 0)
province = region.provinces.create(description: "Gorod Korkino", country: state, continent: continent,  geoname_id: 1535937, population: 0)
province = region.provinces.create(description: "Gorod Kyshtym", country: state, continent: continent,  geoname_id: 1535938, population: 0)
province = region.provinces.create(description: "Gorod Magnitogorsk", country: state, continent: continent,  geoname_id: 825030, population: 0)
municipalities = [
province.municipalities.new(description: "Magnitogorsk", region: region, country: state, continent: continent, geoname_id: 532288, population: 413351),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Miass", country: state, continent: continent,  geoname_id: 1535939, population: 0)
province = region.provinces.create(description: "Gorod Plast", country: state, continent: continent,  geoname_id: 1535940, population: 0)
province = region.provinces.create(description: "Gorod Ust'-Katav", country: state, continent: continent,  geoname_id: 825031, population: 0)
province = region.provinces.create(description: "Gorod Verkhniy Ufaley", country: state, continent: continent,  geoname_id: 1535933, population: 0)
province = region.provinces.create(description: "Gorod Yemanzhelinsk", country: state, continent: continent,  geoname_id: 1535934, population: 0)
province = region.provinces.create(description: "Gorod Yuzhnoural'sk", country: state, continent: continent,  geoname_id: 1535941, population: 0)
province = region.provinces.create(description: "Gorod Zlatoust", country: state, continent: continent,  geoname_id: 825029, population: 0)
province = region.provinces.create(description: "Kartalinskiy Rayon", country: state, continent: continent,  geoname_id: 1504318, population: 0)
province = region.provinces.create(description: "Kaslinskiy Rayon", country: state, continent: continent,  geoname_id: 1504250, population: 0)
province = region.provinces.create(description: "Katav-Ivanovskiy Rayon", country: state, continent: continent,  geoname_id: 551793, population: 0)
province = region.provinces.create(description: "Kizil'skiy Rayon", country: state, continent: continent,  geoname_id: 547854, population: 0)
province = region.provinces.create(description: "Krasnoarmeyskiy Rayon", country: state, continent: continent,  geoname_id: 1502125, population: 0)
province = region.provinces.create(description: "Kunashakskiy Rayon", country: state, continent: continent,  geoname_id: 1501399, population: 0)
province = region.provinces.create(description: "Kusinskiy Rayon", country: state, continent: continent,  geoname_id: 538327, population: 0)
province = region.provinces.create(description: "Nagaybakskiy Rayon", country: state, continent: continent,  geoname_id: 523633, population: 0)
province = region.provinces.create(description: "Nyazepetrovskiy Rayon", country: state, continent: continent,  geoname_id: 516613, population: 0)
province = region.provinces.create(description: "Oktyabr'skiy Rayon", country: state, continent: continent,  geoname_id: 1496266, population: 0)
province = region.provinces.create(description: "Satkinskiy Rayon", country: state, continent: continent,  geoname_id: 498416, population: 0)
municipalities = [
province.municipalities.new(description: "Zyuratkul'", region: region, country: state, continent: continent, geoname_id: 461753, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Sosnovskiy Rayon", country: state, continent: continent,  geoname_id: 1491282, population: 0)
province = region.provinces.create(description: "Troitskiy Rayon", country: state, continent: continent,  geoname_id: 1489213, population: 0)
province = region.provinces.create(description: "Uvel'skiy Rayon", country: state, continent: continent,  geoname_id: 1487930, population: 0)
province = region.provinces.create(description: "Uyskiy Rayon", country: state, continent: continent,  geoname_id: 1487907, population: 0)
province = region.provinces.create(description: "Varnenskiy Rayon", country: state, continent: continent,  geoname_id: 1487759, population: 0)
province = region.provinces.create(description: "Verkhneural'skiy Rayon", country: state, continent: continent,  geoname_id: 475462, population: 0)
province = region.provinces.create(description: "Yetkul'skiy Rayon", country: state, continent: continent,  geoname_id: 1485846, population: 0)
region = Region.create(description: "Chukotskiy Avtonomnyy Okrug", country: state, continent: continent, geoname_id: 2126099)
province = region.provinces.create(description: "Anadyrskiy Rayon", country: state, continent: continent,  geoname_id: 2127198, population: 0)
province = region.provinces.create(description: "Beringovskiy Rayon", country: state, continent: continent,  geoname_id: 2126709, population: 0)
province = region.provinces.create(description: "Bilibinskiy Rayon", country: state, continent: continent,  geoname_id: 2126681, population: 0)
municipalities = [
province.municipalities.new(description: "Bilibino", region: region, country: state, continent: continent, geoname_id: 2126682, population: 5757),
province.municipalities.new(description: "Bol'shaya Baranikha", region: region, country: state, continent: continent, geoname_id: 2126622, population: 0),
province.municipalities.new(description: "Keperveyem", region: region, country: state, continent: continent, geoname_id: 2124860, population: 0),
province.municipalities.new(description: "Vstrechnyy", region: region, country: state, continent: continent, geoname_id: 2119683, population: 12),
]
Municipality.import municipalities
province = region.provinces.create(description: "Chaunskiy Rayon", country: state, continent: continent,  geoname_id: 2126275, population: 0)
province = region.provinces.create(description: "Chukotskiy Rayon", country: state, continent: continent,  geoname_id: 4031750, population: 0)
province = region.provinces.create(description: "Iul'tinskiy Rayon", country: state, continent: continent,  geoname_id: 4031694, population: 0)
province = region.provinces.create(description: "Providenskiy Rayon", country: state, continent: continent,  geoname_id: 4031572, population: 0)
province = region.provinces.create(description: "Shmidtovskiy Rayon", country: state, continent: continent,  geoname_id: 2121261, population: 0)
region = Region.create(description: "Chuvashia", country: state, continent: continent, geoname_id: 567395)
province = region.provinces.create(description: "Alatyrskiy Rayon", country: state, continent: continent,  geoname_id: 583435, population: 0)
province = region.provinces.create(description: "Alikovskiy Rayon", country: state, continent: continent,  geoname_id: 582532, population: 0)
province = region.provinces.create(description: "Batyrevskiy Rayon", country: state, continent: continent,  geoname_id: 578658, population: 0)
province = region.provinces.create(description: "Cheboksarskiy Rayon", country: state, continent: continent,  geoname_id: 569698, population: 0)
municipalities = [
province.municipalities.new(description: "Cheboksary", region: region, country: state, continent: continent, geoname_id: 569696, population: 446781),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ibresinskiy Rayon", country: state, continent: continent,  geoname_id: 557627, population: 0)
province = region.provinces.create(description: "Kanashskiy Rayon", country: state, continent: continent,  geoname_id: 553213, population: 0)
province = region.provinces.create(description: "Komsomol'skiy Rayon", country: state, continent: continent,  geoname_id: 545703, population: 0)
province = region.provinces.create(description: "Kozlovskiy Rayon", country: state, continent: continent,  geoname_id: 543055, population: 0)
province = region.provinces.create(description: "Krasnoarmeyskiy Rayon", country: state, continent: continent,  geoname_id: 542436, population: 0)
province = region.provinces.create(description: "Krasnochetayskiy Rayon", country: state, continent: continent,  geoname_id: 825032, population: 0)
province = region.provinces.create(description: "Mariinsko-Posadskiy Rayon", country: state, continent: continent,  geoname_id: 529342, population: 0)
province = region.provinces.create(description: "Morgaushskiy Rayon", country: state, continent: continent,  geoname_id: 525278, population: 0)
province = region.provinces.create(description: "Poretskiy Rayon", country: state, continent: continent,  geoname_id: 506288, population: 0)
province = region.provinces.create(description: "Shemurshinskiy Rayon", country: state, continent: continent,  geoname_id: 494919, population: 0)
province = region.provinces.create(description: "Shumerlinskiy Rayon", country: state, continent: continent,  geoname_id: 493464, population: 0)
province = region.provinces.create(description: "Tsivil'skiy Rayon", country: state, continent: continent,  geoname_id: 480849, population: 0)
province = region.provinces.create(description: "Urmarskiy Rayon", country: state, continent: continent,  geoname_id: 478690, population: 0)
province = region.provinces.create(description: "Vurnarskiy Rayon", country: state, continent: continent,  geoname_id: 470846, population: 0)
province = region.provinces.create(description: "Yadrinskiy Rayon", country: state, continent: continent,  geoname_id: 469804, population: 0)
province = region.provinces.create(description: "Yal'chikskiy Rayon", country: state, continent: continent,  geoname_id: 469395, population: 0)
province = region.provinces.create(description: "Yantikovskiy Rayon", country: state, continent: continent,  geoname_id: 469048, population: 0)
region = Region.create(description: "Dagestan", country: state, continent: continent, geoname_id: 567293)
province = region.provinces.create(description: "Agul'skiy Rayon", country: state, continent: continent,  geoname_id: 583977, population: 11201)
province = region.provinces.create(description: "Akhtynskiy Rayon", country: state, continent: continent,  geoname_id: 583791, population: 31598)
province = region.provinces.create(description: "Akhvakhskiy Rayon", country: state, continent: continent,  geoname_id: 583776, population: 20705)
municipalities = [
province.municipalities.new(description: "Anchik", region: region, country: state, continent: continent, geoname_id: 582138, population: 0),
province.municipalities.new(description: "Archo", region: region, country: state, continent: continent, geoname_id: 581199, population: 0),
province.municipalities.new(description: "Ingerdakh", region: region, country: state, continent: continent, geoname_id: 556356, population: 0),
province.municipalities.new(description: "Kudiyabroso", region: region, country: state, continent: continent, geoname_id: 539879, population: 0),
province.municipalities.new(description: "Kvankero", region: region, country: state, continent: continent, geoname_id: 858068, population: 0),
province.municipalities.new(description: "Lologonitl'", region: region, country: state, continent: continent, geoname_id: 534389, population: 0),
province.municipalities.new(description: "Mashtada", region: region, country: state, continent: continent, geoname_id: 858050, population: 0),
province.municipalities.new(description: "Mesterukh", region: region, country: state, continent: continent, geoname_id: 527378, population: 0),
province.municipalities.new(description: "Rachabulda", region: region, country: state, continent: continent, geoname_id: 501848, population: 0),
province.municipalities.new(description: "Ratsitl'", region: region, country: state, continent: continent, geoname_id: 502611, population: 0),
province.municipalities.new(description: "Tad-Magitl'", region: region, country: state, continent: continent, geoname_id: 484919, population: 0),
province.municipalities.new(description: "Tad-Magitl'", region: region, country: state, continent: continent, geoname_id: 860428, population: 0),
province.municipalities.new(description: "Tlibisho", region: region, country: state, continent: continent, geoname_id: 482602, population: 0),
province.municipalities.new(description: "Tlisi", region: region, country: state, continent: continent, geoname_id: 482600, population: 0),
province.municipalities.new(description: "Tsoloda", region: region, country: state, continent: continent, geoname_id: 480825, population: 0),
province.municipalities.new(description: "Tsumali", region: region, country: state, continent: continent, geoname_id: 858048, population: 0),
province.municipalities.new(description: "Tsvakilkolo", region: region, country: state, continent: continent, geoname_id: 858069, population: 0),
province.municipalities.new(description: "Tukita", region: region, country: state, continent: continent, geoname_id: 480590, population: 0),
province.municipalities.new(description: "Verkhneye Inkhelo", region: region, country: state, continent: continent, geoname_id: 475382, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Akushinskiy Rayon", country: state, continent: continent,  geoname_id: 583511, population: 0)
province = region.provinces.create(description: "Babayurtovskiy Rayon", country: state, continent: continent,  geoname_id: 579998, population: 42554)
province = region.provinces.create(description: "Bezhtinskiy Uchastok Rayon", country: state, continent: continent,  geoname_id: 830805, population: 0)
municipalities = [
province.municipalities.new(description: "Bezhta", region: region, country: state, continent: continent, geoname_id: 576558, population: 3994),
province.municipalities.new(description: "Garbutl'", region: region, country: state, continent: continent, geoname_id: 561998, population: 0),
province.municipalities.new(description: "Gunzib", region: region, country: state, continent: continent, geoname_id: 567089, population: 0),
province.municipalities.new(description: "Khasharkhota", region: region, country: state, continent: continent, geoname_id: 858608, population: 0),
province.municipalities.new(description: "Nakhada", region: region, country: state, continent: continent, geoname_id: 858610, population: 0),
province.municipalities.new(description: "Tlyadal'", region: region, country: state, continent: continent, geoname_id: 482596, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Botlikhskiy Rayon", country: state, continent: continent,  geoname_id: 571887, population: 50680)
municipalities = [
province.municipalities.new(description: "Alak", region: region, country: state, continent: continent, geoname_id: 583477, population: 0),
province.municipalities.new(description: "Andi", region: region, country: state, continent: continent, geoname_id: 582123, population: 5318),
province.municipalities.new(description: "Ankho", region: region, country: state, continent: continent, geoname_id: 858680, population: 0),
province.municipalities.new(description: "Ansalta", region: region, country: state, continent: continent, geoname_id: 581568, population: 5654),
province.municipalities.new(description: "Ashali", region: region, country: state, continent: continent, geoname_id: 580648, population: 0),
province.municipalities.new(description: "Ashino", region: region, country: state, continent: continent, geoname_id: 858383, population: 0),
province.municipalities.new(description: "Botlikh", region: region, country: state, continent: continent, geoname_id: 571888, population: 0),
province.municipalities.new(description: "Chanko", region: region, country: state, continent: continent, geoname_id: 569990, population: 0),
province.municipalities.new(description: "Godoberi", region: region, country: state, continent: continent, geoname_id: 475133, population: 0),
province.municipalities.new(description: "Gunkha", region: region, country: state, continent: continent, geoname_id: 860471, population: 0),
province.municipalities.new(description: "Kheleturi", region: region, country: state, continent: continent, geoname_id: 550370, population: 0),
province.municipalities.new(description: "Kizhani", region: region, country: state, continent: continent, geoname_id: 547867, population: 0),
province.municipalities.new(description: "Kvankhidatli", region: region, country: state, continent: continent, geoname_id: 858046, population: 0),
province.municipalities.new(description: "Miarso", region: region, country: state, continent: continent, geoname_id: 527214, population: 0),
province.municipalities.new(description: "Miarso", region: region, country: state, continent: continent, geoname_id: 860421, population: 0),
province.municipalities.new(description: "Muni", region: region, country: state, continent: continent, geoname_id: 524452, population: 0),
province.municipalities.new(description: "Nizhneye Inkhelo", region: region, country: state, continent: continent, geoname_id: 520967, population: 0),
province.municipalities.new(description: "Nizhniye Godoberi", region: region, country: state, continent: continent, geoname_id: 520746, population: 0),
province.municipalities.new(description: "Ortakolo", region: region, country: state, continent: continent, geoname_id: 514731, population: 0),
province.municipalities.new(description: "Rakhata", region: region, country: state, continent: continent, geoname_id: 503132, population: 0),
province.municipalities.new(description: "Rikvani", region: region, country: state, continent: continent, geoname_id: 501913, population: 0),
province.municipalities.new(description: "Rushukha", region: region, country: state, continent: continent, geoname_id: 858677, population: 0),
province.municipalities.new(description: "Shivor", region: region, country: state, continent: continent, geoname_id: 858679, population: 0),
province.municipalities.new(description: "Shodroda", region: region, country: state, continent: continent, geoname_id: 493893, population: 0),
province.municipalities.new(description: "Tlokh", region: region, country: state, continent: continent, geoname_id: 482599, population: 0),
province.municipalities.new(description: "Tsibilta", region: region, country: state, continent: continent, geoname_id: 480908, population: 0),
province.municipalities.new(description: "Zilo", region: region, country: state, continent: continent, geoname_id: 462607, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Buynakskiy Rayon", country: state, continent: continent,  geoname_id: 570478, population: 0)
province = region.provinces.create(description: "Charodinskiy Rayon", country: state, continent: continent,  geoname_id: 569892, population: 11607)
province = region.provinces.create(description: "Dakhadayevskiy Rayon", country: state, continent: continent,  geoname_id: 567284, population: 0)
province = region.provinces.create(description: "Derbentskiy Rayon", country: state, continent: continent,  geoname_id: 566528, population: 0)
province = region.provinces.create(description: "Dokuzparinskiy Rayon", country: state, continent: continent,  geoname_id: 825033, population: 0)
province = region.provinces.create(description: "Gergebil'skiy Rayon", country: state, continent: continent,  geoname_id: 561559, population: 18483)
municipalities = [
province.municipalities.new(description: "Chalda", region: region, country: state, continent: continent, geoname_id: 858133, population: 0),
province.municipalities.new(description: "Gotsob", region: region, country: state, continent: continent, geoname_id: 559204, population: 0),
province.municipalities.new(description: "Iputa", region: region, country: state, continent: continent, geoname_id: 858146, population: 0),
province.municipalities.new(description: "Khvarada", region: region, country: state, continent: continent, geoname_id: 858147, population: 0),
province.municipalities.new(description: "Maali", region: region, country: state, continent: continent, geoname_id: 532351, population: 0),
province.municipalities.new(description: "Mogokh", region: region, country: state, continent: continent, geoname_id: 525879, population: 0),
province.municipalities.new(description: "Tunzy", region: region, country: state, continent: continent, geoname_id: 480405, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Buynaksk", country: state, continent: continent,  geoname_id: 830807, population: 0)
province = region.provinces.create(description: "Gorod Dagestanskiye Ogni", country: state, continent: continent,  geoname_id: 830810, population: 0)
province = region.provinces.create(description: "Gorod Derbent", country: state, continent: continent,  geoname_id: 830809, population: 0)
province = region.provinces.create(description: "Gorod Izberbash", country: state, continent: continent,  geoname_id: 830811, population: 0)
province = region.provinces.create(description: "Gorod Kaspiysk", country: state, continent: continent,  geoname_id: 830812, population: 0)
province = region.provinces.create(description: "Gorod Kizlyar", country: state, continent: continent,  geoname_id: 830814, population: 0)
province = region.provinces.create(description: "Gorod Makhachkala", country: state, continent: continent,  geoname_id: 826309, population: 0)
province = region.provinces.create(description: "Gorod Yuzhno-Sukhokumsk", country: state, continent: continent,  geoname_id: 830816, population: 0)
province = region.provinces.create(description: "Gumbetovskiy Rayon", country: state, continent: continent,  geoname_id: 558024, population: 18067)
municipalities = [
province.municipalities.new(description: "Argvani", region: region, country: state, continent: continent, geoname_id: 581129, population: 0),
province.municipalities.new(description: "Chirkata", region: region, country: state, continent: continent, geoname_id: 568078, population: 0),
province.municipalities.new(description: "Chitl'", region: region, country: state, continent: continent, geoname_id: 567953, population: 0),
province.municipalities.new(description: "Danukh", region: region, country: state, continent: continent, geoname_id: 567091, population: 0),
province.municipalities.new(description: "Gadari", region: region, country: state, continent: continent, geoname_id: 562262, population: 0),
province.municipalities.new(description: "Ichichali", region: region, country: state, continent: continent, geoname_id: 557615, population: 0),
province.municipalities.new(description: "Igali", region: region, country: state, continent: continent, geoname_id: 557578, population: 0),
province.municipalities.new(description: "Ingishi", region: region, country: state, continent: continent, geoname_id: 556354, population: 0),
province.municipalities.new(description: "Kilyatl'", region: region, country: state, continent: continent, geoname_id: 548674, population: 0),
province.municipalities.new(description: "Kunzakh", region: region, country: state, continent: continent, geoname_id: 858684, population: 0),
province.municipalities.new(description: "Mekhel'ta", region: region, country: state, continent: continent, geoname_id: 527821, population: 0),
province.municipalities.new(description: "Nizhneye Inkho", region: region, country: state, continent: continent, geoname_id: 858682, population: 0),
province.municipalities.new(description: "Nizhniy Aradirikh", region: region, country: state, continent: continent, geoname_id: 858702, population: 0),
province.municipalities.new(description: "Novyye Argvani", region: region, country: state, continent: continent, geoname_id: 858687, population: 0),
province.municipalities.new(description: "Shabdukh", region: region, country: state, continent: continent, geoname_id: 496166, population: 0),
province.municipalities.new(description: "Sredniy Aradirikh", region: region, country: state, continent: continent, geoname_id: 581283, population: 0),
province.municipalities.new(description: "Tantari", region: region, country: state, continent: continent, geoname_id: 858686, population: 0),
province.municipalities.new(description: "Tenetu", region: region, country: state, continent: continent, geoname_id: 858685, population: 0),
province.municipalities.new(description: "Tlyarata", region: region, country: state, continent: continent, geoname_id: 482587, population: 0),
province.municipalities.new(description: "Tsanatl'", region: region, country: state, continent: continent, geoname_id: 858683, population: 0),
province.municipalities.new(description: "Tsilitl'", region: region, country: state, continent: continent, geoname_id: 480886, population: 0),
province.municipalities.new(description: "Tsundi", region: region, country: state, continent: continent, geoname_id: 564166, population: 0),
province.municipalities.new(description: "Verkhneye Inkho", region: region, country: state, continent: continent, geoname_id: 475381, population: 0),
province.municipalities.new(description: "Verkhniy Aradirikh", region: region, country: state, continent: continent, geoname_id: 802614, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gunibskiy Rayon", country: state, continent: continent,  geoname_id: 557977, population: 25040)
municipalities = [
province.municipalities.new(description: "Agada", region: region, country: state, continent: continent, geoname_id: 858203, population: 0),
province.municipalities.new(description: "Akhnada", region: region, country: state, continent: continent, geoname_id: 858556, population: 0),
province.municipalities.new(description: "Ala", region: region, country: state, continent: continent, geoname_id: 858198, population: 0),
province.municipalities.new(description: "Amuarib", region: region, country: state, continent: continent, geoname_id: 858205, population: 0),
province.municipalities.new(description: "Askhabil'-Kuli", region: region, country: state, continent: continent, geoname_id: 858207, population: 0),
province.municipalities.new(description: "Baldutl'", region: region, country: state, continent: continent, geoname_id: 858241, population: 0),
province.municipalities.new(description: "Basar", region: region, country: state, continent: continent, geoname_id: 858239, population: 0),
province.municipalities.new(description: "Batsada", region: region, country: state, continent: continent, geoname_id: 578688, population: 0),
province.municipalities.new(description: "Batsikvarikh", region: region, country: state, continent: continent, geoname_id: 858208, population: 0),
province.municipalities.new(description: "Bukhty", region: region, country: state, continent: continent, geoname_id: 571114, population: 0),
province.municipalities.new(description: "Chonob", region: region, country: state, continent: continent, geoname_id: 858206, population: 0),
province.municipalities.new(description: "Egeda", region: region, country: state, continent: continent, geoname_id: 858204, population: 0),
province.municipalities.new(description: "Enseruda", region: region, country: state, continent: continent, geoname_id: 858209, population: 0),
province.municipalities.new(description: "Gamsutl'", region: region, country: state, continent: continent, geoname_id: 858579, population: 0),
province.municipalities.new(description: "Garbilazda", region: region, country: state, continent: continent, geoname_id: 858244, population: 0),
province.municipalities.new(description: "Gonoda", region: region, country: state, continent: continent, geoname_id: 560380, population: 0),
province.municipalities.new(description: "Ivaylazda", region: region, country: state, continent: continent, geoname_id: 858238, population: 0),
province.municipalities.new(description: "Karadakh", region: region, country: state, continent: continent, geoname_id: 552901, population: 0),
province.municipalities.new(description: "Khamagib", region: region, country: state, continent: continent, geoname_id: 858212, population: 0),
province.municipalities.new(description: "Khatsunob", region: region, country: state, continent: continent, geoname_id: 858240, population: 0),
province.municipalities.new(description: "Khenda", region: region, country: state, continent: continent, geoname_id: 858237, population: 0),
province.municipalities.new(description: "Khindakh", region: region, country: state, continent: continent, geoname_id: 550275, population: 0),
province.municipalities.new(description: "Khopor", region: region, country: state, continent: continent, geoname_id: 858164, population: 0),
province.municipalities.new(description: "Khotoch", region: region, country: state, continent: continent, geoname_id: 802244, population: 0),
province.municipalities.new(description: "Kommuna", region: region, country: state, continent: continent, geoname_id: 858159, population: 0),
province.municipalities.new(description: "Koroda", region: region, country: state, continent: continent, geoname_id: 802237, population: 0),
province.municipalities.new(description: "Kukor", region: region, country: state, continent: continent, geoname_id: 858242, population: 0),
province.municipalities.new(description: "Kulla", region: region, country: state, continent: continent, geoname_id: 539418, population: 0),
province.municipalities.new(description: "Lakhnayda", region: region, country: state, continent: continent, geoname_id: 858233, population: 0),
province.municipalities.new(description: "Mugdab", region: region, country: state, continent: continent, geoname_id: 858234, population: 0),
province.municipalities.new(description: "Nakazukh", region: region, country: state, continent: continent, geoname_id: 858574, population: 0),
province.municipalities.new(description: "Obonub", region: region, country: state, continent: continent, geoname_id: 858213, population: 0),
province.municipalities.new(description: "Rosutl'", region: region, country: state, continent: continent, geoname_id: 858199, population: 0),
province.municipalities.new(description: "Rugudzha", region: region, country: state, continent: continent, geoname_id: 802220, population: 0),
province.municipalities.new(description: "Sekh", region: region, country: state, continent: continent, geoname_id: 858200, population: 0),
province.municipalities.new(description: "Shulani", region: region, country: state, continent: continent, geoname_id: 493534, population: 0),
province.municipalities.new(description: "Sogratl'", region: region, country: state, continent: continent, geoname_id: 491313, population: 0),
province.municipalities.new(description: "Tlogob", region: region, country: state, continent: continent, geoname_id: 802241, population: 0),
province.municipalities.new(description: "Tsalada", region: region, country: state, continent: continent, geoname_id: 858235, population: 0),
province.municipalities.new(description: "Tsamla", region: region, country: state, continent: continent, geoname_id: 858197, population: 0),
province.municipalities.new(description: "Unkida", region: region, country: state, continent: continent, geoname_id: 858572, population: 0),
province.municipalities.new(description: "Unty", region: region, country: state, continent: continent, geoname_id: 478961, population: 0),
province.municipalities.new(description: "Urala", region: region, country: state, continent: continent, geoname_id: 858236, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Karabudakhkentskiy Rayon", country: state, continent: continent,  geoname_id: 536044, population: 0)
province = region.provinces.create(description: "Kayakentskiy Rayon", country: state, continent: continent,  geoname_id: 551645, population: 0)
province = region.provinces.create(description: "Kaytagskiy Rayon", country: state, continent: continent,  geoname_id: 551590, population: 0)
province = region.provinces.create(description: "Kazbekovskiy Rayon", country: state, continent: continent,  geoname_id: 551375, population: 34074)
municipalities = [
province.municipalities.new(description: "Artlukh", region: region, country: state, continent: continent, geoname_id: 580779, population: 0),
province.municipalities.new(description: "Druzhba", region: region, country: state, continent: continent, geoname_id: 564930, population: 0),
province.municipalities.new(description: "Khalata-Tala", region: region, country: state, continent: continent, geoname_id: 796545, population: 0),
province.municipalities.new(description: "Kuriman", region: region, country: state, continent: continent, geoname_id: 796378, population: 0),
province.municipalities.new(description: "Makhi", region: region, country: state, continent: continent, geoname_id: 532084, population: 0),
province.municipalities.new(description: "Nizhniy Bursun", region: region, country: state, continent: continent, geoname_id: 796532, population: 0),
province.municipalities.new(description: "Shaydan", region: region, country: state, continent: continent, geoname_id: 796543, population: 0),
province.municipalities.new(description: "Verkhniy Bursun", region: region, country: state, continent: continent, geoname_id: 796529, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Khasavyurtovskiy Rayon", country: state, continent: continent,  geoname_id: 550476, population: 130471)
municipalities = [
province.municipalities.new(description: "Aktash-Karlan", region: region, country: state, continent: continent, geoname_id: 796697, population: 0),
province.municipalities.new(description: "Botayurt", region: region, country: state, continent: continent, geoname_id: 578738, population: 4093),
province.municipalities.new(description: "Tsiyab-Tsoloda", region: region, country: state, continent: continent, geoname_id: 858713, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Khivskiy Rayon", country: state, continent: continent,  geoname_id: 550200, population: 20748)
province = region.provinces.create(description: "Khunzakhskiy Rayon", country: state, continent: continent,  geoname_id: 549104, population: 0)
municipalities = [
province.municipalities.new(description: "Akhalchi", region: region, country: state, continent: continent, geoname_id: 583883, population: 0),
province.municipalities.new(description: "Akhalchi", region: region, country: state, continent: continent, geoname_id: 858083, population: 0),
province.municipalities.new(description: "Amishta", region: region, country: state, continent: continent, geoname_id: 582260, population: 0),
province.municipalities.new(description: "Arani", region: region, country: state, continent: continent, geoname_id: 581265, population: 0),
province.municipalities.new(description: "Baitl'", region: region, country: state, continent: continent, geoname_id: 858089, population: 0),
province.municipalities.new(description: "Batlaich", region: region, country: state, continent: continent, geoname_id: 578717, population: 0),
province.municipalities.new(description: "Bol'shiye Amushi", region: region, country: state, continent: continent, geoname_id: 574278, population: 0),
province.municipalities.new(description: "Bol'shoy Gotsatl'", region: region, country: state, continent: continent, geoname_id: 573115, population: 0),
province.municipalities.new(description: "Butsra", region: region, country: state, continent: continent, geoname_id: 570569, population: 0),
province.municipalities.new(description: "Chondotl'", region: region, country: state, continent: continent, geoname_id: 567862, population: 0),
province.municipalities.new(description: "Dzhalaturi", region: region, country: state, continent: continent, geoname_id: 563686, population: 0),
province.municipalities.new(description: "Ebuta", region: region, country: state, continent: continent, geoname_id: 858088, population: 0),
province.municipalities.new(description: "Gatsalukh", region: region, country: state, continent: continent, geoname_id: 802587, population: 0),
province.municipalities.new(description: "Genichutl'", region: region, country: state, continent: continent, geoname_id: 561645, population: 0),
province.municipalities.new(description: "Gonokh", region: region, country: state, continent: continent, geoname_id: 560379, population: 0),
province.municipalities.new(description: "Gortkolo", region: region, country: state, continent: continent, geoname_id: 559367, population: 0),
province.municipalities.new(description: "Gozolokolo", region: region, country: state, continent: continent, geoname_id: 858099, population: 0),
province.municipalities.new(description: "Kakh", region: region, country: state, continent: continent, geoname_id: 554451, population: 0),
province.municipalities.new(description: "Kharakhi", region: region, country: state, continent: continent, geoname_id: 550663, population: 0),
province.municipalities.new(description: "Kharikolo", region: region, country: state, continent: continent, geoname_id: 550625, population: 0),
province.municipalities.new(description: "Khimakoro", region: region, country: state, continent: continent, geoname_id: 858101, population: 0),
province.municipalities.new(description: "Khimakoro", region: region, country: state, continent: continent, geoname_id: 858105, population: 0),
province.municipalities.new(description: "Khindakh", region: region, country: state, continent: continent, geoname_id: 550273, population: 0),
province.municipalities.new(description: "Khini", region: region, country: state, continent: continent, geoname_id: 550267, population: 0),
province.municipalities.new(description: "Kolo", region: region, country: state, continent: continent, geoname_id: 858077, population: 0),
province.municipalities.new(description: "Malyy Gotsatl'", region: region, country: state, continent: continent, geoname_id: 529949, population: 0),
province.municipalities.new(description: "Malyye Amushi", region: region, country: state, continent: continent, geoname_id: 858074, population: 73),
province.municipalities.new(description: "Matlas", region: region, country: state, continent: continent, geoname_id: 858104, population: 0),
province.municipalities.new(description: "Mochokh", region: region, country: state, continent: continent, geoname_id: 525928, population: 0),
province.municipalities.new(description: "Mushuli", region: region, country: state, continent: continent, geoname_id: 524201, population: 0),
province.municipalities.new(description: "Nakitl'", region: region, country: state, continent: continent, geoname_id: 802592, population: 0),
province.municipalities.new(description: "Novaya Butsra", region: region, country: state, continent: continent, geoname_id: 858142, population: 0),
province.municipalities.new(description: "Oboda", region: region, country: state, continent: continent, geoname_id: 516429, population: 0),
province.municipalities.new(description: "Ochlo", region: region, country: state, continent: continent, geoname_id: 516243, population: 0),
province.municipalities.new(description: "Orkachi", region: region, country: state, continent: continent, geoname_id: 563438, population: 0),
province.municipalities.new(description: "Orota", region: region, country: state, continent: continent, geoname_id: 514751, population: 0),
province.municipalities.new(description: "Shakhada", region: region, country: state, continent: continent, geoname_id: 496066, population: 0),
province.municipalities.new(description: "Shotota", region: region, country: state, continent: continent, geoname_id: 493724, population: 0),
province.municipalities.new(description: "Tanusi", region: region, country: state, continent: continent, geoname_id: 484559, population: 0),
province.municipalities.new(description: "Tekita", region: region, country: state, continent: continent, geoname_id: 483834, population: 0),
province.municipalities.new(description: "Tlaylukh", region: region, country: state, continent: continent, geoname_id: 482604, population: 0),
province.municipalities.new(description: "Tsada", region: region, country: state, continent: continent, geoname_id: 802583, population: 185),
province.municipalities.new(description: "Tsalkita", region: region, country: state, continent: continent, geoname_id: 481109, population: 0),
province.municipalities.new(description: "Tsel'mes", region: region, country: state, continent: continent, geoname_id: 858076, population: 0),
province.municipalities.new(description: "Tumagari", region: region, country: state, continent: continent, geoname_id: 858100, population: 0),
province.municipalities.new(description: "Uzdalroso", region: region, country: state, continent: continent, geoname_id: 802239, population: 0),
province.municipalities.new(description: "Verkhniye Akhalchi", region: region, country: state, continent: continent, geoname_id: 858097, population: 0),
province.municipalities.new(description: "Zaib", region: region, country: state, continent: continent, geoname_id: 858256, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kizilyurtovskiy Rayon", country: state, continent: continent,  geoname_id: 547846, population: 71826)
municipalities = [
province.municipalities.new(description: "Nechayevka", region: region, country: state, continent: continent, geoname_id: 796804, population: 0),
province.municipalities.new(description: "Shamshudinovka", region: region, country: state, continent: continent, geoname_id: 495876, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kizlyarskiy Rayon", country: state, continent: continent,  geoname_id: 547836, population: 60590)
province = region.provinces.create(description: "Kulinskiy Rayon", country: state, continent: continent,  geoname_id: 539432, population: 10608)
province = region.provinces.create(description: "Kumtorkalinskiy Rayon", country: state, continent: continent,  geoname_id: 825034, population: 0)
province = region.provinces.create(description: "Kurakhskiy Rayon", country: state, continent: continent,  geoname_id: 538991, population: 15266)
province = region.provinces.create(description: "Lakskiy Rayon", country: state, continent: continent,  geoname_id: 537098, population: 0)
province = region.provinces.create(description: "Levashinskiy Rayon", country: state, continent: continent,  geoname_id: 535538, population: 0)
province = region.provinces.create(description: "Magaramkentskiy Rayon", country: state, continent: continent,  geoname_id: 532306, population: 59763)
province = region.provinces.create(description: "Nogayskiy Rayon", country: state, continent: continent,  geoname_id: 520075, population: 0)
province = region.provinces.create(description: "Novolakskiy Rayon", country: state, continent: continent,  geoname_id: 518649, population: 23441)
municipalities = [
province.municipalities.new(description: "Shushiya", region: region, country: state, continent: continent, geoname_id: 858653, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Rutul'skiy Rayon", country: state, continent: continent,  geoname_id: 500315, population: 23190)
province = region.provinces.create(description: "Sergokalinskiy Rayon", country: state, continent: continent,  geoname_id: 496609, population: 0)
province = region.provinces.create(description: "Shamil'skiy Rayon", country: state, continent: continent,  geoname_id: 490031, population: 26343)
municipalities = [
province.municipalities.new(description: "Dagbash", region: region, country: state, continent: continent, geoname_id: 567294, population: 0),
province.municipalities.new(description: "Datuna", region: region, country: state, continent: continent, geoname_id: 567016, population: 0),
province.municipalities.new(description: "Genitsurib", region: region, country: state, continent: continent, geoname_id: 858260, population: 0),
province.municipalities.new(description: "Genta", region: region, country: state, continent: continent, geoname_id: 561644, population: 0),
province.municipalities.new(description: "Gidatlinskiy Most", region: region, country: state, continent: continent, geoname_id: 858320, population: 0),
province.municipalities.new(description: "Gogotl'", region: region, country: state, continent: continent, geoname_id: 560827, population: 0),
province.municipalities.new(description: "Golotl'", region: region, country: state, continent: continent, geoname_id: 560691, population: 0),
province.municipalities.new(description: "Goor", region: region, country: state, continent: continent, geoname_id: 560371, population: 0),
province.municipalities.new(description: "Goor-Khindakh", region: region, country: state, continent: continent, geoname_id: 550274, population: 0),
province.municipalities.new(description: "Goor-Khindakh", region: region, country: state, continent: continent, geoname_id: 860417, population: 0),
province.municipalities.new(description: "Kakhib", region: region, country: state, continent: continent, geoname_id: 554449, population: 0),
province.municipalities.new(description: "Khamakal", region: region, country: state, continent: continent, geoname_id: 858272, population: 0),
province.municipalities.new(description: "Khindakh", region: region, country: state, continent: continent, geoname_id: 802275, population: 0),
province.municipalities.new(description: "Khonokh", region: region, country: state, continent: continent, geoname_id: 858499, population: 0),
province.municipalities.new(description: "Khoroda", region: region, country: state, continent: continent, geoname_id: 802264, population: 0),
province.municipalities.new(description: "Khotoda", region: region, country: state, continent: continent, geoname_id: 549366, population: 0),
province.municipalities.new(description: "Khuchada", region: region, country: state, continent: continent, geoname_id: 549177, population: 0),
province.municipalities.new(description: "Kienikh", region: region, country: state, continent: continent, geoname_id: 858274, population: 0),
province.municipalities.new(description: "Kuanib", region: region, country: state, continent: continent, geoname_id: 540088, population: 0),
province.municipalities.new(description: "Machada", region: region, country: state, continent: continent, geoname_id: 525968, population: 0),
province.municipalities.new(description: "Mitliurib", region: region, country: state, continent: continent, geoname_id: 858258, population: 0),
province.municipalities.new(description: "Mogokh", region: region, country: state, continent: continent, geoname_id: 525880, population: 0),
province.municipalities.new(description: "Mokoda", region: region, country: state, continent: continent, geoname_id: 858271, population: 0),
province.municipalities.new(description: "Musrukh", region: region, country: state, continent: continent, geoname_id: 524175, population: 0),
province.municipalities.new(description: "Nakitl'", region: region, country: state, continent: continent, geoname_id: 802263, population: 0),
province.municipalities.new(description: "Nitab", region: region, country: state, continent: continent, geoname_id: 521295, population: 0),
province.municipalities.new(description: "Nizhniy Batlukh", region: region, country: state, continent: continent, geoname_id: 520797, population: 0),
province.municipalities.new(description: "Nizhniy Kolob", region: region, country: state, continent: continent, geoname_id: 858273, population: 0),
province.municipalities.new(description: "Nizhniy Togokh", region: region, country: state, continent: continent, geoname_id: 858259, population: 0),
province.municipalities.new(description: "Ratlub", region: region, country: state, continent: continent, geoname_id: 502629, population: 0),
province.municipalities.new(description: "Rugel'da", region: region, country: state, continent: continent, geoname_id: 500633, population: 0),
province.municipalities.new(description: "Rukdakh", region: region, country: state, continent: continent, geoname_id: 858340, population: 0),
province.municipalities.new(description: "Somoda", region: region, country: state, continent: continent, geoname_id: 490691, population: 0),
province.municipalities.new(description: "Teletl'", region: region, country: state, continent: continent, geoname_id: 483782, population: 0),
province.municipalities.new(description: "Tidib", region: region, country: state, continent: continent, geoname_id: 483126, population: 0),
province.municipalities.new(description: "Tlezda", region: region, country: state, continent: continent, geoname_id: 858261, population: 0),
province.municipalities.new(description: "Tlyakh", region: region, country: state, continent: continent, geoname_id: 858312, population: 0),
province.municipalities.new(description: "Tlyanub", region: region, country: state, continent: continent, geoname_id: 482590, population: 0),
province.municipalities.new(description: "Tsekob", region: region, country: state, continent: continent, geoname_id: 481045, population: 0),
province.municipalities.new(description: "Urada", region: region, country: state, continent: continent, geoname_id: 478899, population: 0),
province.municipalities.new(description: "Urchukh", region: region, country: state, continent: continent, geoname_id: 478774, population: 0),
province.municipalities.new(description: "Urib", region: region, country: state, continent: continent, geoname_id: 478728, population: 0),
province.municipalities.new(description: "Verkhniy Batlukh", region: region, country: state, continent: continent, geoname_id: 858326, population: 0),
province.municipalities.new(description: "Verkhniy Kolob", region: region, country: state, continent: continent, geoname_id: 858270, population: 0),
province.municipalities.new(description: "Verkhniy Togokh", region: region, country: state, continent: continent, geoname_id: 802265, population: 0),
province.municipalities.new(description: "Zanata", region: region, country: state, continent: continent, geoname_id: 465020, population: 0),
province.municipalities.new(description: "Ziurib", region: region, country: state, continent: continent, geoname_id: 462452, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Suleyman-Stal'skiy Rayon", country: state, continent: continent,  geoname_id: 486360, population: 54027)
province = region.provinces.create(description: "Tabasaranskiy Rayon", country: state, continent: continent,  geoname_id: 484957, population: 54822)
province = region.provinces.create(description: "Tarumovskiy Rayon", country: state, continent: continent,  geoname_id: 484288, population: 0)
province = region.provinces.create(description: "Tlyaratinskiy Rayon", country: state, continent: continent,  geoname_id: 482588, population: 22536)
province = region.provinces.create(description: "Tsumadinskiy Rayon", country: state, continent: continent,  geoname_id: 480804, population: 21667)
municipalities = [
province.municipalities.new(description: "Agvali", region: region, country: state, continent: continent, geoname_id: 583973, population: 2158),
province.municipalities.new(description: "Aknada", region: region, country: state, continent: continent, geoname_id: 583707, population: 4070),
province.municipalities.new(description: "Angida", region: region, country: state, continent: continent, geoname_id: 581772, population: 0),
province.municipalities.new(description: "Asha", region: region, country: state, continent: continent, geoname_id: 580661, population: 0),
province.municipalities.new(description: "Batlakhatli", region: region, country: state, continent: continent, geoname_id: 858010, population: 13),
province.municipalities.new(description: "Boto", region: region, country: state, continent: continent, geoname_id: 802372, population: 0),
province.municipalities.new(description: "Daatla", region: region, country: state, continent: continent, geoname_id: 802343, population: 0),
province.municipalities.new(description: "Echeda", region: region, country: state, continent: continent, geoname_id: 563565, population: 0),
province.municipalities.new(description: "Gachitli", region: region, country: state, continent: continent, geoname_id: 562267, population: 0),
province.municipalities.new(description: "Gadaichi", region: region, country: state, continent: continent, geoname_id: 858423, population: 0),
province.municipalities.new(description: "Gadiri", region: region, country: state, continent: continent, geoname_id: 562257, population: 0),
province.municipalities.new(description: "Gakko", region: region, country: state, continent: continent, geoname_id: 562197, population: 0),
province.municipalities.new(description: "Gigatli-Urukh", region: region, country: state, continent: continent, geoname_id: 858016, population: 0),
province.municipalities.new(description: "Gigatl'", region: region, country: state, continent: continent, geoname_id: 561492, population: 0),
province.municipalities.new(description: "Gigikh", region: region, country: state, continent: continent, geoname_id: 858035, population: 0),
province.municipalities.new(description: "Gimerso", region: region, country: state, continent: continent, geoname_id: 561479, population: 0),
province.municipalities.new(description: "Gunduchi", region: region, country: state, continent: continent, geoname_id: 858409, population: 0),
province.municipalities.new(description: "Gvanachi", region: region, country: state, continent: continent, geoname_id: 860419, population: 0),
province.municipalities.new(description: "Gvanachi", region: region, country: state, continent: continent, geoname_id: 858412, population: 0),
province.municipalities.new(description: "Inkhokvari", region: region, country: state, continent: continent, geoname_id: 556344, population: 0),
province.municipalities.new(description: "Issi", region: region, country: state, continent: continent, geoname_id: 858438, population: 0),
province.municipalities.new(description: "Kedi", region: region, country: state, continent: continent, geoname_id: 551247, population: 0),
province.municipalities.new(description: "Khalikh", region: region, country: state, continent: continent, geoname_id: 858422, population: 0),
province.municipalities.new(description: "Khonokh", region: region, country: state, continent: continent, geoname_id: 549923, population: 0),
province.municipalities.new(description: "Khushet", region: region, country: state, continent: continent, geoname_id: 549083, population: 0),
province.municipalities.new(description: "Khushtada", region: region, country: state, continent: continent, geoname_id: 549082, population: 0),
province.municipalities.new(description: "Khvarshi", region: region, country: state, continent: continent, geoname_id: 548978, population: 0),
province.municipalities.new(description: "Khvayni", region: region, country: state, continent: continent, geoname_id: 548960, population: 0),
province.municipalities.new(description: "Kochali", region: region, country: state, continent: continent, geoname_id: 858036, population: 0),
province.municipalities.new(description: "Kvanada", region: region, country: state, continent: continent, geoname_id: 537543, population: 0),
province.municipalities.new(description: "Kvantlada", region: region, country: state, continent: continent, geoname_id: 802342, population: 0),
province.municipalities.new(description: "Metrada", region: region, country: state, continent: continent, geoname_id: 527337, population: 0),
province.municipalities.new(description: "Mukharkh", region: region, country: state, continent: continent, geoname_id: 858415, population: 0),
province.municipalities.new(description: "Nizhniye Gakvari", region: region, country: state, continent: continent, geoname_id: 520748, population: 0),
province.municipalities.new(description: "Nizhniye Khvarshini", region: region, country: state, continent: continent, geoname_id: 520727, population: 0),
province.municipalities.new(description: "Richaganikh", region: region, country: state, continent: continent, geoname_id: 802411, population: 0),
province.municipalities.new(description: "Santlada", region: region, country: state, continent: continent, geoname_id: 498796, population: 0),
province.municipalities.new(description: "Sanukh", region: region, country: state, continent: continent, geoname_id: 858417, population: 0),
province.municipalities.new(description: "Sasitli", region: region, country: state, continent: continent, geoname_id: 498443, population: 0),
province.municipalities.new(description: "Sil'di", region: region, country: state, continent: continent, geoname_id: 492980, population: 0),
province.municipalities.new(description: "Tenla", region: region, country: state, continent: continent, geoname_id: 858416, population: 0),
province.municipalities.new(description: "Tindi", region: region, country: state, continent: continent, geoname_id: 482802, population: 0),
province.municipalities.new(description: "Tissi", region: region, country: state, continent: continent, geoname_id: 482704, population: 0),
province.municipalities.new(description: "Tissi-Akhitli", region: region, country: state, continent: continent, geoname_id: 802409, population: 0),
province.municipalities.new(description: "Tlondoda", region: region, country: state, continent: continent, geoname_id: 482598, population: 0),
province.municipalities.new(description: "Tsidatl'", region: region, country: state, continent: continent, geoname_id: 858041, population: 0),
province.municipalities.new(description: "Tsidatl'", region: region, country: state, continent: continent, geoname_id: 860425, population: 0),
province.municipalities.new(description: "Tsumada", region: region, country: state, continent: continent, geoname_id: 480805, population: 0),
province.municipalities.new(description: "Tsumada-Urukh", region: region, country: state, continent: continent, geoname_id: 858437, population: 0),
province.municipalities.new(description: "Tsuydi", region: region, country: state, continent: continent, geoname_id: 858042, population: 0),
province.municipalities.new(description: "Tsykhalakh", region: region, country: state, continent: continent, geoname_id: 800523, population: 0),
province.municipalities.new(description: "Verkhniye Gakvari", region: region, country: state, continent: continent, geoname_id: 475135, population: 0),
province.municipalities.new(description: "Verkhniye Khvarshini", region: region, country: state, continent: continent, geoname_id: 475106, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Tsuntinskiy Rayon", country: state, continent: continent,  geoname_id: 480801, population: 17530)
province = region.provinces.create(description: "Untsukul'skiy Rayon", country: state, continent: continent,  geoname_id: 478962, population: 27839)
municipalities = [
province.municipalities.new(description: "Inkvalita", region: region, country: state, continent: continent, geoname_id: 556337, population: 0),
province.municipalities.new(description: "Irganay", region: region, country: state, continent: continent, geoname_id: 556198, population: 2336),
province.municipalities.new(description: "Ishtiburi", region: region, country: state, continent: continent, geoname_id: 802616, population: 0),
province.municipalities.new(description: "Kakhabroso", region: region, country: state, continent: continent, geoname_id: 554450, population: 0),
province.municipalities.new(description: "Kharachi", region: region, country: state, continent: continent, geoname_id: 550666, population: 0),
province.municipalities.new(description: "Kolob", region: region, country: state, continent: continent, geoname_id: 546387, population: 0),
province.municipalities.new(description: "Maydanskoye", region: region, country: state, continent: continent, geoname_id: 858126, population: 0),
province.municipalities.new(description: "Moksokh", region: region, country: state, continent: continent, geoname_id: 525652, population: 0),
province.municipalities.new(description: "Tsatanikh", region: region, country: state, continent: continent, geoname_id: 481054, population: 0),
province.municipalities.new(description: "Zirani", region: region, country: state, continent: continent, geoname_id: 462470, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Irkutskaya Oblast'", country: state, continent: continent, geoname_id: 2023468)
province = region.provinces.create(description: "Alarskiy Rayon", country: state, continent: continent,  geoname_id: 2027984, population: 0)
province = region.provinces.create(description: "Angarskiy Rayon", country: state, continent: continent,  geoname_id: 2050918, population: 0)
province = region.provinces.create(description: "Balaganskiy Rayon", country: state, continent: continent,  geoname_id: 2050919, population: 0)
province = region.provinces.create(description: "Bayandayevskiy Rayon", country: state, continent: continent,  geoname_id: 2027003, population: 0)
province = region.provinces.create(description: "Bodaybinskiy Rayon", country: state, continent: continent,  geoname_id: 2026584, population: 0)
province = region.provinces.create(description: "Bokhanskiy Rayon", country: state, continent: continent,  geoname_id: 2026543, population: 0)
province = region.provinces.create(description: "Bratskiy Rayon", country: state, continent: continent,  geoname_id: 2026092, population: 0)
province = region.provinces.create(description: "Cheremkhovskiy Rayon", country: state, continent: continent,  geoname_id: 2025526, population: 0)
province = region.provinces.create(description: "Chunskiy Rayon", country: state, continent: continent,  geoname_id: 1507634, population: 0)
province = region.provinces.create(description: "Ekhirit-Bulagatskiy Rayon", country: state, continent: continent,  geoname_id: 2024464, population: 0)
province = region.provinces.create(description: "Irkutskiy Rayon", country: state, continent: continent,  geoname_id: 2023464, population: 0)
municipalities = [
province.municipalities.new(description: "Irkutsk", region: region, country: state, continent: continent, geoname_id: 2023469, population: 586695),
province.municipalities.new(description: "Irkutsk", region: region, country: state, continent: continent, geoname_id: 7536078, population: 0),
province.municipalities.new(description: "Listvyanka", region: region, country: state, continent: continent, geoname_id: 2020744, population: 1700),
province.municipalities.new(description: "Nikola", region: region, country: state, continent: continent, geoname_id: 2019270, population: 119),
province.municipalities.new(description: "Shara-Togot", region: region, country: state, continent: continent, geoname_id: 2016799, population: 375),
province.municipalities.new(description: "Zogi", region: region, country: state, continent: continent, geoname_id: 2012459, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kachugskiy Rayon", country: state, continent: continent,  geoname_id: 2023332, population: 0)
province = region.provinces.create(description: "Katangskiy Rayon", country: state, continent: continent,  geoname_id: 2023075, population: 0)
province = region.provinces.create(description: "Kazachinsko-Lenskiy Rayon", country: state, continent: continent,  geoname_id: 2023030, population: 0)
province = region.provinces.create(description: "Kirenskiy Rayon", country: state, continent: continent,  geoname_id: 2022082, population: 0)
province = region.provinces.create(description: "Kuytunskiy Rayon", country: state, continent: continent,  geoname_id: 2021089, population: 0)
province = region.provinces.create(description: "Mamsko-Chuyskiy Rayon", country: state, continent: continent,  geoname_id: 2020302, population: 0)
province = region.provinces.create(description: "Nizhneilimskiy Rayon", country: state, continent: continent,  geoname_id: 2019196, population: 0)
province = region.provinces.create(description: "Nizhneudinskiy Rayon", country: state, continent: continent,  geoname_id: 1497548, population: 0)
province = region.provinces.create(description: "Nukutskiy Rayon", country: state, continent: continent,  geoname_id: 2018795, population: 0)
province = region.provinces.create(description: "Ol'khonskiy Rayon", country: state, continent: continent,  geoname_id: 2018527, population: 0)
municipalities = [
province.municipalities.new(description: "Sakhyurta", region: region, country: state, continent: continent, geoname_id: 2050712, population: 224),
]
Municipality.import municipalities
province = region.provinces.create(description: "Osinskiy Rayon", country: state, continent: continent,  geoname_id: 2018281, population: 0)
province = region.provinces.create(description: "Shelekhovskiy Rayon", country: state, continent: continent,  geoname_id: 2050920, population: 0)
province = region.provinces.create(description: "Slyudyanskiy Rayon", country: state, continent: continent,  geoname_id: 2016415, population: 0)
province = region.provinces.create(description: "Tayshetskiy Rayon", country: state, continent: continent,  geoname_id: 1489868, population: 0)
province = region.provinces.create(description: "Tulunskiy Rayon", country: state, continent: continent,  geoname_id: 2014922, population: 0)
province = region.provinces.create(description: "Usol'skiy Rayon", country: state, continent: continent,  geoname_id: 2014025, population: 0)
province = region.provinces.create(description: "Ust-Orda Buryat Okrug", country: state, continent: continent,  geoname_id: 2013895, population: 0)
province = region.provinces.create(description: "Ust'-Ilimskiy Rayon", country: state, continent: continent,  geoname_id: 2013951, population: 0)
province = region.provinces.create(description: "Ust'-Kutskiy Rayon", country: state, continent: continent,  geoname_id: 2013922, population: 0)
province = region.provinces.create(description: "Ust'-Udinskiy Rayon", country: state, continent: continent,  geoname_id: 2013864, population: 0)
province = region.provinces.create(description: "Zalarinskiy Rayon", country: state, continent: continent,  geoname_id: 2012700, population: 0)
province = region.provinces.create(description: "Zhigalovskiy Rayon", country: state, continent: continent,  geoname_id: 2012531, population: 0)
province = region.provinces.create(description: "Ziminskiy Rayon", country: state, continent: continent,  geoname_id: 2012482, population: 0)
region = Region.create(description: "Ivanovskaya Oblast'", country: state, continent: continent, geoname_id: 555235)
province = region.provinces.create(description: "Furmanovskiy Rayon", country: state, continent: continent,  geoname_id: 562305, population: 0)
province = region.provinces.create(description: "Gavrilovo-Posadskiy Rayon", country: state, continent: continent,  geoname_id: 561784, population: 0)
province = region.provinces.create(description: "Gorod Furmanovo", country: state, continent: continent,  geoname_id: 826310, population: 0)
province = region.provinces.create(description: "Gorod Ivanovo", country: state, continent: continent,  geoname_id: 825094, population: 0)
municipalities = [
province.municipalities.new(description: "Ivanovo", region: region, country: state, continent: continent, geoname_id: 555312, population: 420839),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Kineshma", country: state, continent: continent,  geoname_id: 825092, population: 0)
province = region.provinces.create(description: "Gorod Shuya", country: state, continent: continent,  geoname_id: 825093, population: 0)
province = region.provinces.create(description: "Gorod Teykovo", country: state, continent: continent,  geoname_id: 825095, population: 0)
province = region.provinces.create(description: "Gorod Vichuga", country: state, continent: continent,  geoname_id: 825091, population: 0)
province = region.provinces.create(description: "Il'inskiy Rayon", country: state, continent: continent,  geoname_id: 557129, population: 0)
province = region.provinces.create(description: "Ivanovskiy Rayon", country: state, continent: continent,  geoname_id: 555207, population: 0)
province = region.provinces.create(description: "Kineshemskiy Rayon", country: state, continent: continent,  geoname_id: 548606, population: 0)
province = region.provinces.create(description: "Komsomol'skiy Rayon", country: state, continent: continent,  geoname_id: 545702, population: 0)
province = region.provinces.create(description: "Lezhnevskiy Rayon", country: state, continent: continent,  geoname_id: 825096, population: 0)
province = region.provinces.create(description: "Lukhskiy Rayon", country: state, continent: continent,  geoname_id: 533539, population: 0)
province = region.provinces.create(description: "Palekhskiy Rayon", country: state, continent: continent,  geoname_id: 513094, population: 0)
province = region.provinces.create(description: "Pestyakovskiy Rayon", country: state, continent: continent,  geoname_id: 510322, population: 0)
province = region.provinces.create(description: "Privolzhskiy Rayon", country: state, continent: continent,  geoname_id: 505049, population: 0)
municipalities = [
province.municipalities.new(description: "Plës", region: region, country: state, continent: continent, geoname_id: 509029, population: 2790),
]
Municipality.import municipalities
province = region.provinces.create(description: "Puchezhskiy Rayon", country: state, continent: continent,  geoname_id: 504293, population: 0)
province = region.provinces.create(description: "Rodnikovskiy Rayon", country: state, continent: continent,  geoname_id: 501709, population: 0)
province = region.provinces.create(description: "Savinskiy Rayon", country: state, continent: continent,  geoname_id: 498203, population: 0)
province = region.provinces.create(description: "Shuyskiy Rayon", country: state, continent: continent,  geoname_id: 493203, population: 0)
province = region.provinces.create(description: "Teykovskiy Rayon", country: state, continent: continent,  geoname_id: 483136, population: 0)
province = region.provinces.create(description: "Verkhnelandekhovskiy Rayon", country: state, continent: continent,  geoname_id: 475550, population: 0)
province = region.provinces.create(description: "Vichugskiy Rayon", country: state, continent: continent,  geoname_id: 473787, population: 0)
province = region.provinces.create(description: "Yur'yevetskiy Rayon", country: state, continent: continent,  geoname_id: 466254, population: 0)
province = region.provinces.create(description: "Yuzhskiy Rayon", country: state, continent: continent,  geoname_id: 466002, population: 0)
province = region.provinces.create(description: "Zavolzhskiy Rayon", country: state, continent: continent,  geoname_id: 464107, population: 0)
region = Region.create(description: "Jewish Autonomous Oblast", country: state, continent: continent, geoname_id: 2026639)
province = region.provinces.create(description: "Birobidzhanskiy Rayon", country: state, continent: continent,  geoname_id: 2026641, population: 0)
province = region.provinces.create(description: "Leninskiy Rayon", country: state, continent: continent,  geoname_id: 2020845, population: 0)
province = region.provinces.create(description: "Obluchenskiy Rayon", country: state, continent: continent,  geoname_id: 2018720, population: 0)
province = region.provinces.create(description: "Oktyabr'skiy Rayon", country: state, continent: continent,  geoname_id: 2018609, population: 0)
province = region.provinces.create(description: "Smidovichskiy Rayon", country: state, continent: continent,  geoname_id: 2016411, population: 0)
region = Region.create(description: "Kabardino-Balkarskaya Respublika", country: state, continent: continent, geoname_id: 554667)
province = region.provinces.create(description: "Baksanskiy Rayon", country: state, continent: continent,  geoname_id: 579567, population: 0)
province = region.provinces.create(description: "Chegemskiy Rayon", country: state, continent: continent,  geoname_id: 569634, population: 0)
province = region.provinces.create(description: "Cherekskiy Rayon", country: state, continent: continent,  geoname_id: 490029, population: 0)
province = region.provinces.create(description: "El'brusskiy Rayon", country: state, continent: continent,  geoname_id: 825097, population: 0)
municipalities = [
province.municipalities.new(description: "El'brus", region: region, country: state, continent: continent, geoname_id: 563534, population: 3300),
province.municipalities.new(description: "Tegenekli", region: region, country: state, continent: continent, geoname_id: 795309, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Nal'chik", country: state, continent: continent,  geoname_id: 825098, population: 0)
municipalities = [
province.municipalities.new(description: "Nal'chik", region: region, country: state, continent: continent, geoname_id: 523523, population: 272800),
]
Municipality.import municipalities
province = region.provinces.create(description: "Mayskiy Rayon", country: state, continent: continent,  geoname_id: 528218, population: 0)
province = region.provinces.create(description: "Prokhladnenskiy Rayon", country: state, continent: continent,  geoname_id: 504938, population: 0)
province = region.provinces.create(description: "Terskiy Rayon", country: state, continent: continent,  geoname_id: 483273, population: 0)
province = region.provinces.create(description: "Urvanskiy Rayon", country: state, continent: continent,  geoname_id: 478559, population: 0)
province = region.provinces.create(description: "Zol'skiy Rayon", country: state, continent: continent,  geoname_id: 462156, population: 0)
region = Region.create(description: "Kaliningradskaya Oblast'", country: state, continent: continent, geoname_id: 554230)
province = region.provinces.create(description: "Bagrationovskiy Rayon", country: state, continent: continent,  geoname_id: 579759, population: 0)
province = region.provinces.create(description: "Chernyakhovskiy Rayon", country: state, continent: continent,  geoname_id: 568594, population: 0)
province = region.provinces.create(description: "Gorod Baltiysk", country: state, continent: continent,  geoname_id: 3233216, population: 0)
province = region.provinces.create(description: "Gorod Chernyakhovsk", country: state, continent: continent,  geoname_id: 825119, population: 0)
province = region.provinces.create(description: "Gorod Gusev", country: state, continent: continent,  geoname_id: 825120, population: 0)
province = region.provinces.create(description: "Gorod Kaliningrad", country: state, continent: continent,  geoname_id: 825118, population: 0)
municipalities = [
province.municipalities.new(description: "Baltiysk", region: region, country: state, continent: continent, geoname_id: 2609906, population: 34540),
province.municipalities.new(description: "Kaliningrad", region: region, country: state, continent: continent, geoname_id: 554234, population: 434954),
province.municipalities.new(description: "Pionerskiy", region: region, country: state, continent: continent, geoname_id: 509437, population: 11856),
province.municipalities.new(description: "Yantarnyy", region: region, country: state, continent: continent, geoname_id: 2609894, population: 5527),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Neman", country: state, continent: continent,  geoname_id: 825114, population: 0)
province = region.provinces.create(description: "Gorod Pionerskiy", country: state, continent: continent,  geoname_id: 825116, population: 0)
province = region.provinces.create(description: "Gorod Sovetsk", country: state, continent: continent,  geoname_id: 825113, population: 0)
province = region.provinces.create(description: "Gorod Svetlogorsk", country: state, continent: continent,  geoname_id: 825115, population: 0)
municipalities = [
province.municipalities.new(description: "Svetlogorsk", region: region, country: state, continent: continent, geoname_id: 485699, population: 11000),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gorod Svetlyy", country: state, continent: continent,  geoname_id: 825117, population: 0)
province = region.provinces.create(description: "Gur'yevskiy Rayon", country: state, continent: continent,  geoname_id: 557904, population: 0)
province = region.provinces.create(description: "Gusevskiy Rayon", country: state, continent: continent,  geoname_id: 557841, population: 0)
province = region.provinces.create(description: "Gvardeyskiy Rayon", country: state, continent: continent,  geoname_id: 557707, population: 0)
province = region.provinces.create(description: "Krasnoznamenskiy Rayon", country: state, continent: continent,  geoname_id: 541941, population: 0)
province = region.provinces.create(description: "Nemanskiy Rayon", country: state, continent: continent,  geoname_id: 522740, population: 0)
province = region.provinces.create(description: "Nesterovskiy Rayon", country: state, continent: continent,  geoname_id: 522467, population: 0)
province = region.provinces.create(description: "Ozerskiy Rayon", country: state, continent: continent,  geoname_id: 513394, population: 0)
province = region.provinces.create(description: "Polesskiy Rayon", country: state, continent: continent,  geoname_id: 507290, population: 0)
province = region.provinces.create(description: "Pravdinskiy Rayon", country: state, continent: continent,  geoname_id: 505596, population: 0)
province = region.provinces.create(description: "Slavskiy Rayon", country: state, continent: continent,  geoname_id: 492111, population: 0)
province = region.provinces.create(description: "Zelenogradskiy Rayon", country: state, continent: continent,  geoname_id: 463825, population: 0)
municipalities = [
province.municipalities.new(description: "Morskoye", region: region, country: state, continent: continent, geoname_id: 525121, population: 300),
province.municipalities.new(description: "Zelenogradsk", region: region, country: state, continent: continent, geoname_id: 463828, population: 12846),
]
Municipality.import municipalities
region = Region.create(description: "Kalmykiya", country: state, continent: continent, geoname_id: 553972)
province = region.provinces.create(description: "Adyk", country: state, continent: continent,  geoname_id: 584219, population: 0)
province = region.provinces.create(description: "Akhnud", country: state, continent: continent,  geoname_id: 583828, population: 0)
province = region.provinces.create(description: "Altn-Bulg", country: state, continent: continent,  geoname_id: 582366, population: 0)
province = region.provinces.create(description: "Amur-Sanan", country: state, continent: continent,  geoname_id: 582226, population: 0)
province = region.provinces.create(description: "Andratinskiy", country: state, continent: continent,  geoname_id: 805935, population: 0)
province = region.provinces.create(description: "Arshan'", country: state, continent: continent,  geoname_id: 580862, population: 3542)
province = region.provinces.create(description: "Artezian", country: state, continent: continent,  geoname_id: 580786, population: 0)
province = region.provinces.create(description: "Baga Tugtun", country: state, continent: continent,  geoname_id: 579778, population: 0)
province = region.provinces.create(description: "Baga-Burul", country: state, continent: continent,  geoname_id: 579788, population: 0)
province = region.provinces.create(description: "Balkovskiy", country: state, continent: continent,  geoname_id: 579406, population: 0)
province = region.provinces.create(description: "Balkovskiy", country: state, continent: continent,  geoname_id: 579407, population: 0)
province = region.provinces.create(description: "Barun", country: state, continent: continent,  geoname_id: 578958, population: 0)
province = region.provinces.create(description: "Basy", country: state, continent: continent,  geoname_id: 578769, population: 0)
province = region.provinces.create(description: "Berezovskiy", country: state, continent: continent,  geoname_id: 576875, population: 0)
province = region.provinces.create(description: "Bor Nur", country: state, continent: continent,  geoname_id: 572305, population: 0)
province = region.provinces.create(description: "Bugu", country: state, continent: continent,  geoname_id: 571173, population: 0)
province = region.provinces.create(description: "Bulg", country: state, continent: continent,  geoname_id: 839573, population: 0)
province = region.provinces.create(description: "Burannyy", country: state, continent: continent,  geoname_id: 570885, population: 0)
province = region.provinces.create(description: "Buratinskiy", country: state, continent: continent,  geoname_id: 570874, population: 0)
province = region.provinces.create(description: "Burgsun", country: state, continent: continent,  geoname_id: 570818, population: 0)
province = region.provinces.create(description: "Burgusta", country: state, continent: continent,  geoname_id: 570815, population: 0)
province = region.provinces.create(description: "Burgusun", country: state, continent: continent,  geoname_id: 803719, population: 0)
province = region.provinces.create(description: "Burul", country: state, continent: continent,  geoname_id: 518984, population: 0)
province = region.provinces.create(description: "Charlakta", country: state, continent: continent,  geoname_id: 507258, population: 0)
province = region.provinces.create(description: "Chernozemel'skiy", country: state, continent: continent,  geoname_id: 568627, population: 0)
province = region.provinces.create(description: "Chilgir", country: state, continent: continent,  geoname_id: 568155, population: 0)
province = region.provinces.create(description: "Chkalovskiy", country: state, continent: continent,  geoname_id: 567899, population: 0)
province = region.provinces.create(description: "Cholun Khamur", country: state, continent: continent,  geoname_id: 839560, population: 0)
province = region.provinces.create(description: "Chompot", country: state, continent: continent,  geoname_id: 567863, population: 0)
province = region.provinces.create(description: "Dmitriyevskoye", country: state, continent: continent,  geoname_id: 565978, population: 0)
province = region.provinces.create(description: "Dogzmakin", country: state, continent: continent,  geoname_id: 565741, population: 0)
province = region.provinces.create(description: "Dolan", country: state, continent: continent,  geoname_id: 565723, population: 0)
province = region.provinces.create(description: "Dotseng", country: state, continent: continent,  geoname_id: 565099, population: 0)
province = region.provinces.create(description: "Druzhnyy", country: state, continent: continent,  geoname_id: 564853, population: 0)
province = region.provinces.create(description: "Druzhnyy", country: state, continent: continent,  geoname_id: 564855, population: 0)
province = region.provinces.create(description: "Dzhalykovo", country: state, continent: continent,  geoname_id: 563675, population: 0)
province = region.provinces.create(description: "Dzhedzhik", country: state, continent: continent,  geoname_id: 563641, population: 0)
province = region.provinces.create(description: "Dzhedzhikiny", country: state, continent: continent,  geoname_id: 563642, population: 0)
province = region.provinces.create(description: "Elista", country: state, continent: continent,  geoname_id: 563514, population: 106971)
province = region.provinces.create(description: "Erketeno", country: state, continent: continent,  geoname_id: 804214, population: 0)
province = region.provinces.create(description: "Esto-Altay", country: state, continent: continent,  geoname_id: 563406, population: 0)
province = region.provinces.create(description: "Evdik", country: state, continent: continent,  geoname_id: 563390, population: 0)
province = region.provinces.create(description: "Gashun", country: state, continent: continent,  geoname_id: 561901, population: 0)
province = region.provinces.create(description: "Godzhur", country: state, continent: continent,  geoname_id: 560854, population: 0)
province = region.provinces.create(description: "Godzhur", country: state, continent: continent,  geoname_id: 803902, population: 0)
province = region.provinces.create(description: "Gorodoviki", country: state, continent: continent,  geoname_id: 559478, population: 10706)
province = region.provinces.create(description: "Gorodovikovo", country: state, continent: continent,  geoname_id: 559476, population: 0)
province = region.provinces.create(description: "Gorodovikovsk", country: state, continent: continent,  geoname_id: 559475, population: 9809)
municipalities = [
province.municipalities.new(description: "Don-Ural", region: region, country: state, continent: continent, geoname_id: 565273, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Gyudik", country: state, continent: continent,  geoname_id: 557667, population: 0)
province = region.provinces.create(description: "Iki Chonos", country: state, continent: continent,  geoname_id: 557409, population: 0)
province = region.provinces.create(description: "Iki-Burul", country: state, continent: continent,  geoname_id: 557413, population: 3709)
province = region.provinces.create(description: "Iki-Malan", country: state, continent: continent,  geoname_id: 557408, population: 0)
province = region.provinces.create(description: "Kanukovo", country: state, continent: continent,  geoname_id: 553091, population: 0)
province = region.provinces.create(description: "Karakul'", country: state, continent: continent,  geoname_id: 552834, population: 0)
province = region.provinces.create(description: "Karantin", country: state, continent: continent,  geoname_id: 552751, population: 0)
province = region.provinces.create(description: "Kegul'ta", country: state, continent: continent,  geoname_id: 551220, population: 0)
province = region.provinces.create(description: "Kenkrya", country: state, continent: continent,  geoname_id: 551087, population: 0)
province = region.provinces.create(description: "Kevyudy", country: state, continent: continent,  geoname_id: 551254, population: 0)
province = region.provinces.create(description: "Khanata", country: state, continent: continent,  geoname_id: 550754, population: 0)
province = region.provinces.create(description: "Kharba", country: state, continent: continent,  geoname_id: 550654, population: 0)
province = region.provinces.create(description: "Khargata", country: state, continent: continent,  geoname_id: 538826, population: 0)
province = region.provinces.create(description: "Khazyk Khulsuk", country: state, continent: continent,  geoname_id: 550384, population: 0)
province = region.provinces.create(description: "Khomutnikov", country: state, continent: continent,  geoname_id: 549620, population: 0)
province = region.provinces.create(description: "Khoyr-Khuduk", country: state, continent: continent,  geoname_id: 549317, population: 0)
province = region.provinces.create(description: "Khulkhuta", country: state, continent: continent,  geoname_id: 549123, population: 0)
province = region.provinces.create(description: "Kirovskiy", country: state, continent: continent,  geoname_id: 548385, population: 0)
province = region.provinces.create(description: "Kirovskiy", country: state, continent: continent,  geoname_id: 548386, population: 0)
province = region.provinces.create(description: "Kista", country: state, continent: continent,  geoname_id: 803726, population: 0)
province = region.provinces.create(description: "Komsomol'skiy", country: state, continent: continent,  geoname_id: 545727, population: 0)
province = region.provinces.create(description: "Korobkin", country: state, continent: continent,  geoname_id: 544741, population: 0)
province = region.provinces.create(description: "Kovyl'nyy", country: state, continent: continent,  geoname_id: 543431, population: 0)
province = region.provinces.create(description: "Krasinskoye", country: state, continent: continent,  geoname_id: 542858, population: 0)
province = region.provinces.create(description: "Krasnomikhaylovskoye", country: state, continent: continent,  geoname_id: 542295, population: 0)
province = region.provinces.create(description: "Krasnopol'ye", country: state, continent: continent,  geoname_id: 542265, population: 0)
province = region.provinces.create(description: "Krasnoye Selo", country: state, continent: continent,  geoname_id: 542006, population: 0)
province = region.provinces.create(description: "Krasnyy Manych", country: state, continent: continent,  geoname_id: 541616, population: 0)
province = region.provinces.create(description: "Krasnyy Partizan", country: state, continent: continent,  geoname_id: 541485, population: 0)
province = region.provinces.create(description: "Kumskiy", country: state, continent: continent,  geoname_id: 539242, population: 0)
province = region.provinces.create(description: "Kumskoy", country: state, continent: continent,  geoname_id: 539243, population: 0)
province = region.provinces.create(description: "Kurdyukov", country: state, continent: continent,  geoname_id: 538888, population: 0)
province = region.provinces.create(description: "Kurgannoye", country: state, continent: continent,  geoname_id: 538830, population: 0)
province = region.provinces.create(description: "Kurnakov", country: state, continent: continent,  geoname_id: 538660, population: 0)
province = region.provinces.create(description: "Kurtkuk", country: state, continent: continent,  geoname_id: 538531, population: 0)
province = region.provinces.create(description: "Lagan", country: state, continent: continent,  geoname_id: 551846, population: 14045)
province = region.provinces.create(description: "Lala", country: state, continent: continent,  geoname_id: 537097, population: 0)
province = region.provinces.create(description: "Leninskiy", country: state, continent: continent,  geoname_id: 536134, population: 0)
province = region.provinces.create(description: "Maksimovskiy", country: state, continent: continent,  geoname_id: 531882, population: 0)
province = region.provinces.create(description: "Maloye", country: state, continent: continent,  geoname_id: 530845, population: 0)
province = region.provinces.create(description: "Malye Derbety", country: state, continent: continent,  geoname_id: 530196, population: 5822)
province = region.provinces.create(description: "Mandzhikiny", country: state, continent: continent,  geoname_id: 529584, population: 0)
province = region.provinces.create(description: "Mants", country: state, continent: continent,  geoname_id: 529512, population: 0)
province = region.provinces.create(description: "Mantsin-Kets", country: state, continent: continent,  geoname_id: 839559, population: 0)
province = region.provinces.create(description: "Manych", country: state, continent: continent,  geoname_id: 529475, population: 0)
province = region.provinces.create(description: "Manychskiy", country: state, continent: continent,  geoname_id: 529462, population: 0)
province = region.provinces.create(description: "Matrosovo", country: state, continent: continent,  geoname_id: 528566, population: 0)
province = region.provinces.create(description: "Mayskiy", country: state, continent: continent,  geoname_id: 528243, population: 0)
province = region.provinces.create(description: "Modta", country: state, continent: continent,  geoname_id: 524754, population: 0)
province = region.provinces.create(description: "Molodezhnyy", country: state, continent: continent,  geoname_id: 797048, population: 0)
province = region.provinces.create(description: "Mumantsin", country: state, continent: continent,  geoname_id: 524475, population: 0)
province = region.provinces.create(description: "Naryn Khuduk", country: state, continent: continent,  geoname_id: 523387, population: 0)
province = region.provinces.create(description: "Neyfel'd", country: state, continent: continent,  geoname_id: 522339, population: 0)
province = region.provinces.create(description: "Obil'noye", country: state, continent: continent,  geoname_id: 516481, population: 0)
province = region.provinces.create(description: "Oktyabr'skiy", country: state, continent: continent,  geoname_id: 515914, population: 0)
province = region.provinces.create(description: "Oktyabr'skiy", country: state, continent: continent,  geoname_id: 515915, population: 0)
province = region.provinces.create(description: "Oling", country: state, continent: continent,  geoname_id: 515560, population: 0)
province = region.provinces.create(description: "Partizanskiy", country: state, continent: continent,  geoname_id: 512469, population: 0)
province = region.provinces.create(description: "Peredovoy", country: state, continent: continent,  geoname_id: 802287, population: 0)
province = region.provinces.create(description: "Peresheyechnyy", country: state, continent: continent,  geoname_id: 511367, population: 0)
province = region.provinces.create(description: "Pervomayskiy", country: state, continent: continent,  geoname_id: 510970, population: 0)
province = region.provinces.create(description: "Pervomayskoye", country: state, continent: continent,  geoname_id: 510840, population: 0)
province = region.provinces.create(description: "Peschanyy", country: state, continent: continent,  geoname_id: 510586, population: 0)
province = region.provinces.create(description: "Plodovitoye", country: state, continent: continent,  geoname_id: 508928, population: 0)
province = region.provinces.create(description: "Podgornyy", country: state, continent: continent,  geoname_id: 508335, population: 0)
province = region.provinces.create(description: "Pogranichnoye", country: state, continent: continent,  geoname_id: 507680, population: 0)
province = region.provinces.create(description: "Polevoye", country: state, continent: continent,  geoname_id: 507259, population: 0)
province = region.provinces.create(description: "Polynnyy", country: state, continent: continent,  geoname_id: 506754, population: 0)
province = region.provinces.create(description: "Pravyy Ostrov", country: state, continent: continent,  geoname_id: 505572, population: 0)
province = region.provinces.create(description: "Pridorozhnyy", country: state, continent: continent,  geoname_id: 505411, population: 0)
province = region.provinces.create(description: "Prikumskiy", country: state, continent: continent,  geoname_id: 505338, population: 0)
province = region.provinces.create(description: "Primanych", country: state, continent: continent,  geoname_id: 505278, population: 0)
province = region.provinces.create(description: "Primanychskiy", country: state, continent: continent,  geoname_id: 505277, population: 0)
province = region.provinces.create(description: "Priozërnyy", country: state, continent: continent,  geoname_id: 505236, population: 0)
province = region.provinces.create(description: "Privol'nyy", country: state, continent: continent,  geoname_id: 505095, population: 0)
province = region.provinces.create(description: "Priyutnoye", country: state, continent: continent,  geoname_id: 505019, population: 5632)
province = region.provinces.create(description: "Proletarskiy", country: state, continent: continent,  geoname_id: 504809, population: 0)
province = region.provinces.create(description: "Proletarskiy", country: state, continent: continent,  geoname_id: 504810, population: 0)
province = region.provinces.create(description: "Prudovyy", country: state, continent: continent,  geoname_id: 504480, population: 0)
province = region.provinces.create(description: "Prudovyy", country: state, continent: continent,  geoname_id: 839529, population: 0)
province = region.provinces.create(description: "Prutnyak", country: state, continent: continent,  geoname_id: 504435, population: 0)
province = region.provinces.create(description: "Pushkinskoye", country: state, continent: continent,  geoname_id: 503961, population: 0)
province = region.provinces.create(description: "Putevoye", country: state, continent: continent,  geoname_id: 503773, population: 0)
province = region.provinces.create(description: "Rovnoye", country: state, continent: continent,  geoname_id: 501093, population: 0)
province = region.provinces.create(description: "Rozental'", country: state, continent: continent,  geoname_id: 501053, population: 0)
province = region.provinces.create(description: "Sadovoye", country: state, continent: continent,  geoname_id: 499535, population: 6333)
province = region.provinces.create(description: "Samtunskiy", country: state, continent: continent,  geoname_id: 498910, population: 0)
province = region.provinces.create(description: "Sarakha", country: state, continent: continent,  geoname_id: 498709, population: 0)
province = region.provinces.create(description: "Sarpinskiy", country: state, continent: continent,  geoname_id: 498508, population: 0)
province = region.provinces.create(description: "Sarvadyk", country: state, continent: continent,  geoname_id: 498477, population: 0)
province = region.provinces.create(description: "Savin", country: state, continent: continent,  geoname_id: 498309, population: 0)
province = region.provinces.create(description: "Senokosnoye", country: state, continent: continent,  geoname_id: 497000, population: 0)
province = region.provinces.create(description: "Sen'-Mantsyn", country: state, continent: continent,  geoname_id: 497039, population: 0)
province = region.provinces.create(description: "Serebryakovo", country: state, continent: continent,  geoname_id: 496914, population: 0)
province = region.provinces.create(description: "Sertin", country: state, continent: continent,  geoname_id: 496521, population: 0)
province = region.provinces.create(description: "Severnoye", country: state, continent: continent,  geoname_id: 496384, population: 0)
province = region.provinces.create(description: "Severnoye", country: state, continent: continent,  geoname_id: 496383, population: 0)
province = region.provinces.create(description: "Severnyy", country: state, continent: continent,  geoname_id: 496360, population: 0)
province = region.provinces.create(description: "Shar-Davr", country: state, continent: continent,  geoname_id: 495726, population: 0)
province = region.provinces.create(description: "Shara-Ulyun", country: state, continent: continent,  geoname_id: 495733, population: 0)
province = region.provinces.create(description: "Sharnutovskiy", country: state, continent: continent,  geoname_id: 495658, population: 0)
province = region.provinces.create(description: "Sharon", country: state, continent: continent,  geoname_id: 495652, population: 0)
province = region.provinces.create(description: "Sharshun", country: state, continent: continent,  geoname_id: 495634, population: 0)
province = region.provinces.create(description: "Shatta", country: state, continent: continent,  geoname_id: 495527, population: 0)
province = region.provinces.create(description: "Shatta", country: state, continent: continent,  geoname_id: 839537, population: 0)
province = region.provinces.create(description: "Shatta", country: state, continent: continent,  geoname_id: 495528, population: 0)
province = region.provinces.create(description: "Shen-Khor", country: state, continent: continent,  geoname_id: 494885, population: 0)
province = region.provinces.create(description: "Sheret", country: state, continent: continent,  geoname_id: 839553, population: 0)
province = region.provinces.create(description: "Shin Byadl", country: state, continent: continent,  geoname_id: 839885, population: 0)
province = region.provinces.create(description: "Shinkashara", country: state, continent: continent,  geoname_id: 494341, population: 0)
province = region.provinces.create(description: "Sladkiy", country: state, continent: continent,  geoname_id: 492186, population: 0)
province = region.provinces.create(description: "Smushkovoye", country: state, continent: continent,  geoname_id: 491600, population: 0)
province = region.provinces.create(description: "Solnechnyy", country: state, continent: continent,  geoname_id: 490988, population: 0)
province = region.provinces.create(description: "Solënoye", country: state, continent: continent,  geoname_id: 491052, population: 0)
province = region.provinces.create(description: "Sostinskiy", country: state, continent: continent,  geoname_id: 490147, population: 0)
province = region.provinces.create(description: "Sovetskoye", country: state, continent: continent,  geoname_id: 489994, population: 3834)
province = region.provinces.create(description: "Sredneye Selo", country: state, continent: continent,  geoname_id: 489571, population: 0)
province = region.provinces.create(description: "Staroye Olenichevo", country: state, continent: continent,  geoname_id: 488370, population: 0)
province = region.provinces.create(description: "Svetlyy", country: state, continent: continent,  geoname_id: 485667, population: 0)
province = region.provinces.create(description: "Tatal", country: state, continent: continent,  geoname_id: 484182, population: 0)
province = region.provinces.create(description: "Tavn Gashun", country: state, continent: continent,  geoname_id: 483968, population: 0)
province = region.provinces.create(description: "Ternovoy", country: state, continent: continent,  geoname_id: 483333, population: 0)
province = region.provinces.create(description: "Troitskoye", country: state, continent: continent,  geoname_id: 481542, population: 10025)
province = region.provinces.create(description: "Tsagan Aman", country: state, continent: continent,  geoname_id: 481117, population: 5769)
province = region.provinces.create(description: "Tsagan Usun", country: state, continent: continent,  geoname_id: 481113, population: 0)
province = region.provinces.create(description: "Tselinnyy", country: state, continent: continent,  geoname_id: 481032, population: 0)
province = region.provinces.create(description: "Tsoros", country: state, continent: continent,  geoname_id: 480821, population: 0)
province = region.provinces.create(description: "Tugtun", country: state, continent: continent,  geoname_id: 480650, population: 0)
province = region.provinces.create(description: "Ul'dyuchiny", country: state, continent: continent,  geoname_id: 479280, population: 0)
province = region.provinces.create(description: "Ul'yanovskoye", country: state, continent: continent,  geoname_id: 479104, population: 0)
province = region.provinces.create(description: "Ulan Erge", country: state, continent: continent,  geoname_id: 479302, population: 0)
province = region.provinces.create(description: "Ulan Khol", country: state, continent: continent,  geoname_id: 479299, population: 0)
province = region.provinces.create(description: "Ulan-Kheyechi", country: state, continent: continent,  geoname_id: 479300, population: 0)
province = region.provinces.create(description: "Umantsevo", country: state, continent: continent,  geoname_id: 479077, population: 0)
province = region.provinces.create(description: "Ungun-Teryachi", country: state, continent: continent,  geoname_id: 478997, population: 0)
province = region.provinces.create(description: "Ut Sala", country: state, continent: continent,  geoname_id: 477683, population: 0)
province = region.provinces.create(description: "Utta", country: state, continent: continent,  geoname_id: 477680, population: 0)
province = region.provinces.create(description: "Vasil'yev", country: state, continent: continent,  geoname_id: 476726, population: 0)
province = region.provinces.create(description: "Verkhniy Sal", country: state, continent: continent,  geoname_id: 474857, population: 0)
province = region.provinces.create(description: "Verkhniy Yashkul'", country: state, continent: continent,  geoname_id: 474777, population: 0)
province = region.provinces.create(description: "Vesëloye", country: state, continent: continent,  geoname_id: 474110, population: 0)
province = region.provinces.create(description: "Vinogradnoye", country: state, continent: continent,  geoname_id: 473550, population: 0)
province = region.provinces.create(description: "Vorob'yëvka", country: state, continent: continent,  geoname_id: 472117, population: 0)
province = region.provinces.create(description: "Voskresenskoye", country: state, continent: continent,  geoname_id: 471640, population: 0)
province = region.provinces.create(description: "Voznesenovka", country: state, continent: continent,  geoname_id: 471200, population: 0)
province = region.provinces.create(description: "Yashalta", country: state, continent: continent,  geoname_id: 468776, population: 4723)
province = region.provinces.create(description: "Yashkul'", country: state, continent: continent,  geoname_id: 468747, population: 7203)
province = region.provinces.create(description: "Yergeninskiy", country: state, continent: continent,  geoname_id: 467331, population: 0)
province = region.provinces.create(description: "Yusta", country: state, continent: continent,  geoname_id: 466135, population: 0)
province = region.provinces.create(description: "Yuzhnyy", country: state, continent: continent,  geoname_id: 541617, population: 0)
province = region.provinces.create(description: "Zaagin Sala", country: state, continent: continent,  geoname_id: 465999, population: 0)
province = region.provinces.create(description: "Zernovoye", country: state, continent: continent,  geoname_id: 463628, population: 0)
region = Region.create(description: "Kaluzhskaya Oblast'", country: state, continent: continent, geoname_id: 553899)
province = region.provinces.create(description: "Babyninskiy Rayon", country: state, continent: continent,  geoname_id: 579834, population: 0)
province = region.provinces.create(description: "Baryatinskiy Rayon", country: state, continent: continent,  geoname_id: 578944, population: 0)
province = region.provinces.create(description: "Duminichskiy Rayon", country: state, continent: continent,  geoname_id: 564189, population: 0)
province = region.provinces.create(description: "Dzerzhinskiy Rayon", country: state, continent: continent,  geoname_id: 563697, population: 0)
province = region.provinces.create(description: "Ferzikovskiy Rayon", country: state, continent: continent,  geoname_id: 562871, population: 0)
province = region.provinces.create(description: "Kirovskiy Rayon", country: state, continent: continent,  geoname_id: 548363, population: 0)
province = region.provinces.create(description: "Kozel'skiy Rayon", country: state, continent: continent,  geoname_id: 543347, population: 0)
province = region.provinces.create(description: "Lyudinovskiy Rayon", country: state, continent: continent,  geoname_id: 532457, population: 0)
province = region.provinces.create(description: "Maloyaroslavetskiy Rayon", country: state, continent: continent,  geoname_id: 530848, population: 0)
province = region.provinces.create(description: "Meshchovskiy Rayon", country: state, continent: continent,  geoname_id: 527404, population: 0)
province = region.provinces.create(description: "Mosal'skiy Rayon", country: state, continent: continent,  geoname_id: 525083, population: 0)
province = region.provinces.create(description: "Peremyshl'skiy Rayon", country: state, continent: continent,  geoname_id: 511399, population: 0)
province = region.provinces.create(description: "Spas-Demenskiy Rayon", country: state, continent: continent,  geoname_id: 489867, population: 0)
province = region.provinces.create(description: "Sukhinichskiy Rayon", country: state, continent: continent,  geoname_id: 486662, population: 0)
province = region.provinces.create(description: "Tarusskiy Rayon", country: state, continent: continent,  geoname_id: 484282, population: 15314)
province = region.provinces.create(description: "Yukhnovskiy Rayon", country: state, continent: continent,  geoname_id: 466653, population: 0)
province = region.provinces.create(description: "Zhizdrinskiy Rayon", country: state, continent: continent,  geoname_id: 462912, population: 0)
region = Region.create(description: "Kamtchatski Kray", country: state, continent: continent, geoname_id: 2125072)
province = region.provinces.create(description: "Koryakskiy Okrug", country: state, continent: continent,  geoname_id: 2124279, population: 0)
municipalities = [
province.municipalities.new(description: "Palana", region: region, country: state, continent: continent, geoname_id: 2122262, population: 3671),
]
Municipality.import municipalities
region = Region.create(description: "Karachayevo-Cherkesiya", country: state, continent: continent, geoname_id: 552927)
province = region.provinces.create(description: "Abaza-Khabl'", country: state, continent: continent,  geoname_id: 584497, population: 0)
province = region.provinces.create(description: "Abazakt", country: state, continent: continent,  geoname_id: 584496, population: 0)
province = region.provinces.create(description: "Adil'-Khalk", country: state, continent: continent,  geoname_id: 584250, population: 0)
province = region.provinces.create(description: "Adyge-Khabl'", country: state, continent: continent,  geoname_id: 584221, population: 3666)
province = region.provinces.create(description: "Akhalsheni", country: state, continent: continent,  geoname_id: 799645, population: 0)
province = region.provinces.create(description: "Aksu", country: state, continent: continent,  geoname_id: 841307, population: 0)
province = region.provinces.create(description: "Aktyube", country: state, continent: continent,  geoname_id: 865507, population: 0)
province = region.provinces.create(description: "Ali-Berdukovskiy", country: state, continent: continent,  geoname_id: 582544, population: 5093)
province = region.provinces.create(description: "Apsua", country: state, continent: continent,  geoname_id: 581309, population: 0)
province = region.provinces.create(description: "Arkhyz", country: state, continent: continent,  geoname_id: 580939, population: 600)
province = region.provinces.create(description: "Aziatskiy", country: state, continent: continent,  geoname_id: 580083, population: 0)
province = region.provinces.create(description: "Baralki", country: state, continent: continent,  geoname_id: 579274, population: 0)
province = region.provinces.create(description: "Bavuko", country: state, continent: continent,  geoname_id: 841042, population: 0)
province = region.provinces.create(description: "Belaya Gora", country: state, continent: continent,  geoname_id: 868694, population: 0)
province = region.provinces.create(description: "Beskes", country: state, continent: continent,  geoname_id: 576703, population: 0)
province = region.provinces.create(description: "Besleney", country: state, continent: continent,  geoname_id: 576695, population: 3189)
province = region.provinces.create(description: "Bogoslovka", country: state, continent: continent,  geoname_id: 865505, population: 0)
province = region.provinces.create(description: "Bol'shaya Azhoga", country: state, continent: continent,  geoname_id: 575217, population: 0)
province = region.provinces.create(description: "Bol'shevik", country: state, continent: continent,  geoname_id: 799502, population: 0)
province = region.provinces.create(description: "Bukovyy Uchastok", country: state, continent: continent,  geoname_id: 571089, population: 0)
province = region.provinces.create(description: "Chapayevskoye", country: state, continent: continent,  geoname_id: 569978, population: 0)
province = region.provinces.create(description: "Cherkessk", country: state, continent: continent,  geoname_id: 569154, population: 116224)
municipalities = [
province.municipalities.new(description: "Yubileynyy", region: region, country: state, continent: continent, geoname_id: 7889335, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Damkhurts", country: state, continent: continent,  geoname_id: 864185, population: 0)
province = region.provinces.create(description: "Dausuz", country: state, continent: continent,  geoname_id: 567014, population: 0)
province = region.provinces.create(description: "Dombay", country: state, continent: continent,  geoname_id: 565405, population: 405)
province = region.provinces.create(description: "Druzhba", country: state, continent: continent,  geoname_id: 564929, population: 3153)
province = region.provinces.create(description: "Dubyanskiy", country: state, continent: continent,  geoname_id: 564322, population: 0)
province = region.provinces.create(description: "Dzhaga", country: state, continent: continent,  geoname_id: 563691, population: 0)
province = region.provinces.create(description: "Dzhaga", country: state, continent: continent,  geoname_id: 563692, population: 0)
province = region.provinces.create(description: "Dzhazlyk", country: state, continent: continent,  geoname_id: 563644, population: 0)
province = region.provinces.create(description: "Dzhegonas", country: state, continent: continent,  geoname_id: 563639, population: 0)
province = region.provinces.create(description: "Dzheguta", country: state, continent: continent,  geoname_id: 563637, population: 0)
province = region.provinces.create(description: "Dzhingirik", country: state, continent: continent,  geoname_id: 563611, population: 0)
province = region.provinces.create(description: "El'brusskiy", country: state, continent: continent,  geoname_id: 563531, population: 0)
province = region.provinces.create(description: "El'kush", country: state, continent: continent,  geoname_id: 563510, population: 0)
province = region.provinces.create(description: "El'tarkach", country: state, continent: continent,  geoname_id: 563497, population: 0)
province = region.provinces.create(description: "El'burgan", country: state, continent: continent,  geoname_id: 563530, population: 0)
province = region.provinces.create(description: "Erken-Khalk", country: state, continent: continent,  geoname_id: 563436, population: 0)
province = region.provinces.create(description: "Erken-Shakhar", country: state, continent: continent,  geoname_id: 563435, population: 0)
province = region.provinces.create(description: "Erken-Yurt", country: state, continent: continent,  geoname_id: 563433, population: 0)
province = region.provinces.create(description: "Ersakon", country: state, continent: continent,  geoname_id: 563424, population: 0)
province = region.provinces.create(description: "Frolovskiy", country: state, continent: continent,  geoname_id: 562363, population: 0)
province = region.provinces.create(description: "Ikon-Khalk", country: state, continent: continent,  geoname_id: 557399, population: 4220)
province = region.provinces.create(description: "Il'inskiy", country: state, continent: continent,  geoname_id: 557153, population: 0)
province = region.provinces.create(description: "Il'ichëvskoye", country: state, continent: continent,  geoname_id: 805812, population: 0)
province = region.provinces.create(description: "Imeni Kosta Khetagurova", country: state, continent: continent,  geoname_id: 544015, population: 0)
province = region.provinces.create(description: "Inzhi-Chishkho", country: state, continent: continent,  geoname_id: 556272, population: 0)
province = region.provinces.create(description: "Inzhich-Chukun", country: state, continent: continent,  geoname_id: 556273, population: 0)
province = region.provinces.create(description: "Ispravnaya", country: state, continent: continent,  geoname_id: 555801, population: 4606)
province = region.provinces.create(description: "Ispravnaya", country: state, continent: continent,  geoname_id: 841082, population: 0)
province = region.provinces.create(description: "Itkol", country: state, continent: continent,  geoname_id: 795310, population: 0)
province = region.provinces.create(description: "Kamennomostskiy", country: state, continent: continent,  geoname_id: 553515, population: 0)
province = region.provinces.create(description: "Kara-Pago", country: state, continent: continent,  geoname_id: 552744, population: 0)
province = region.provinces.create(description: "Karachayevsk", country: state, continent: continent,  geoname_id: 552924, population: 20264)
province = region.provinces.create(description: "Kardonikskaya", country: state, continent: continent,  geoname_id: 552562, population: 7830)
province = region.provinces.create(description: "Kart-Dzhurt", country: state, continent: continent,  geoname_id: 552106, population: 0)
province = region.provinces.create(description: "Kavkazskiy", country: state, continent: continent,  geoname_id: 551667, population: 3052)
province = region.provinces.create(description: "Khabez", country: state, continent: continent,  geoname_id: 550868, population: 5806)
province = region.provinces.create(description: "Khabez", country: state, continent: continent,  geoname_id: 550867, population: 0)
province = region.provinces.create(description: "Khasaut", country: state, continent: continent,  geoname_id: 550481, population: 0)
province = region.provinces.create(description: "Khasaut-Grecheskoye", country: state, continent: continent,  geoname_id: 550479, population: 0)
province = region.provinces.create(description: "Kholodnorodnikovskoye", country: state, continent: continent,  geoname_id: 549703, population: 0)
municipalities = [
province.municipalities.new(description: "Gandroburovskiy", region: region, country: state, continent: continent, geoname_id: 562055, population: 0),
province.municipalities.new(description: "Issayevskiy", region: region, country: state, continent: continent, geoname_id: 555792, population: 0),
province.municipalities.new(description: "Pritulinskiy", region: region, country: state, continent: continent, geoname_id: 505138, population: 0),
province.municipalities.new(description: "Ukleinskiy", region: region, country: state, continent: continent, geoname_id: 479364, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kholodnorodnikovskoye", country: state, continent: continent,  geoname_id: 841289, population: 0)
municipalities = [
province.municipalities.new(description: "Kravtsovskiy", region: region, country: state, continent: continent, geoname_id: 541275, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Khoperskiy", country: state, continent: continent,  geoname_id: 805844, population: 0)
province = region.provinces.create(description: "Khotodnyy", country: state, continent: continent,  geoname_id: 805837, population: 0)
municipalities = [
province.municipalities.new(description: "Il'ich", region: region, country: state, continent: continent, geoname_id: 557286, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Khudes", country: state, continent: continent,  geoname_id: 549166, population: 0)
province = region.provinces.create(description: "Khudes", country: state, continent: continent,  geoname_id: 795099, population: 0)
province = region.provinces.create(description: "Khumara", country: state, continent: continent,  geoname_id: 549117, population: 0)
province = region.provinces.create(description: "Khurzuk", country: state, continent: continent,  geoname_id: 549087, population: 0)
province = region.provinces.create(description: "Khusy-Kardonik", country: state, continent: continent,  geoname_id: 566339, population: 0)
province = region.provinces.create(description: "Kichi-Balyk", country: state, continent: continent,  geoname_id: 548812, population: 0)
province = region.provinces.create(description: "Kiyevo-Zhurakovskiy", country: state, continent: continent,  geoname_id: 548575, population: 0)
province = region.provinces.create(description: "Kizil'chuk", country: state, continent: continent,  geoname_id: 547859, population: 0)
province = region.provinces.create(description: "Kobu-Bashi", country: state, continent: continent,  geoname_id: 793815, population: 0)
province = region.provinces.create(description: "Kommuna Iskra Kavkaza", country: state, continent: continent,  geoname_id: 545803, population: 0)
province = region.provinces.create(description: "Kommunstroy", country: state, continent: continent,  geoname_id: 869257, population: 0)
province = region.provinces.create(description: "Kosh-Khabl'", country: state, continent: continent,  geoname_id: 544204, population: 0)
province = region.provinces.create(description: "Kotlyarovskiy", country: state, continent: continent,  geoname_id: 543668, population: 0)
province = region.provinces.create(description: "Koydan", country: state, continent: continent,  geoname_id: 543401, population: 0)
municipalities = [
province.municipalities.new(description: "Darkin", region: region, country: state, continent: continent, geoname_id: 567061, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Krasivyy", country: state, continent: continent,  geoname_id: 542846, population: 0)
province = region.provinces.create(description: "Krasnaya Zvezda", country: state, continent: continent,  geoname_id: 542533, population: 0)
province = region.provinces.create(description: "Krasnogorskaya", country: state, continent: continent,  geoname_id: 542373, population: 0)
province = region.provinces.create(description: "Krasnovostochnyy", country: state, continent: continent,  geoname_id: 542161, population: 0)
province = region.provinces.create(description: "Krasnyy Kurgan", country: state, continent: continent,  geoname_id: 541661, population: 3243)
province = region.provinces.create(description: "Kruglyy", country: state, continent: continent,  geoname_id: 540630, population: 0)
province = region.provinces.create(description: "Kuban-Khalk", country: state, continent: continent,  geoname_id: 805320, population: 0)
province = region.provinces.create(description: "Kubina", country: state, continent: continent,  geoname_id: 540031, population: 0)
province = region.provinces.create(description: "Kubran'", country: state, continent: continent,  geoname_id: 869209, population: 0)
province = region.provinces.create(description: "Kumysh", country: state, continent: continent,  geoname_id: 539218, population: 4306)
province = region.provinces.create(description: "Kurdzhinovo", country: state, continent: continent,  geoname_id: 538879, population: 4234)
province = region.provinces.create(description: "Kyzyl-Kala", country: state, continent: continent,  geoname_id: 537331, population: 0)
province = region.provinces.create(description: "Kyzyl-Oktyabr'skiy", country: state, continent: continent,  geoname_id: 537326, population: 3603)
province = region.provinces.create(description: "Kyzyl-Pokun", country: state, continent: continent,  geoname_id: 537324, population: 0)
province = region.provinces.create(description: "Kyzyl-Togay", country: state, continent: continent,  geoname_id: 547850, population: 0)
province = region.provinces.create(description: "Kyzyl-Urup", country: state, continent: continent,  geoname_id: 841079, population: 0)
province = region.provinces.create(description: "Kyzyl-Yurt", country: state, continent: continent,  geoname_id: 547848, population: 0)
province = region.provinces.create(description: "Leso-Kefar'", country: state, continent: continent,  geoname_id: 535666, population: 0)
province = region.provinces.create(description: "Lunnaya Polyana", country: state, continent: continent,  geoname_id: 869073, population: 0)
province = region.provinces.create(description: "Madniskhevi", country: state, continent: continent,  geoname_id: 795312, population: 0)
province = region.provinces.create(description: "Maloabazinka", country: state, continent: continent,  geoname_id: 805231, population: 0)
province = region.provinces.create(description: "Malokurgannyy", country: state, continent: continent,  geoname_id: 869208, population: 0)
province = region.provinces.create(description: "Malyy Zelenchuk", country: state, continent: continent,  geoname_id: 529724, population: 0)
province = region.provinces.create(description: "Marukha", country: state, continent: continent,  geoname_id: 528925, population: 0)
province = region.provinces.create(description: "Mayskiy", country: state, continent: continent,  geoname_id: 528247, population: 0)
province = region.provinces.create(description: "Mednogorskiy", country: state, continent: continent,  geoname_id: 864612, population: 4328)
province = region.provinces.create(description: "Michurinskiy", country: state, continent: continent,  geoname_id: 527189, population: 0)
province = region.provinces.create(description: "Molochnyy", country: state, continent: continent,  geoname_id: 525584, population: 0)
province = region.provinces.create(description: "Morkh", country: state, continent: continent,  geoname_id: 525265, population: 0)
province = region.provinces.create(description: "Mukhina", country: state, continent: continent,  geoname_id: 524567, population: 0)
province = region.provinces.create(description: "Musht", country: state, continent: continent,  geoname_id: 524208, population: 0)
province = region.provinces.create(description: "Nikolayevskoye", country: state, continent: continent,  geoname_id: 521845, population: 0)
municipalities = [
province.municipalities.new(description: "Bocharovskiy", region: region, country: state, continent: continent, geoname_id: 575825, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nikolinskoye", country: state, continent: continent,  geoname_id: 521819, population: 0)
province = region.provinces.create(description: "Nizhniy Arkhyz", country: state, continent: continent,  geoname_id: 520806, population: 2000)
province = region.provinces.create(description: "Nizhniy Beskes", country: state, continent: continent,  geoname_id: 520795, population: 0)
province = region.provinces.create(description: "Nizhniy Georgiyevskiy", country: state, continent: continent,  geoname_id: 805803, population: 0)
province = region.provinces.create(description: "Nizhnyaya Mara", country: state, continent: continent,  geoname_id: 520315, population: 0)
province = region.provinces.create(description: "Nizhnyaya Teberda", country: state, continent: continent,  geoname_id: 520215, population: 0)
province = region.provinces.create(description: "Nizhnyaya Yermolovka", country: state, continent: continent,  geoname_id: 520154, population: 0)
province = region.provinces.create(description: "Novaya Dzheguta", country: state, continent: continent,  geoname_id: 7433980, population: 0)
province = region.provinces.create(description: "Novaya Teberda", country: state, continent: continent,  geoname_id: 869210, population: 0)
province = region.provinces.create(description: "Novogeorgiyevskiy", country: state, continent: continent,  geoname_id: 518886, population: 0)
province = region.provinces.create(description: "Novoispravnenskoye", country: state, continent: continent,  geoname_id: 518831, population: 0)
province = region.provinces.create(description: "Novokhumarinskiy", country: state, continent: continent,  geoname_id: 518737, population: 0)
province = region.provinces.create(description: "Novokuvinskiy", country: state, continent: continent,  geoname_id: 518660, population: 0)
province = region.provinces.create(description: "Novourupskiy", country: state, continent: continent,  geoname_id: 517757, population: 0)
province = region.provinces.create(description: "Novyy", country: state, continent: continent,  geoname_id: 517262, population: 0)
province = region.provinces.create(description: "Novyy Karachay", country: state, continent: continent,  geoname_id: 517009, population: 2172)
province = region.provinces.create(description: "Oktyabr'skiy", country: state, continent: continent,  geoname_id: 515924, population: 0)
province = region.provinces.create(description: "Ordzhonikidzevskiy", country: state, continent: continent,  geoname_id: 515082, population: 3246)
province = region.provinces.create(description: "Pervomayskiy", country: state, continent: continent,  geoname_id: 510986, population: 0)
province = region.provinces.create(description: "Pervomayskoye", country: state, continent: continent,  geoname_id: 510842, population: 5345)
province = region.provinces.create(description: "Pkhiya", country: state, continent: continent,  geoname_id: 509162, population: 0)
province = region.provinces.create(description: "Plavni", country: state, continent: continent,  geoname_id: 841060, population: 0)
province = region.provinces.create(description: "Podskal'noye", country: state, continent: continent,  geoname_id: 839872, population: 0)
province = region.provinces.create(description: "Pravokubanskiy", country: state, continent: continent,  geoname_id: 865506, population: 2971)
province = region.provinces.create(description: "Predgornoye", country: state, continent: continent,  geoname_id: 505555, population: 0)
province = region.provinces.create(description: "Pregradnaya", country: state, continent: continent,  geoname_id: 505539, population: 6595)
province = region.provinces.create(description: "Prigorodnoye", country: state, continent: continent,  geoname_id: 505380, population: 0)
province = region.provinces.create(description: "Pristan'", country: state, continent: continent,  geoname_id: 505171, population: 0)
province = region.provinces.create(description: "Privol'nyy", country: state, continent: continent,  geoname_id: 841288, population: 0)
province = region.provinces.create(description: "Psauch'ye-Dakhe", country: state, continent: continent,  geoname_id: 504394, population: 0)
province = region.provinces.create(description: "Psemen", country: state, continent: continent,  geoname_id: 504382, population: 0)
province = region.provinces.create(description: "Psysh", country: state, continent: continent,  geoname_id: 504320, population: 0)
province = region.provinces.create(description: "Psyzh", country: state, continent: continent,  geoname_id: 504317, population: 6840)
province = region.provinces.create(description: "Rodnik", country: state, continent: continent,  geoname_id: 805839, population: 0)
province = region.provinces.create(description: "Rodnikovskiy", country: state, continent: continent,  geoname_id: 501714, population: 0)
province = region.provinces.create(description: "Rozhkao", country: state, continent: continent,  geoname_id: 500942, population: 0)
province = region.provinces.create(description: "Sadovaya Dolina", country: state, continent: continent,  geoname_id: 869256, population: 0)
province = region.provinces.create(description: "Sadovoye", country: state, continent: continent,  geoname_id: 499521, population: 0)
province = region.provinces.create(description: "Sary-Tyuz", country: state, continent: continent,  geoname_id: 498462, population: 3188)
province = region.provinces.create(description: "Schastlivoye", country: state, continent: continent,  geoname_id: 498010, population: 0)
municipalities = [
province.municipalities.new(description: "Alenovskiy", region: region, country: state, continent: continent, geoname_id: 582697, population: 0),
province.municipalities.new(description: "Bulavinskiy", region: region, country: state, continent: continent, geoname_id: 571034, population: 0),
province.municipalities.new(description: "Golubenovskiy", region: region, country: state, continent: continent, geoname_id: 560536, population: 0),
province.municipalities.new(description: "Kosyakinskiy", region: region, country: state, continent: continent, geoname_id: 543792, population: 0),
province.municipalities.new(description: "Kramorovskiy", region: region, country: state, continent: continent, geoname_id: 542968, population: 0),
province.municipalities.new(description: "Kucherovskiy", region: region, country: state, continent: continent, geoname_id: 539982, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Severnyy Priyut", country: state, continent: continent,  geoname_id: 865501, population: 0)
province = region.provinces.create(description: "Shkol'nyy", country: state, continent: continent,  geoname_id: 795100, population: 0)
province = region.provinces.create(description: "Solnechnaya Dolina", country: state, continent: continent,  geoname_id: 491000, population: 0)
province = region.provinces.create(description: "Solnechnyy", country: state, continent: continent,  geoname_id: 490989, population: 0)
province = region.provinces.create(description: "Sparta", country: state, continent: continent,  geoname_id: 489896, population: 0)
province = region.provinces.create(description: "Starokuvinskiy", country: state, continent: continent,  geoname_id: 488767, population: 0)
province = region.provinces.create(description: "Starokuvinskiy", country: state, continent: continent,  geoname_id: 805226, population: 0)
province = region.provinces.create(description: "Storozhevaya", country: state, continent: continent,  geoname_id: 487372, population: 7986)
province = region.provinces.create(description: "Svetloye", country: state, continent: continent,  geoname_id: 485690, population: 0)
municipalities = [
province.municipalities.new(description: "Morozovskiy", region: region, country: state, continent: continent, geoname_id: 525151, population: 0),
province.municipalities.new(description: "Pogorelovskiy", region: region, country: state, continent: continent, geoname_id: 507761, population: 0),
province.municipalities.new(description: "Popovskiy", region: region, country: state, continent: continent, geoname_id: 506350, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Svinyachi", country: state, continent: continent,  geoname_id: 485585, population: 0)
province = region.provinces.create(description: "Sychëv", country: state, continent: continent,  geoname_id: 485289, population: 0)
province = region.provinces.create(description: "Tallyk", country: state, continent: continent,  geoname_id: 841290, population: 0)
province = region.provinces.create(description: "Tapanta", country: state, continent: continent,  geoname_id: 484550, population: 0)
province = region.provinces.create(description: "Teberda", country: state, continent: continent,  geoname_id: 483873, population: 7705)
province = region.provinces.create(description: "Tereze", country: state, continent: continent,  geoname_id: 483386, population: 6335)
province = region.provinces.create(description: "Tsementnyy", country: state, continent: continent,  geoname_id: 841051, population: 0)
province = region.provinces.create(description: "Tëplyy", country: state, continent: continent,  geoname_id: 483558, population: 0)
province = region.provinces.create(description: "Uchkeken", country: state, continent: continent,  geoname_id: 479687, population: 15118)
municipalities = [
province.municipalities.new(description: "Rim Gorskiy", region: region, country: state, continent: continent, geoname_id: 501909, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Uchkulan", country: state, continent: continent,  geoname_id: 479685, population: 5000)
province = region.provinces.create(description: "Udarnyy", country: state, continent: continent,  geoname_id: 841270, population: 1142)
province = region.provinces.create(description: "Udarnyy", country: state, continent: continent,  geoname_id: 479645, population: 0)
province = region.provinces.create(description: "Ullukol", country: state, continent: continent,  geoname_id: 479228, population: 0)
province = region.provinces.create(description: "Urochishche Grushka", country: state, continent: continent,  geoname_id: 805230, population: 0)
province = region.provinces.create(description: "Urup", country: state, continent: continent,  geoname_id: 478593, population: 0)
province = region.provinces.create(description: "Ust'-Dzheguta", country: state, continent: continent,  geoname_id: 478130, population: 34001)
province = region.provinces.create(description: "Vako-Zhile", country: state, continent: continent,  geoname_id: 477324, population: 0)
province = region.provinces.create(description: "Vazhnoye", country: state, continent: continent,  geoname_id: 476293, population: 0)
province = region.provinces.create(description: "Verkhnepanteleymonovka", country: state, continent: continent,  geoname_id: 537317, population: 0)
province = region.provinces.create(description: "Verkhniy Beskes", country: state, continent: continent,  geoname_id: 475189, population: 0)
province = region.provinces.create(description: "Verkhniy Kubanskiy", country: state, continent: continent,  geoname_id: 805824, population: 0)
province = region.provinces.create(description: "Verkhniy Uchkulan", country: state, continent: continent,  geoname_id: 869055, population: 0)
province = region.provinces.create(description: "Verkhnyaya Mara", country: state, continent: continent,  geoname_id: 474600, population: 0)
province = region.provinces.create(description: "Verkhnyaya Pkhiya", country: state, continent: continent,  geoname_id: 474553, population: 0)
province = region.provinces.create(description: "Verkhnyaya Teberda", country: state, continent: continent,  geoname_id: 474481, population: 0)
province = region.provinces.create(description: "Vodorazdel'nyy", country: state, continent: continent,  geoname_id: 472955, population: 0)
province = region.provinces.create(description: "Vodovod", country: state, continent: continent,  geoname_id: 869246, population: 0)
province = region.provinces.create(description: "Voroshilovskiy", country: state, continent: continent,  geoname_id: 471829, population: 0)
province = region.provinces.create(description: "Vostok", country: state, continent: continent,  geoname_id: 471485, population: 0)
province = region.provinces.create(description: "Yershov", country: state, continent: continent,  geoname_id: 467122, population: 0)
province = region.provinces.create(description: "Yevseyevskiy", country: state, continent: continent,  geoname_id: 805297, population: 0)
province = region.provinces.create(description: "Zagedan", country: state, continent: continent,  geoname_id: 465673, population: 0)
province = region.provinces.create(description: "Zakan", country: state, continent: continent,  geoname_id: 874745, population: 0)
province = region.provinces.create(description: "Zarechnyy", country: state, continent: continent,  geoname_id: 841280, population: 0)
province = region.provinces.create(description: "Zarya Truda", country: state, continent: continent,  geoname_id: 464354, population: 0)
province = region.provinces.create(description: "Zedvake", country: state, continent: continent,  geoname_id: 795311, population: 0)
province = region.provinces.create(description: "Zelenchukskaya", country: state, continent: continent,  geoname_id: 463885, population: 21117)
province = region.provinces.create(description: "Zeyuko", country: state, continent: continent,  geoname_id: 463616, population: 0)
province = region.provinces.create(description: "Zhako", country: state, continent: continent,  geoname_id: 463560, population: 0)
province = region.provinces.create(description: "Znamenka", country: state, continent: continent,  geoname_id: 462371, population: 0)
municipalities = [
province.municipalities.new(description: "Nekrasovskiy", region: region, country: state, continent: continent, geoname_id: 522802, population: 0),
province.municipalities.new(description: "Valuyskiy", region: region, country: state, continent: continent, geoname_id: 477190, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Kemerovskaya Oblast'", country: state, continent: continent, geoname_id: 1503900)
province = region.provinces.create(description: "Yurginskiy Rayon", country: state, continent: continent,  geoname_id: 1485714, population: 0)
region = Region.create(description: "Khabarovsk Krai", country: state, continent: continent, geoname_id: 2022888)
province = region.provinces.create(description: "Bikinskiy Rayon", country: state, continent: continent,  geoname_id: 2026693, population: 0)
province = region.provinces.create(description: "Khabarovskiy Rayon", country: state, continent: continent,  geoname_id: 2022887, population: 0)
municipalities = [
province.municipalities.new(description: "Khabarovsk", region: region, country: state, continent: continent, geoname_id: 2022890, population: 579000),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vyazemskiy Rayon", country: state, continent: continent,  geoname_id: 2013228, population: 0)
region = Region.create(description: "Khanty-Mansiyskiy Avtonomnyy Okrug-Yugra", country: state, continent: continent, geoname_id: 1503773)
province = region.provinces.create(description: "Achimovy", country: state, continent: continent,  geoname_id: 1512168, population: 0)
province = region.provinces.create(description: "Agan", country: state, continent: continent,  geoname_id: 1512122, population: 0)
province = region.provinces.create(description: "Agirish", country: state, continent: continent,  geoname_id: 1512101, population: 2886)
province = region.provinces.create(description: "Altatump", country: state, continent: continent,  geoname_id: 1511742, population: 0)
province = region.provinces.create(description: "Altay", country: state, continent: continent,  geoname_id: 1511740, population: 0)
province = region.provinces.create(description: "Alyab'yevskiy", country: state, continent: continent,  geoname_id: 1511717, population: 0)
province = region.provinces.create(description: "Andra", country: state, continent: continent,  geoname_id: 1511646, population: 2013)
province = region.provinces.create(description: "Aneyevo", country: state, continent: continent,  geoname_id: 1511586, population: 0)
province = region.provinces.create(description: "Arantur", country: state, continent: continent,  geoname_id: 1511458, population: 0)
province = region.provinces.create(description: "Arpavla", country: state, continent: continent,  geoname_id: 1511378, population: 0)
province = region.provinces.create(description: "Asomkiny", country: state, continent: continent,  geoname_id: 1511296, population: 0)
province = region.provinces.create(description: "Barsovo", country: state, continent: continent,  geoname_id: 1510842, population: 5710)
province = region.provinces.create(description: "Batovo", country: state, continent: continent,  geoname_id: 1510762, population: 0)
province = region.provinces.create(description: "Baz'yany", country: state, continent: continent,  geoname_id: 1510632, population: 0)
province = region.provinces.create(description: "Belogor'ye", country: state, continent: continent,  geoname_id: 1510512, population: 0)
province = region.provinces.create(description: "Beloyarskiy", country: state, continent: continent,  geoname_id: 1510450, population: 20087)
province = region.provinces.create(description: "Berëzovo", country: state, continent: continent,  geoname_id: 1510214, population: 7034)
province = region.provinces.create(description: "Bobrovskiy", country: state, continent: continent,  geoname_id: 1540487, population: 0)
province = region.provinces.create(description: "Bogdany", country: state, continent: continent,  geoname_id: 1509871, population: 0)
province = region.provinces.create(description: "Bol'shetarkhovo", country: state, continent: continent,  geoname_id: 1509491, population: 0)
province = region.provinces.create(description: "Bol'shiye Leushi", country: state, continent: continent,  geoname_id: 1509444, population: 0)
province = region.provinces.create(description: "Bol'shoy Kamen'", country: state, continent: continent,  geoname_id: 1509214, population: 0)
province = region.provinces.create(description: "Bol'she-Lar'yakskiye", country: state, continent: continent,  geoname_id: 1509513, population: 0)
province = region.provinces.create(description: "Bol'shiye Shogany", country: state, continent: continent,  geoname_id: 1509433, population: 0)
province = region.provinces.create(description: "Bol'shoy Atlym", country: state, continent: continent,  geoname_id: 1509384, population: 0)
province = region.provinces.create(description: "Bol'shoye Pylino", country: state, continent: continent,  geoname_id: 1509273, population: 0)
province = region.provinces.create(description: "Borki", country: state, continent: continent,  geoname_id: 1508959, population: 0)
province = region.provinces.create(description: "Bylino", country: state, continent: continent,  geoname_id: 1508540, population: 0)
province = region.provinces.create(description: "Chaginskiye", country: state, continent: continent,  geoname_id: 1508489, population: 0)
province = region.provinces.create(description: "Chebykovo", country: state, continent: continent,  geoname_id: 1508332, population: 0)
province = region.provinces.create(description: "Chemashi", country: state, continent: continent,  geoname_id: 1508283, population: 0)
province = region.provinces.create(description: "Chentyr'ya", country: state, continent: continent,  geoname_id: 1508264, population: 0)
province = region.provinces.create(description: "Cheremikhovo", country: state, continent: continent,  geoname_id: 1508244, population: 0)
province = region.provinces.create(description: "Chuil'skiye", country: state, continent: continent,  geoname_id: 1507710, population: 0)
province = region.provinces.create(description: "Chuyenel'", country: state, continent: continent,  geoname_id: 1507590, population: 0)
province = region.provinces.create(description: "Dal'niy", country: state, continent: continent,  geoname_id: 1507557, population: 0)
province = region.provinces.create(description: "Darko-Gorshkovskiy", country: state, continent: continent,  geoname_id: 1507529, population: 0)
province = region.provinces.create(description: "Dolgoye Plëso", country: state, continent: continent,  geoname_id: 1507271, population: 0)
province = region.provinces.create(description: "Gornopravdinsk", country: state, continent: continent,  geoname_id: 1506268, population: 5048)
province = region.provinces.create(description: "Gornyy", country: state, continent: continent,  geoname_id: 1506248, population: 0)
province = region.provinces.create(description: "Gorodishche", country: state, continent: continent,  geoname_id: 1506233, population: 0)
province = region.provinces.create(description: "Gur'yanovskiye", country: state, continent: continent,  geoname_id: 1506076, population: 0)
province = region.provinces.create(description: "Igrim", country: state, continent: continent,  geoname_id: 1505965, population: 9545)
province = region.provinces.create(description: "Il'ichëvka", country: state, continent: continent,  geoname_id: 1505918, population: 0)
province = region.provinces.create(description: "Ingisoim", country: state, continent: continent,  geoname_id: 1505606, population: 0)
province = region.provinces.create(description: "Kal'manovy", country: state, continent: continent,  geoname_id: 1504981, population: 0)
province = region.provinces.create(description: "Kama", country: state, continent: continent,  geoname_id: 1504942, population: 0)
province = region.provinces.create(description: "Kamennyy", country: state, continent: continent,  geoname_id: 1504853, population: 0)
province = region.provinces.create(description: "Kamennyy Mys", country: state, continent: continent,  geoname_id: 1504842, population: 0)
province = region.provinces.create(description: "Kar'yegan", country: state, continent: continent,  geoname_id: 1504306, population: 0)
province = region.provinces.create(description: "Karym", country: state, continent: continent,  geoname_id: 1504300, population: 0)
province = region.provinces.create(description: "Kashat", country: state, continent: continent,  geoname_id: 1504283, population: 0)
province = region.provinces.create(description: "Kazym", country: state, continent: continent,  geoname_id: 1503977, population: 0)
province = region.provinces.create(description: "Kedras'yu", country: state, continent: continent,  geoname_id: 1503952, population: 0)
province = region.provinces.create(description: "Kedrovyy", country: state, continent: continent,  geoname_id: 1503927, population: 0)
province = region.provinces.create(description: "Ketlakh", country: state, continent: continent,  geoname_id: 1503881, population: 0)
province = region.provinces.create(description: "Keushki", country: state, continent: continent,  geoname_id: 1503872, population: 0)
province = region.provinces.create(description: "Khanglasy", country: state, continent: continent,  geoname_id: 1503790, population: 0)
province = region.provinces.create(description: "Khanlazin", country: state, continent: continent,  geoname_id: 1503786, population: 0)
province = region.provinces.create(description: "Khanty-Mansiysk", country: state, continent: continent,  geoname_id: 1503772, population: 67800)
province = region.provinces.create(description: "Khobeyu", country: state, continent: continent,  geoname_id: 1503625, population: 0)
province = region.provinces.create(description: "Khotlokh", country: state, continent: continent,  geoname_id: 1503529, population: 0)
province = region.provinces.create(description: "Khulimpaul'", country: state, continent: continent,  geoname_id: 1503482, population: 0)
province = region.provinces.create(description: "Khulimsunt", country: state, continent: continent,  geoname_id: 1503481, population: 2409)
province = region.provinces.create(description: "Kimk\"yasuy", country: state, continent: continent,  geoname_id: 1503411, population: 0)
province = region.provinces.create(description: "Kirpichnyy", country: state, continent: continent,  geoname_id: 1503310, population: 0)
province = region.provinces.create(description: "Kogalym", country: state, continent: continent,  geoname_id: 6695754, population: 57800)
province = region.provinces.create(description: "Kommunisticheskiy", country: state, continent: continent,  geoname_id: 1502750, population: 2690)
province = region.provinces.create(description: "Komsomol'skiy", country: state, continent: continent,  geoname_id: 1502724, population: 0)
province = region.provinces.create(description: "Kondinskoye", country: state, continent: continent,  geoname_id: 1502697, population: 4166)
province = region.provinces.create(description: "Koryst'ya", country: state, continent: continent,  geoname_id: 1502435, population: 0)
province = region.provinces.create(description: "Kososor", country: state, continent: continent,  geoname_id: 1502364, population: 0)
province = region.provinces.create(description: "Koyukovy", country: state, continent: continent,  geoname_id: 1502273, population: 0)
province = region.provinces.create(description: "Kugi", country: state, continent: continent,  geoname_id: 1501561, population: 0)
province = region.provinces.create(description: "Kuminskiy", country: state, continent: continent,  geoname_id: 1501429, population: 2860)
province = region.provinces.create(description: "Kuminskiy", country: state, continent: continent,  geoname_id: 1539665, population: 0)
province = region.provinces.create(description: "Landina", country: state, continent: continent,  geoname_id: 1500897, population: 0)
province = region.provinces.create(description: "Langepas", country: state, continent: continent,  geoname_id: 6696767, population: 40000)
province = region.provinces.create(description: "Lar'yak", country: state, continent: continent,  geoname_id: 1500846, population: 0)
province = region.provinces.create(description: "Larlomkiny", country: state, continent: continent,  geoname_id: 1500852, population: 0)
province = region.provinces.create(description: "Lempiny", country: state, continent: continent,  geoname_id: 1500713, population: 0)
province = region.provinces.create(description: "Leushi", country: state, continent: continent,  geoname_id: 1500595, population: 0)
province = region.provinces.create(description: "Leushinka", country: state, continent: continent,  geoname_id: 1500594, population: 0)
province = region.provinces.create(description: "Levkina", country: state, continent: continent,  geoname_id: 1500569, population: 0)
province = region.provinces.create(description: "Listvennichnyy", country: state, continent: continent,  geoname_id: 1500489, population: 0)
province = region.provinces.create(description: "Lokosovo", country: state, continent: continent,  geoname_id: 1500399, population: 3915)
province = region.provinces.create(description: "Lombovozh", country: state, continent: continent,  geoname_id: 1500381, population: 0)
province = region.provinces.create(description: "Lugovoy", country: state, continent: continent,  geoname_id: 1500269, population: 0)
province = region.provinces.create(description: "Lyantor", country: state, continent: continent,  geoname_id: 1541359, population: 38200)
province = region.provinces.create(description: "Malinovskiy", country: state, continent: continent,  geoname_id: 1539045, population: 2672)
province = region.provinces.create(description: "Malyy Atlym", country: state, continent: continent,  geoname_id: 1499642, population: 0)
province = region.provinces.create(description: "Malyy Tap", country: state, continent: continent,  geoname_id: 1499485, population: 0)
province = region.provinces.create(description: "Mashalorgort", country: state, continent: continent,  geoname_id: 1499268, population: 0)
province = region.provinces.create(description: "Mat'kinskiye", country: state, continent: continent,  geoname_id: 1499230, population: 0)
province = region.provinces.create(description: "Megion", country: state, continent: continent,  geoname_id: 1499053, population: 48691)
province = region.provinces.create(description: "Menk'ya", country: state, continent: continent,  geoname_id: 1498990, population: 0)
province = region.provinces.create(description: "Mezhdurechenskiy", country: state, continent: continent,  geoname_id: 1498919, population: 11121)
province = region.provinces.create(description: "Mogilëvo", country: state, continent: continent,  geoname_id: 1498580, population: 0)
province = region.provinces.create(description: "Mokrovskaya", country: state, continent: continent,  geoname_id: 1498507, population: 0)
province = region.provinces.create(description: "Mortka", country: state, continent: continent,  geoname_id: 1498402, population: 3698)
province = region.provinces.create(description: "Mortym'ya", country: state, continent: continent,  geoname_id: 1498400, population: 0)
province = region.provinces.create(description: "Muligort", country: state, continent: continent,  geoname_id: 1498261, population: 0)
province = region.provinces.create(description: "Multanovy", country: state, continent: continent,  geoname_id: 1498255, population: 0)
province = region.provinces.create(description: "Mulym'ya", country: state, continent: continent,  geoname_id: 1498253, population: 0)
province = region.provinces.create(description: "Mulym'ya", country: state, continent: continent,  geoname_id: 1498254, population: 0)
province = region.provinces.create(description: "Mushkiny", country: state, continent: continent,  geoname_id: 1498184, population: 0)
province = region.provinces.create(description: "Narimanovo", country: state, continent: continent,  geoname_id: 1498009, population: 0)
province = region.provinces.create(description: "Nazarovo", country: state, continent: continent,  geoname_id: 1497943, population: 0)
province = region.provinces.create(description: "Nefteyugansk", country: state, continent: continent,  geoname_id: 1497917, population: 112632)
province = region.provinces.create(description: "Nemchinovy", country: state, continent: continent,  geoname_id: 1497880, population: 0)
province = region.provinces.create(description: "Neremovskiye", country: state, continent: continent,  geoname_id: 1497846, population: 0)
province = region.provinces.create(description: "Nerga", country: state, continent: continent,  geoname_id: 1497844, population: 0)
province = region.provinces.create(description: "Nikul'kina", country: state, continent: continent,  geoname_id: 1497603, population: 0)
province = region.provinces.create(description: "Nil'din Paul'", country: state, continent: continent,  geoname_id: 1497601, population: 0)
province = region.provinces.create(description: "Nizhnevartovsk", country: state, continent: continent,  geoname_id: 1497543, population: 244937)
province = region.provinces.create(description: "Nizhniye Nil'diny", country: state, continent: continent,  geoname_id: 1497507, population: 0)
province = region.provinces.create(description: "Novoagansk", country: state, continent: continent,  geoname_id: 1497210, population: 9907)
province = region.provinces.create(description: "Novyy Katysh", country: state, continent: continent,  geoname_id: 1496551, population: 0)
province = region.provinces.create(description: "Novyy Nazym", country: state, continent: continent,  geoname_id: 1496537, population: 0)
province = region.provinces.create(description: "Numto", country: state, continent: continent,  geoname_id: 1496494, population: 0)
province = region.provinces.create(description: "Nyagan", country: state, continent: continent,  geoname_id: 1496476, population: 52137)
province = region.provinces.create(description: "Nyakhyn'", country: state, continent: continent,  geoname_id: 1536753, population: 0)
province = region.provinces.create(description: "Nyaksimvol'", country: state, continent: continent,  geoname_id: 1496472, population: 0)
province = region.provinces.create(description: "Nyurkoy", country: state, continent: continent,  geoname_id: 1496428, population: 0)
province = region.provinces.create(description: "Okhteur'ye", country: state, continent: continent,  geoname_id: 1496333, population: 0)
province = region.provinces.create(description: "Oktyabr'skoye", country: state, continent: continent,  geoname_id: 1496250, population: 0)
province = region.provinces.create(description: "Olym'ya", country: state, continent: continent,  geoname_id: 1496160, population: 0)
province = region.provinces.create(description: "Ozërnyy", country: state, continent: continent,  geoname_id: 1495736, population: 0)
province = region.provinces.create(description: "Pakhtyn'ya", country: state, continent: continent,  geoname_id: 1495680, population: 0)
province = region.provinces.create(description: "Pankratkina", country: state, continent: continent,  geoname_id: 1495617, population: 0)
province = region.provinces.create(description: "Pasol", country: state, continent: continent,  geoname_id: 1495506, population: 0)
province = region.provinces.create(description: "Pen'kovy", country: state, continent: continent,  geoname_id: 1495371, population: 0)
province = region.provinces.create(description: "Peschanyy", country: state, continent: continent,  geoname_id: 1495213, population: 0)
province = region.provinces.create(description: "Pilyugino", country: state, continent: continent,  geoname_id: 1494973, population: 0)
province = region.provinces.create(description: "Pionerskiy", country: state, continent: continent,  geoname_id: 1494949, population: 5348)
province = region.provinces.create(description: "Podgornyy", country: state, continent: continent,  geoname_id: 1494782, population: 0)
province = region.provinces.create(description: "Pokur", country: state, continent: continent,  geoname_id: 1494599, population: 0)
province = region.provinces.create(description: "Pol'yanovo", country: state, continent: continent,  geoname_id: 1494469, population: 0)
province = region.provinces.create(description: "Pol-Paul'", country: state, continent: continent,  geoname_id: 1494505, population: 0)
province = region.provinces.create(description: "Polovinka", country: state, continent: continent,  geoname_id: 1494535, population: 0)
province = region.provinces.create(description: "Polushaim", country: state, continent: continent,  geoname_id: 1494481, population: 0)
province = region.provinces.create(description: "Potanay", country: state, continent: continent,  geoname_id: 1536385, population: 0)
province = region.provinces.create(description: "Poykovskiy", country: state, continent: continent,  geoname_id: 1494276, population: 28080)
province = region.provinces.create(description: "Poykovskiy", country: state, continent: continent,  geoname_id: 1539990, population: 0)
province = region.provinces.create(description: "Priob'ye", country: state, continent: continent,  geoname_id: 1536757, population: 7400)
province = region.provinces.create(description: "Pug”yug", country: state, continent: continent,  geoname_id: 1494020, population: 0)
province = region.provinces.create(description: "Punga", country: state, continent: continent,  geoname_id: 1494008, population: 0)
province = region.provinces.create(description: "Puolokh", country: state, continent: continent,  geoname_id: 1494004, population: 0)
province = region.provinces.create(description: "Pyliny", country: state, continent: continent,  geoname_id: 1493881, population: 0)
province = region.provinces.create(description: "Pyr'yakh", country: state, continent: continent,  geoname_id: 1493871, population: 0)
province = region.provinces.create(description: "Pyt-Yakh", country: state, continent: continent,  geoname_id: 6696686, population: 41500)
province = region.provinces.create(description: "Pyzh'yan", country: state, continent: continent,  geoname_id: 1493859, population: 0)
province = region.provinces.create(description: "Raduzhny", country: state, continent: continent,  geoname_id: 1540356, population: 47679)
province = region.provinces.create(description: "Rakhtyn'ya", country: state, continent: continent,  geoname_id: 1493836, population: 0)
province = region.provinces.create(description: "Reden'koye", country: state, continent: continent,  geoname_id: 1493697, population: 0)
province = region.provinces.create(description: "Rezimovskiye", country: state, continent: continent,  geoname_id: 1493642, population: 0)
province = region.provinces.create(description: "Russkinskiye", country: state, continent: continent,  geoname_id: 1493420, population: 0)
province = region.provinces.create(description: "Ruzitgort", country: state, continent: continent,  geoname_id: 1493409, population: 0)
province = region.provinces.create(description: "Sakhal'", country: state, continent: continent,  geoname_id: 1493241, population: 0)
province = region.provinces.create(description: "Salym", country: state, continent: continent,  geoname_id: 1493162, population: 5605)
province = region.provinces.create(description: "Sarady-Paul'", country: state, continent: continent,  geoname_id: 1493068, population: 0)
province = region.provinces.create(description: "Saranpaul'", country: state, continent: continent,  geoname_id: 1493049, population: 2985)
province = region.provinces.create(description: "Sargachi", country: state, continent: continent,  geoname_id: 1493008, population: 0)
province = region.provinces.create(description: "Sartyn'ya", country: state, continent: continent,  geoname_id: 1492969, population: 0)
province = region.provinces.create(description: "Satarino", country: state, continent: continent,  geoname_id: 1492932, population: 0)
province = region.provinces.create(description: "Saygatiny", country: state, continent: continent,  geoname_id: 1492879, population: 0)
province = region.provinces.create(description: "Seul'", country: state, continent: continent,  geoname_id: 1492647, population: 0)
province = region.provinces.create(description: "Severnaya Naroda", country: state, continent: continent,  geoname_id: 1492624, population: 0)
province = region.provinces.create(description: "Shaim", country: state, continent: continent,  geoname_id: 1492495, population: 0)
province = region.provinces.create(description: "Shchekur'ya", country: state, continent: continent,  geoname_id: 1492352, population: 0)
province = region.provinces.create(description: "Sherkaly", country: state, continent: continent,  geoname_id: 1492248, population: 1361)
province = region.provinces.create(description: "Slushka", country: state, continent: continent,  geoname_id: 1491673, population: 0)
province = region.provinces.create(description: "Sogom", country: state, continent: continent,  geoname_id: 1491576, population: 0)
province = region.provinces.create(description: "Sorovskiye", country: state, continent: continent,  geoname_id: 1491363, population: 0)
province = region.provinces.create(description: "Sos'va", country: state, continent: continent,  geoname_id: 1491266, population: 0)
province = region.provinces.create(description: "Sosnina", country: state, continent: continent,  geoname_id: 1491344, population: 0)
province = region.provinces.create(description: "Sosnovo", country: state, continent: continent,  geoname_id: 1491292, population: 0)
province = region.provinces.create(description: "Sotnik", country: state, continent: continent,  geoname_id: 1491262, population: 0)
province = region.provinces.create(description: "Sotnik", country: state, continent: continent,  geoname_id: 1491263, population: 0)
province = region.provinces.create(description: "Sotnikovo", country: state, continent: continent,  geoname_id: 1491257, population: 0)
province = region.provinces.create(description: "Sovetskiy", country: state, continent: continent,  geoname_id: 1491230, population: 23685)
province = region.provinces.create(description: "Sovlinskiy", country: state, continent: continent,  geoname_id: 1491214, population: 0)
province = region.provinces.create(description: "Spirina", country: state, continent: continent,  geoname_id: 1491183, population: 0)
province = region.provinces.create(description: "Sukhorukova", country: state, continent: continent,  geoname_id: 1490702, population: 0)
province = region.provinces.create(description: "Sukhoy Bor", country: state, continent: continent,  geoname_id: 1490694, population: 0)
province = region.provinces.create(description: "Sumkino", country: state, continent: continent,  geoname_id: 1490654, population: 0)
province = region.provinces.create(description: "Supra", country: state, continent: continent,  geoname_id: 1490633, population: 0)
province = region.provinces.create(description: "Surgut", country: state, continent: continent,  geoname_id: 1490624, population: 300367)
province = region.provinces.create(description: "Sushka", country: state, continent: continent,  geoname_id: 1490599, population: 0)
province = region.provinces.create(description: "Sytomino", country: state, continent: continent,  geoname_id: 1490388, population: 0)
province = region.provinces.create(description: "Taurovo", country: state, continent: continent,  geoname_id: 1489978, population: 0)
province = region.provinces.create(description: "Tugiyany", country: state, continent: continent,  geoname_id: 1489049, population: 0)
province = region.provinces.create(description: "Tutleym", country: state, continent: continent,  geoname_id: 1488878, population: 0)
province = region.provinces.create(description: "Uray", country: state, continent: continent,  geoname_id: 1488429, population: 39878)
province = region.provinces.create(description: "Vanzevat", country: state, continent: continent,  geoname_id: 1487798, population: 0)
province = region.provinces.create(description: "Verkhnenil'dina", country: state, continent: continent,  geoname_id: 1487558, population: 0)
province = region.provinces.create(description: "Yugan", country: state, continent: continent,  geoname_id: 1485793, population: 0)
province = region.provinces.create(description: "Yugorsk", country: state, continent: continent,  geoname_id: 1502725, population: 30878)
province = region.provinces.create(description: "Yuzhnyy Balyk", country: state, continent: continent,  geoname_id: 1538107, population: 0)
province = region.provinces.create(description: "Zelenoborsk", country: state, continent: continent,  geoname_id: 1485286, population: 2252)
region = Region.create(description: "Kirovskaya Oblast'", country: state, continent: continent, geoname_id: 548389)
province = region.provinces.create(description: "Arbazhskiy Rayon", country: state, continent: continent,  geoname_id: 581227, population: 0)
province = region.provinces.create(description: "Kirovo-Chepetskiy Rayon", country: state, continent: continent,  geoname_id: 548394, population: 0)
municipalities = [
province.municipalities.new(description: "Kirov", region: region, country: state, continent: continent, geoname_id: 548408, population: 457383),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kotel'nichskiy Rayon", country: state, continent: continent,  geoname_id: 543733, population: 0)
province = region.provinces.create(description: "Kumenskiy Rayon", country: state, continent: continent,  geoname_id: 539285, population: 0)
province = region.provinces.create(description: "Nagorskiy Rayon", country: state, continent: continent,  geoname_id: 523582, population: 0)
province = region.provinces.create(description: "Orichevskiy Rayon", country: state, continent: continent,  geoname_id: 514967, population: 0)
province = region.provinces.create(description: "Orlovskiy Rayon", country: state, continent: continent,  geoname_id: 550782, population: 0)
province = region.provinces.create(description: "Pizhanskiy Rayon", country: state, continent: continent,  geoname_id: 509182, population: 0)
province = region.provinces.create(description: "Slobodskoy Rayon", country: state, continent: continent,  geoname_id: 491877, population: 0)
province = region.provinces.create(description: "Sovetskiy Rayon", country: state, continent: continent,  geoname_id: 490023, population: 0)
province = region.provinces.create(description: "Verkhoshizhemskiy Rayon", country: state, continent: continent,  geoname_id: 474372, population: 0)
province = region.provinces.create(description: "Yaranskiy Rayon", country: state, continent: continent,  geoname_id: 469004, population: 0)
province = region.provinces.create(description: "Yur'yanskiy Rayon", country: state, continent: continent,  geoname_id: 466268, population: 0)
region = Region.create(description: "Komi Republic", country: state, continent: continent, geoname_id: 545854)
province = region.provinces.create(description: "Koygorodskiy Rayon", country: state, continent: continent,  geoname_id: 543395, population: 0)
province = region.provinces.create(description: "Priluzskiy Rayon", country: state, continent: continent,  geoname_id: 505282, population: 0)
province = region.provinces.create(description: "Syktyvdinskiy Rayon", country: state, continent: continent,  geoname_id: 485241, population: 0)
municipalities = [
province.municipalities.new(description: "Syktyvkar", region: region, country: state, continent: continent, geoname_id: 485239, population: 230139),
]
Municipality.import municipalities
province = region.provinces.create(description: "Sysol'skiy Rayon", country: state, continent: continent,  geoname_id: 485121, population: 0)
region = Region.create(description: "Kostromskaya Oblast'", country: state, continent: continent, geoname_id: 543871)
province = region.provinces.create(description: "Kostromskoy Rayon", country: state, continent: continent,  geoname_id: 543869, population: 0)
municipalities = [
province.municipalities.new(description: "Kostroma", region: region, country: state, continent: continent, geoname_id: 543878, population: 277656),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nerekhtskiy Rayon", country: state, continent: continent,  geoname_id: 522591, population: 0)
province = region.provinces.create(description: "Ostrovskiy Rayon", country: state, continent: continent,  geoname_id: 514056, population: 0)
region = Region.create(description: "Krasnodarskiy Kray", country: state, continent: continent, geoname_id: 542415)
province = region.provinces.create(description: "Sochi City", country: state, continent: continent,  geoname_id: 6695246, population: 0)
municipalities = [
province.municipalities.new(description: "Dagomys", region: region, country: state, continent: continent, geoname_id: 567288, population: 0),
province.municipalities.new(description: "Estosadok", region: region, country: state, continent: continent, geoname_id: 563401, population: 704),
province.municipalities.new(description: "Khosta", region: region, country: state, continent: continent, geoname_id: 549424, population: 20000),
province.municipalities.new(description: "Krasnaya Polyana", region: region, country: state, continent: continent, geoname_id: 542681, population: 4020),
province.municipalities.new(description: "Lazarevskoye", region: region, country: state, continent: continent, geoname_id: 536625, population: 30000),
province.municipalities.new(description: "Sochi", region: region, country: state, continent: continent, geoname_id: 491422, population: 327608),
province.municipalities.new(description: "Yakornaya Shchel'", region: region, country: state, continent: continent, geoname_id: 805548, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Taymyrsky Dolgano-Nenetsky District", country: state, continent: continent,  geoname_id: 1489879, population: 0)
municipalities = [
province.municipalities.new(description: "Golubitskaya", region: region, country: state, continent: continent, geoname_id: 560513, population: 4138),
]
Municipality.import municipalities
region = Region.create(description: "Krasnoyarskiy Kray", country: state, continent: continent, geoname_id: 1502020)
province = region.provinces.create(description: "Abanskiy Rayon", country: state, continent: continent,  geoname_id: 1512216, population: 0)
province = region.provinces.create(description: "Achinskiy Rayon", country: state, continent: continent,  geoname_id: 1512163, population: 0)
province = region.provinces.create(description: "Birilyusskiy Rayon", country: state, continent: continent,  geoname_id: 1510060, population: 0)
province = region.provinces.create(description: "Bogotol'skiy Rayon", country: state, continent: continent,  geoname_id: 1509850, population: 0)
province = region.provinces.create(description: "Bol'sheuluyskiy Rayon", country: state, continent: continent,  geoname_id: 1509484, population: 0)
province = region.provinces.create(description: "Evenkiyskiy District", country: state, continent: continent,  geoname_id: 1506922, population: 16507)
province = region.provinces.create(description: "Kozul'skiy Rayon", country: state, continent: continent,  geoname_id: 1502206, population: 0)
province = region.provinces.create(description: "Nazarovskiy Rayon", country: state, continent: continent,  geoname_id: 1497938, population: 0)
province = region.provinces.create(description: "Nizhneingashskiy Rayon", country: state, continent: continent,  geoname_id: 1497575, population: 0)
province = region.provinces.create(description: "Sharypovskiy Rayon", country: state, continent: continent,  geoname_id: 1492400, population: 0)
province = region.provinces.create(description: "Uzhurskiy Rayon", country: state, continent: continent,  geoname_id: 1487880, population: 0)
region = Region.create(description: "Kurganskaya Oblast'", country: state, continent: continent, geoname_id: 1501312)
province = region.provinces.create(description: "Antipino", country: state, continent: continent,  geoname_id: 1543594, population: 0)
province = region.provinces.create(description: "Baraba", country: state, continent: continent,  geoname_id: 1543169, population: 0)
province = region.provinces.create(description: "Barsukova", country: state, continent: continent,  geoname_id: 1542122, population: 0)
province = region.provinces.create(description: "Belyakovskoye", country: state, continent: continent,  geoname_id: 1510403, population: 0)
province = region.provinces.create(description: "Bol'shoye Chausovo", country: state, continent: continent,  geoname_id: 1509332, population: 0)
province = region.provinces.create(description: "Bol'shoye Dubrovnoye", country: state, continent: continent,  geoname_id: 1509329, population: 0)
province = region.provinces.create(description: "Bol'shoye Kureynoye", country: state, continent: continent,  geoname_id: 1509516, population: 0)
province = region.provinces.create(description: "Chapayeva", country: state, continent: continent,  geoname_id: 1508452, population: 0)
province = region.provinces.create(description: "Cherepanova", country: state, continent: continent,  geoname_id: 1542132, population: 0)
province = region.provinces.create(description: "Chistopol'ye", country: state, continent: continent,  geoname_id: 1507791, population: 0)
province = region.provinces.create(description: "Chistoye", country: state, continent: continent,  geoname_id: 1507780, population: 0)
province = region.provinces.create(description: "Chudnyakovo", country: state, continent: continent,  geoname_id: 1507726, population: 0)
province = region.provinces.create(description: "Chuloshnoye", country: state, continent: continent,  geoname_id: 1507683, population: 0)
province = region.provinces.create(description: "Chumlyak", country: state, continent: continent,  geoname_id: 1507653, population: 0)
province = region.provinces.create(description: "Chusovaya", country: state, continent: continent,  geoname_id: 1507607, population: 0)
province = region.provinces.create(description: "Dal'nyaya Kubasova", country: state, continent: continent,  geoname_id: 1507549, population: 0)
province = region.provinces.create(description: "Dalmatovo", country: state, continent: continent,  geoname_id: 1507565, population: 14526)
province = region.provinces.create(description: "Dan'kovo", country: state, continent: continent,  geoname_id: 1507534, population: 0)
province = region.provinces.create(description: "Davydovka", country: state, continent: continent,  geoname_id: 1507506, population: 0)
province = region.provinces.create(description: "Desyatyy Oktyabr'", country: state, continent: continent,  geoname_id: 1543496, population: 0)
province = region.provinces.create(description: "Donki", country: state, continent: continent,  geoname_id: 1507251, population: 0)
province = region.provinces.create(description: "Dryannovo", country: state, continent: continent,  geoname_id: 1507180, population: 0)
province = region.provinces.create(description: "Dubrova", country: state, continent: continent,  geoname_id: 1507161, population: 0)
province = region.provinces.create(description: "Dubrovnoye", country: state, continent: continent,  geoname_id: 1507129, population: 0)
province = region.provinces.create(description: "Dubrovnoye", country: state, continent: continent,  geoname_id: 1507130, population: 0)
province = region.provinces.create(description: "Dukhovka", country: state, continent: continent,  geoname_id: 1507110, population: 0)
province = region.provinces.create(description: "Dulino", country: state, continent: continent,  geoname_id: 1507107, population: 0)
province = region.provinces.create(description: "Dundino", country: state, continent: continent,  geoname_id: 1507098, population: 0)
province = region.provinces.create(description: "Dvortsy", country: state, continent: continent,  geoname_id: 1507067, population: 0)
province = region.provinces.create(description: "Dëmino", country: state, continent: continent,  geoname_id: 1507469, population: 0)
province = region.provinces.create(description: "Filippovo", country: state, continent: continent,  geoname_id: 1506820, population: 0)
province = region.provinces.create(description: "Frolovka", country: state, continent: continent,  geoname_id: 1506766, population: 0)
province = region.provinces.create(description: "Frolovka", country: state, continent: continent,  geoname_id: 1506767, population: 0)
province = region.provinces.create(description: "Gagar'ye", country: state, continent: continent,  geoname_id: 1506738, population: 0)
province = region.provinces.create(description: "Galishovo", country: state, continent: continent,  geoname_id: 1506720, population: 0)
province = region.provinces.create(description: "Galkino", country: state, continent: continent,  geoname_id: 1506716, population: 0)
province = region.provinces.create(description: "Gladkovskoye", country: state, continent: continent,  geoname_id: 1506570, population: 0)
province = region.provinces.create(description: "Gladyshevo", country: state, continent: continent,  geoname_id: 1506567, population: 0)
province = region.provinces.create(description: "Glubokaya", country: state, continent: continent,  geoname_id: 1506549, population: 0)
province = region.provinces.create(description: "Glyadyanskoye", country: state, continent: continent,  geoname_id: 1506499, population: 4237)
province = region.provinces.create(description: "Golovnoye", country: state, continent: continent,  geoname_id: 1506452, population: 0)
province = region.provinces.create(description: "Gomzino", country: state, continent: continent,  geoname_id: 1543800, population: 0)
province = region.provinces.create(description: "Gorokhovo", country: state, continent: continent,  geoname_id: 1506226, population: 0)
province = region.provinces.create(description: "Gorshkovo", country: state, continent: continent,  geoname_id: 1506219, population: 0)
province = region.provinces.create(description: "Grenadery", country: state, continent: continent,  geoname_id: 1506167, population: 0)
province = region.provinces.create(description: "Ignat'yeva", country: state, continent: continent,  geoname_id: 1505978, population: 0)
province = region.provinces.create(description: "Ik", country: state, continent: continent,  geoname_id: 1505959, population: 0)
province = region.provinces.create(description: "Ikovka", country: state, continent: continent,  geoname_id: 1505946, population: 5243)
province = region.provinces.create(description: "Ikovskoye", country: state, continent: continent,  geoname_id: 1505944, population: 0)
province = region.provinces.create(description: "Il'ino", country: state, continent: continent,  geoname_id: 1505884, population: 0)
province = region.provinces.create(description: "Il'inskoye", country: state, continent: continent,  geoname_id: 1505872, population: 0)
province = region.provinces.create(description: "Il'tyakovo", country: state, continent: continent,  geoname_id: 1505859, population: 0)
province = region.provinces.create(description: "Iryum", country: state, continent: continent,  geoname_id: 1505492, population: 0)
province = region.provinces.create(description: "Iskandarovo", country: state, continent: continent,  geoname_id: 1505431, population: 0)
province = region.provinces.create(description: "Itkul'", country: state, continent: continent,  geoname_id: 1505376, population: 0)
province = region.provinces.create(description: "Ivankovo", country: state, continent: continent,  geoname_id: 1505344, population: 0)
province = region.provinces.create(description: "Ivankovo", country: state, continent: continent,  geoname_id: 1505345, population: 0)
province = region.provinces.create(description: "Iz”yedugino", country: state, continent: continent,  geoname_id: 1505207, population: 0)
province = region.provinces.create(description: "Kalashnoye", country: state, continent: continent,  geoname_id: 1505063, population: 0)
province = region.provinces.create(description: "Kargapol'ye", country: state, continent: continent,  geoname_id: 1542143, population: 0)
province = region.provinces.create(description: "Kataysk", country: state, continent: continent,  geoname_id: 1504212, population: 15619)
province = region.provinces.create(description: "Ketovo", country: state, continent: continent,  geoname_id: 1503879, population: 6966)
province = region.provinces.create(description: "Komsomol'skaya", country: state, continent: continent,  geoname_id: 1543664, population: 0)
province = region.provinces.create(description: "Kosulino", country: state, continent: continent,  geoname_id: 1541017, population: 0)
province = region.provinces.create(description: "Kremenëvka", country: state, continent: continent,  geoname_id: 1501842, population: 0)
province = region.provinces.create(description: "Kropani", country: state, continent: continent,  geoname_id: 1501761, population: 0)
province = region.provinces.create(description: "Kukushkino", country: state, continent: continent,  geoname_id: 1501541, population: 0)
province = region.provinces.create(description: "Kurgan", country: state, continent: continent,  geoname_id: 1501321, population: 343129)
municipalities = [
province.municipalities.new(description: "Galkino", region: region, country: state, continent: continent, geoname_id: 1542718, population: 0),
province.municipalities.new(description: "Inkubator", region: region, country: state, continent: continent, geoname_id: 1542727, population: 0),
province.municipalities.new(description: "Kamchikha", region: region, country: state, continent: continent, geoname_id: 1504921, population: 0),
province.municipalities.new(description: "Karchevskaya Roshcha", region: region, country: state, continent: continent, geoname_id: 1542716, population: 0),
province.municipalities.new(description: "Keramzit", region: region, country: state, continent: continent, geoname_id: 1542734, population: 0),
province.municipalities.new(description: "Kurganka", region: region, country: state, continent: continent, geoname_id: 1501313, population: 0),
province.municipalities.new(description: "Ryabkovo", region: region, country: state, continent: continent, geoname_id: 1493402, population: 0),
province.municipalities.new(description: "Severnyy", region: region, country: state, continent: continent, geoname_id: 1542728, population: 0),
province.municipalities.new(description: "Smolino", region: region, country: state, continent: continent, geoname_id: 1491628, population: 0),
province.municipalities.new(description: "Torfyaniki", region: region, country: state, continent: continent, geoname_id: 1542729, population: 0),
province.municipalities.new(description: "Voronovka", region: region, country: state, continent: continent, geoname_id: 1542731, population: 0),
province.municipalities.new(description: "Vostochnyy", region: region, country: state, continent: continent, geoname_id: 1542724, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kurort Ozero Medvezh'ye", country: state, continent: continent,  geoname_id: 1495726, population: 0)
province = region.provinces.create(description: "Kurtamysh", country: state, continent: continent,  geoname_id: 1501255, population: 17936)
province = region.provinces.create(description: "Lebyazh'ye", country: state, continent: continent,  geoname_id: 1500764, population: 6900)
province = region.provinces.create(description: "Lesnikovo", country: state, continent: continent,  geoname_id: 1543161, population: 0)
province = region.provinces.create(description: "Makushino", country: state, continent: continent,  geoname_id: 1500036, population: 9682)
province = region.provinces.create(description: "Mal'tsevo", country: state, continent: continent,  geoname_id: 1499682, population: 0)
province = region.provinces.create(description: "Maloye Beloye", country: state, continent: continent,  geoname_id: 1499762, population: 0)
province = region.provinces.create(description: "Maloye Pes'yanovo", country: state, continent: continent,  geoname_id: 1499742, population: 0)
province = region.provinces.create(description: "Maloye Serëdkino", country: state, continent: continent,  geoname_id: 1499693, population: 0)
province = region.provinces.create(description: "Malyy Atyazh", country: state, continent: continent,  geoname_id: 1499640, population: 0)
province = region.provinces.create(description: "Malëtino", country: state, continent: continent,  geoname_id: 1499831, population: 0)
province = region.provinces.create(description: "Mansurovo", country: state, continent: continent,  geoname_id: 1499397, population: 0)
province = region.provinces.create(description: "Manuylovo", country: state, continent: continent,  geoname_id: 1499394, population: 0)
province = region.provinces.create(description: "Maray", country: state, continent: continent,  geoname_id: 1499364, population: 0)
province = region.provinces.create(description: "Markovo", country: state, continent: continent,  geoname_id: 1499315, population: 0)
province = region.provinces.create(description: "Martynovka", country: state, continent: continent,  geoname_id: 1499295, population: 0)
province = region.provinces.create(description: "Masli", country: state, continent: continent,  geoname_id: 1499260, population: 0)
province = region.provinces.create(description: "Matasy", country: state, continent: continent,  geoname_id: 1499234, population: 0)
province = region.provinces.create(description: "Matveyevka", country: state, continent: continent,  geoname_id: 1499217, population: 0)
province = region.provinces.create(description: "Maylyk", country: state, continent: continent,  geoname_id: 1499166, population: 0)
province = region.provinces.create(description: "Medvedskoye", country: state, continent: continent,  geoname_id: 1499094, population: 0)
province = region.provinces.create(description: "Medvezh'ye", country: state, continent: continent,  geoname_id: 1499070, population: 0)
province = region.provinces.create(description: "Mekhonskoye", country: state, continent: continent,  geoname_id: 1499050, population: 0)
province = region.provinces.create(description: "Men'shchikovo", country: state, continent: continent,  geoname_id: 1498984, population: 0)
province = region.provinces.create(description: "Menderskoye", country: state, continent: continent,  geoname_id: 1498996, population: 0)
province = region.provinces.create(description: "Menshchikovo", country: state, continent: continent,  geoname_id: 1498986, population: 0)
province = region.provinces.create(description: "Mezhbornoye", country: state, continent: continent,  geoname_id: 1498925, population: 0)
province = region.provinces.create(description: "Mezhles'ye", country: state, continent: continent,  geoname_id: 1498902, population: 0)
province = region.provinces.create(description: "Mikhalëvo", country: state, continent: continent,  geoname_id: 1498865, population: 0)
province = region.provinces.create(description: "Mikhaylovka", country: state, continent: continent,  geoname_id: 1498822, population: 0)
province = region.provinces.create(description: "Mikhaylovka", country: state, continent: continent,  geoname_id: 1498831, population: 0)
province = region.provinces.create(description: "Mir", country: state, continent: continent,  geoname_id: 1498685, population: 0)
province = region.provinces.create(description: "Mishkino", country: state, continent: continent,  geoname_id: 1498633, population: 8712)
province = region.provinces.create(description: "Mit'kina", country: state, continent: continent,  geoname_id: 1498623, population: 0)
province = region.provinces.create(description: "Mokhovoye", country: state, continent: continent,  geoname_id: 1498528, population: 0)
province = region.provinces.create(description: "Mokhovoye", country: state, continent: continent,  geoname_id: 1498531, population: 0)
province = region.provinces.create(description: "Mokrousovo", country: state, continent: continent,  geoname_id: 1498511, population: 4851)
province = region.provinces.create(description: "Molodënki", country: state, continent: continent,  geoname_id: 1541792, population: 0)
province = region.provinces.create(description: "Morshikha", country: state, continent: continent,  geoname_id: 1498406, population: 0)
province = region.provinces.create(description: "Mostovskoye", country: state, continent: continent,  geoname_id: 1498324, population: 0)
province = region.provinces.create(description: "Murzabayeva", country: state, continent: continent,  geoname_id: 1498219, population: 0)
province = region.provinces.create(description: "Myasnikovo", country: state, continent: continent,  geoname_id: 1498149, population: 0)
province = region.provinces.create(description: "Nadezhdinka", country: state, continent: continent,  geoname_id: 1498102, population: 0)
province = region.provinces.create(description: "Nalimovo", country: state, continent: continent,  geoname_id: 1498036, population: 0)
province = region.provinces.create(description: "Nazarovo", country: state, continent: continent,  geoname_id: 1497952, population: 0)
province = region.provinces.create(description: "Nechunayeva", country: state, continent: continent,  geoname_id: 1497925, population: 0)
province = region.provinces.create(description: "Neonilinskoye", country: state, continent: continent,  geoname_id: 1497860, population: 0)
province = region.provinces.create(description: "Nifanka", country: state, continent: continent,  geoname_id: 1497759, population: 0)
province = region.provinces.create(description: "Nikitino", country: state, continent: continent,  geoname_id: 1497743, population: 0)
province = region.provinces.create(description: "Nikitinskoye", country: state, continent: continent,  geoname_id: 1497741, population: 0)
province = region.provinces.create(description: "Nikolayevka", country: state, continent: continent,  geoname_id: 1497709, population: 0)
province = region.provinces.create(description: "Nikolayevka", country: state, continent: continent,  geoname_id: 1497717, population: 0)
province = region.provinces.create(description: "Nizhnetobol'noye", country: state, continent: continent,  geoname_id: 1497550, population: 0)
province = region.provinces.create(description: "Nizhneye", country: state, continent: continent,  geoname_id: 1497539, population: 0)
province = region.provinces.create(description: "Noril'noye", country: state, continent: continent,  geoname_id: 1497338, population: 0)
province = region.provinces.create(description: "Noskovo", country: state, continent: continent,  geoname_id: 1497324, population: 0)
province = region.provinces.create(description: "Novaya Zavorina", country: state, continent: continent,  geoname_id: 1497238, population: 0)
province = region.provinces.create(description: "Novoberëzovo", country: state, continent: continent,  geoname_id: 1543554, population: 0)
province = region.provinces.create(description: "Novonikol'skoye", country: state, continent: continent,  geoname_id: 1496901, population: 0)
province = region.provinces.create(description: "Novopetropavlovskoye", country: state, continent: continent,  geoname_id: 1496876, population: 0)
province = region.provinces.create(description: "Novosel'skoye", country: state, continent: continent,  geoname_id: 1496766, population: 0)
province = region.provinces.create(description: "Novotroitskoye", country: state, continent: continent,  geoname_id: 1496662, population: 0)
province = region.provinces.create(description: "Novotroitskoye", country: state, continent: continent,  geoname_id: 1496664, population: 0)
province = region.provinces.create(description: "Novoye Il'inskoye", country: state, continent: continent,  geoname_id: 1497084, population: 0)
province = region.provinces.create(description: "Novozaborka", country: state, continent: continent,  geoname_id: 1496589, population: 0)
province = region.provinces.create(description: "Novyye Peski", country: state, continent: continent,  geoname_id: 1496560, population: 0)
province = region.provinces.create(description: "Obanino", country: state, continent: continent,  geoname_id: 1496417, population: 0)
province = region.provinces.create(description: "Obutkovskoye", country: state, continent: continent,  geoname_id: 1496390, population: 0)
province = region.provinces.create(description: "Okatova", country: state, continent: continent,  geoname_id: 1496342, population: 0)
province = region.provinces.create(description: "Oktyabr'", country: state, continent: continent,  geoname_id: 1496322, population: 0)
province = region.provinces.create(description: "Oktyabr'skoye", country: state, continent: continent,  geoname_id: 1496254, population: 0)
province = region.provinces.create(description: "Okunëvka", country: state, continent: continent,  geoname_id: 1543596, population: 0)
province = region.provinces.create(description: "Okunëvka", country: state, continent: continent,  geoname_id: 1496243, population: 0)
province = region.provinces.create(description: "Ol'khovka", country: state, continent: continent,  geoname_id: 1496186, population: 0)
province = region.provinces.create(description: "Ol'khovskoye Ozero", country: state, continent: continent,  geoname_id: 1496172, population: 0)
province = region.provinces.create(description: "Oshurkovo", country: state, continent: continent,  geoname_id: 1495979, population: 0)
province = region.provinces.create(description: "Oshurkovo", country: state, continent: continent,  geoname_id: 1495980, population: 0)
province = region.provinces.create(description: "Osinovka", country: state, continent: continent,  geoname_id: 1495960, population: 0)
province = region.provinces.create(description: "Osinovskoye", country: state, continent: continent,  geoname_id: 1495925, population: 0)
province = region.provinces.create(description: "Ostrova", country: state, continent: continent,  geoname_id: 1495884, population: 0)
province = region.provinces.create(description: "Ostrovnoye", country: state, continent: continent,  geoname_id: 1495871, population: 0)
province = region.provinces.create(description: "Ozhogino", country: state, continent: continent,  geoname_id: 1495714, population: 0)
province = region.provinces.create(description: "Ozërnaya", country: state, continent: continent,  geoname_id: 1495760, population: 0)
province = region.provinces.create(description: "Paderino", country: state, continent: continent,  geoname_id: 1495703, population: 0)
province = region.provinces.create(description: "Padun", country: state, continent: continent,  geoname_id: 1495698, population: 0)
province = region.provinces.create(description: "Pamyatnaya", country: state, continent: continent,  geoname_id: 1495642, population: 0)
province = region.provinces.create(description: "Paratkul'", country: state, continent: continent,  geoname_id: 1495576, population: 0)
province = region.provinces.create(description: "Pavelevo", country: state, continent: continent,  geoname_id: 1541226, population: 0)
province = region.provinces.create(description: "Pegan", country: state, continent: continent,  geoname_id: 1495400, population: 0)
province = region.provinces.create(description: "Pepelino", country: state, continent: continent,  geoname_id: 1495365, population: 0)
province = region.provinces.create(description: "Perevalovo", country: state, continent: continent,  geoname_id: 1495344, population: 0)
province = region.provinces.create(description: "Pershino", country: state, continent: continent,  geoname_id: 1495323, population: 0)
province = region.provinces.create(description: "Pershinskoye", country: state, continent: continent,  geoname_id: 1495317, population: 0)
province = region.provinces.create(description: "Pervomayskoye", country: state, continent: continent,  geoname_id: 1495257, population: 0)
province = region.provinces.create(description: "Pes'yanoye", country: state, continent: continent,  geoname_id: 1495163, population: 0)
province = region.provinces.create(description: "Pes'yanoye", country: state, continent: continent,  geoname_id: 1495165, population: 0)
province = region.provinces.create(description: "Pes'yanoye", country: state, continent: continent,  geoname_id: 1495166, population: 0)
province = region.provinces.create(description: "Pes'yanoye", country: state, continent: continent,  geoname_id: 1495167, population: 0)
province = region.provinces.create(description: "Peschanokoledino", country: state, continent: continent,  geoname_id: 1495232, population: 0)
province = region.provinces.create(description: "Peschanotavolzhanskoye", country: state, continent: continent,  geoname_id: 1495231, population: 0)
province = region.provinces.create(description: "Peschanskoye", country: state, continent: continent,  geoname_id: 1495216, population: 0)
province = region.provinces.create(description: "Peski", country: state, continent: continent,  geoname_id: 1495199, population: 0)
province = region.provinces.create(description: "Peski", country: state, continent: continent,  geoname_id: 1495201, population: 0)
province = region.provinces.create(description: "Petropavlovskoye", country: state, continent: continent,  geoname_id: 1495100, population: 0)
province = region.provinces.create(description: "Petrovskoye", country: state, continent: continent,  geoname_id: 1495048, population: 0)
province = region.provinces.create(description: "Petukhi", country: state, continent: continent,  geoname_id: 1495026, population: 0)
province = region.provinces.create(description: "Petukhovo", country: state, continent: continent,  geoname_id: 1495022, population: 12367)
province = region.provinces.create(description: "Petukhovo", country: state, continent: continent,  geoname_id: 1495021, population: 0)
province = region.provinces.create(description: "Petukhovskoye", country: state, continent: continent,  geoname_id: 1495013, population: 0)
province = region.provinces.create(description: "Pivkino", country: state, continent: continent,  geoname_id: 1541018, population: 0)
province = region.provinces.create(description: "Polevoye", country: state, continent: continent,  geoname_id: 1494575, population: 0)
province = region.provinces.create(description: "Polovinnoye", country: state, continent: continent,  geoname_id: 1494523, population: 5103)
province = region.provinces.create(description: "Profintern", country: state, continent: continent,  geoname_id: 1543699, population: 0)
province = region.provinces.create(description: "Raskovalova", country: state, continent: continent,  geoname_id: 1542061, population: 0)
province = region.provinces.create(description: "Rodniki", country: state, continent: continent,  geoname_id: 1541219, population: 0)
province = region.provinces.create(description: "Rybnaya", country: state, continent: continent,  geoname_id: 1493357, population: 0)
province = region.provinces.create(description: "Sadovod", country: state, continent: continent,  geoname_id: 1543539, population: 0)
province = region.provinces.create(description: "Safakulevo", country: state, continent: continent,  geoname_id: 1493268, population: 4189)
province = region.provinces.create(description: "Sanatornaya", country: state, continent: continent,  geoname_id: 1493103, population: 0)
province = region.provinces.create(description: "Setovo", country: state, continent: continent,  geoname_id: 1541525, population: 0)
province = region.provinces.create(description: "Sevast'yanovka", country: state, continent: continent,  geoname_id: 1541208, population: 0)
province = region.provinces.create(description: "Shadrinsk", country: state, continent: continent,  geoname_id: 1492517, population: 79479)
province = region.provinces.create(description: "Shatrovo", country: state, continent: continent,  geoname_id: 1492388, population: 6295)
province = region.provinces.create(description: "Shchuch'ye", country: state, continent: continent,  geoname_id: 1498293, population: 0)
province = region.provinces.create(description: "Shchuchanka", country: state, continent: continent,  geoname_id: 1541457, population: 0)
province = region.provinces.create(description: "Shumikha", country: state, continent: continent,  geoname_id: 1491999, population: 18499)
municipalities = [
province.municipalities.new(description: "Mayevka", region: region, country: state, continent: continent, geoname_id: 1541249, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Slevnoye", country: state, continent: continent,  geoname_id: 1543684, population: 0)
province = region.provinces.create(description: "Strizhovo", country: state, continent: continent,  geoname_id: 1490793, population: 0)
province = region.provinces.create(description: "Sumki", country: state, continent: continent,  geoname_id: 1543140, population: 0)
province = region.provinces.create(description: "Tselinnoye", country: state, continent: continent,  geoname_id: 1489137, population: 5711)
province = region.provinces.create(description: "Yagodnaya", country: state, continent: continent,  geoname_id: 1486546, population: 0)
province = region.provinces.create(description: "Zverinogolovskoye", country: state, continent: continent,  geoname_id: 1484943, population: 4400)
region = Region.create(description: "Kurskaya Oblast'", country: state, continent: continent, geoname_id: 538555)
province = region.provinces.create(description: "Oboyanskiy Rayon", country: state, continent: continent,  geoname_id: 516399, population: 0)
province = region.provinces.create(description: "Pristenskiy Rayon", country: state, continent: continent,  geoname_id: 505150, population: 0)
region = Region.create(description: "Leningrad", country: state, continent: continent, geoname_id: 536199)
province = region.provinces.create(description: "Kingiseppskiy Rayon", country: state, continent: continent,  geoname_id: 548601, population: 0)
municipalities = [
province.municipalities.new(description: "Klenno", region: region, country: state, continent: continent, geoname_id: 547772, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Lomonosovskiy Rayon", country: state, continent: continent,  geoname_id: 534332, population: 37420)
province = region.provinces.create(description: "Priozersk Region", country: state, continent: continent,  geoname_id: 6695196, population: 0)
province = region.provinces.create(description: "Volosovsky Region", country: state, continent: continent,  geoname_id: 472350, population: 47925)
municipalities = [
province.municipalities.new(description: "Shlissel'burg", region: region, country: state, continent: continent, geoname_id: 493970, population: 12115),
]
Municipality.import municipalities
province = region.provinces.create(description: "Всеволжский Район", country: state, continent: continent,  geoname_id: 6695195, population: 0)
municipalities = [
province.municipalities.new(description: "Vaskelovo", region: region, country: state, continent: continent, geoname_id: 476500, population: 12388),
]
Municipality.import municipalities
region = Region.create(description: "Lipetskaya Oblast'", country: state, continent: continent, geoname_id: 535120)
province = region.provinces.create(description: "Aleksandrovka Pervaya", country: state, continent: continent,  geoname_id: 511064, population: 0)
province = region.provinces.create(description: "Argamach-Pal'na", country: state, continent: continent,  geoname_id: 581142, population: 0)
province = region.provinces.create(description: "Arkhangel'skoye Pervoye", country: state, continent: continent,  geoname_id: 510803, population: 0)
province = region.provinces.create(description: "Bol'shaya Kuz'minka", country: state, continent: continent,  geoname_id: 537852, population: 0)
province = region.provinces.create(description: "Borinskoye", country: state, continent: continent,  geoname_id: 572559, population: 5998)
province = region.provinces.create(description: "Burdino", country: state, continent: continent,  geoname_id: 570858, population: 0)
province = region.provinces.create(description: "Chamlyk-Nikol'skoye", country: state, continent: continent,  geoname_id: 521721, population: 0)
province = region.provinces.create(description: "Chaplygin", country: state, continent: continent,  geoname_id: 569934, population: 13488)
municipalities = [
province.municipalities.new(description: "Gai", region: region, country: state, continent: continent, geoname_id: 562202, population: 0),
province.municipalities.new(description: "Kryuchki", region: region, country: state, continent: continent, geoname_id: 540224, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Dankov", country: state, continent: continent,  geoname_id: 567109, population: 22913)
municipalities = [
province.municipalities.new(description: "Bogoslovka", region: region, country: state, continent: continent, geoname_id: 575490, population: 0),
province.municipalities.new(description: "Storozhevaya", region: region, country: state, continent: continent, geoname_id: 487368, population: 0),
province.municipalities.new(description: "Streletskaya", region: region, country: state, continent: continent, geoname_id: 487282, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Dmitryashëvka", country: state, continent: continent,  geoname_id: 565901, population: 0)
province = region.provinces.create(description: "Dobrinka", country: state, continent: continent,  geoname_id: 565857, population: 10063)
province = region.provinces.create(description: "Dobroye", country: state, continent: continent,  geoname_id: 565803, population: 5550)
province = region.provinces.create(description: "Dolevka", country: state, continent: continent,  geoname_id: 489223, population: 0)
province = region.provinces.create(description: "Dolgorukovo", country: state, continent: continent,  geoname_id: 565611, population: 5599)
province = region.provinces.create(description: "Donskaya", country: state, continent: continent,  geoname_id: 565311, population: 0)
province = region.provinces.create(description: "Donskoye", country: state, continent: continent,  geoname_id: 565285, population: 3860)
province = region.provinces.create(description: "Dëmshinka", country: state, continent: continent,  geoname_id: 566662, population: 0)
province = region.provinces.create(description: "Fashchëvka", country: state, continent: continent,  geoname_id: 563312, population: 0)
province = region.provinces.create(description: "Fëdorovka", country: state, continent: continent,  geoname_id: 563198, population: 0)
province = region.provinces.create(description: "Gatishche", country: state, continent: continent,  geoname_id: 561879, population: 0)
province = region.provinces.create(description: "Glotovo", country: state, continent: continent,  geoname_id: 561177, population: 0)
municipalities = [
province.municipalities.new(description: "Glotovo-Vasil'yevka Tret'ya", region: region, country: state, continent: continent, geoname_id: 561172, population: 0),
province.municipalities.new(description: "Glotovo-Vasil'yevka Vtoraya", region: region, country: state, continent: continent, geoname_id: 561171, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Glushitsa", country: state, continent: continent,  geoname_id: 561016, population: 0)
province = region.provinces.create(description: "Gnilovody", country: state, continent: continent,  geoname_id: 560906, population: 0)
province = region.provinces.create(description: "Gnilusha", country: state, continent: continent,  geoname_id: 560889, population: 0)
province = region.provinces.create(description: "Golikovo", country: state, continent: continent,  geoname_id: 560772, population: 0)
province = region.provinces.create(description: "Golovinshchino", country: state, continent: continent,  geoname_id: 560620, population: 0)
province = region.provinces.create(description: "Golubëvka", country: state, continent: continent,  geoname_id: 560484, population: 0)
province = region.provinces.create(description: "Grachëvka", country: state, continent: continent,  geoname_id: 559149, population: 0)
province = region.provinces.create(description: "Griboyedovo", country: state, continent: continent,  geoname_id: 558773, population: 0)
province = region.provinces.create(description: "Grunin Vorgol", country: state, continent: continent,  geoname_id: 558399, population: 0)
province = region.provinces.create(description: "Gryazi", country: state, continent: continent,  geoname_id: 558312, population: 47413)
province = region.provinces.create(description: "Gryaznoye", country: state, continent: continent,  geoname_id: 558272, population: 0)
province = region.provinces.create(description: "Gudovka", country: state, continent: continent,  geoname_id: 558100, population: 0)
province = region.provinces.create(description: "Gudovo", country: state, continent: continent,  geoname_id: 558096, population: 0)
province = region.provinces.create(description: "Il'ino", country: state, continent: continent,  geoname_id: 557197, population: 0)
province = region.provinces.create(description: "Ishcheino", country: state, continent: continent,  geoname_id: 555998, population: 0)
province = region.provinces.create(description: "Istobnoye", country: state, continent: continent,  geoname_id: 555770, population: 0)
province = region.provinces.create(description: "Ivanitskoye-Troitskoye", country: state, continent: continent,  geoname_id: 481525, population: 0)
province = region.provinces.create(description: "Ivanovka", country: state, continent: continent,  geoname_id: 555447, population: 0)
province = region.provinces.create(description: "Ivovo", country: state, continent: continent,  geoname_id: 554945, population: 0)
province = region.provinces.create(description: "Izlegoshche", country: state, continent: continent,  geoname_id: 554813, population: 0)
province = region.provinces.create(description: "Izmalkovo", country: state, continent: continent,  geoname_id: 554806, population: 4072)
province = region.provinces.create(description: "Izmaylovka", country: state, continent: continent,  geoname_id: 554797, population: 0)
province = region.provinces.create(description: "Kalabino", country: state, continent: continent,  geoname_id: 554413, population: 0)
province = region.provinces.create(description: "Kalikino", country: state, continent: continent,  geoname_id: 554297, population: 3352)
province = region.provinces.create(description: "Kamenka", country: state, continent: continent,  geoname_id: 553754, population: 0)
province = region.provinces.create(description: "Kamyshevka", country: state, continent: continent,  geoname_id: 553302, population: 0)
province = region.provinces.create(description: "Kazaki", country: state, continent: continent,  geoname_id: 551535, population: 3227)
province = region.provinces.create(description: "Kazinka", country: state, continent: continent,  geoname_id: 551330, population: 3002)
province = region.provinces.create(description: "Khlevnoye", country: state, continent: continent,  geoname_id: 550102, population: 6150)
province = region.provinces.create(description: "Korytino", country: state, continent: continent,  geoname_id: 544365, population: 0)
province = region.provinces.create(description: "Krasnaya", country: state, continent: continent,  geoname_id: 542113, population: 0)
province = region.provinces.create(description: "Krasnaya Pal'na", country: state, continent: continent,  geoname_id: 542688, population: 0)
province = region.provinces.create(description: "Krasnoye", country: state, continent: continent,  geoname_id: 542109, population: 4021)
province = region.provinces.create(description: "Krasnoye", country: state, continent: continent,  geoname_id: 510791, population: 0)
province = region.provinces.create(description: "Krasnyy Luch", country: state, continent: continent,  geoname_id: 541625, population: 0)
province = region.provinces.create(description: "Krivets", country: state, continent: continent,  geoname_id: 540962, population: 0)
province = region.provinces.create(description: "Krivka", country: state, continent: continent,  geoname_id: 540942, population: 0)
province = region.provinces.create(description: "Krivopolyan'ye", country: state, continent: continent,  geoname_id: 540915, population: 0)
province = region.provinces.create(description: "Kropotova Lyubashëvka", country: state, continent: continent,  geoname_id: 540758, population: 0)
province = region.provinces.create(description: "Krugloye", country: state, continent: continent,  geoname_id: 540662, population: 0)
province = region.provinces.create(description: "Krutchenskaya Baygora", country: state, continent: continent,  geoname_id: 540543, population: 0)
province = region.provinces.create(description: "Krutogor'ye", country: state, continent: continent,  geoname_id: 540436, population: 0)
province = region.provinces.create(description: "Krutyye Khutora", country: state, continent: continent,  geoname_id: 541776, population: 0)
province = region.provinces.create(description: "Ksizovo", country: state, continent: continent,  geoname_id: 540112, population: 0)
province = region.provinces.create(description: "Kudiyarovka Pervaya", country: state, continent: continent,  geoname_id: 539878, population: 0)
province = region.provinces.create(description: "Kulikovo", country: state, continent: continent,  geoname_id: 539458, population: 0)
province = region.provinces.create(description: "Kurgano-Golovino", country: state, continent: continent,  geoname_id: 538822, population: 0)
province = region.provinces.create(description: "Lamskoye", country: state, continent: continent,  geoname_id: 537051, population: 0)
province = region.provinces.create(description: "Lebedyan'", country: state, continent: continent,  geoname_id: 536518, population: 22970)
municipalities = [
province.municipalities.new(description: "Monastyrskaya Sloboda", region: region, country: state, continent: continent, geoname_id: 525414, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Lebyazh'ye", country: state, continent: continent,  geoname_id: 558831, population: 0)
province = region.provinces.create(description: "Lev Tolstoy", country: state, continent: continent,  geoname_id: 535417, population: 8955)
province = region.provinces.create(description: "Lipetsk", country: state, continent: continent,  geoname_id: 535121, population: 515655)
municipalities = [
province.municipalities.new(description: "Novolipetsk", region: region, country: state, continent: continent, geoname_id: 516967, population: 0),
province.municipalities.new(description: "Sokol'skoye", region: region, country: state, continent: continent, geoname_id: 491143, population: 0),
province.municipalities.new(description: "Svobodnyy Sokol", region: region, country: state, continent: continent, geoname_id: 827991, population: 0),
province.municipalities.new(description: "Traktornyy", region: region, country: state, continent: continent, geoname_id: 7452197, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Malyye Borki", country: state, continent: continent,  geoname_id: 530210, population: 0)
province = region.provinces.create(description: "Matyskiy", country: state, continent: continent,  geoname_id: 528429, population: 0)
province = region.provinces.create(description: "Mazeyka", country: state, continent: continent,  geoname_id: 528181, population: 0)
province = region.provinces.create(description: "Natal'ino", country: state, continent: continent,  geoname_id: 523286, population: 0)
province = region.provinces.create(description: "Nechayevka", country: state, continent: continent,  geoname_id: 523028, population: 0)
province = region.provinces.create(description: "Nikol'skoye", country: state, continent: continent,  geoname_id: 521664, population: 0)
province = region.provinces.create(description: "Nizhnedrezgalovo", country: state, continent: continent,  geoname_id: 521142, population: 0)
province = region.provinces.create(description: "Nizhniy Vorgol", country: state, continent: continent,  geoname_id: 520457, population: 0)
province = region.provinces.create(description: "Nizhnyaya Kolybel'ka", country: state, continent: continent,  geoname_id: 520347, population: 0)
province = region.provinces.create(description: "Novaya Slobodka", country: state, continent: continent,  geoname_id: 520235, population: 0)
province = region.provinces.create(description: "Novikova", country: state, continent: continent,  geoname_id: 519297, population: 0)
province = region.provinces.create(description: "Novodmitriyevka", country: state, continent: continent,  geoname_id: 518931, population: 0)
province = region.provinces.create(description: "Novonikol'skoye", country: state, continent: continent,  geoname_id: 518457, population: 0)
province = region.provinces.create(description: "Novopetrovka", country: state, continent: continent,  geoname_id: 518369, population: 0)
province = region.provinces.create(description: "Novopokrovka", country: state, continent: continent,  geoname_id: 507425, population: 0)
province = region.provinces.create(description: "Ostrovki-Zarech'ye", country: state, continent: continent,  geoname_id: 514090, population: 0)
province = region.provinces.create(description: "Ostryy Kamen'", country: state, continent: continent,  geoname_id: 521623, population: 0)
province = region.provinces.create(description: "Pady", country: state, continent: continent,  geoname_id: 513242, population: 0)
province = region.provinces.create(description: "Pal'na-Mikhaylovka", country: state, continent: continent,  geoname_id: 513035, population: 0)
province = region.provinces.create(description: "Panikovets", country: state, continent: continent,  geoname_id: 512874, population: 0)
province = region.provinces.create(description: "Panino", country: state, continent: continent,  geoname_id: 512858, population: 0)
province = region.provinces.create(description: "Pashkovo", country: state, continent: continent,  geoname_id: 512395, population: 0)
province = region.provinces.create(description: "Pavelka", country: state, continent: continent,  geoname_id: 512251, population: 0)
province = region.provinces.create(description: "Pavlovskoye", country: state, continent: continent,  geoname_id: 512017, population: 0)
province = region.provinces.create(description: "Perekhval'", country: state, continent: continent,  geoname_id: 511461, population: 0)
province = region.provinces.create(description: "Pervomayskoye", country: state, continent: continent,  geoname_id: 510826, population: 0)
province = region.provinces.create(description: "Petrishchevo", country: state, continent: continent,  geoname_id: 510237, population: 0)
province = region.provinces.create(description: "Petrovka-Kitayevo", country: state, continent: continent,  geoname_id: 509906, population: 0)
province = region.provinces.create(description: "Petrovskiye Krugi", country: state, continent: continent,  geoname_id: 540713, population: 0)
province = region.provinces.create(description: "Plakhovo", country: state, continent: continent,  geoname_id: 509156, population: 0)
province = region.provinces.create(description: "Plastinka", country: state, continent: continent,  geoname_id: 509129, population: 0)
municipalities = [
province.municipalities.new(description: "Vtoraya Plastinka", region: region, country: state, continent: continent, geoname_id: 471044, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Plekhanovo", country: state, continent: continent,  geoname_id: 509047, population: 1850)
province = region.provinces.create(description: "Ploskoye", country: state, continent: continent,  geoname_id: 489290, population: 5211)
province = region.provinces.create(description: "Poddubrovka", country: state, continent: continent,  geoname_id: 508429, population: 0)
province = region.provinces.create(description: "Podgornaya", country: state, continent: continent,  geoname_id: 508387, population: 0)
province = region.provinces.create(description: "Podgornoye", country: state, continent: continent,  geoname_id: 508357, population: 0)
province = region.provinces.create(description: "Pokrovskoye", country: state, continent: continent,  geoname_id: 507412, population: 0)
province = region.provinces.create(description: "Pokrovskoye", country: state, continent: continent,  geoname_id: 507424, population: 0)
province = region.provinces.create(description: "Polevyye Lokottsy", country: state, continent: continent,  geoname_id: 507244, population: 0)
municipalities = [
province.municipalities.new(description: "Polevyye Lokottsy Vtoryye", region: region, country: state, continent: continent, geoname_id: 507241, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Polibino", country: state, continent: continent,  geoname_id: 507223, population: 0)
province = region.provinces.create(description: "Ponomarëvo", country: state, continent: continent,  geoname_id: 506638, population: 0)
province = region.provinces.create(description: "Poroy", country: state, continent: continent,  geoname_id: 506227, population: 0)
province = region.provinces.create(description: "Predtech'ye", country: state, continent: continent,  geoname_id: 505545, population: 0)
province = region.provinces.create(description: "Preobrazheniye", country: state, continent: continent,  geoname_id: 505533, population: 0)
province = region.provinces.create(description: "Preobrazhenovka", country: state, continent: continent,  geoname_id: 505512, population: 0)
province = region.provinces.create(description: "Prigorodka", country: state, continent: continent,  geoname_id: 505395, population: 3140)
province = region.provinces.create(description: "Pruzhinki", country: state, continent: continent,  geoname_id: 504431, population: 0)
province = region.provinces.create(description: "Pushkino", country: state, continent: continent,  geoname_id: 503998, population: 0)
province = region.provinces.create(description: "Putyatino", country: state, continent: continent,  geoname_id: 503684, population: 0)
province = region.provinces.create(description: "Ratchino", country: state, continent: continent,  geoname_id: 502650, population: 0)
province = region.provinces.create(description: "Reshetovo-Dubrovo", country: state, continent: continent,  geoname_id: 502057, population: 0)
province = region.provinces.create(description: "Romanovo", country: state, continent: continent,  geoname_id: 501436, population: 0)
province = region.provinces.create(description: "Rovenka", country: state, continent: continent,  geoname_id: 501129, population: 0)
province = region.provinces.create(description: "Ryazanka", country: state, continent: continent,  geoname_id: 500091, population: 0)
province = region.provinces.create(description: "Rzhëvka", country: state, continent: continent,  geoname_id: 499710, population: 0)
province = region.provinces.create(description: "Sadovaya", country: state, continent: continent,  geoname_id: 499572, population: 0)
province = region.provinces.create(description: "Safonovo", country: state, continent: continent,  geoname_id: 499457, population: 0)
province = region.provinces.create(description: "Savitskoye", country: state, continent: continent,  geoname_id: 498188, population: 0)
province = region.provinces.create(description: "Semenëk", country: state, continent: continent,  geoname_id: 497496, population: 0)
province = region.provinces.create(description: "Sentsovo", country: state, continent: continent,  geoname_id: 496994, population: 0)
province = region.provinces.create(description: "Sergiyevskoye", country: state, continent: continent,  geoname_id: 496622, population: 0)
province = region.provinces.create(description: "Sergëvka", country: state, continent: continent,  geoname_id: 496793, population: 0)
province = region.provinces.create(description: "Shatovo", country: state, continent: continent,  geoname_id: 495548, population: 0)
province = region.provinces.create(description: "Shovskoye", country: state, continent: continent,  geoname_id: 493716, population: 0)
province = region.provinces.create(description: "Shpeynarka", country: state, continent: continent,  geoname_id: 493691, population: 0)
province = region.provinces.create(description: "Skorovarovo Pervoye", country: state, continent: continent,  geoname_id: 510728, population: 0)
province = region.provinces.create(description: "Slepukha", country: state, continent: continent,  geoname_id: 492065, population: 0)
province = region.provinces.create(description: "Sloboda", country: state, continent: continent,  geoname_id: 492039, population: 0)
province = region.provinces.create(description: "Slobodka", country: state, continent: continent,  geoname_id: 491939, population: 0)
province = region.provinces.create(description: "Sof'ino", country: state, continent: continent,  geoname_id: 510727, population: 0)
province = region.provinces.create(description: "Soldatskoye", country: state, continent: continent,  geoname_id: 491065, population: 0)
province = region.provinces.create(description: "Solov'yëvo", country: state, continent: continent,  geoname_id: 490787, population: 0)
province = region.provinces.create(description: "Solovyye", country: state, continent: continent,  geoname_id: 490767, population: 0)
province = region.provinces.create(description: "Soshki", country: state, continent: continent,  geoname_id: 490433, population: 0)
province = region.provinces.create(description: "Sotnikovo", country: state, continent: continent,  geoname_id: 490113, population: 0)
province = region.provinces.create(description: "Speshnëvo-Ivanovskoye", country: state, continent: continent,  geoname_id: 489714, population: 0)
province = region.provinces.create(description: "Speshnëvo-Podlesnoye", country: state, continent: continent,  geoname_id: 489719, population: 0)
province = region.provinces.create(description: "Sredneye", country: state, continent: continent,  geoname_id: 489603, population: 0)
province = region.provinces.create(description: "Srednyaya Matrënka", country: state, continent: continent,  geoname_id: 489417, population: 0)
province = region.provinces.create(description: "Ssëlki", country: state, continent: continent,  geoname_id: 489376, population: 0)
province = region.provinces.create(description: "Starochemodanovo", country: state, continent: continent,  geoname_id: 488476, population: 0)
province = region.provinces.create(description: "Staroye Pitelino", country: state, continent: continent,  geoname_id: 509274, population: 0)
province = region.provinces.create(description: "Stegalovka", country: state, continent: continent,  geoname_id: 487804, population: 0)
province = region.provinces.create(description: "Sterlyagovka", country: state, continent: continent,  geoname_id: 487499, population: 0)
province = region.provinces.create(description: "Storozhevoye", country: state, continent: continent,  geoname_id: 487363, population: 0)
province = region.provinces.create(description: "Strelets", country: state, continent: continent,  geoname_id: 487287, population: 0)
province = region.provinces.create(description: "Studënka", country: state, continent: continent,  geoname_id: 487045, population: 0)
province = region.provinces.create(description: "Studënki", country: state, continent: continent,  geoname_id: 487041, population: 0)
province = region.provinces.create(description: "Studënyye Vyselki", country: state, continent: continent,  geoname_id: 487014, population: 0)
province = region.provinces.create(description: "Sukhaya Lubna", country: state, continent: continent,  geoname_id: 486709, population: 0)
province = region.provinces.create(description: "Surki", country: state, continent: continent,  geoname_id: 486105, population: 0)
province = region.provinces.create(description: "Syrskoye", country: state, continent: continent,  geoname_id: 485153, population: 3454)
province = region.provinces.create(description: "Talitsa", country: state, continent: continent,  geoname_id: 484808, population: 0)
province = region.provinces.create(description: "Talitskiy Chamlyk", country: state, continent: continent,  geoname_id: 484772, population: 0)
province = region.provinces.create(description: "Talykovo", country: state, continent: continent,  geoname_id: 484689, population: 0)
province = region.provinces.create(description: "Telegino", country: state, continent: continent,  geoname_id: 483816, population: 0)
province = region.provinces.create(description: "Telelyuy", country: state, continent: continent,  geoname_id: 483802, population: 0)
province = region.provinces.create(description: "Telepnevo", country: state, continent: continent,  geoname_id: 483797, population: 0)
province = region.provinces.create(description: "Telezhënka", country: state, continent: continent,  geoname_id: 483777, population: 0)
province = region.provinces.create(description: "Terbuny", country: state, continent: continent,  geoname_id: 483541, population: 6936)
province = region.provinces.create(description: "Ternovo", country: state, continent: continent,  geoname_id: 483328, population: 0)
province = region.provinces.create(description: "Topki", country: state, continent: continent,  geoname_id: 482198, population: 0)
province = region.provinces.create(description: "Trebunki", country: state, continent: continent,  geoname_id: 481838, population: 0)
province = region.provinces.create(description: "Troitskoye", country: state, continent: continent,  geoname_id: 481526, population: 0)
province = region.provinces.create(description: "Trostnoye", country: state, continent: continent,  geoname_id: 481438, population: 0)
province = region.provinces.create(description: "Troyekurovo", country: state, continent: continent,  geoname_id: 481372, population: 0)
province = region.provinces.create(description: "Troyekurovo", country: state, continent: continent,  geoname_id: 481373, population: 0)
province = region.provinces.create(description: "Trubetchino", country: state, continent: continent,  geoname_id: 481343, population: 0)
province = region.provinces.create(description: "Tul'skoye", country: state, continent: continent,  geoname_id: 480505, population: 0)
province = region.provinces.create(description: "Tëploye", country: state, continent: continent,  geoname_id: 483576, population: 0)
province = region.provinces.create(description: "Tëploye", country: state, continent: continent,  geoname_id: 483578, population: 0)
province = region.provinces.create(description: "Usman'", country: state, continent: continent,  geoname_id: 478317, population: 19910)
province = region.provinces.create(description: "Uspenskoye", country: state, continent: continent,  geoname_id: 478192, population: 0)
province = region.provinces.create(description: "Utkino", country: state, continent: continent,  geoname_id: 477723, population: 0)
province = region.provinces.create(description: "Vednoye", country: state, continent: continent,  geoname_id: 476224, population: 0)
province = region.provinces.create(description: "Verbilovo", country: state, continent: continent,  geoname_id: 475842, population: 0)
province = region.provinces.create(description: "Verkhneye Bruslanovo", country: state, continent: continent,  geoname_id: 475406, population: 0)
province = region.provinces.create(description: "Verkhniy Studenets", country: state, continent: continent,  geoname_id: 474834, population: 0)
province = region.provinces.create(description: "Vertyach'ye", country: state, continent: continent,  geoname_id: 474192, population: 0)
province = region.provinces.create(description: "Veshalovka", country: state, continent: continent,  geoname_id: 474006, population: 0)
province = region.provinces.create(description: "Vesëlaya", country: state, continent: continent,  geoname_id: 474154, population: 0)
province = region.provinces.create(description: "Vislaya Polyana", country: state, continent: continent,  geoname_id: 473362, population: 0)
province = region.provinces.create(description: "Volovo", country: state, continent: continent,  geoname_id: 472306, population: 4036)
province = region.provinces.create(description: "Yazykovo", country: state, continent: continent,  geoname_id: 507566, population: 0)
province = region.provinces.create(description: "Yelets", country: state, continent: continent,  geoname_id: 467978, population: 115688)
municipalities = [
province.municipalities.new(description: "Argamach", region: region, country: state, continent: continent, geoname_id: 581144, population: 0),
province.municipalities.new(description: "Zaton", region: region, country: state, continent: continent, geoname_id: 7451878, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Zadonsk", country: state, continent: continent,  geoname_id: 465726, population: 10326)
province = region.provinces.create(description: "Zarechnoye", country: state, continent: continent,  geoname_id: 551333, population: 0)
region = Region.create(description: "MO", country: state, continent: continent, geoname_id: 524925)
province = region.provinces.create(description: "Aeroport District", country: state, continent: continent,  geoname_id: 9881959, population: 0)
province = region.provinces.create(description: "Akademichesky District", country: state, continent: continent,  geoname_id: 9883011, population: 0)
province = region.provinces.create(description: "Alexeyevsky District", country: state, continent: continent,  geoname_id: 9881975, population: 0)
province = region.provinces.create(description: "Altufyevsky District", country: state, continent: continent,  geoname_id: 9881976, population: 0)
province = region.provinces.create(description: "Arbat District", country: state, continent: continent,  geoname_id: 9881948, population: 0)
province = region.provinces.create(description: "Babushkinsky District", country: state, continent: continent,  geoname_id: 9881977, population: 0)
province = region.provinces.create(description: "Balashikhinskiy Rayon", country: state, continent: continent,  geoname_id: 579462, population: 0)
province = region.provinces.create(description: "Basmanny District", country: state, continent: continent,  geoname_id: 9881949, population: 0)
province = region.provinces.create(description: "Begovoy District", country: state, continent: continent,  geoname_id: 9881960, population: 0)
province = region.provinces.create(description: "Bibirevo District", country: state, continent: continent,  geoname_id: 9881978, population: 0)
province = region.provinces.create(description: "Biryulyovo Vostochnoye District", country: state, continent: continent,  geoname_id: 9882995, population: 0)
province = region.provinces.create(description: "Biryulyovo Zapadnoye District", country: state, continent: continent,  geoname_id: 9882996, population: 0)
province = region.provinces.create(description: "Bogorodskoye District", country: state, continent: continent,  geoname_id: 9882949, population: 0)
province = region.provinces.create(description: "Brateyevo District", country: state, continent: continent,  geoname_id: 9882997, population: 0)
province = region.provinces.create(description: "Butyrsky District", country: state, continent: continent,  geoname_id: 9881979, population: 0)
province = region.provinces.create(description: "Chekhovskiy Rayon", country: state, continent: continent,  geoname_id: 569587, population: 0)
municipalities = [
province.municipalities.new(description: "Chekhov", region: region, country: state, continent: continent, geoname_id: 569591, population: 75643),
province.municipalities.new(description: "Novaya Ol'khovka", region: region, country: state, continent: continent, geoname_id: 818501, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Chertanovo Severnoye District", country: state, continent: continent,  geoname_id: 9882998, population: 0)
province = region.provinces.create(description: "Chertanovo Tsentralnoye District", country: state, continent: continent,  geoname_id: 9882999, population: 0)
province = region.provinces.create(description: "Chertanovo Yuzhnoye District", country: state, continent: continent,  geoname_id: 9883000, population: 0)
province = region.provinces.create(description: "Cheryomushki District", country: state, continent: continent,  geoname_id: 9883012, population: 0)
province = region.provinces.create(description: "Danilovsky District", country: state, continent: continent,  geoname_id: 9883001, population: 0)
province = region.provinces.create(description: "Dmitrovskiy Rayon", country: state, continent: continent,  geoname_id: 565909, population: 0)
province = region.provinces.create(description: "Dmitrovsky District", country: state, continent: continent,  geoname_id: 9881961, population: 0)
province = region.provinces.create(description: "Domodedovskiy Rayon", country: state, continent: continent,  geoname_id: 565379, population: 0)
province = region.provinces.create(description: "Donskoy District", country: state, continent: continent,  geoname_id: 9883002, population: 0)
province = region.provinces.create(description: "Dorogomilovo District", country: state, continent: continent,  geoname_id: 9883027, population: 0)
province = region.provinces.create(description: "Fili-Davydkovo District", country: state, continent: continent,  geoname_id: 9883029, population: 0)
province = region.provinces.create(description: "Filyovsky park District", country: state, continent: continent,  geoname_id: 9883028, population: 0)
province = region.provinces.create(description: "Gagarinsky District", country: state, continent: continent,  geoname_id: 9883013, population: 0)
province = region.provinces.create(description: "Golovinsky District", country: state, continent: continent,  geoname_id: 9881962, population: 0)
province = region.provinces.create(description: "Golyanovo District", country: state, continent: continent,  geoname_id: 9882950, population: 0)
province = region.provinces.create(description: "Ivanovskoye District", country: state, continent: continent,  geoname_id: 9882951, population: 0)
province = region.provinces.create(description: "Izmaylovo District", country: state, continent: continent,  geoname_id: 9882952, population: 0)
province = region.provinces.create(description: "Kapotnya District", country: state, continent: continent,  geoname_id: 9882964, population: 0)
province = region.provinces.create(description: "Khamovniki District", country: state, continent: continent,  geoname_id: 9881950, population: 0)
province = region.provinces.create(description: "Khimkinskiy Rayon", country: state, continent: continent,  geoname_id: 550279, population: 0)
province = region.provinces.create(description: "Khoroshevo-Mnevniki District", country: state, continent: continent,  geoname_id: 9883039, population: 0)
province = region.provinces.create(description: "Khoroshyovsky District", country: state, continent: continent,  geoname_id: 9881963, population: 0)
province = region.provinces.create(description: "Khovrino District", country: state, continent: continent,  geoname_id: 9881964, population: 0)
province = region.provinces.create(description: "Konkovo District", country: state, continent: continent,  geoname_id: 9883014, population: 0)
province = region.provinces.create(description: "Koptevo District", country: state, continent: continent,  geoname_id: 9881965, population: 0)
province = region.provinces.create(description: "Kosino-Ukhtomsky District", country: state, continent: continent,  geoname_id: 9882953, population: 0)
province = region.provinces.create(description: "Kotlovka District", country: state, continent: continent,  geoname_id: 9883015, population: 0)
province = region.provinces.create(description: "Krasnogorskiy Rayon", country: state, continent: continent,  geoname_id: 542363, population: 0)
province = region.provinces.create(description: "Krasnoselsky District", country: state, continent: continent,  geoname_id: 9881951, population: 0)
province = region.provinces.create(description: "Krylatskoye District", country: state, continent: continent,  geoname_id: 9883030, population: 0)
province = region.provinces.create(description: "Kryukovo District", country: state, continent: continent,  geoname_id: 9883065, population: 0)
province = region.provinces.create(description: "Kuntsevo District", country: state, continent: continent,  geoname_id: 9883031, population: 0)
province = region.provinces.create(description: "Kurkino District", country: state, continent: continent,  geoname_id: 9883040, population: 0)
province = region.provinces.create(description: "Kuzminki District", country: state, continent: continent,  geoname_id: 9882965, population: 0)
province = region.provinces.create(description: "Lefortovo District", country: state, continent: continent,  geoname_id: 9882966, population: 0)
province = region.provinces.create(description: "Leninskiy Rayon", country: state, continent: continent,  geoname_id: 536086, population: 0)
municipalities = [
province.municipalities.new(description: "Michurinets", region: region, country: state, continent: continent, geoname_id: 6417569, population: 0),
province.municipalities.new(description: "Molokovo", region: region, country: state, continent: continent, geoname_id: 525510, population: 3080),
province.municipalities.new(description: "Sovkhoz Imeni Lenina", region: region, country: state, continent: continent, geoname_id: 6417432, population: 0),
province.municipalities.new(description: "Vnukovo", region: region, country: state, continent: continent, geoname_id: 857689, population: 20000),
]
Municipality.import municipalities
province = region.provinces.create(description: "Levoberezhny District", country: state, continent: continent,  geoname_id: 9881967, population: 0)
province = region.provinces.create(description: "Lianozovo District", country: state, continent: continent,  geoname_id: 9881980, population: 0)
province = region.provinces.create(description: "Lomonosovsky District", country: state, continent: continent,  geoname_id: 9883016, population: 0)
province = region.provinces.create(description: "Losinoostrovsky District", country: state, continent: continent,  geoname_id: 9881983, population: 0)
province = region.provinces.create(description: "Lotoshinskiy Rayon", country: state, continent: continent,  geoname_id: 533974, population: 18111)
province = region.provinces.create(description: "Lyuberetskiy Rayon", country: state, continent: continent,  geoname_id: 532616, population: 0)
municipalities = [
province.municipalities.new(description: "Пляж", region: region, country: state, continent: continent, geoname_id: 7303562, population: 0),
province.municipalities.new(description: "Угрешская 6", region: region, country: state, continent: continent, geoname_id: 7303556, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Lyublino District", country: state, continent: continent,  geoname_id: 9882967, population: 0)
province = region.provinces.create(description: "Marfino District", country: state, continent: continent,  geoname_id: 9881984, population: 0)
province = region.provinces.create(description: "Maryina Roshcha District", country: state, continent: continent,  geoname_id: 9881985, population: 0)
province = region.provinces.create(description: "Maryino District", country: state, continent: continent,  geoname_id: 9882968, population: 0)
province = region.provinces.create(description: "Matushkino District", country: state, continent: continent,  geoname_id: 9883062, population: 0)
province = region.provinces.create(description: "Meshchansky District", country: state, continent: continent,  geoname_id: 9881952, population: 0)
province = region.provinces.create(description: "Metrogorodok District", country: state, continent: continent,  geoname_id: 9882954, population: 0)
province = region.provinces.create(description: "Mitino District", country: state, continent: continent,  geoname_id: 9883041, population: 0)
province = region.provinces.create(description: "Molzhaninovsky District", country: state, continent: continent,  geoname_id: 9881968, population: 0)
province = region.provinces.create(description: "Moskvorechye-Saburovo District", country: state, continent: continent,  geoname_id: 9883003, population: 0)
province = region.provinces.create(description: "Mozhaysky District", country: state, continent: continent,  geoname_id: 9883032, population: 0)
province = region.provinces.create(description: "Mytishchinskiy Rayon", country: state, continent: continent,  geoname_id: 523810, population: 0)
municipalities = [
province.municipalities.new(description: "Vysokovo", region: region, country: state, continent: continent, geoname_id: 470135, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Nagatino-Sadovniki District", country: state, continent: continent,  geoname_id: 9883004, population: 0)
province = region.provinces.create(description: "Nagatinsky Zaton District", country: state, continent: continent,  geoname_id: 9883005, population: 0)
province = region.provinces.create(description: "Nagorny District", country: state, continent: continent,  geoname_id: 9883006, population: 0)
province = region.provinces.create(description: "Nekrasovka District", country: state, continent: continent,  geoname_id: 9882971, population: 0)
province = region.provinces.create(description: "Nizhegorodsky District", country: state, continent: continent,  geoname_id: 9882972, population: 0)
province = region.provinces.create(description: "Noginskiy Rayon", country: state, continent: continent,  geoname_id: 520066, population: 0)
province = region.provinces.create(description: "Novo-Peredelkino District", country: state, continent: continent,  geoname_id: 9883033, population: 0)
province = region.provinces.create(description: "Novogireyevo District", country: state, continent: continent,  geoname_id: 9882955, population: 0)
province = region.provinces.create(description: "Novokosino District", country: state, continent: continent,  geoname_id: 9882956, population: 0)
province = region.provinces.create(description: "Obruchevsky District", country: state, continent: continent,  geoname_id: 9883017, population: 0)
province = region.provinces.create(description: "Ochakovo-Matveyevskoye District", country: state, continent: continent,  geoname_id: 9883034, population: 0)
province = region.provinces.create(description: "Orekhovo-Borisovo Severnoye District", country: state, continent: continent,  geoname_id: 9883007, population: 0)
province = region.provinces.create(description: "Orekhovo-Borisovo Yuzhnoye District", country: state, continent: continent,  geoname_id: 9883008, population: 0)
province = region.provinces.create(description: "Ostankinsky District", country: state, continent: continent,  geoname_id: 9881986, population: 0)
province = region.provinces.create(description: "Otradnoye District", country: state, continent: continent,  geoname_id: 9881987, population: 0)
province = region.provinces.create(description: "Pavlovo-Posadskiy Rayon", country: state, continent: continent,  geoname_id: 512055, population: 0)
province = region.provinces.create(description: "Pechatniki District", country: state, continent: continent,  geoname_id: 9882973, population: 0)
province = region.provinces.create(description: "Podol'skiy Rayon", country: state, continent: continent,  geoname_id: 508091, population: 0)
municipalities = [
province.municipalities.new(description: "Podolsk", region: region, country: state, continent: continent, geoname_id: 508101, population: 179400),
]
Municipality.import municipalities
province = region.provinces.create(description: "Pokrovskoye-Streshnevo District", country: state, continent: continent,  geoname_id: 9883057, population: 0)
province = region.provinces.create(description: "Preobrazhenskoye District", country: state, continent: continent,  geoname_id: 9882957, population: 0)
province = region.provinces.create(description: "Presnensky District", country: state, continent: continent,  geoname_id: 9881953, population: 0)
province = region.provinces.create(description: "Prospekt Vernadskogo District", country: state, continent: continent,  geoname_id: 9883035, population: 0)
province = region.provinces.create(description: "Pushkinskiy Rayon", country: state, continent: continent,  geoname_id: 503964, population: 0)
province = region.provinces.create(description: "Ramenki District", country: state, continent: continent,  geoname_id: 9883036, population: 0)
province = region.provinces.create(description: "Rostokino District", country: state, continent: continent,  geoname_id: 9882944, population: 0)
province = region.provinces.create(description: "Ryazansky District", country: state, continent: continent,  geoname_id: 9882979, population: 0)
province = region.provinces.create(description: "Savyolovsky District", country: state, continent: continent,  geoname_id: 9881969, population: 0)
province = region.provinces.create(description: "Serpukhovskiy Rayon", country: state, continent: continent,  geoname_id: 496526, population: 33906)
province = region.provinces.create(description: "Severnoye Butovo District", country: state, continent: continent,  geoname_id: 9883018, population: 0)
province = region.provinces.create(description: "Severnoye Izmaylovo District", country: state, continent: continent,  geoname_id: 9882958, population: 0)
province = region.provinces.create(description: "Severnoye Medvedkovo District", country: state, continent: continent,  geoname_id: 9882945, population: 0)
province = region.provinces.create(description: "Severnoye Tushino District", country: state, continent: continent,  geoname_id: 9883058, population: 0)
province = region.provinces.create(description: "Severny District", country: state, continent: continent,  geoname_id: 9882946, population: 0)
province = region.provinces.create(description: "Shakhovskoy Rayon", country: state, continent: continent,  geoname_id: 496029, population: 24915)
province = region.provinces.create(description: "Shchukino District", country: state, continent: continent,  geoname_id: 9883059, population: 0)
province = region.provinces.create(description: "Shchëlkovskiy Rayon", country: state, continent: continent,  geoname_id: 495337, population: 0)
municipalities = [
province.municipalities.new(description: "Bogoslovo", region: region, country: state, continent: continent, geoname_id: 575488, population: 685),
province.municipalities.new(description: "Grebnevo", region: region, country: state, continent: continent, geoname_id: 518858, population: 1161),
province.municipalities.new(description: "Kamshilovka", region: region, country: state, continent: continent, geoname_id: 875363, population: 6),
province.municipalities.new(description: "Koryakino", region: region, country: state, continent: continent, geoname_id: 552053, population: 7),
province.municipalities.new(description: "Novaya Sloboda", region: region, country: state, continent: continent, geoname_id: 519493, population: 91),
province.municipalities.new(description: "Novo", region: region, country: state, continent: continent, geoname_id: 8299507, population: 252),
province.municipalities.new(description: "Novofryazino", region: region, country: state, continent: continent, geoname_id: 8299506, population: 321),
province.municipalities.new(description: "Saburovo", region: region, country: state, continent: continent, geoname_id: 499624, population: 30),
province.municipalities.new(description: "Staraya Sloboda", region: region, country: state, continent: continent, geoname_id: 489067, population: 117),
]
Municipality.import municipalities
province = region.provinces.create(description: "Silino District", country: state, continent: continent,  geoname_id: 9883064, population: 0)
province = region.provinces.create(description: "Sokol District", country: state, continent: continent,  geoname_id: 9881970, population: 0)
province = region.provinces.create(description: "Sokolinaya gora District", country: state, continent: continent,  geoname_id: 9882959, population: 0)
province = region.provinces.create(description: "Sokolniki District", country: state, continent: continent,  geoname_id: 9882960, population: 0)
province = region.provinces.create(description: "Solntsevo District", country: state, continent: continent,  geoname_id: 9883037, population: 0)
province = region.provinces.create(description: "Staroye Kryukovo District", country: state, continent: continent,  geoname_id: 9883063, population: 0)
province = region.provinces.create(description: "Strogino District", country: state, continent: continent,  geoname_id: 9883060, population: 0)
province = region.provinces.create(description: "Sviblovo District", country: state, continent: continent,  geoname_id: 9882947, population: 0)
province = region.provinces.create(description: "Tagansky District", country: state, continent: continent,  geoname_id: 9881954, population: 0)
province = region.provinces.create(description: "Tekstilshchiki District", country: state, continent: continent,  geoname_id: 9882984, population: 0)
province = region.provinces.create(description: "Timiryazevsky District", country: state, continent: continent,  geoname_id: 9881971, population: 0)
province = region.provinces.create(description: "Troparyovo-Nikulino District", country: state, continent: continent,  geoname_id: 9883038, population: 0)
province = region.provinces.create(description: "Tsaritsyno District", country: state, continent: continent,  geoname_id: 9883009, population: 0)
province = region.provinces.create(description: "Tverskoy District", country: state, continent: continent,  geoname_id: 9881955, population: 0)
province = region.provinces.create(description: "Tyoply Stan District", country: state, continent: continent,  geoname_id: 9883019, population: 0)
province = region.provinces.create(description: "Veshnyaki District", country: state, continent: continent,  geoname_id: 9882961, population: 0)
province = region.provinces.create(description: "Volokolamskiy Rayon", country: state, continent: continent,  geoname_id: 472430, population: 31435)
municipalities = [
province.municipalities.new(description: "Volokolamsk", region: region, country: state, continent: continent, geoname_id: 472433, population: 16276),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vostochnoye Degunino District", country: state, continent: continent,  geoname_id: 9881972, population: 0)
province = region.provinces.create(description: "Vostochnoye Izmaylovo District", country: state, continent: continent,  geoname_id: 9882962, population: 0)
province = region.provinces.create(description: "Vostochny District", country: state, continent: continent,  geoname_id: 9882963, population: 0)
province = region.provinces.create(description: "Voykovsky District", country: state, continent: continent,  geoname_id: 9881973, population: 0)
province = region.provinces.create(description: "Vykhino-Zhulebino District", country: state, continent: continent,  geoname_id: 9882985, population: 0)
province = region.provinces.create(description: "Yakimanka District", country: state, continent: continent,  geoname_id: 9881957, population: 0)
province = region.provinces.create(description: "Yaroslavsky District", country: state, continent: continent,  geoname_id: 9882948, population: 0)
province = region.provinces.create(description: "Yasenevo District", country: state, continent: continent,  geoname_id: 9883020, population: 0)
province = region.provinces.create(description: "Yuzhnoportovy District", country: state, continent: continent,  geoname_id: 9882986, population: 0)
province = region.provinces.create(description: "Yuzhnoye Butovo District", country: state, continent: continent,  geoname_id: 9883021, population: 0)
province = region.provinces.create(description: "Yuzhnoye Tushino District", country: state, continent: continent,  geoname_id: 9883061, population: 0)
province = region.provinces.create(description: "Zamoskvorechye District", country: state, continent: continent,  geoname_id: 9881958, population: 0)
province = region.provinces.create(description: "Zapadnoye Degunino District", country: state, continent: continent,  geoname_id: 9881974, population: 0)
province = region.provinces.create(description: "Zyablikovo District", country: state, continent: continent,  geoname_id: 9883010, population: 0)
province = region.provinces.create(description: "Zyuzino District", country: state, continent: continent,  geoname_id: 9883022, population: 0)
region = Region.create(description: "Magadanskaya Oblast'", country: state, continent: continent, geoname_id: 2123627)
province = region.provinces.create(description: "Gorod Magadan", country: state, continent: continent,  geoname_id: 2131663, population: 169501)
province = region.provinces.create(description: "Khasynskiy Rayon", country: state, continent: continent,  geoname_id: 2124738, population: 0)
province = region.provinces.create(description: "Ol'skiy Rayon", country: state, continent: continent,  geoname_id: 2122529, population: 0)
province = region.provinces.create(description: "Omsukchanskiy Rayon", country: state, continent: continent,  geoname_id: 2122490, population: 0)
province = region.provinces.create(description: "Severo-Evenskiy Rayon", country: state, continent: continent,  geoname_id: 2121386, population: 0)
province = region.provinces.create(description: "Srednekanskiy Rayon", country: state, continent: continent,  geoname_id: 2121026, population: 0)
province = region.provinces.create(description: "Susumanskiy Rayon", country: state, continent: continent,  geoname_id: 2120865, population: 0)
province = region.provinces.create(description: "Ten'kinskiy Rayon", country: state, continent: continent,  geoname_id: 2120639, population: 0)
province = region.provinces.create(description: "Yagodninskiy Rayon", country: state, continent: continent,  geoname_id: 2119629, population: 0)
region = Region.create(description: "Moscow", country: state, continent: continent, geoname_id: 524894)
province = region.provinces.create(description: "Central Administrative Okrug", country: state, continent: continent,  geoname_id: 562331, population: 0)
province = region.provinces.create(description: "North-Eastern Administrative Okrug", country: state, continent: continent,  geoname_id: 579866, population: 0)
province = region.provinces.create(description: "Novomoskovsky Administrative Okrug", country: state, continent: continent,  geoname_id: 8520892, population: 0)
municipalities = [
province.municipalities.new(description: "Kokoshkino", region: region, country: state, continent: continent, geoname_id: 546606, population: 9818),
province.municipalities.new(description: "Marushkino", region: region, country: state, continent: continent, geoname_id: 528919, population: 0),
province.municipalities.new(description: "Moskovskiy", region: region, country: state, continent: continent, geoname_id: 857690, population: 15435),
province.municipalities.new(description: "Sharapovo", region: region, country: state, continent: continent, geoname_id: 495742, population: 0),
province.municipalities.new(description: "Shcherbinka", region: region, country: state, continent: continent, geoname_id: 495260, population: 28065),
province.municipalities.new(description: "Starosyrovo", region: region, country: state, continent: continent, geoname_id: 485157, population: 0),
province.municipalities.new(description: "Znamya Oktyabrya", region: region, country: state, continent: continent, geoname_id: 6417084, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Severnyy Administrativnyy Okrug", country: state, continent: continent,  geoname_id: 471823, population: 0)
province = region.provinces.create(description: "Severo-Zapadnyy Administrativnyy Okrug", country: state, continent: continent,  geoname_id: 480141, population: 0)
province = region.provinces.create(description: "South-Eastern Administrative Okrug", country: state, continent: continent,  geoname_id: 532527, population: 0)
province = region.provinces.create(description: "South-Western Administrative Okrug", country: state, continent: continent,  geoname_id: 562221, population: 0)
province = region.provinces.create(description: "Southern Administrative Okrug", country: state, continent: continent,  geoname_id: 490025, population: 0)
province = region.provinces.create(description: "Troitsky Administrative Okrug", country: state, continent: continent,  geoname_id: 8520893, population: 0)
municipalities = [
province.municipalities.new(description: "Rassudovo", region: region, country: state, continent: continent, geoname_id: 502751, population: 300),
province.municipalities.new(description: "Troitsk", region: region, country: state, continent: continent, geoname_id: 481608, population: 37591),
province.municipalities.new(description: "Zhukovka", region: region, country: state, continent: continent, geoname_id: 6417158, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Zapadnyy Administrativnyy Okrug", country: state, continent: continent,  geoname_id: 490968, population: 0)
province = region.provinces.create(description: "Zelenogradsky Administrative Okrug", country: state, continent: continent,  geoname_id: 8520888, population: 0)
province = region.provinces.create(description: "ВАО", country: state, continent: continent,  geoname_id: 8520891, population: 0)
region = Region.create(description: "Murmansk", country: state, continent: continent, geoname_id: 524304)
province = region.provinces.create(description: "Abram Mys", country: state, continent: continent,  geoname_id: 559324, population: 0)
municipalities = [
province.municipalities.new(description: "Abram-Mys", region: region, country: state, continent: continent, geoname_id: 584410, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Afrikanda", country: state, continent: continent,  geoname_id: 584087, population: 1800)
province = region.provinces.create(description: "Akhmalakhti", country: state, continent: continent,  geoname_id: 583867, population: 0)
province = region.provinces.create(description: "Alakurtti", country: state, continent: continent,  geoname_id: 583472, population: 6293)
province = region.provinces.create(description: "Apatity", country: state, continent: continent,  geoname_id: 581357, population: 61186)
municipalities = [
province.municipalities.new(description: "Belorechenskiy", region: region, country: state, continent: continent, geoname_id: 577887, population: 0),
province.municipalities.new(description: "Molodëzhnyy", region: region, country: state, continent: continent, geoname_id: 525555, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ara", country: state, continent: continent,  geoname_id: 581289, population: 0)
province = region.provinces.create(description: "Belokamenka", country: state, continent: continent,  geoname_id: 577949, population: 0)
province = region.provinces.create(description: "Beloye More", country: state, continent: continent,  geoname_id: 871270, population: 0)
province = region.provinces.create(description: "Bol'shoye Ozerko", country: state, continent: continent,  geoname_id: 573427, population: 0)
province = region.provinces.create(description: "Bol'shaya Kumuzh'ya", country: state, continent: continent,  geoname_id: 574952, population: 0)
province = region.provinces.create(description: "Borisoglebsk", country: state, continent: continent,  geoname_id: 572523, population: 0)
province = region.provinces.create(description: "Chal'mny-Varre", country: state, continent: continent,  geoname_id: 570034, population: 0)
province = region.provinces.create(description: "Chan-Ruchey", country: state, continent: continent,  geoname_id: 569986, population: 0)
province = region.provinces.create(description: "Chapoma", country: state, continent: continent,  geoname_id: 569925, population: 0)
province = region.provinces.create(description: "Chavan'ga", country: state, continent: continent,  geoname_id: 569772, population: 0)
province = region.provinces.create(description: "Chirvis-Guba", country: state, continent: continent,  geoname_id: 568034, population: 0)
province = region.provinces.create(description: "Dal'niye Zelentsy", country: state, continent: continent,  geoname_id: 567241, population: 20)
province = region.provinces.create(description: "Drozdovka", country: state, continent: continent,  geoname_id: 564961, population: 0)
province = region.provinces.create(description: "Fedoseyevka", country: state, continent: continent,  geoname_id: 563042, population: 0)
province = region.provinces.create(description: "Gabrish", country: state, continent: continent,  geoname_id: 562273, population: 0)
province = region.provinces.create(description: "Gadzhiyevo", country: state, continent: continent,  geoname_id: 562245, population: 14225)
province = region.provinces.create(description: "Gangos", country: state, continent: continent,  geoname_id: 562047, population: 0)
province = region.provinces.create(description: "Goryachiye Ruch'i", country: state, continent: continent,  geoname_id: 559318, population: 0)
province = region.provinces.create(description: "Granitnyy", country: state, continent: continent,  geoname_id: 559055, population: 0)
province = region.provinces.create(description: "Gremikha", country: state, continent: continent,  geoname_id: 558929, population: 0)
province = region.provinces.create(description: "Hangasniemi", country: state, continent: continent,  geoname_id: 553144, population: 0)
province = region.provinces.create(description: "Imandra", country: state, continent: continent,  geoname_id: 556885, population: 0)
province = region.provinces.create(description: "Indel'", country: state, continent: continent,  geoname_id: 831418, population: 0)
province = region.provinces.create(description: "Iokangskiy", country: state, continent: continent,  geoname_id: 556266, population: 0)
province = region.provinces.create(description: "Izba Bol'shaya Bab'ya", country: state, continent: continent,  geoname_id: 554904, population: 0)
province = region.provinces.create(description: "Kachalovka", country: state, continent: continent,  geoname_id: 554630, population: 0)
province = region.provinces.create(description: "Kakuri", country: state, continent: continent,  geoname_id: 554424, population: 0)
province = region.provinces.create(description: "Kalyuzhnyy", country: state, continent: continent,  geoname_id: 831274, population: 0)
province = region.provinces.create(description: "Kamenskiy", country: state, continent: continent,  geoname_id: 553412, population: 0)
province = region.provinces.create(description: "Kandalaksha", country: state, continent: continent,  geoname_id: 553190, population: 38431)
municipalities = [
province.municipalities.new(description: "Niva Tret'ya", region: region, country: state, continent: continent, geoname_id: 521264, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Kanëvka", country: state, continent: continent,  geoname_id: 553153, population: 0)
province = region.provinces.create(description: "Kashkarantsy", country: state, continent: continent,  geoname_id: 551933, population: 80)
province = region.provinces.create(description: "Katskim-Ozero", country: state, continent: continent,  geoname_id: 551745, population: 0)
province = region.provinces.create(description: "Kaylara", country: state, continent: continent,  geoname_id: 551619, population: 0)
province = region.provinces.create(description: "Kervanto", country: state, continent: continent,  geoname_id: 550972, population: 0)
province = region.provinces.create(description: "Khabozero", country: state, continent: continent,  geoname_id: 550856, population: 0)
province = region.provinces.create(description: "Kharlovka", country: state, continent: continent,  geoname_id: 550521, population: 0)
province = region.provinces.create(description: "Khibiny", country: state, continent: continent,  geoname_id: 550317, population: 0)
province = region.provinces.create(description: "Khyamruchey", country: state, continent: continent,  geoname_id: 873056, population: 0)
province = region.provinces.create(description: "Kichany", country: state, continent: continent,  geoname_id: 548819, population: 0)
province = region.provinces.create(description: "Kil'dinstroy", country: state, continent: continent,  geoname_id: 548723, population: 0)
province = region.provinces.create(description: "Kirovsk", country: state, continent: continent,  geoname_id: 548391, population: 29605)
province = region.provinces.create(description: "Kitsa", country: state, continent: continent,  geoname_id: 548034, population: 0)
province = region.provinces.create(description: "Knyazhaya Guba", country: state, continent: continent,  geoname_id: 547108, population: 0)
province = region.provinces.create(description: "Kola", country: state, continent: continent,  geoname_id: 546554, population: 10600)
province = region.provinces.create(description: "Kolvitsa", country: state, continent: continent,  geoname_id: 546033, population: 0)
province = region.provinces.create(description: "Komsomol'sk", country: state, continent: continent,  geoname_id: 545735, population: 0)
province = region.provinces.create(description: "Korabel'noye", country: state, continent: continent,  geoname_id: 545013, population: 0)
province = region.provinces.create(description: "Korzunovo", country: state, continent: continent,  geoname_id: 544322, population: 0)
province = region.provinces.create(description: "Kovd Zapon'ye", country: state, continent: continent,  geoname_id: 543500, population: 0)
province = region.provinces.create(description: "Kovda", country: state, continent: continent,  geoname_id: 543513, population: 20)
province = region.provinces.create(description: "Kovdor", country: state, continent: continent,  geoname_id: 543508, population: 19518)
province = region.provinces.create(description: "Kovdozero", country: state, continent: continent,  geoname_id: 543502, population: 0)
province = region.provinces.create(description: "Krasnoshchel'ye", country: state, continent: continent,  geoname_id: 542217, population: 0)
province = region.provinces.create(description: "Kuna", country: state, continent: continent,  geoname_id: 539202, population: 0)
province = region.provinces.create(description: "Kuoloyarvi", country: state, continent: continent,  geoname_id: 539084, population: 0)
province = region.provinces.create(description: "Kuropta", country: state, continent: continent,  geoname_id: 831270, population: 0)
province = region.provinces.create(description: "Kuzomen'", country: state, continent: continent,  geoname_id: 537604, population: 78)
province = region.provinces.create(description: "Laplandiya", country: state, continent: continent,  geoname_id: 536984, population: 0)
province = region.provinces.create(description: "Lebyazh'ye", country: state, continent: continent,  geoname_id: 536464, population: 0)
province = region.provinces.create(description: "Lesnoy", country: state, continent: continent,  geoname_id: 871259, population: 0)
province = region.provinces.create(description: "Lesozavodskiy", country: state, continent: continent,  geoname_id: 535651, population: 0)
province = region.provinces.create(description: "Liinakhamari", country: state, continent: continent,  geoname_id: 535185, population: 0)
province = region.provinces.create(description: "Lodeynoye", country: state, continent: continent,  geoname_id: 534561, population: 0)
province = region.provinces.create(description: "Loparskaya", country: state, continent: continent,  geoname_id: 534240, population: 0)
province = region.provinces.create(description: "Lopskaya", country: state, continent: continent,  geoname_id: 534136, population: 0)
province = region.provinces.create(description: "Lovozero", country: state, continent: continent,  geoname_id: 533933, population: 2963)
province = region.provinces.create(description: "Lumbovka", country: state, continent: continent,  geoname_id: 533345, population: 0)
province = region.provinces.create(description: "Lumbovskaya", country: state, continent: continent,  geoname_id: 533343, population: 0)
province = region.provinces.create(description: "Luostari", country: state, continent: continent,  geoname_id: 533254, population: 0)
province = region.provinces.create(description: "Luven'ga", country: state, continent: continent,  geoname_id: 533150, population: 0)
province = region.provinces.create(description: "Lyagkomina", country: state, continent: continent,  geoname_id: 532949, population: 0)
province = region.provinces.create(description: "Maloolen'ye", country: state, continent: continent,  geoname_id: 530625, population: 0)
province = region.provinces.create(description: "Mayak Nikodimskiy", country: state, continent: continent,  geoname_id: 870705, population: 0)
province = region.provinces.create(description: "Mayatalo", country: state, continent: continent,  geoname_id: 528325, population: 0)
province = region.provinces.create(description: "Mezhdurech'ye", country: state, continent: continent,  geoname_id: 795250, population: 0)
province = region.provinces.create(description: "Min'kino", country: state, continent: continent,  geoname_id: 828221, population: 0)
province = region.provinces.create(description: "Mishukovo", country: state, continent: continent,  geoname_id: 795249, population: 0)
province = region.provinces.create(description: "Mokket", country: state, continent: continent,  geoname_id: 525768, population: 0)
province = region.provinces.create(description: "Molochnyy", country: state, continent: continent,  geoname_id: 866057, population: 5308)
province = region.provinces.create(description: "Monchegorsk", country: state, continent: continent,  geoname_id: 525404, population: 49868)
municipalities = [
province.municipalities.new(description: "Sotsialisticheskiy Gorod", region: region, country: state, continent: continent, geoname_id: 490094, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Mosha", country: state, continent: continent,  geoname_id: 525059, population: 0)
province = region.provinces.create(description: "Murmansk", country: state, continent: continent,  geoname_id: 524305, population: 319263)
municipalities = [
province.municipalities.new(description: "Bol'nichnyy Gorodok", region: region, country: state, continent: continent, geoname_id: 795258, population: 0),
province.municipalities.new(description: "Drovyanoy", region: region, country: state, continent: continent, geoname_id: 564965, population: 0),
province.municipalities.new(description: "Novoye Plato", region: region, country: state, continent: continent, geoname_id: 795259, population: 0),
province.municipalities.new(description: "Rosta", region: region, country: state, continent: continent, geoname_id: 501203, population: 0),
province.municipalities.new(description: "Severnoye Nagornoye", region: region, country: state, continent: continent, geoname_id: 523599, population: 0),
province.municipalities.new(description: "Stroiteley", region: region, country: state, continent: continent, geoname_id: 795257, population: 0),
province.municipalities.new(description: "Zelënyy Mys", region: region, country: state, continent: continent, geoname_id: 795260, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Murmashi", country: state, continent: continent,  geoname_id: 524299, population: 14152)
province = region.provinces.create(description: "Nautsi", country: state, continent: continent,  geoname_id: 523205, population: 0)
province = region.provinces.create(description: "Neyukhenyarvi", country: state, continent: continent,  geoname_id: 550334, population: 0)
province = region.provinces.create(description: "Nikel", country: state, continent: continent,  geoname_id: 522260, population: 15596)
province = region.provinces.create(description: "Nivankyul'", country: state, continent: continent,  geoname_id: 521268, population: 0)
province = region.provinces.create(description: "Nivskiy", country: state, continent: continent,  geoname_id: 521240, population: 0)
province = region.provinces.create(description: "Novaya Titovka", country: state, continent: continent,  geoname_id: 482666, population: 0)
province = region.provinces.create(description: "Nyal", country: state, continent: continent,  geoname_id: 7095445, population: 0)
province = region.provinces.create(description: "Nyam-Ozero", country: state, continent: continent,  geoname_id: 516649, population: 0)
province = region.provinces.create(description: "Nyudoayvench", country: state, continent: continent,  geoname_id: 516564, population: 0)
province = region.provinces.create(description: "Oktyabr'skiy", country: state, continent: continent,  geoname_id: 829167, population: 0)
province = region.provinces.create(description: "Olenegorsk", country: state, continent: continent,  geoname_id: 515698, population: 23670)
province = region.provinces.create(description: "Olenitsa", country: state, continent: continent,  geoname_id: 515682, population: 0)
province = region.provinces.create(description: "Ostrov Kharlov", country: state, continent: continent,  geoname_id: 863213, population: 10)
province = region.provinces.create(description: "Ostrovnoy", country: state, continent: continent,  geoname_id: 556268, population: 4746)
province = region.provinces.create(description: "Palkina-Guba", country: state, continent: continent,  geoname_id: 513044, population: 0)
province = region.provinces.create(description: "Parkkino", country: state, continent: continent,  geoname_id: 512536, population: 0)
province = region.provinces.create(description: "Pechenga", country: state, continent: continent,  geoname_id: 511865, population: 2791)
province = region.provinces.create(description: "Perekop", country: state, continent: continent,  geoname_id: 511453, population: 0)
province = region.provinces.create(description: "Pil'skiy", country: state, continent: continent,  geoname_id: 509527, population: 0)
province = region.provinces.create(description: "Pinozero", country: state, continent: continent,  geoname_id: 509459, population: 0)
province = region.provinces.create(description: "Pirenga", country: state, continent: continent,  geoname_id: 509424, population: 0)
province = region.provinces.create(description: "Pitkul'", country: state, continent: continent,  geoname_id: 516035, population: 0)
province = region.provinces.create(description: "Pitkyayarvi", country: state, continent: continent,  geoname_id: 509229, population: 0)
province = region.provinces.create(description: "Platonovka", country: state, continent: continent,  geoname_id: 509101, population: 0)
province = region.provinces.create(description: "Plekhanovo", country: state, continent: continent,  geoname_id: 509041, population: 0)
province = region.provinces.create(description: "Plesozero", country: state, continent: continent,  geoname_id: 508968, population: 0)
province = region.provinces.create(description: "Podkitsa", country: state, continent: continent,  geoname_id: 508274, population: 0)
province = region.provinces.create(description: "Podkitsa", country: state, continent: continent,  geoname_id: 508275, population: 0)
province = region.provinces.create(description: "Podmuna", country: state, continent: continent,  geoname_id: 508149, population: 0)
province = region.provinces.create(description: "Podpakhta", country: state, continent: continent,  geoname_id: 508046, population: 0)
province = region.provinces.create(description: "Polyarnyy", country: state, continent: continent,  geoname_id: 506763, population: 17332)
province = region.provinces.create(description: "Polyarnyye Zori", country: state, continent: continent,  geoname_id: 506762, population: 15092)
province = region.provinces.create(description: "Ponchozero", country: state, continent: continent,  geoname_id: 506690, population: 0)
province = region.provinces.create(description: "Poropirtti", country: state, continent: continent,  geoname_id: 506251, population: 0)
province = region.provinces.create(description: "Port-Vladimir", country: state, continent: continent,  geoname_id: 506182, population: 0)
province = region.provinces.create(description: "Poyakonda", country: state, continent: continent,  geoname_id: 505795, population: 3100)
province = region.provinces.create(description: "Prirechnyy", country: state, continent: continent,  geoname_id: 505216, population: 103)
province = region.provinces.create(description: "Prolivy", country: state, continent: continent,  geoname_id: 504774, population: 0)
province = region.provinces.create(description: "Pulozero", country: state, continent: continent,  geoname_id: 504166, population: 0)
province = region.provinces.create(description: "Purnulampi", country: state, continent: continent,  geoname_id: 504072, population: 0)
province = region.provinces.create(description: "Pushnoy", country: state, continent: continent,  geoname_id: 503949, population: 0)
province = region.provinces.create(description: "Pustaya Guba", country: state, continent: continent,  geoname_id: 503924, population: 0)
province = region.provinces.create(description: "Pyalitsa", country: state, continent: continent,  geoname_id: 503624, population: 0)
province = region.provinces.create(description: "Rayakoski", country: state, continent: continent,  geoname_id: 502572, population: 0)
province = region.provinces.create(description: "Razvumchorr", country: state, continent: continent,  geoname_id: 502385, population: 0)
province = region.provinces.create(description: "Retinskoye", country: state, continent: continent,  geoname_id: 502032, population: 0)
province = region.provinces.create(description: "Revda", country: state, continent: continent,  geoname_id: 502010, population: 9780)
province = region.provinces.create(description: "Rikolatva", country: state, continent: continent,  geoname_id: 831269, population: 0)
province = region.provinces.create(description: "Ristikent", country: state, continent: continent,  geoname_id: 501891, population: 0)
province = region.provinces.create(description: "Riyka", country: state, continent: continent,  geoname_id: 501869, population: 0)
province = region.provinces.create(description: "Rizh-Guba", country: state, continent: continent,  geoname_id: 501866, population: 0)
province = region.provinces.create(description: "Roslyakovo", country: state, continent: continent,  geoname_id: 501265, population: 8921)
municipalities = [
province.municipalities.new(description: "Malaya Chalmpushka", region: region, country: state, continent: continent, geoname_id: 570032, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ruch'i", country: state, continent: continent,  geoname_id: 871272, population: 0)
province = region.provinces.create(description: "Ruchey Tretiy", country: state, continent: continent,  geoname_id: 500800, population: 0)
municipalities = [
province.municipalities.new(description: "Tri Ruch'ya", region: region, country: state, continent: continent, geoname_id: 481676, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Ruchey Vtoroy", country: state, continent: continent,  geoname_id: 500799, population: 0)
municipalities = [
province.municipalities.new(description: "Dva Ruch'ya", region: region, country: state, continent: continent, geoname_id: 795251, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Rybpromkhoz", country: state, continent: continent,  geoname_id: 499954, population: 0)
province = region.provinces.create(description: "Rynda", country: state, continent: continent,  geoname_id: 499885, population: 0)
province = region.provinces.create(description: "Safonovo", country: state, continent: continent,  geoname_id: 499439, population: 4578)
province = region.provinces.create(description: "Sal'miyarvi", country: state, continent: continent,  geoname_id: 499225, population: 0)
province = region.provinces.create(description: "Sal'nitsa", country: state, continent: continent,  geoname_id: 499208, population: 0)
province = region.provinces.create(description: "Sava-Guba", country: state, continent: continent,  geoname_id: 498377, population: 0)
municipalities = [
province.municipalities.new(description: "Ozero Dlinnaya Guba", region: region, country: state, continent: continent, geoname_id: 566134, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Sayda-Guba", country: state, continent: continent,  geoname_id: 498103, population: 0)
province = region.provinces.create(description: "Set'-Navolok", country: state, continent: continent,  geoname_id: 795240, population: 0)
province = region.provinces.create(description: "Severnyy", country: state, continent: continent,  geoname_id: 496342, population: 0)
province = region.provinces.create(description: "Severomorsk", country: state, continent: continent,  geoname_id: 496278, population: 53921)
municipalities = [
province.municipalities.new(description: "Nizhneye Varlamovo", region: region, country: state, continent: continent, geoname_id: 477001, population: 0),
province.municipalities.new(description: "Severomorsk Odin", region: region, country: state, continent: continent, geoname_id: 795276, population: 0),
province.municipalities.new(description: "Staraya Vayenga", region: region, country: state, continent: continent, geoname_id: 795278, population: 0),
province.municipalities.new(description: "Verkhneye Varlamovo", region: region, country: state, continent: continent, geoname_id: 795271, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Severomorsk-3", country: state, continent: continent,  geoname_id: 6696921, population: 3125)
province = region.provinces.create(description: "Shchuch'ye", country: state, continent: continent,  geoname_id: 505814, population: 0)
province = region.provinces.create(description: "Shonguy", country: state, continent: continent,  geoname_id: 493795, population: 1122)
province = region.provinces.create(description: "Sigov Ruchey", country: state, continent: continent,  geoname_id: 493013, population: 0)
province = region.provinces.create(description: "Slyuda", country: state, continent: continent,  geoname_id: 491805, population: 0)
province = region.provinces.create(description: "Slyudyanka", country: state, continent: continent,  geoname_id: 491803, population: 0)
province = region.provinces.create(description: "Snezhnitsa", country: state, continent: continent,  geoname_id: 491544, population: 0)
province = region.provinces.create(description: "Snezhnogorsk", country: state, continent: continent,  geoname_id: 795243, population: 12014)
province = region.provinces.create(description: "Songel'skiy", country: state, continent: continent,  geoname_id: 490657, population: 0)
province = region.provinces.create(description: "Sosnovaya Guba", country: state, continent: continent,  geoname_id: 490381, population: 0)
province = region.provinces.create(description: "Sosnovka", country: state, continent: continent,  geoname_id: 490237, population: 0)
province = region.provinces.create(description: "Sputnik", country: state, continent: continent,  geoname_id: 870473, population: 0)
province = region.provinces.create(description: "Staraya Titovka", country: state, continent: continent,  geoname_id: 489048, population: 0)
province = region.provinces.create(description: "Svyatoy Nos", country: state, continent: continent,  geoname_id: 485411, population: 0)
province = region.provinces.create(description: "Taybola", country: state, continent: continent,  geoname_id: 483924, population: 0)
province = region.provinces.create(description: "Teribërka", country: state, continent: continent,  geoname_id: 483379, population: 1300)
province = region.provinces.create(description: "Tersko-Orlovskiy Mayak", country: state, continent: continent,  geoname_id: 483265, population: 0)
province = region.provinces.create(description: "Tetrino", country: state, continent: continent,  geoname_id: 483158, population: 0)
province = region.provinces.create(description: "Tovand", country: state, continent: continent,  geoname_id: 483981, population: 0)
province = region.provinces.create(description: "Tsypnavolok", country: state, continent: continent,  geoname_id: 480726, population: 0)
province = region.provinces.create(description: "Tuloma", country: state, continent: continent,  geoname_id: 480524, population: 0)
province = region.provinces.create(description: "Tumannyy", country: state, continent: continent,  geoname_id: 480472, population: 896)
province = region.provinces.create(description: "Umba", country: state, continent: continent,  geoname_id: 479071, population: 6128)
province = region.provinces.create(description: "Upoloksha", country: state, continent: continent,  geoname_id: 831267, population: 0)
province = region.provinces.create(description: "Ura-Guba", country: state, continent: continent,  geoname_id: 828219, population: 0)
province = region.provinces.create(description: "Ust'ye-Varzugi", country: state, continent: continent,  geoname_id: 477812, population: 0)
province = region.provinces.create(description: "Varzuga", country: state, continent: continent,  geoname_id: 476871, population: 0)
province = region.provinces.create(description: "Vaydaguba", country: state, continent: continent,  geoname_id: 829296, population: 0)
province = region.provinces.create(description: "Verkhnetulomskiy", country: state, continent: continent,  geoname_id: 475469, population: 1889)
province = region.provinces.create(description: "Vidyayevo", country: state, continent: continent,  geoname_id: 795235, population: 7062)
province = region.provinces.create(description: "Vidyayevo", country: state, continent: continent,  geoname_id: 473762, population: 5949)
municipalities = [
province.municipalities.new(description: "Yuzhnoye Nagornoye", region: region, country: state, continent: continent, geoname_id: 795252, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Vostochnaya Guba", country: state, continent: continent,  geoname_id: 471548, population: 0)
province = region.provinces.create(description: "Vostochnaya Litsa", country: state, continent: continent,  geoname_id: 471544, population: 0)
province = region.provinces.create(description: "Vostochnoye Munozero", country: state, continent: continent,  geoname_id: 471526, population: 0)
province = region.provinces.create(description: "Vostochnyy Kil'din", country: state, continent: continent,  geoname_id: 471493, population: 0)
province = region.provinces.create(description: "Vuoriyarvi", country: state, continent: continent,  geoname_id: 470881, population: 0)
province = region.provinces.create(description: "Yulyakurtti", country: state, continent: continent,  geoname_id: 466563, population: 0)
province = region.provinces.create(description: "Yëna", country: state, continent: continent,  geoname_id: 467524, population: 445)
province = region.provinces.create(description: "Yënskiy", country: state, continent: continent,  geoname_id: 831272, population: 0)
province = region.provinces.create(description: "Zakhrebetnoye", country: state, continent: continent,  geoname_id: 465359, population: 0)
province = region.provinces.create(description: "Zaozërsk", country: state, continent: continent,  geoname_id: 828218, population: 13429)
province = region.provinces.create(description: "Zapolyarnyy", country: state, continent: continent,  geoname_id: 464790, population: 17789)
municipalities = [
province.municipalities.new(description: "Gornyy", region: region, country: state, continent: continent, geoname_id: 559720, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Zarechensk", country: state, continent: continent,  geoname_id: 464680, population: 0)
province = region.provinces.create(description: "Zasheyek", country: state, continent: continent,  geoname_id: 464310, population: 983)
province = region.provinces.create(description: "Zelenoborskiy", country: state, continent: continent,  geoname_id: 463838, population: 7207)
province = region.provinces.create(description: "Zhemchuzhnaya", country: state, continent: continent,  geoname_id: 871256, population: 0)
region = Region.create(description: "Nenetskiy Avtonomnyy Okrug", country: state, continent: continent, geoname_id: 522652)
province = region.provinces.create(description: "Amderma", country: state, continent: continent,  geoname_id: 1511696, population: 609)
province = region.provinces.create(description: "Andeg", country: state, continent: continent,  geoname_id: 582124, population: 0)
province = region.provinces.create(description: "Arkhipovo", country: state, continent: continent,  geoname_id: 580952, population: 0)
province = region.provinces.create(description: "Bedovoye", country: state, continent: continent,  geoname_id: 578359, population: 0)
province = region.provinces.create(description: "Beloshchel'ye", country: state, continent: continent,  geoname_id: 577868, population: 0)
province = region.provinces.create(description: "Belush'ye", country: state, continent: continent,  geoname_id: 577672, population: 0)
province = region.provinces.create(description: "Bol'shaya Bugryanitsa", country: state, continent: continent,  geoname_id: 575189, population: 0)
province = region.provinces.create(description: "Bol'shaya Sopka", country: state, continent: continent,  geoname_id: 574621, population: 0)
province = region.provinces.create(description: "Bugrino", country: state, continent: continent,  geoname_id: 571204, population: 0)
province = region.provinces.create(description: "Chizha", country: state, continent: continent,  geoname_id: 567942, population: 0)
province = region.provinces.create(description: "Chupovo", country: state, continent: continent,  geoname_id: 567576, population: 0)
province = region.provinces.create(description: "Chërnaya", country: state, continent: continent,  geoname_id: 569060, population: 0)
province = region.provinces.create(description: "Chërnoye", country: state, continent: continent,  geoname_id: 568687, population: 0)
province = region.provinces.create(description: "Chërnyy", country: state, continent: continent,  geoname_id: 568521, population: 0)
province = region.provinces.create(description: "Chësha", country: state, continent: continent,  geoname_id: 568373, population: 0)
province = region.provinces.create(description: "Dedkovo", country: state, continent: continent,  geoname_id: 566879, population: 0)
province = region.provinces.create(description: "Dresvyanka", country: state, continent: continent,  geoname_id: 565015, population: 0)
province = region.provinces.create(description: "Filimon", country: state, continent: continent,  geoname_id: 562815, population: 0)
province = region.provinces.create(description: "Forikha", country: state, continent: continent,  geoname_id: 512561, population: 0)
province = region.provinces.create(description: "Golubkovo", country: state, continent: continent,  geoname_id: 560507, population: 0)
province = region.provinces.create(description: "Gorby", country: state, continent: continent,  geoname_id: 560214, population: 0)
province = region.provinces.create(description: "Gorby", country: state, continent: continent,  geoname_id: 560216, population: 0)
province = region.provinces.create(description: "Gorby", country: state, continent: continent,  geoname_id: 560215, population: 0)
province = region.provinces.create(description: "Greben'", country: state, continent: continent,  geoname_id: 559015, population: 0)
province = region.provinces.create(description: "Grishino", country: state, continent: continent,  geoname_id: 558536, population: 0)
province = region.provinces.create(description: "Gusinets", country: state, continent: continent,  geoname_id: 557792, population: 0)
province = region.provinces.create(description: "Il'yavan'", country: state, continent: continent,  geoname_id: 1505851, population: 0)
province = region.provinces.create(description: "Indiga", country: state, continent: continent,  geoname_id: 556395, population: 0)
province = region.provinces.create(description: "Iskateley", country: state, continent: continent,  geoname_id: 866062, population: 6545)
province = region.provinces.create(description: "Kamennoy Nos", country: state, continent: continent,  geoname_id: 553481, population: 0)
province = region.provinces.create(description: "Karatayka", country: state, continent: continent,  geoname_id: 1504453, population: 0)
province = region.provinces.create(description: "Karrol'", country: state, continent: continent,  geoname_id: 552153, population: 0)
province = region.provinces.create(description: "Kerka Sorvacheva", country: state, continent: continent,  geoname_id: 1503889, population: 0)
province = region.provinces.create(description: "Kharaley", country: state, continent: continent,  geoname_id: 550661, population: 0)
province = region.provinces.create(description: "Kharitonovo", country: state, continent: continent,  geoname_id: 550573, population: 0)
province = region.provinces.create(description: "Khar'yakha", country: state, continent: continent,  geoname_id: 550495, population: 0)
province = region.provinces.create(description: "Khorey Ver", country: state, continent: continent,  geoname_id: 549542, population: 739)
province = region.provinces.create(description: "Khosedakhard", country: state, continent: continent,  geoname_id: 549435, population: 0)
province = region.provinces.create(description: "Kiya", country: state, continent: continent,  geoname_id: 547933, population: 0)
province = region.provinces.create(description: "Konkovër", country: state, continent: continent,  geoname_id: 545430, population: 0)
province = region.provinces.create(description: "Kononov", country: state, continent: continent,  geoname_id: 545394, population: 0)
province = region.provinces.create(description: "Koregovka", country: state, continent: continent,  geoname_id: 544927, population: 0)
province = region.provinces.create(description: "Korga", country: state, continent: continent,  geoname_id: 544883, population: 0)
province = region.provinces.create(description: "Korzha", country: state, continent: continent,  geoname_id: 544341, population: 0)
province = region.provinces.create(description: "Kotkino", country: state, continent: continent,  geoname_id: 543710, population: 0)
province = region.provinces.create(description: "Kot'kin", country: state, continent: continent,  geoname_id: 543711, population: 0)
province = region.provinces.create(description: "Krasnaya Pechora", country: state, continent: continent,  geoname_id: 542687, population: 0)
province = region.provinces.create(description: "Krasnoye", country: state, continent: continent,  geoname_id: 542045, population: 0)
province = region.provinces.create(description: "Krestovo", country: state, continent: continent,  geoname_id: 871038, population: 0)
province = region.provinces.create(description: "Kuya", country: state, continent: continent,  geoname_id: 538089, population: 0)
province = region.provinces.create(description: "Labazhskoye", country: state, continent: continent,  geoname_id: 537288, population: 0)
province = region.provinces.create(description: "Laya-Vozh", country: state, continent: continent,  geoname_id: 536674, population: 0)
province = region.provinces.create(description: "Ledkovo", country: state, continent: continent,  geoname_id: 536422, population: 0)
province = region.provinces.create(description: "Lekorvan'", country: state, continent: continent,  geoname_id: 1500722, population: 0)
province = region.provinces.create(description: "Ludovatoye", country: state, continent: continent,  geoname_id: 533717, population: 0)
province = region.provinces.create(description: "Lyayuvom", country: state, continent: continent,  geoname_id: 1500168, population: 0)
province = region.provinces.create(description: "Lymbada Nyav", country: state, continent: continent,  geoname_id: 1500161, population: 0)
province = region.provinces.create(description: "Makarovo", country: state, continent: continent,  geoname_id: 532164, population: 0)
province = region.provinces.create(description: "Malaya Naryga", country: state, continent: continent,  geoname_id: 531496, population: 0)
province = region.provinces.create(description: "Malaya Nes'", country: state, continent: continent,  geoname_id: 531495, population: 0)
province = region.provinces.create(description: "Malaya Sopka", country: state, continent: continent,  geoname_id: 531342, population: 0)
province = region.provinces.create(description: "Malaya Toshviska", country: state, continent: continent,  geoname_id: 531297, population: 0)
province = region.provinces.create(description: "Markhida", country: state, continent: continent,  geoname_id: 529171, population: 0)
province = region.provinces.create(description: "Martyn", country: state, continent: continent,  geoname_id: 528988, population: 0)
province = region.provinces.create(description: "Mesino", country: state, continent: continent,  geoname_id: 527390, population: 0)
province = region.provinces.create(description: "Mikheyev", country: state, continent: continent,  geoname_id: 526699, population: 0)
province = region.provinces.create(description: "Mikit-Yu-Vom", country: state, continent: continent,  geoname_id: 1498744, population: 0)
province = region.provinces.create(description: "Mitrofan", country: state, continent: continent,  geoname_id: 526089, population: 0)
province = region.provinces.create(description: "Naryan-Mar", country: state, continent: continent,  geoname_id: 523392, population: 18041)
province = region.provinces.create(description: "Naryga", country: state, continent: continent,  geoname_id: 523391, population: 0)
province = region.provinces.create(description: "Nel'min Nos", country: state, continent: continent,  geoname_id: 522766, population: 0)
province = region.provinces.create(description: "Nertseta", country: state, continent: continent,  geoname_id: 1497834, population: 0)
province = region.provinces.create(description: "Neruyuvom", country: state, continent: continent,  geoname_id: 1497829, population: 0)
province = region.provinces.create(description: "Nes'", country: state, continent: continent,  geoname_id: 522534, population: 0)
province = region.provinces.create(description: "Nikittsy", country: state, continent: continent,  geoname_id: 522099, population: 0)
province = region.provinces.create(description: "Nizhnyaya Kamenka", country: state, continent: continent,  geoname_id: 520367, population: 0)
province = region.provinces.create(description: "Nizhnyaya Mgla", country: state, continent: continent,  geoname_id: 520304, population: 0)
province = region.provinces.create(description: "Nizhnyaya Pesha", country: state, continent: continent,  geoname_id: 520272, population: 0)
province = region.provinces.create(description: "Nosovaya", country: state, continent: continent,  geoname_id: 519925, population: 0)
province = region.provinces.create(description: "Novaya Tonya", country: state, continent: continent,  geoname_id: 519466, population: 0)
province = region.provinces.create(description: "Novyy Dom", country: state, continent: continent,  geoname_id: 1496566, population: 0)
province = region.provinces.create(description: "Nyadver", country: state, continent: continent,  geoname_id: 1496478, population: 0)
province = region.provinces.create(description: "Nyurov", country: state, continent: continent,  geoname_id: 516521, population: 0)
province = region.provinces.create(description: "Oksino", country: state, continent: continent,  geoname_id: 515973, population: 0)
province = region.provinces.create(description: "Oma", country: state, continent: continent,  geoname_id: 515303, population: 0)
province = region.provinces.create(description: "Ortino", country: state, continent: continent,  geoname_id: 514724, population: 0)
province = region.provinces.create(description: "Oskolkovo", country: state, continent: continent,  geoname_id: 514358, population: 0)
province = region.provinces.create(description: "Os'ka-Mish", country: state, continent: continent,  geoname_id: 514379, population: 0)
province = region.provinces.create(description: "Pesha", country: state, continent: continent,  geoname_id: 510560, population: 0)
province = region.provinces.create(description: "Peshitsa", country: state, continent: continent,  geoname_id: 510544, population: 0)
province = region.provinces.create(description: "Popova", country: state, continent: continent,  geoname_id: 506512, population: 0)
province = region.provinces.create(description: "Popovka", country: state, continent: continent,  geoname_id: 506412, population: 0)
province = region.provinces.create(description: "Posëlok", country: state, continent: continent,  geoname_id: 1494350, population: 0)
province = region.provinces.create(description: "Poylova", country: state, continent: continent,  geoname_id: 505777, population: 0)
province = region.provinces.create(description: "Prelaya", country: state, continent: continent,  geoname_id: 505536, population: 0)
province = region.provinces.create(description: "Prishchatenok", country: state, continent: continent,  geoname_id: 505197, population: 0)
province = region.provinces.create(description: "Prishchatinitsa", country: state, continent: continent,  geoname_id: 505196, population: 0)
province = region.provinces.create(description: "Proryvy", country: state, continent: continent,  geoname_id: 504694, population: 0)
province = region.provinces.create(description: "Prosunduy", country: state, continent: continent,  geoname_id: 504646, population: 0)
province = region.provinces.create(description: "Pustozersk", country: state, continent: continent,  geoname_id: 503830, population: 0)
province = region.provinces.create(description: "Pylemets", country: state, continent: continent,  geoname_id: 503437, population: 0)
province = region.provinces.create(description: "Rodino", country: state, continent: continent,  geoname_id: 501810, population: 0)
province = region.provinces.create(description: "Rudnik", country: state, continent: continent,  geoname_id: 1544819, population: 0)
province = region.provinces.create(description: "Rusanova", country: state, continent: continent,  geoname_id: 1493435, population: 0)
province = region.provinces.create(description: "Saviny", country: state, continent: continent,  geoname_id: 498193, population: 0)
province = region.provinces.create(description: "Severnyy", country: state, continent: continent,  geoname_id: 496341, population: 0)
province = region.provinces.create(description: "Shchelino", country: state, continent: continent,  geoname_id: 495360, population: 0)
province = region.provinces.create(description: "Shevelëvka", country: state, continent: continent,  geoname_id: 871060, population: 0)
province = region.provinces.create(description: "Shoyna", country: state, continent: continent,  geoname_id: 493714, population: 0)
province = region.provinces.create(description: "Shpindler", country: state, continent: continent,  geoname_id: 1492044, population: 0)
province = region.provinces.create(description: "Smekalovka", country: state, continent: continent,  geoname_id: 491780, population: 0)
province = region.provinces.create(description: "Snopa", country: state, continent: continent,  geoname_id: 491532, population: 0)
province = region.provinces.create(description: "Stanovishche Morzverprom", country: state, continent: continent,  geoname_id: 489301, population: 0)
province = region.provinces.create(description: "Staraya Yazhma Russkaya", country: state, continent: continent,  geoname_id: 489008, population: 0)
province = region.provinces.create(description: "Sukhanikha", country: state, continent: continent,  geoname_id: 486788, population: 0)
province = region.provinces.create(description: "Sukharev", country: state, continent: continent,  geoname_id: 486765, population: 0)
province = region.provinces.create(description: "Sula", country: state, continent: continent,  geoname_id: 486404, population: 0)
province = region.provinces.create(description: "Syavta", country: state, continent: continent,  geoname_id: 1490454, population: 0)
province = region.provinces.create(description: "Syropyatovo", country: state, continent: continent,  geoname_id: 485163, population: 0)
province = region.provinces.create(description: "Syr”yakha", country: state, continent: continent,  geoname_id: 1490404, population: 0)
province = region.provinces.create(description: "Tarasovo", country: state, continent: continent,  geoname_id: 484406, population: 0)
province = region.provinces.create(description: "Taratinskiy", country: state, continent: continent,  geoname_id: 484385, population: 0)
province = region.provinces.create(description: "Tarkhanovo", country: state, continent: continent,  geoname_id: 484349, population: 0)
province = region.provinces.create(description: "Tel'viska", country: state, continent: continent,  geoname_id: 483748, population: 0)
province = region.provinces.create(description: "Tobseda", country: state, continent: continent,  geoname_id: 482573, population: 0)
province = region.provinces.create(description: "Tolstyy Nos", country: state, continent: continent,  geoname_id: 482296, population: 0)
province = region.provinces.create(description: "Toshviska", country: state, continent: continent,  geoname_id: 481972, population: 0)
province = region.provinces.create(description: "Tri Bugra", country: state, continent: continent,  geoname_id: 481706, population: 0)
province = region.provinces.create(description: "Ugol'nyy", country: state, continent: continent,  geoname_id: 479487, population: 0)
province = region.provinces.create(description: "Ust'-Kara", country: state, continent: continent,  geoname_id: 1488184, population: 0)
province = region.provinces.create(description: "Ust'ye", country: state, continent: continent,  geoname_id: 477831, population: 0)
province = region.provinces.create(description: "Vangurey", country: state, continent: continent,  geoname_id: 871049, population: 0)
province = region.provinces.create(description: "Varandey", country: state, continent: continent,  geoname_id: 477062, population: 0)
province = region.provinces.create(description: "Varandey", country: state, continent: continent,  geoname_id: 857843, population: 0)
province = region.provinces.create(description: "Varnek", country: state, continent: continent,  geoname_id: 1487762, population: 0)
province = region.provinces.create(description: "Vashutkiny Ozëra", country: state, continent: continent,  geoname_id: 1487732, population: 0)
province = region.provinces.create(description: "Vasino", country: state, continent: continent,  geoname_id: 870585, population: 0)
province = region.provinces.create(description: "Vaygach", country: state, continent: continent,  geoname_id: 476327, population: 0)
province = region.provinces.create(description: "Velikaya", country: state, continent: continent,  geoname_id: 476136, population: 0)
province = region.provinces.create(description: "Velikovisochnoye", country: state, continent: continent,  geoname_id: 476027, population: 0)
province = region.provinces.create(description: "Verkhnesul'skaya", country: state, continent: continent,  geoname_id: 475486, population: 0)
province = region.provinces.create(description: "Verkhnyaya Kamenka", country: state, continent: continent,  geoname_id: 474679, population: 0)
province = region.provinces.create(description: "Verkhnyaya Mgla", country: state, continent: continent,  geoname_id: 527218, population: 0)
province = region.provinces.create(description: "Verkhnyaya Pesha", country: state, continent: continent,  geoname_id: 474559, population: 0)
province = region.provinces.create(description: "Vizhas", country: state, continent: continent,  geoname_id: 473279, population: 0)
province = region.provinces.create(description: "Volkovaya", country: state, continent: continent,  geoname_id: 472686, population: 0)
province = region.provinces.create(description: "Volokovaya", country: state, continent: continent,  geoname_id: 472419, population: 0)
province = region.provinces.create(description: "Volonga", country: state, continent: continent,  geoname_id: 472405, population: 0)
province = region.provinces.create(description: "Vonda", country: state, continent: continent,  geoname_id: 472214, population: 0)
province = region.provinces.create(description: "Vyselok", country: state, continent: continent,  geoname_id: 470317, population: 0)
province = region.provinces.create(description: "Vyssheye Lesnoye", country: state, continent: continent,  geoname_id: 469982, population: 0)
province = region.provinces.create(description: "Vyucheyskiy", country: state, continent: continent,  geoname_id: 469957, population: 0)
province = region.provinces.create(description: "Yangarey", country: state, continent: continent,  geoname_id: 1486431, population: 0)
province = region.provinces.create(description: "Yaptayakha", country: state, continent: continent,  geoname_id: 1486403, population: 0)
province = region.provinces.create(description: "Yazhma", country: state, continent: continent,  geoname_id: 468547, population: 0)
province = region.provinces.create(description: "Yegorovo", country: state, continent: continent,  geoname_id: 468281, population: 0)
province = region.provinces.create(description: "Yegorvan'", country: state, continent: continent,  geoname_id: 468276, population: 0)
province = region.provinces.create(description: "Yekusha", country: state, continent: continent,  geoname_id: 468091, population: 0)
region = Region.create(description: "Nizhegorodskaya Oblast'", country: state, continent: continent, geoname_id: 559838)
province = region.provinces.create(description: "Ardatovskiy Rayon", country: state, continent: continent,  geoname_id: 581181, population: 0)
province = region.provinces.create(description: "Arzamasskiy Rayon", country: state, continent: continent,  geoname_id: 580722, population: 0)
province = region.provinces.create(description: "Borskiy Rayon", country: state, continent: continent,  geoname_id: 571988, population: 0)
province = region.provinces.create(description: "Diveyevskiy Rayon", country: state, continent: continent,  geoname_id: 566164, population: 0)
province = region.provinces.create(description: "Kstovskiy Rayon", country: state, continent: continent,  geoname_id: 540102, population: 0)
province = region.provinces.create(description: "Pavlovskiy Rayon", country: state, continent: continent,  geoname_id: 512018, population: 0)
province = region.provinces.create(description: "Semënovskiy Rayon", country: state, continent: continent,  geoname_id: 497311, population: 0)
province = region.provinces.create(description: "Sosnovskiy Rayon", country: state, continent: continent,  geoname_id: 490199, population: 0)
region = Region.create(description: "North Ossetia", country: state, continent: continent, geoname_id: 519969)
province = region.provinces.create(description: "Alagirskiy Rayon", country: state, continent: continent,  geoname_id: 583478, population: 0)
province = region.provinces.create(description: "Ardonskiy Rayon", country: state, continent: continent,  geoname_id: 581175, population: 0)
province = region.provinces.create(description: "Digorskiy Rayon", country: state, continent: continent,  geoname_id: 566241, population: 0)
province = region.provinces.create(description: "Irafskiy Rayon", country: state, continent: continent,  geoname_id: 556219, population: 0)
province = region.provinces.create(description: "Kirovskiy Rayon", country: state, continent: continent,  geoname_id: 548364, population: 0)
province = region.provinces.create(description: "Mozdokskiy Rayon", country: state, continent: continent,  geoname_id: 524734, population: 0)
province = region.provinces.create(description: "Pravoberezhnyy Rayon", country: state, continent: continent,  geoname_id: 505586, population: 0)
province = region.provinces.create(description: "Prigorodnyy Rayon", country: state, continent: continent,  geoname_id: 505371, population: 0)
region = Region.create(description: "Novgorodskaya Oblast'", country: state, continent: continent, geoname_id: 519324)
province = region.provinces.create(description: "Borovichskiy Rayon", country: state, continent: continent,  geoname_id: 572153, population: 0)
province = region.provinces.create(description: "Lyubytinskiy Rayon", country: state, continent: continent,  geoname_id: 532461, population: 0)
province = region.provinces.create(description: "Okulovskiy Rayon", country: state, continent: continent,  geoname_id: 515748, population: 0)
province = region.provinces.create(description: "Valdayskiy Rayon", country: state, continent: continent,  geoname_id: 477295, population: 0)
region = Region.create(description: "Novosibirskaya Oblast'", country: state, continent: continent, geoname_id: 1496745)
region = Region.create(description: "Omskaya Oblast'", country: state, continent: continent, geoname_id: 1496152)
region = Region.create(description: "Orenburgskaya Oblast'", country: state, continent: continent, geoname_id: 515001)
region = Region.create(description: "Orlovskaya Oblast'", country: state, continent: continent, geoname_id: 514801)
region = Region.create(description: "Penzenskaya Oblast'", country: state, continent: continent, geoname_id: 511555)
region = Region.create(description: "Perm Krai", country: state, continent: continent, geoname_id: 511180)
region = Region.create(description: "Primorskiy Kray", country: state, continent: continent, geoname_id: 2017623)
region = Region.create(description: "Pskovskaya Oblast'", country: state, continent: continent, geoname_id: 504338)
region = Region.create(description: "Republic of Karelia", country: state, continent: continent, geoname_id: 552548)
region = Region.create(description: "Respublika Adygeya", country: state, continent: continent, geoname_id: 584222)
region = Region.create(description: "Respublika Altay", country: state, continent: continent, geoname_id: 1506272)
region = Region.create(description: "Respublika Buryatiya", country: state, continent: continent, geoname_id: 2050915)
region = Region.create(description: "Respublika Ingushetiya", country: state, continent: continent, geoname_id: 556349)
region = Region.create(description: "Respublika Khakasiya", country: state, continent: continent, geoname_id: 1503834)
region = Region.create(description: "Respublika Mariy-El", country: state, continent: continent, geoname_id: 529352)
region = Region.create(description: "Respublika Mordoviya", country: state, continent: continent, geoname_id: 525369)
region = Region.create(description: "Respublika Sakha (Yakutiya)", country: state, continent: continent, geoname_id: 2013162)
region = Region.create(description: "Respublika Tyva", country: state, continent: continent, geoname_id: 1488873)
region = Region.create(description: "Rostov", country: state, continent: continent, geoname_id: 501165)
region = Region.create(description: "Ryazanskaya Oblast'", country: state, continent: continent, geoname_id: 500059)
region = Region.create(description: "Sakhalinskaya Oblast'", country: state, continent: continent, geoname_id: 2121529)
region = Region.create(description: "Samarskaya Oblast'", country: state, continent: continent, geoname_id: 499068)
region = Region.create(description: "Saratovskaya Oblast'", country: state, continent: continent, geoname_id: 498671)
region = Region.create(description: "Smolenskaya Oblast'", country: state, continent: continent, geoname_id: 491684)
region = Region.create(description: "St.-Petersburg", country: state, continent: continent, geoname_id: 536203)
region = Region.create(description: "Stavropol'skiy Kray", country: state, continent: continent, geoname_id: 487839)
region = Region.create(description: "Sverdlovskaya Oblast'", country: state, continent: continent, geoname_id: 1490542)
region = Region.create(description: "Tambovskaya Oblast'", country: state, continent: continent, geoname_id: 484638)
region = Region.create(description: "Tatarstan", country: state, continent: continent, geoname_id: 484048)
region = Region.create(description: "Tomskaya Oblast'", country: state, continent: continent, geoname_id: 1489421)
region = Region.create(description: "Transbaikal Territory", country: state, continent: continent, geoname_id: 7779061)
region = Region.create(description: "Tul'skaya Oblast'", country: state, continent: continent, geoname_id: 480508)
region = Region.create(description: "Tverskaya Oblast'", country: state, continent: continent, geoname_id: 480041)
region = Region.create(description: "Tyumenskaya Oblast'", country: state, continent: continent, geoname_id: 1488747)
region = Region.create(description: "Udmurtskaya Respublika", country: state, continent: continent, geoname_id: 479613)
region = Region.create(description: "Ulyanovsk", country: state, continent: continent, geoname_id: 479119)
region = Region.create(description: "Vladimirskaya Oblast'", country: state, continent: continent, geoname_id: 826294)
region = Region.create(description: "Volgogradskaya Oblast'", country: state, continent: continent, geoname_id: 472755)
region = Region.create(description: "Vologodskaya Oblast'", country: state, continent: continent, geoname_id: 472454)
region = Region.create(description: "Voronezhskaya Oblast'", country: state, continent: continent, geoname_id: 472039)
region = Region.create(description: "Yamalo-Nenetskiy Avtonomnyy Okrug", country: state, continent: continent, geoname_id: 1486462)
region = Region.create(description: "Yaroslavskaya Oblast'", country: state, continent: continent, geoname_id: 468898)
