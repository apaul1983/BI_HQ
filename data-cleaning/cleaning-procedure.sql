/*

	Procedure Name: clean_country_code()
	Purpose: It checks country code field, so that it maintains all code in upper-case and have alphabets only without any special characters and spaces.

*/
use `bi_data`;
DROP procedure IF EXISTS `clean_country_code`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_country_code`()
BEGIN
	DECLARE code varchar(35) DEFAULT "";
    DECLARE temp varchar(35) DEFAULT "";
    DECLARE clean_code varchar(35) DEFAULT "";
    DECLARE ch varchar(35) DEFAULT "";
    DECLARE oid int;
    DECLARE done INT DEFAULT 0;
    DECLARE incr int;
    DECLARE curr CURSOR FOR SELECT `original_currency_code`,`offer_id` from `bi_data`.`valid_offers`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN curr;
    my_cur_loop: LOOP
    	FETCH curr into code,oid;
        IF done = 1 THEN
           LEAVE my_cur_loop;
        END IF;
        SET temp=UCASE(RTRIM(LTRIM(code)));
        SET clean_code="";
        SET incr=1;
        WHILE incr <= LENGTH(temp) DO
        	SET ch = MID(temp, incr, 1);
            IF ASCII(ch) = 32 OR ASCII(ch) >= 48 AND ASCII(ch) <= 57 OR ASCII(ch) >= 65 AND ASCII(ch) <= 90  OR ASCII(ch) >= 97 AND ASCII(ch) <= 122 THEN
                SET clean_code = CONCAT(clean_code, ch);
            END IF;
            SET incr = incr + 1;    
        END WHILE;
        SET clean_code =REPLACE(clean_code,' ','');
        update `bi_data`.`valid_offers` set `original_currency_code`=clean_code where `offer_id`=oid;
    END LOOP my_cur_loop;
    CLOSE curr;
END $$
DELIMITER ;

/* calling procedure clean_country_code() */
call clean_country_code();
