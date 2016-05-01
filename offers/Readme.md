API ENDPOINT	[Author: Anamik Paul, Email: anamikpaul@gmail.com]	*Database Used: MySQL	*API WRITTEN IN LANGUAGE: PHP
-------------------------------------------------------------------------------------------------------------------------

The API Endpoint is built by dividing the task and database connection in two separate files.

1.	connection.class.php

	It is a class based on singleton design pattern for database connection. Singleton design pattern is used to 
	allow only a single instance of database object at any time.
	
	It has private data members that are assigned before hand except a static member called $instance, which is assigned to NULL.
	
	It has two methods:
	(1)	A constructor that does perform mysql_connect() and mysql_select_db() functions for database connection.
	(2) A getDB() method (accessor method) which creates an object of the class, if $instance is NULL and returns the object.
	
2.	best-deal.php 
	
	It handles the API call and validates the input as well as provide the output in JSON format.

	It performs the following tasks:
	(1)	It ensures to serve only HTTP GET request.
	(2)	It ensures exact three GET parameters are provided and the parameters are validated such as hotelId to be numeric only, as well as checkinDate and  checkoutDate to be in date format (YYYY-MM-DD).
	(3) It fetches the result from database based on the given parameters.
	(4) It provides JSON response in the following format:
	
		Example:
		
			(1)
				http://localhost/offers/best-deal.php?hotelId=51&checkinDate=2015-04-07&checkoutDate=2015-04-10 
				
				Output:
					{
						"status":1,
						"error_msg":"",
						"response":
						[
							{	"offerId":"1",
								"hotelId":"51",
								"checkinDate":"2015-04-07",
								"checkoutDate":"2015-04-10",
								"sellingPrice":"1.07",
								"currencyCode":"USD"
							},
							{	"offerId":"5",
								"hotelId":"51",
								"checkinDate":"2015-04-07",
								"checkoutDate":"2015-04-10",
								"sellingPrice":"2.39",
								"currencyCode":"USD"
							}
						]
					}
				
				
			(2)
			
				http://localhost/offers/best-deal.php?hotelId=51&checkinDate=20150407&checkoutDate=20150507   [Invalid Date Format]
				
				Output:
				
					{
						"status":0,
						"error_msg":"Invalid Arguments Type. Valid Arguments Type include hotelId (numeric type), checkinDate (YYYY-MM-DD) and checkoutDate (YYYY-MM-DD)",
						"response":""
					}
					
			(3)
			
				http://localhost/offers/best-deal.php	[Without any GET parameters]
				
				Output:
				
					{
						"status":0,
						"error_msg":"Check Parameters. Only three parameters: hotelId (numeric type), checkinDate (YYYY-MM-DD) and checkoutDate (YYYY-MM-DD) are allowed.",
						"response":""
					}
				
ACCESSING THE API
-----------------

Step 1:	The API needs to be consumed through the API ENDPOINT http://localhost/offers/best-deal.php

Step 2: It is mandatory to send three GET parameters hotelId (numeric only), checkinDate (YYYY-MM-DD format) and checkoutDate (YYYY-MM-DD format) using the API ENDPOINT

Step #: It provides the response in JSON format comprising of status (0 for Failure and 1 for success), error_msg (only if status is 0) and response (comprising of offerId, hotelId,
		checkinDate, checkoutDate, sellingPrice and currencyCode).
		
		Note: The response might contain 0 or more values depending on the deals availability.
