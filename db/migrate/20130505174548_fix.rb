class Fix < ActiveRecord::Migration
  def up
    execute " insert into stato_translations(stato_id,locale,description) values(5,'it','Isole Åland');
              insert into stato_translations(stato_id,locale,description) values(6,'it','Albania');
              insert into stato_translations(stato_id,locale,description) values(7,'it','Andorra');
              insert into stato_translations(stato_id,locale,description) values(8,'it','Austria');
              insert into stato_translations(stato_id,locale,description) values(9,'it','Bielorussia');
              insert into stato_translations(stato_id,locale,description) values(10,'it','Belgio');
              insert into stato_translations(stato_id,locale,description) values(11,'it','Bosnia ed Erzegovina');
              insert into stato_translations(stato_id,locale,description) values(12,'it','Bulgaria');
              insert into stato_translations(stato_id,locale,description) values(13,'it','Croazia');
              insert into stato_translations(stato_id,locale,description) values(14,'it','Repubblica Ceca');
              insert into stato_translations(stato_id,locale,description) values(15,'it','Danimarca');
              insert into stato_translations(stato_id,locale,description) values(16,'it','Estonia');
              insert into stato_translations(stato_id,locale,description) values(17,'it','Isole Fær Øer');
              insert into stato_translations(stato_id,locale,description) values(18,'it','Finlandia');
              insert into stato_translations(stato_id,locale,description) values(19,'it','Francia');
              insert into stato_translations(stato_id,locale,description) values(20,'it','Germania');
              insert into stato_translations(stato_id,locale,description) values(21,'it','Gibilterra');
              insert into stato_translations(stato_id,locale,description) values(22,'it','Grecia');
              insert into stato_translations(stato_id,locale,description) values(23,'it','Guernsey');
              insert into stato_translations(stato_id,locale,description) values(24,'it','Ungheria');
              insert into stato_translations(stato_id,locale,description) values(25,'it','Islanda');
              insert into stato_translations(stato_id,locale,description) values(26,'it','Irlanda');
              insert into stato_translations(stato_id,locale,description) values(27,'it','Isola di Man');
              insert into stato_translations(stato_id,locale,description) values(28,'it','Jersey');
              insert into stato_translations(stato_id,locale,description) values(29,'it','Kosovo');
              insert into stato_translations(stato_id,locale,description) values(30,'it','Lettonia');
              insert into stato_translations(stato_id,locale,description) values(31,'it','Liechtenstein');
              insert into stato_translations(stato_id,locale,description) values(32,'it','Lituania');
              insert into stato_translations(stato_id,locale,description) values(33,'it','Lussemburgo');
              insert into stato_translations(stato_id,locale,description) values(34,'it','Macedonia');
              insert into stato_translations(stato_id,locale,description) values(35,'it','Malta');
              insert into stato_translations(stato_id,locale,description) values(36,'it','Moldavia');
              insert into stato_translations(stato_id,locale,description) values(37,'it','Monaco');
              insert into stato_translations(stato_id,locale,description) values(38,'it','Montenegro');
              insert into stato_translations(stato_id,locale,description) values(39,'it','Olanda');
              insert into stato_translations(stato_id,locale,description) values(40,'it','Norvegia');
              insert into stato_translations(stato_id,locale,description) values(41,'it','Polonia');
              insert into stato_translations(stato_id,locale,description) values(42,'it','Portogallo');
              insert into stato_translations(stato_id,locale,description) values(43,'it','Romania');
              insert into stato_translations(stato_id,locale,description) values(44,'it','Russia');
              insert into stato_translations(stato_id,locale,description) values(45,'it','Serbia');
              insert into stato_translations(stato_id,locale,description) values(46,'it','Slovacchia');
              insert into stato_translations(stato_id,locale,description) values(47,'it','Slovenia');
              insert into stato_translations(stato_id,locale,description) values(48,'it','Spagna');
              insert into stato_translations(stato_id,locale,description) values(49,'it','Svalbard e Jan Mayen');
              insert into stato_translations(stato_id,locale,description) values(50,'it','Svezia');
              insert into stato_translations(stato_id,locale,description) values(51,'it','Svizzera');
              insert into stato_translations(stato_id,locale,description) values(52,'it','Ucraina');
              insert into stato_translations(stato_id,locale,description) values(53,'it','Inghilterra');"
  end

  def down
  end
end
