continent = Continent.find_by(description: 'America')
state = Country.find_by(description: 'Chile')
region = Region.create(description: "Antofagasta", country: state, continent: continent, geoname_id: 3899537)
province = region.provinces.create(description: "Provincia de Antofagasta", country: state, continent: continent,  geoname_id: 3899538, population: 0)
municipalities = [
province.municipalities.new(description: "Antofagasta", region: region, country: state, continent: continent, geoname_id: 8261129, population: 0),
province.municipalities.new(description: "Mejillones", region: region, country: state, continent: continent, geoname_id: 8261203, population: 0),
province.municipalities.new(description: "Sierra Gorda", region: region, country: state, continent: continent, geoname_id: 8261211, population: 0),
province.municipalities.new(description: "Tal-Tal", region: region, country: state, continent: continent, geoname_id: 8261130, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de El Loa", country: state, continent: continent,  geoname_id: 3891149, population: 0)
municipalities = [
province.municipalities.new(description: "Calama", region: region, country: state, continent: continent, geoname_id: 8261495, population: 0),
province.municipalities.new(description: "Ollague", region: region, country: state, continent: continent, geoname_id: 8261205, population: 0),
province.municipalities.new(description: "San Pedro de Atacama", region: region, country: state, continent: continent, geoname_id: 8261210, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Tocopilla", country: state, continent: continent,  geoname_id: 3869715, population: 0)
municipalities = [
province.municipalities.new(description: "Maria Elena", region: region, country: state, continent: continent, geoname_id: 8261208, population: 0),
province.municipalities.new(description: "Tocopilla", region: region, country: state, continent: continent, geoname_id: 8261216, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Atacama", country: state, continent: continent, geoname_id: 3899191)
province = region.provinces.create(description: "Provincia de Chañaral", country: state, continent: continent,  geoname_id: 3895547, population: 0)
municipalities = [
province.municipalities.new(description: "Chañaral", region: region, country: state, continent: continent, geoname_id: 8261221, population: 0),
province.municipalities.new(description: "Diego de Almagro", region: region, country: state, continent: continent, geoname_id: 8261132, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Copiapó", country: state, continent: continent,  geoname_id: 3893653, population: 0)
municipalities = [
province.municipalities.new(description: "Caldera", region: region, country: state, continent: continent, geoname_id: 8261223, population: 0),
province.municipalities.new(description: "Copiapo", region: region, country: state, continent: continent, geoname_id: 8261212, population: 0),
province.municipalities.new(description: "Tierra Amarrilla", region: region, country: state, continent: continent, geoname_id: 8261213, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Huasco", country: state, continent: continent,  geoname_id: 3887756, population: 0)
municipalities = [
province.municipalities.new(description: "Alto del Carmen", region: region, country: state, continent: continent, geoname_id: 8261214, population: 0),
province.municipalities.new(description: "Freirina", region: region, country: state, continent: continent, geoname_id: 8261215, population: 0),
province.municipalities.new(description: "Huasco", region: region, country: state, continent: continent, geoname_id: 8261131, population: 0),
province.municipalities.new(description: "Vallenar", region: region, country: state, continent: continent, geoname_id: 8261168, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Aysén", country: state, continent: continent, geoname_id: 3900333)
province = region.provinces.create(description: "Provincia Capitán Prat", country: state, continent: continent,  geoname_id: 3896832, population: 0)
municipalities = [
province.municipalities.new(description: "Cochrane", region: region, country: state, continent: continent, geoname_id: 8261363, population: 0),
province.municipalities.new(description: "O Higgins", region: region, country: state, continent: continent, geoname_id: 8261464, population: 0),
province.municipalities.new(description: "Tortel", region: region, country: state, continent: continent, geoname_id: 8261362, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia General Carrera", country: state, continent: continent,  geoname_id: 3889024, population: 0)
municipalities = [
province.municipalities.new(description: "Chile Chico", region: region, country: state, continent: continent, geoname_id: 8261446, population: 0),
province.municipalities.new(description: "Rio Ibañez", region: region, country: state, continent: continent, geoname_id: 8261444, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Aisén", country: state, continent: continent,  geoname_id: 3900336, population: 0)
municipalities = [
province.municipalities.new(description: "Aisen", region: region, country: state, continent: continent, geoname_id: 8261162, population: 0),
province.municipalities.new(description: "Cisnes", region: region, country: state, continent: continent, geoname_id: 8261163, population: 0),
province.municipalities.new(description: "Guaitecas", region: region, country: state, continent: continent, geoname_id: 8261164, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Coyhaique", country: state, continent: continent,  geoname_id: 8181715, population: 0)
municipalities = [
province.municipalities.new(description: "Coyhaique", region: region, country: state, continent: continent, geoname_id: 8261198, population: 0),
province.municipalities.new(description: "Lago Verde", region: region, country: state, continent: continent, geoname_id: 8261161, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Coquimbo", country: state, continent: continent, geoname_id: 3893623)
province = region.provinces.create(description: "Provincia de Choapa", country: state, continent: continent,  geoname_id: 3894914, population: 0)
municipalities = [
province.municipalities.new(description: "Canela", region: region, country: state, continent: continent, geoname_id: 8261137, population: 0),
province.municipalities.new(description: "Illapel", region: region, country: state, continent: continent, geoname_id: 8261136, population: 0),
province.municipalities.new(description: "Los Vilos", region: region, country: state, continent: continent, geoname_id: 8261193, population: 0),
province.municipalities.new(description: "Salamanca", region: region, country: state, continent: continent, geoname_id: 8261138, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Elqui", country: state, continent: continent,  geoname_id: 3890620, population: 0)
municipalities = [
province.municipalities.new(description: "Andacollo", region: region, country: state, continent: continent, geoname_id: 8261217, population: 0),
province.municipalities.new(description: "Coquimbo", region: region, country: state, continent: continent, geoname_id: 8261227, population: 0),
province.municipalities.new(description: "La Higuera", region: region, country: state, continent: continent, geoname_id: 8261133, population: 0),
province.municipalities.new(description: "La Serena", region: region, country: state, continent: continent, geoname_id: 8261226, population: 0),
province.municipalities.new(description: "Paihuano", region: region, country: state, continent: continent, geoname_id: 8261228, population: 0),
province.municipalities.new(description: "Vicuña", region: region, country: state, continent: continent, geoname_id: 8261134, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Limarí", country: state, continent: continent,  geoname_id: 3883200, population: 0)
municipalities = [
province.municipalities.new(description: "Combarbala", region: region, country: state, continent: continent, geoname_id: 8261230, population: 0),
province.municipalities.new(description: "Monte Patria", region: region, country: state, continent: continent, geoname_id: 8261135, population: 0),
province.municipalities.new(description: "Ovalle", region: region, country: state, continent: continent, geoname_id: 8261224, population: 0),
province.municipalities.new(description: "Punitaqui", region: region, country: state, continent: continent, geoname_id: 8261232, population: 0),
province.municipalities.new(description: "Rio Hurtado", region: region, country: state, continent: continent, geoname_id: 7874689, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Los Lagos", country: state, continent: continent, geoname_id: 3881974)
province = region.provinces.create(description: "Provincia de Chiloé", country: state, continent: continent,  geoname_id: 3895070, population: 0)
municipalities = [
province.municipalities.new(description: "Ancud", region: region, country: state, continent: continent, geoname_id: 8261160, population: 0),
province.municipalities.new(description: "Castro", region: region, country: state, continent: continent, geoname_id: 8261426, population: 0),
province.municipalities.new(description: "Chonchi", region: region, country: state, continent: continent, geoname_id: 8261427, population: 0),
province.municipalities.new(description: "Curaco de Velez", region: region, country: state, continent: continent, geoname_id: 8261430, population: 0),
province.municipalities.new(description: "Dalcahue", region: region, country: state, continent: continent, geoname_id: 8261159, population: 0),
province.municipalities.new(description: "Puqueldon", region: region, country: state, continent: continent, geoname_id: 8261167, population: 0),
province.municipalities.new(description: "Queilen", region: region, country: state, continent: continent, geoname_id: 8261429, population: 0),
province.municipalities.new(description: "Quellon", region: region, country: state, continent: continent, geoname_id: 8261176, population: 0),
province.municipalities.new(description: "Quemchi", region: region, country: state, continent: continent, geoname_id: 8261154, population: 0),
province.municipalities.new(description: "Quinchao", region: region, country: state, continent: continent, geoname_id: 8261422, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Llanquihue", country: state, continent: continent,  geoname_id: 3882955, population: 0)
municipalities = [
province.municipalities.new(description: "Calbuco", region: region, country: state, continent: continent, geoname_id: 8261175, population: 0),
province.municipalities.new(description: "Cochamo", region: region, country: state, continent: continent, geoname_id: 8261177, population: 0),
province.municipalities.new(description: "Fresia", region: region, country: state, continent: continent, geoname_id: 8261406, population: 0),
province.municipalities.new(description: "Frutillar", region: region, country: state, continent: continent, geoname_id: 8261382, population: 0),
province.municipalities.new(description: "Llanquihue", region: region, country: state, continent: continent, geoname_id: 8261374, population: 0),
province.municipalities.new(description: "Los Muermos", region: region, country: state, continent: continent, geoname_id: 8261420, population: 0),
province.municipalities.new(description: "Maulln", region: region, country: state, continent: continent, geoname_id: 8261415, population: 0),
province.municipalities.new(description: "Puerto Montt", region: region, country: state, continent: continent, geoname_id: 8261383, population: 0),
province.municipalities.new(description: "Puerto Varas", region: region, country: state, continent: continent, geoname_id: 8261155, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Osorno", country: state, continent: continent,  geoname_id: 3877946, population: 0)
municipalities = [
province.municipalities.new(description: "Osorno", region: region, country: state, continent: continent, geoname_id: 8261411, population: 0),
province.municipalities.new(description: "Puerto Octay", region: region, country: state, continent: continent, geoname_id: 8261412, population: 0),
province.municipalities.new(description: "Purranque", region: region, country: state, continent: continent, geoname_id: 8261408, population: 0),
province.municipalities.new(description: "Puyehue", region: region, country: state, continent: continent, geoname_id: 8261443, population: 0),
province.municipalities.new(description: "Rio Negro", region: region, country: state, continent: continent, geoname_id: 8261409, population: 0),
province.municipalities.new(description: "San Juan de la Costa", region: region, country: state, continent: continent, geoname_id: 8261433, population: 0),
province.municipalities.new(description: "San Pablo", region: region, country: state, continent: continent, geoname_id: 8261435, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Palena", country: state, continent: continent,  geoname_id: 8181714, population: 0)
municipalities = [
province.municipalities.new(description: "Chaiten", region: region, country: state, continent: continent, geoname_id: 8261361, population: 0),
province.municipalities.new(description: "Futaleufu", region: region, country: state, continent: continent, geoname_id: 8261437, population: 0),
province.municipalities.new(description: "Huailaihue", region: region, country: state, continent: continent, geoname_id: 8261375, population: 0),
province.municipalities.new(description: "Palena", region: region, country: state, continent: continent, geoname_id: 8261360, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Maule", country: state, continent: continent, geoname_id: 3880306)
province = region.provinces.create(description: "Provincia de Cauquenes", country: state, continent: continent,  geoname_id: 8181713, population: 0)
municipalities = [
province.municipalities.new(description: "Cauquenes", region: region, country: state, continent: continent, geoname_id: 8261149, population: 0),
province.municipalities.new(description: "Chanco", region: region, country: state, continent: continent, geoname_id: 8261295, population: 0),
province.municipalities.new(description: "Pelluhue", region: region, country: state, continent: continent, geoname_id: 8261306, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Curicó", country: state, continent: continent,  geoname_id: 3892868, population: 0)
municipalities = [
province.municipalities.new(description: "Curico", region: region, country: state, continent: continent, geoname_id: 8261139, population: 0),
province.municipalities.new(description: "Hualañe", region: region, country: state, continent: continent, geoname_id: 8261333, population: 0),
province.municipalities.new(description: "Licanten", region: region, country: state, continent: continent, geoname_id: 8261286, population: 0),
province.municipalities.new(description: "Molina", region: region, country: state, continent: continent, geoname_id: 8261189, population: 0),
province.municipalities.new(description: "Rauco", region: region, country: state, continent: continent, geoname_id: 8261289, population: 0),
province.municipalities.new(description: "Romeral", region: region, country: state, continent: continent, geoname_id: 8261288, population: 0),
province.municipalities.new(description: "Sagrada Familia", region: region, country: state, continent: continent, geoname_id: 8261287, population: 0),
province.municipalities.new(description: "Teno", region: region, country: state, continent: continent, geoname_id: 8261291, population: 0),
province.municipalities.new(description: "Vichquen", region: region, country: state, continent: continent, geoname_id: 8261317, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Linares", country: state, continent: continent,  geoname_id: 3883166, population: 0)
municipalities = [
province.municipalities.new(description: "Colbun", region: region, country: state, continent: continent, geoname_id: 8261145, population: 0),
province.municipalities.new(description: "Linares", region: region, country: state, continent: continent, geoname_id: 8261146, population: 0),
province.municipalities.new(description: "Longavi", region: region, country: state, continent: continent, geoname_id: 8261147, population: 0),
province.municipalities.new(description: "Parral", region: region, country: state, continent: continent, geoname_id: 8261148, population: 0),
province.municipalities.new(description: "Retiro", region: region, country: state, continent: continent, geoname_id: 8261299, population: 0),
province.municipalities.new(description: "San Javier", region: region, country: state, continent: continent, geoname_id: 8261310, population: 0),
province.municipalities.new(description: "Villa Alegre", region: region, country: state, continent: continent, geoname_id: 8261292, population: 0),
province.municipalities.new(description: "Yerbas Buenas", region: region, country: state, continent: continent, geoname_id: 8261242, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Talca", country: state, continent: continent,  geoname_id: 3870289, population: 0)
municipalities = [
province.municipalities.new(description: "Constitucion", region: region, country: state, continent: continent, geoname_id: 8261313, population: 0),
province.municipalities.new(description: "Curepto", region: region, country: state, continent: continent, geoname_id: 8261308, population: 0),
province.municipalities.new(description: "Empedrado", region: region, country: state, continent: continent, geoname_id: 8261298, population: 0),
province.municipalities.new(description: "Maule", region: region, country: state, continent: continent, geoname_id: 8261300, population: 0),
province.municipalities.new(description: "Pelarco", region: region, country: state, continent: continent, geoname_id: 8261290, population: 0),
province.municipalities.new(description: "Pencahue", region: region, country: state, continent: continent, geoname_id: 8261297, population: 0),
province.municipalities.new(description: "Rio Claro", region: region, country: state, continent: continent, geoname_id: 8261294, population: 0),
province.municipalities.new(description: "San Clemente", region: region, country: state, continent: continent, geoname_id: 8261188, population: 0),
province.municipalities.new(description: "San Rafael", region: region, country: state, continent: continent, geoname_id: 8261293, population: 0),
province.municipalities.new(description: "Talca", region: region, country: state, continent: continent, geoname_id: 8261285, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región Metropolitana de Santiago", country: state, continent: continent, geoname_id: 3873544)
province = region.provinces.create(description: "Provincia de Chacabuco", country: state, continent: continent,  geoname_id: 8181717, population: 0)
municipalities = [
province.municipalities.new(description: "Colina", region: region, country: state, continent: continent, geoname_id: 8261384, population: 0),
province.municipalities.new(description: "Lampa", region: region, country: state, continent: continent, geoname_id: 8261454, population: 0),
province.municipalities.new(description: "Tiltil", region: region, country: state, continent: continent, geoname_id: 8261453, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Cordillera", country: state, continent: continent,  geoname_id: 8181716, population: 0)
municipalities = [
province.municipalities.new(description: "Pirque", region: region, country: state, continent: continent, geoname_id: 8261440, population: 0),
province.municipalities.new(description: "Puente Alto", region: region, country: state, continent: continent, geoname_id: 8261423, population: 0),
province.municipalities.new(description: "San Jose de Maipo", region: region, country: state, continent: continent, geoname_id: 8261184, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Maipo", country: state, continent: continent,  geoname_id: 3880987, population: 0)
municipalities = [
province.municipalities.new(description: "Buin", region: region, country: state, continent: continent, geoname_id: 8261309, population: 0),
province.municipalities.new(description: "Calera de Tango", region: region, country: state, continent: continent, geoname_id: 8261334, population: 0),
province.municipalities.new(description: "Paine", region: region, country: state, continent: continent, geoname_id: 8261424, population: 0),
province.municipalities.new(description: "San Bernardo", region: region, country: state, continent: continent, geoname_id: 8261438, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Melipilla", country: state, continent: continent,  geoname_id: 3880106, population: 0)
municipalities = [
province.municipalities.new(description: "Alhue", region: region, country: state, continent: continent, geoname_id: 8261425, population: 0),
province.municipalities.new(description: "Curacavi", region: region, country: state, continent: continent, geoname_id: 8261456, population: 0),
province.municipalities.new(description: "Maria Pinto", region: region, country: state, continent: continent, geoname_id: 8261439, population: 0),
province.municipalities.new(description: "Melipilla", region: region, country: state, continent: continent, geoname_id: 8261185, population: 0),
province.municipalities.new(description: "San Pedro", region: region, country: state, continent: continent, geoname_id: 8261455, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Santiago", country: state, continent: continent,  geoname_id: 3871332, population: 0)
municipalities = [
province.municipalities.new(description: "Cerillos", region: region, country: state, continent: continent, geoname_id: 8261369, population: 0),
province.municipalities.new(description: "Cerro Navia", region: region, country: state, continent: continent, geoname_id: 8261397, population: 0),
province.municipalities.new(description: "Conchali", region: region, country: state, continent: continent, geoname_id: 8261398, population: 0),
province.municipalities.new(description: "El Bosque", region: region, country: state, continent: continent, geoname_id: 8261399, population: 0),
province.municipalities.new(description: "Estacion Central", region: region, country: state, continent: continent, geoname_id: 8261400, population: 0),
province.municipalities.new(description: "Huechuraba", region: region, country: state, continent: continent, geoname_id: 8261432, population: 0),
province.municipalities.new(description: "Independencia", region: region, country: state, continent: continent, geoname_id: 8261421, population: 0),
province.municipalities.new(description: "La Cisterna", region: region, country: state, continent: continent, geoname_id: 8261372, population: 0),
province.municipalities.new(description: "La Florida", region: region, country: state, continent: continent, geoname_id: 8261405, population: 0),
province.municipalities.new(description: "La Granja", region: region, country: state, continent: continent, geoname_id: 8261316, population: 0),
province.municipalities.new(description: "La Pintana", region: region, country: state, continent: continent, geoname_id: 8261407, population: 0),
province.municipalities.new(description: "La Reina", region: region, country: state, continent: continent, geoname_id: 8261410, population: 0),
province.municipalities.new(description: "Las Condes", region: region, country: state, continent: continent, geoname_id: 8261428, population: 0),
province.municipalities.new(description: "Lo Barnechea", region: region, country: state, continent: continent, geoname_id: 8261390, population: 0),
province.municipalities.new(description: "Lo Espejo", region: region, country: state, continent: continent, geoname_id: 8261156, population: 0),
province.municipalities.new(description: "Lo Prado", region: region, country: state, continent: continent, geoname_id: 8261174, population: 0),
province.municipalities.new(description: "Macul", region: region, country: state, continent: continent, geoname_id: 8261194, population: 0),
province.municipalities.new(description: "Maipu", region: region, country: state, continent: continent, geoname_id: 8261434, population: 0),
province.municipalities.new(description: "Pedro Aguirre Cerda", region: region, country: state, continent: continent, geoname_id: 8261157, population: 0),
province.municipalities.new(description: "Peñalolen", region: region, country: state, continent: continent, geoname_id: 8261413, population: 0),
province.municipalities.new(description: "Providencia", region: region, country: state, continent: continent, geoname_id: 8261414, population: 0),
province.municipalities.new(description: "Pudahuel", region: region, country: state, continent: continent, geoname_id: 8261436, population: 0),
province.municipalities.new(description: "Quilicura", region: region, country: state, continent: continent, geoname_id: 8261431, population: 0),
province.municipalities.new(description: "Quinta Normal", region: region, country: state, continent: continent, geoname_id: 8261416, population: 0),
province.municipalities.new(description: "Recoleta", region: region, country: state, continent: continent, geoname_id: 8261417, population: 0),
province.municipalities.new(description: "Renca", region: region, country: state, continent: continent, geoname_id: 8261418, population: 0),
province.municipalities.new(description: "San Joaquin", region: region, country: state, continent: continent, geoname_id: 8261419, population: 0),
province.municipalities.new(description: "San Miguel", region: region, country: state, continent: continent, geoname_id: 8261377, population: 0),
province.municipalities.new(description: "San Ramon", region: region, country: state, continent: continent, geoname_id: 8261158, population: 0),
province.municipalities.new(description: "Santiago", region: region, country: state, continent: continent, geoname_id: 8261395, population: 0),
province.municipalities.new(description: "Vitacura", region: region, country: state, continent: continent, geoname_id: 8261380, population: 0),
province.municipalities.new(description: "Ñuñoa", region: region, country: state, continent: continent, geoname_id: 8261178, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Talagante", country: state, continent: continent,  geoname_id: 3870304, population: 0)
municipalities = [
province.municipalities.new(description: "El Monte", region: region, country: state, continent: continent, geoname_id: 8261346, population: 0),
province.municipalities.new(description: "Isla de Maipo", region: region, country: state, continent: continent, geoname_id: 8261364, population: 0),
province.municipalities.new(description: "Padre Hurtado", region: region, country: state, continent: continent, geoname_id: 8261231, population: 0),
province.municipalities.new(description: "Peñaflor", region: region, country: state, continent: continent, geoname_id: 8261457, population: 0),
province.municipalities.new(description: "Talagante", region: region, country: state, continent: continent, geoname_id: 8261332, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región de Arica y Parinacota", country: state, continent: continent, geoname_id: 6693562)
province = region.provinces.create(description: "Provincia de Arica", country: state, continent: continent,  geoname_id: 3899358, population: 0)
municipalities = [
province.municipalities.new(description: "Arica", region: region, country: state, continent: continent, geoname_id: 8261387, population: 0),
province.municipalities.new(description: "Camarones", region: region, country: state, continent: continent, geoname_id: 8261252, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Parinacota", country: state, continent: continent,  geoname_id: 8181709, population: 0)
municipalities = [
province.municipalities.new(description: "General Lagos", region: region, country: state, continent: continent, geoname_id: 8261451, population: 0),
province.municipalities.new(description: "Putre", region: region, country: state, continent: continent, geoname_id: 8261463, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región de Los Ríos", country: state, continent: continent, geoname_id: 6693563)
province = region.provinces.create(description: "Provincia de Valdivia", country: state, continent: continent,  geoname_id: 3868703, population: 0)
municipalities = [
province.municipalities.new(description: "Corral", region: region, country: state, continent: continent, geoname_id: 8261460, population: 0),
province.municipalities.new(description: "Lanco", region: region, country: state, continent: continent, geoname_id: 8261462, population: 0),
province.municipalities.new(description: "Los Lagos", region: region, country: state, continent: continent, geoname_id: 8261445, population: 0),
province.municipalities.new(description: "Mafil", region: region, country: state, continent: continent, geoname_id: 8261458, population: 0),
province.municipalities.new(description: "Mariquina", region: region, country: state, continent: continent, geoname_id: 8261365, population: 0),
province.municipalities.new(description: "Paillaco", region: region, country: state, continent: continent, geoname_id: 8261459, population: 0),
province.municipalities.new(description: "Panguipulli", region: region, country: state, continent: continent, geoname_id: 8261354, population: 0),
province.municipalities.new(description: "Valdivia", region: region, country: state, continent: continent, geoname_id: 8261461, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia del Ranco", country: state, continent: continent,  geoname_id: 6693564, population: 0)
municipalities = [
province.municipalities.new(description: "Futrono", region: region, country: state, continent: continent, geoname_id: 8261366, population: 0),
province.municipalities.new(description: "La Union", region: region, country: state, continent: continent, geoname_id: 8261355, population: 0),
province.municipalities.new(description: "Lago Ranco", region: region, country: state, continent: continent, geoname_id: 8261367, population: 0),
province.municipalities.new(description: "Rio Bueno", region: region, country: state, continent: continent, geoname_id: 8261356, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región de Magallanes y de la Antártica Chilena", country: state, continent: continent, geoname_id: 4036650)
province = region.provinces.create(description: "Provincia Antártica Chilena", country: state, continent: continent,  geoname_id: 4036651, population: 0)
municipalities = [
province.municipalities.new(description: "Cabo de Hornos", region: region, country: state, continent: continent, geoname_id: 8261179, population: 0),
province.municipalities.new(description: "Chilean Antarctic Territory", region: region, country: state, continent: continent, geoname_id: 8261467, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Magallanes", country: state, continent: continent,  geoname_id: 3881037, population: 0)
municipalities = [
province.municipalities.new(description: "Laguna Blanca", region: region, country: state, continent: continent, geoname_id: 8261394, population: 0),
province.municipalities.new(description: "Punta Arenas", region: region, country: state, continent: continent, geoname_id: 8261182, population: 0),
province.municipalities.new(description: "Rio Verde", region: region, country: state, continent: continent, geoname_id: 8261180, population: 0),
province.municipalities.new(description: "San Gregorio", region: region, country: state, continent: continent, geoname_id: 8261452, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Tierra del Fuego", country: state, continent: continent,  geoname_id: 3869875, population: 0)
municipalities = [
province.municipalities.new(description: "Porvenir", region: region, country: state, continent: continent, geoname_id: 8261448, population: 0),
province.municipalities.new(description: "Primavera", region: region, country: state, continent: continent, geoname_id: 8261447, population: 0),
province.municipalities.new(description: "Timaukel", region: region, country: state, continent: continent, geoname_id: 8261181, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Última Esperanza", country: state, continent: continent,  geoname_id: 3868829, population: 0)
municipalities = [
province.municipalities.new(description: "Natales", region: region, country: state, continent: continent, geoname_id: 8261192, population: 0),
province.municipalities.new(description: "Torres del Paine", region: region, country: state, continent: continent, geoname_id: 8261441, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región de Tarapacá", country: state, continent: continent, geoname_id: 3870116)
province = region.provinces.create(description: "Provincia de Iquique", country: state, continent: continent,  geoname_id: 3887125, population: 0)
municipalities = [
province.municipalities.new(description: "Alto Hospicio", region: region, country: state, continent: continent, geoname_id: 8261202, population: 0),
province.municipalities.new(description: "Iquique", region: region, country: state, continent: continent, geoname_id: 8261207, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia del Tamarugal", country: state, continent: continent,  geoname_id: 8181710, population: 0)
municipalities = [
province.municipalities.new(description: "Camiña", region: region, country: state, continent: continent, geoname_id: 8261314, population: 0),
province.municipalities.new(description: "Colchane", region: region, country: state, continent: continent, geoname_id: 8261296, population: 0),
province.municipalities.new(description: "Huara", region: region, country: state, continent: continent, geoname_id: 8261206, population: 0),
province.municipalities.new(description: "Pica", region: region, country: state, continent: continent, geoname_id: 8261128, population: 0),
province.municipalities.new(description: "Pozo Almonte", region: region, country: state, continent: continent, geoname_id: 8261350, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región de Valparaíso", country: state, continent: continent, geoname_id: 3868621)
province = region.provinces.create(description: "Petorca Province", country: state, continent: continent,  geoname_id: 3876415, population: 0)
municipalities = [
province.municipalities.new(description: "Cabildo", region: region, country: state, continent: continent, geoname_id: 8261236, population: 0),
province.municipalities.new(description: "La Ligua", region: region, country: state, continent: continent, geoname_id: 8261234, population: 0),
province.municipalities.new(description: "Papudo", region: region, country: state, continent: continent, geoname_id: 8261391, population: 0),
province.municipalities.new(description: "Petorca", region: region, country: state, continent: continent, geoname_id: 8261235, population: 0),
province.municipalities.new(description: "Zapallar", region: region, country: state, continent: continent, geoname_id: 8261247, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Isla de Pascua", country: state, continent: continent,  geoname_id: 4030752, population: 0)
municipalities = [
province.municipalities.new(description: "Isla de Pascua", region: region, country: state, continent: continent, geoname_id: 8261466, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Los Andes", country: state, continent: continent,  geoname_id: 3882432, population: 0)
municipalities = [
province.municipalities.new(description: "Calle Larga", region: region, country: state, continent: continent, geoname_id: 8261246, population: 0),
province.municipalities.new(description: "Los Andes", region: region, country: state, continent: continent, geoname_id: 8261245, population: 0),
province.municipalities.new(description: "Rinconada", region: region, country: state, continent: continent, geoname_id: 8261389, population: 0),
province.municipalities.new(description: "San Esteban", region: region, country: state, continent: continent, geoname_id: 8261243, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Marga Marga", country: state, continent: continent,  geoname_id: 8181711, population: 0)
municipalities = [
province.municipalities.new(description: "Limache", region: region, country: state, continent: continent, geoname_id: 8261200, population: 0),
province.municipalities.new(description: "Olmue", region: region, country: state, continent: continent, geoname_id: 8261449, population: 0),
province.municipalities.new(description: "Quilpue", region: region, country: state, continent: continent, geoname_id: 8261204, population: 0),
province.municipalities.new(description: "Villa Alemana", region: region, country: state, continent: continent, geoname_id: 8261165, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Quillota", country: state, continent: continent,  geoname_id: 3874118, population: 0)
municipalities = [
province.municipalities.new(description: "Calera", region: region, country: state, continent: continent, geoname_id: 8261219, population: 0),
province.municipalities.new(description: "Hijuelas", region: region, country: state, continent: continent, geoname_id: 8261442, population: 0),
province.municipalities.new(description: "La Cruz", region: region, country: state, continent: continent, geoname_id: 8261222, population: 0),
province.municipalities.new(description: "Nogales", region: region, country: state, continent: continent, geoname_id: 8261218, population: 0),
province.municipalities.new(description: "Quillota", region: region, country: state, continent: continent, geoname_id: 8261275, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de San Felipe", country: state, continent: continent,  geoname_id: 3872251, population: 0)
municipalities = [
province.municipalities.new(description: "Catemu", region: region, country: state, continent: continent, geoname_id: 8261229, population: 0),
province.municipalities.new(description: "Llaillay", region: region, country: state, continent: continent, geoname_id: 8261237, population: 0),
province.municipalities.new(description: "Panquehue", region: region, country: state, continent: continent, geoname_id: 8261238, population: 0),
province.municipalities.new(description: "Putaendo", region: region, country: state, continent: continent, geoname_id: 8261240, population: 0),
province.municipalities.new(description: "San Felipe", region: region, country: state, continent: continent, geoname_id: 8261220, population: 0),
province.municipalities.new(description: "Santa Maria", region: region, country: state, continent: continent, geoname_id: 8261244, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Valparaíso", country: state, continent: continent,  geoname_id: 3868623, population: 0)
municipalities = [
province.municipalities.new(description: "Casablanca", region: region, country: state, continent: continent, geoname_id: 8261254, population: 0),
province.municipalities.new(description: "Concon", region: region, country: state, continent: continent, geoname_id: 8261183, population: 0),
province.municipalities.new(description: "Juan Fernández", region: region, country: state, continent: continent, geoname_id: 8261465, population: 0),
province.municipalities.new(description: "Puchuncavi", region: region, country: state, continent: continent, geoname_id: 8261248, population: 0),
province.municipalities.new(description: "Quintero", region: region, country: state, continent: continent, geoname_id: 8261233, population: 0),
province.municipalities.new(description: "Valparaíso", region: region, country: state, continent: continent, geoname_id: 8261249, population: 0),
province.municipalities.new(description: "Viña del Mar", region: region, country: state, continent: continent, geoname_id: 8261239, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "San Antonio Province", country: state, continent: continent,  geoname_id: 3872374, population: 0)
municipalities = [
province.municipalities.new(description: "Algarrobo", region: region, country: state, continent: continent, geoname_id: 8261201, population: 0),
province.municipalities.new(description: "Cartagena", region: region, country: state, continent: continent, geoname_id: 8261450, population: 0),
province.municipalities.new(description: "El Quisco", region: region, country: state, continent: continent, geoname_id: 8261225, population: 0),
province.municipalities.new(description: "El Tabo", region: region, country: state, continent: continent, geoname_id: 7798677, population: 0),
province.municipalities.new(description: "San Antonio", region: region, country: state, continent: continent, geoname_id: 8261250, population: 0),
province.municipalities.new(description: "Santo Domingo", region: region, country: state, continent: continent, geoname_id: 8261251, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región de la Araucanía", country: state, continent: continent, geoname_id: 3899463)
province = region.provinces.create(description: "Provincia de Cautín", country: state, continent: continent,  geoname_id: 3896095, population: 0)
municipalities = [
province.municipalities.new(description: "Carahue", region: region, country: state, continent: continent, geoname_id: 8261166, population: 0),
province.municipalities.new(description: "Cholchol", region: region, country: state, continent: continent, geoname_id: 8261379, population: 0),
province.municipalities.new(description: "Cunco", region: region, country: state, continent: continent, geoname_id: 8261376, population: 0),
province.municipalities.new(description: "Curarrehue", region: region, country: state, continent: continent, geoname_id: 8261173, population: 0),
province.municipalities.new(description: "Freire", region: region, country: state, continent: continent, geoname_id: 8261381, population: 0),
province.municipalities.new(description: "Galvarino", region: region, country: state, continent: continent, geoname_id: 8261378, population: 0),
province.municipalities.new(description: "Gorbea", region: region, country: state, continent: continent, geoname_id: 8261403, population: 0),
province.municipalities.new(description: "Lautaro", region: region, country: state, continent: continent, geoname_id: 8261368, population: 0),
province.municipalities.new(description: "Loncoche", region: region, country: state, continent: continent, geoname_id: 8261401, population: 0),
province.municipalities.new(description: "Melipeuco", region: region, country: state, continent: continent, geoname_id: 8261404, population: 0),
province.municipalities.new(description: "Nueva Imperial", region: region, country: state, continent: continent, geoname_id: 8261358, population: 0),
province.municipalities.new(description: "Padre Las Casas", region: region, country: state, continent: continent, geoname_id: 8261351, population: 0),
province.municipalities.new(description: "Perquenco", region: region, country: state, continent: continent, geoname_id: 8261307, population: 0),
province.municipalities.new(description: "Pitrufquen", region: region, country: state, continent: continent, geoname_id: 8261373, population: 0),
province.municipalities.new(description: "Pucon", region: region, country: state, continent: continent, geoname_id: 8261402, population: 0),
province.municipalities.new(description: "Saavedra", region: region, country: state, continent: continent, geoname_id: 8261241, population: 0),
province.municipalities.new(description: "Temuco", region: region, country: state, continent: continent, geoname_id: 8261311, population: 0),
province.municipalities.new(description: "Teodoro Schmidt", region: region, country: state, continent: continent, geoname_id: 8261371, population: 0),
province.municipalities.new(description: "Tolten", region: region, country: state, continent: continent, geoname_id: 8261393, population: 0),
province.municipalities.new(description: "Vilcun", region: region, country: state, continent: continent, geoname_id: 8261385, population: 0),
province.municipalities.new(description: "Villarrica", region: region, country: state, continent: continent, geoname_id: 8261396, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Malleco", country: state, continent: continent,  geoname_id: 3880842, population: 0)
municipalities = [
province.municipalities.new(description: "Angol", region: region, country: state, continent: continent, geoname_id: 8261199, population: 0),
province.municipalities.new(description: "Collipulli", region: region, country: state, continent: continent, geoname_id: 8261169, population: 0),
province.municipalities.new(description: "Curacautin", region: region, country: state, continent: continent, geoname_id: 8261386, population: 0),
province.municipalities.new(description: "Ercilla", region: region, country: state, continent: continent, geoname_id: 8261357, population: 0),
province.municipalities.new(description: "Lonquimay", region: region, country: state, continent: continent, geoname_id: 8261172, population: 0),
province.municipalities.new(description: "Los Sauces", region: region, country: state, continent: continent, geoname_id: 8261359, population: 0),
province.municipalities.new(description: "Lumaco", region: region, country: state, continent: continent, geoname_id: 8261170, population: 0),
province.municipalities.new(description: "Puren", region: region, country: state, continent: continent, geoname_id: 8261392, population: 0),
province.municipalities.new(description: "Renaico", region: region, country: state, continent: continent, geoname_id: 8261388, population: 0),
province.municipalities.new(description: "Traiguen", region: region, country: state, continent: continent, geoname_id: 8261370, population: 0),
province.municipalities.new(description: "Victoria", region: region, country: state, continent: continent, geoname_id: 8261352, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región del Biobío", country: state, continent: continent, geoname_id: 3898380)
province = region.provinces.create(description: "Provincia de Arauco", country: state, continent: continent,  geoname_id: 3899459, population: 0)
municipalities = [
province.municipalities.new(description: "Arauco", region: region, country: state, continent: continent, geoname_id: 8261302, population: 0),
province.municipalities.new(description: "Cañete", region: region, country: state, continent: continent, geoname_id: 8261315, population: 0),
province.municipalities.new(description: "Contulmo", region: region, country: state, continent: continent, geoname_id: 8261331, population: 0),
province.municipalities.new(description: "Curanilahue", region: region, country: state, continent: continent, geoname_id: 8261152, population: 0),
province.municipalities.new(description: "Lebu", region: region, country: state, continent: continent, geoname_id: 8261150, population: 0),
province.municipalities.new(description: "Los Alamos", region: region, country: state, continent: continent, geoname_id: 8261301, population: 0),
province.municipalities.new(description: "Tirúa", region: region, country: state, continent: continent, geoname_id: 8261330, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Biobío", country: state, continent: continent,  geoname_id: 3898381, population: 0)
municipalities = [
province.municipalities.new(description: "Alto Biobio", region: region, country: state, continent: continent, geoname_id: 8261320, population: 0),
province.municipalities.new(description: "Antuco", region: region, country: state, continent: continent, geoname_id: 8261322, population: 0),
province.municipalities.new(description: "Cabrero", region: region, country: state, continent: continent, geoname_id: 8261305, population: 0),
province.municipalities.new(description: "Laja", region: region, country: state, continent: continent, geoname_id: 8261353, population: 0),
province.municipalities.new(description: "Los Angeles", region: region, country: state, continent: continent, geoname_id: 8261144, population: 0),
province.municipalities.new(description: "Mulchén", region: region, country: state, continent: continent, geoname_id: 8261318, population: 0),
province.municipalities.new(description: "Nacimiento", region: region, country: state, continent: continent, geoname_id: 8261153, population: 0),
province.municipalities.new(description: "Negrete", region: region, country: state, continent: continent, geoname_id: 8261343, population: 0),
province.municipalities.new(description: "Quilaco", region: region, country: state, continent: continent, geoname_id: 8261319, population: 0),
province.municipalities.new(description: "Quilleco", region: region, country: state, continent: continent, geoname_id: 8261324, population: 0),
province.municipalities.new(description: "San Rosendo", region: region, country: state, continent: continent, geoname_id: 8261349, population: 0),
province.municipalities.new(description: "Santa Barbara", region: region, country: state, continent: continent, geoname_id: 8261321, population: 0),
province.municipalities.new(description: "Tucapel", region: region, country: state, continent: continent, geoname_id: 8261325, population: 0),
province.municipalities.new(description: "Yumbel", region: region, country: state, continent: continent, geoname_id: 8261197, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Concepción", country: state, continent: continent,  geoname_id: 3893889, population: 0)
municipalities = [
province.municipalities.new(description: "Chiguayante", region: region, country: state, continent: continent, geoname_id: 8261344, population: 0),
province.municipalities.new(description: "Comuna de Concepción", region: region, country: state, continent: continent, geoname_id: 6693568, population: 0),
province.municipalities.new(description: "Comuna de Hualpén", region: region, country: state, continent: continent, geoname_id: 3888526, population: 0),
province.municipalities.new(description: "Comuna de San Pedro de la Paz", region: region, country: state, continent: continent, geoname_id: 6693571, population: 0),
province.municipalities.new(description: "Comuna de Talcahuano", region: region, country: state, continent: continent, geoname_id: 6693599, population: 0),
province.municipalities.new(description: "Coronel", region: region, country: state, continent: continent, geoname_id: 8261347, population: 0),
province.municipalities.new(description: "Florida", region: region, country: state, continent: continent, geoname_id: 8261342, population: 0),
province.municipalities.new(description: "Hualqui", region: region, country: state, continent: continent, geoname_id: 8261345, population: 0),
province.municipalities.new(description: "Lota", region: region, country: state, continent: continent, geoname_id: 8261348, population: 0),
province.municipalities.new(description: "Penco", region: region, country: state, continent: continent, geoname_id: 8261303, population: 0),
province.municipalities.new(description: "Santa Juana", region: region, country: state, continent: continent, geoname_id: 8261196, population: 0),
province.municipalities.new(description: "Tome", region: region, country: state, continent: continent, geoname_id: 8261151, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Ñuble", country: state, continent: continent,  geoname_id: 3878472, population: 0)
municipalities = [
province.municipalities.new(description: "Bulnes", region: region, country: state, continent: continent, geoname_id: 8261304, population: 0),
province.municipalities.new(description: "Chillan", region: region, country: state, continent: continent, geoname_id: 8261195, population: 0),
province.municipalities.new(description: "Chillán Viejo", region: region, country: state, continent: continent, geoname_id: 8261339, population: 0),
province.municipalities.new(description: "Cobquecura", region: region, country: state, continent: continent, geoname_id: 8261140, population: 0),
province.municipalities.new(description: "Coelemu", region: region, country: state, continent: continent, geoname_id: 8261340, population: 0),
province.municipalities.new(description: "Coihueco", region: region, country: state, continent: continent, geoname_id: 8261338, population: 0),
province.municipalities.new(description: "El Carmen", region: region, country: state, continent: continent, geoname_id: 8261328, population: 0),
province.municipalities.new(description: "Ninhue", region: region, country: state, continent: continent, geoname_id: 8261142, population: 0),
province.municipalities.new(description: "Pemuco", region: region, country: state, continent: continent, geoname_id: 8261327, population: 0),
province.municipalities.new(description: "Pinto", region: region, country: state, continent: continent, geoname_id: 8261323, population: 0),
province.municipalities.new(description: "Portezuelo", region: region, country: state, continent: continent, geoname_id: 8261312, population: 0),
province.municipalities.new(description: "Quillon", region: region, country: state, continent: continent, geoname_id: 8261171, population: 0),
province.municipalities.new(description: "Quirihue", region: region, country: state, continent: continent, geoname_id: 8261141, population: 0),
province.municipalities.new(description: "Ranquil", region: region, country: state, continent: continent, geoname_id: 8261341, population: 0),
province.municipalities.new(description: "San Carlos", region: region, country: state, continent: continent, geoname_id: 8261190, population: 0),
province.municipalities.new(description: "San Fabian", region: region, country: state, continent: continent, geoname_id: 8261337, population: 0),
province.municipalities.new(description: "San Ignacio", region: region, country: state, continent: continent, geoname_id: 8261329, population: 0),
province.municipalities.new(description: "San Nicolás", region: region, country: state, continent: continent, geoname_id: 8261335, population: 0),
province.municipalities.new(description: "Treguaco", region: region, country: state, continent: continent, geoname_id: 8261143, population: 0),
province.municipalities.new(description: "Yungay", region: region, country: state, continent: continent, geoname_id: 8261326, population: 0),
province.municipalities.new(description: "Ñiquen", region: region, country: state, continent: continent, geoname_id: 8261336, population: 0),
]
Municipality.import municipalities
region = Region.create(description: "Región del Libertador General Bernardo O’Higgins", country: state, continent: continent, geoname_id: 3883281)
province = region.provinces.create(description: "Provincia de Cachapoal", country: state, continent: continent,  geoname_id: 3897525, population: 0)
municipalities = [
province.municipalities.new(description: "Codegua", region: region, country: state, continent: continent, geoname_id: 8261269, population: 0),
province.municipalities.new(description: "Coinco", region: region, country: state, continent: continent, geoname_id: 8261280, population: 0),
province.municipalities.new(description: "Coltauco", region: region, country: state, continent: continent, geoname_id: 8261258, population: 0),
province.municipalities.new(description: "Doñihue", region: region, country: state, continent: continent, geoname_id: 8261283, population: 0),
province.municipalities.new(description: "Graneros", region: region, country: state, continent: continent, geoname_id: 8261271, population: 0),
province.municipalities.new(description: "Las Cabras", region: region, country: state, continent: continent, geoname_id: 8261260, population: 0),
province.municipalities.new(description: "Machali", region: region, country: state, continent: continent, geoname_id: 8261191, population: 0),
province.municipalities.new(description: "Malloa", region: region, country: state, continent: continent, geoname_id: 8261277, population: 0),
province.municipalities.new(description: "Mostazal", region: region, country: state, continent: continent, geoname_id: 8261284, population: 0),
province.municipalities.new(description: "Olivar", region: region, country: state, continent: continent, geoname_id: 8261282, population: 0),
province.municipalities.new(description: "Peumo", region: region, country: state, continent: continent, geoname_id: 8261186, population: 0),
province.municipalities.new(description: "Pichidegua", region: region, country: state, continent: continent, geoname_id: 8261262, population: 0),
province.municipalities.new(description: "Quinta de Toloco", region: region, country: state, continent: continent, geoname_id: 8261273, population: 0),
province.municipalities.new(description: "Rancagua", region: region, country: state, continent: continent, geoname_id: 8261278, population: 0),
province.municipalities.new(description: "Rengo", region: region, country: state, continent: continent, geoname_id: 8261279, population: 0),
province.municipalities.new(description: "Requinoa", region: region, country: state, continent: continent, geoname_id: 8261281, population: 0),
province.municipalities.new(description: "San Vincente", region: region, country: state, continent: continent, geoname_id: 8261263, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Cardenal Caro", country: state, continent: continent,  geoname_id: 8181712, population: 0)
municipalities = [
province.municipalities.new(description: "La Estrella", region: region, country: state, continent: continent, geoname_id: 8261257, population: 0),
province.municipalities.new(description: "Litueche", region: region, country: state, continent: continent, geoname_id: 8261255, population: 0),
province.municipalities.new(description: "Marchihue", region: region, country: state, continent: continent, geoname_id: 8261259, population: 0),
province.municipalities.new(description: "Navidad", region: region, country: state, continent: continent, geoname_id: 8261253, population: 0),
province.municipalities.new(description: "Paredones", region: region, country: state, continent: continent, geoname_id: 8261270, population: 0),
province.municipalities.new(description: "Pichilemu", region: region, country: state, continent: continent, geoname_id: 8261256, population: 0),
]
Municipality.import municipalities
province = region.provinces.create(description: "Provincia de Colchagua", country: state, continent: continent,  geoname_id: 3894310, population: 0)
municipalities = [
province.municipalities.new(description: "Chepica", region: region, country: state, continent: continent, geoname_id: 8261274, population: 0),
province.municipalities.new(description: "Chimbarongo", region: region, country: state, continent: continent, geoname_id: 8261276, population: 0),
province.municipalities.new(description: "Lolol", region: region, country: state, continent: continent, geoname_id: 8261272, population: 0),
province.municipalities.new(description: "Nancagua", region: region, country: state, continent: continent, geoname_id: 8261266, population: 0),
province.municipalities.new(description: "Palmilla", region: region, country: state, continent: continent, geoname_id: 8261264, population: 0),
province.municipalities.new(description: "Peralillo", region: region, country: state, continent: continent, geoname_id: 8261267, population: 0),
province.municipalities.new(description: "Placilla", region: region, country: state, continent: continent, geoname_id: 8261261, population: 0),
province.municipalities.new(description: "Pumanque", region: region, country: state, continent: continent, geoname_id: 8261268, population: 0),
province.municipalities.new(description: "San Fernando", region: region, country: state, continent: continent, geoname_id: 8261187, population: 0),
province.municipalities.new(description: "Santa Cruz", region: region, country: state, continent: continent, geoname_id: 8261265, population: 0),
]
Municipality.import municipalities
