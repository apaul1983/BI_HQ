/* creating database primary_data */
create database if not exists `primary_data`;

/* creating table offer in primary_data */
create table if not exists `primary_data`.`offer`(id int not null primary key,hotel_id int not null,currency_id int not null,source_system_code int not null,available_cnt int not null,selling_price float not null,checkin_date date not null,checkout_date date not null,valid_offer_flag tinyint not null default 0,offer_valid_from datetime not null,offer_valid_to datetime not null,breakfast_included_flag tinyint not null default 0,insert_datetime datetime not null default current_timestamp);

/* creating table fx_rate in primary_data */
create table if not exists `primary_data`.`fx_rate`(id int not null primary key,prim_currency_id int not null,scnd_currency_id int not null,date date not null,currency_rate float not null);

/* creating table lst_currency in primary_data */
create table if not exists `primary_data`.`lst_currency`(id int not null primary key,code varchar(35) default null,name varchar(100) default null);

/* loading data in fx_rate table from fx_rate.csv */
load data infile 'c:/xampp/htdocs/BIHQ/csv/fx_rate.csv' into table `primary_data`.`fx_rate` fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows;

/* loading data in lst_currency table from lst_currency.csv */
load data infile 'c:/xampp/htdocs/BIHQ/csv/lst_currency.csv' into table `primary_data`.`lst_currency` fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows;

/* loading data in offer table from offer.csv */
load data infile 'c:/xampp/htdocs/BIHQ/csv/offer.csv' into table `primary_data`.`offer` fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows;

/* creating database bi_data  */
create database if not exists `bi_data`;

/* creating table valid_offers in bi_data */
create table if not exists `bi_data`.`valid_offers`(offer_id int not null,hotel_id int not null,price_usd float not null,original_price float not null,original_currency_code varchar(35) not null,breakfast_included_flag tinyint not null default 0,valid_from_date datetime not null,valid_to_date datetime not null);

/* creating table hotel_offers in bi_data */
create table if not exists `bi_data`.`hotel_offers`(hotel_id int not null,date date not null,hour tinyint not null default 0,breakfast_included_flag tinyint not null default 0,valid_offer_available_flag tinyint not null default 1);

/* loading data in valid_offers table of bi_data after transforming from primary_data database */
insert into `bi_data`.`valid_offers`(`offer_id`,`hotel_id`,`price_usd`,`original_price`,`original_currency_code`,`breakfast_included_flag`,`valid_from_date`,`valid_to_date`) select `id`,`hotel_id`,(SELECT CASE WHEN `currency_id`!=1 THEN round(`currency_rate`*`selling_price`,2) ELSE round(`selling_price`,2) END) as `price_usd`,`selling_price`,`code`,`breakfast_included_flag`,`offer_valid_from`,`offer_valid_to` from (SELECT `t1`.`id`,`t1`.`hotel_id`,`t1`.`selling_price`,`t2`.`code`,`t1`.`currency_id`,`t1`.`breakfast_included_flag`,`t1`.`offer_valid_from`,`t1`.`offer_valid_to` from `primary_data`.`offer` as `t1` inner join `primary_data`.`lst_currency` as `t2` on `t1`.`currency_id`=`t2`.`id` where `t1`.`valid_offer_flag`=1) as `t3` inner join (SELECT `t5`.`id` as `tid`,`t4`.`currency_rate` FROM `primary_data`.`offer` as `t5` inner join `primary_data`.`fx_rate` as `t4` WHERE `t4`.`prim_currency_id`=`t5`.`currency_id` and `scnd_currency_id`=1 and `t5`.`valid_offer_flag`=1 and `t4`.`date`=DATE(`t5`.`insert_datetime`)) as `t6` on `t3`.`id`=`t6`.`tid`;

/* loading data in hotel_offers table of bi_data after transforming from primary_data database in two steps */

/* Step 1: creating a procedure to load data into hotel_offers table */
use `primary_data`;
DROP procedure IF EXISTS `set_hotel_offers`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `set_hotel_offers`()
BEGIN
	DECLARE hr int DEFAULT 0;
    DECLARE temp_hr int DEFAULT 0;
    DECLARE temp_date date;
    declare temp_incr int default 0;
	DECLARE done INT DEFAULT 0;
	DECLARE hid int DEFAULT 0;
    DECLARE bflag tinyint DEFAULT 0;
    DECLARE oflag tinyint DEFAULT 0;
    DECLARE hour tinyint DEFAULT 0;
    DECLARE min tinyint DEFAULT 0;
    DECLARE vfrom datetime DEFAULT 0;
	DECLARE cursor_offer CURSOR FOR SELECT `hotel_id`,`breakfast_included_flag`,`valid_offer_flag`,time_format(timediff(`offer_valid_to`, `offer_valid_from` ),'%H') as `hour`,time_format(timediff(`offer_valid_to`, `offer_valid_from` ),'%m') as `min`, `offer_valid_from` from `primary_data`.`offer`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cursor_offer;
    my_cur_loop: LOOP 
    FETCH cursor_offer into hid, bflag, oflag, hour, min, vfrom;
    IF done = 1 THEN
       LEAVE my_cur_loop;
    END IF;
    SET hr=0;
    SET temp_incr=0;
    IF min>0 THEN 
    	SET hour=hour+1;
    END IF;
    while hr < hour DO
    	SET temp_date=DATE_ADD(vfrom,INTERVAL 60*(hr+1) MINUTE);
    	IF temp_date>vfrom THEN
        	IF temp_incr>23 THEN
            	SET temp_incr=0;
            END IF;
        	SET temp_hr=temp_incr;
            SET temp_incr=temp_incr+1;
        ELSE
            SET temp_hr=hr;
        END IF;
    	insert into `bi_data`.`hotel_offers`(`hotel_id`,`date`,`hour`,`breakfast_included_flag`,`valid_offer_available_flag`) values (hid,temp_date,temp_hr,bflag,oflag);
        set hr=hr+1;
    END WHILE;
    
    
    END LOOP my_cur_loop;
    CLOSE cursor_offer;
END $$
DELIMITER ;

/* Step 2: Calling the Procedure set_hotel_offers */
call set_hotel_offers();
