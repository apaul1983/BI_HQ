DATA WAREHOUSE AND ETL	[Author: Anamik Paul, Email: anamikpaul@gmail.com]
-------------------------------------------------------------------------------------------

	The task performed are listed below in the order, they were performed:
	
		(1)		Creating database primary_data.
		(2)		Creating table offer in primary_data database.
		(3)		Creating table fx_rate in primary_data database.
		(4)		Creating table lst_currency in primary_data database.
		(5)		Loading data in fx_rate table by from fx_rate.csv
		(6)		Loading data in lst_currency table from lst_currency.csv
		(7)		Loading data in offer table from offer.csv
		(8)		Creating database bi_data.
		(9)		Creating table valid_offers in bi_data database.
		(10)	Creating table hotel_offers in bi_data database.
		(11)	Loading data in valid_offers table of bi_data database after transforming from primary_data database.
		(12)	Loading data in hotel_offers table of bi_data database after transforming from primary_data database in two steps:
				
				(a)	Step 1: Creating a procedure to load data into hotel_offers table of bi_data database.
				(b)	Step 2: Calling the Procedure set_hotel_offers().
				
	Note:	1.  All the above task were performed by using sq1 queries in extract_transform_load.sql script file.
			  2.  *Database Used: MySQL
