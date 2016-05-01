DATA CLEANING	[Author: Anamik Paul, Email: anamikpaul@gmail.com] *Database Used: MySQL
-------------------------------------------------------------------------------------------

	A simple procedure named clean_country_code() is prepared to run autonomously and identify the outliers in the original_currency_code field for valid_offers table in bi_data schema.
	
	The procedure checks the following anomalies against the original_currency_code field:
	
		(1)	It eliminates any special characters, whitespaces, etc . allowing only alphabets.
		
			It is performed by using LTRIM, RTRIM, REPLACE and looping through each character to eliminate the anomalies.
		
		(2)	It transform the values in uppercase format.
		
			It is performed by using UCASE.
	
	This procedures utilizes cursor for accessing tuples and performing the desired task.
	The procedure eliminates the anomalies and updates the tuples at the same time.
	
CALLING THE PRECODURE clean_country_code()
---------------------------------------------

	call clean_country_code();
