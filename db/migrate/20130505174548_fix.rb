#encoding: utf-8
class Fix < ActiveRecord::Migration
  def up
    execute " insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(5,'it','Isole Åland',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(6,'it','Albania',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(7,'it','Andorra',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(8,'it','Austria',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(9,'it','Bielorussia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(10,'it','Belgio',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(11,'it','Bosnia ed Erzegovina',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(12,'it','Bulgaria',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(13,'it','Croazia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(14,'it','Repubblica Ceca',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(15,'it','Danimarca',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(16,'it','Estonia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(17,'it','Isole Fær Øer',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(18,'it','Finlandia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(19,'it','Francia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(20,'it','Germania',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(21,'it','Gibilterra',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(22,'it','Grecia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(23,'it','Guernsey',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(24,'it','Ungheria',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(25,'it','Islanda',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(26,'it','Irlanda',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(27,'it','Isola di Man',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(28,'it','Jersey',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(29,'it','Kosovo',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(30,'it','Lettonia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(31,'it','Liechtenstein',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(32,'it','Lituania',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(33,'it','Lussemburgo',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(34,'it','Macedonia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(35,'it','Malta',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(36,'it','Moldavia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(37,'it','Monaco',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(38,'it','Montenegro',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(39,'it','Olanda',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(40,'it','Norvegia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(41,'it','Polonia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(42,'it','Portogallo',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(43,'it','Romania',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(44,'it','Russia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(45,'it','Serbia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(46,'it','Slovacchia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(47,'it','Slovenia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(48,'it','Spagna',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(49,'it','Svalbard e Jan Mayen',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(50,'it','Svezia',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(51,'it','Svizzera',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(52,'it','Ucraina',current_timestamp,current_timestamp);
insert into stato_translations(stato_id,locale,description,created_at,updated_at) values(53,'it','Inghilterra',current_timestamp,current_timestamp);
"
  end

  def down
  end
end
