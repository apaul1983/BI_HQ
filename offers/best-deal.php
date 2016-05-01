<?php
	
	/*
	
		Name: best-deal.php
		Purpose: API Endpoint [Ex: offers/best-deal.php?hotelId=51&checkinDate=2015-04-07&checkoutDate=2015-05-07]
		Author: Anamik Paul
		Email: anamikpaul@gmail.com
	
	*/
	
	if($_SERVER['REQUEST_METHOD'] == 'GET') {	
	
		require_once('class/connection.class.php');
	
		$num_of_get_parameters=count($_GET);
		if($num_of_get_parameters==3) {
			$hotelId = isset($_GET['hotelId']) ? mysql_real_escape_string(trim($_GET['hotelId']," ")) :  "";
			$checkinDate = isset($_GET['checkinDate']) ? mysql_real_escape_string(trim($_GET['checkinDate']," ")) :  "";
			$checkoutDate = isset($_GET['checkoutDate']) ? mysql_real_escape_string(trim($_GET['checkoutDate']," ")) :  "";
			if(!empty($hotelId)&&!empty($checkinDate)&&!empty($checkoutDate)&&is_numeric($hotelId)&&preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/",$checkinDate)&&preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/",$checkoutDate)) {
				$db=ConnectDB::getDB();
				$sql="select * from `valid_offers` where `hotel_id`='".$hotelId."' and (`valid_from_date` between '".$checkinDate."' and '".$checkoutDate."' or `valid_to_date` between '".$checkinDate."' and '".$checkoutDate."')";
				$query = mysql_query($sql);
				$result=array();
				$count_result=mysql_num_rows($query);
				if($count_result>0) {
					while($row=mysql_fetch_assoc($query)){
						$result[] = array("offerId" => $row['offer_id'], "hotelId" => $row['hotel_id'], 'checkinDate' => $checkinDate, 'checkoutDate' => $checkoutDate, 'sellingPrice' => $row['price_usd'], 'currencyCode' => 'USD'); 
					}
				}
				$json_result = array("status" => 1, "error_msg" => "", "response" => $result);
			}
			else {
				$json_result = array("status" => 0, "error_msg" => "Invalid Arguments Type. Valid Arguments Type include hotelId (numeric type), checkinDate (YYYY-MM-DD) and checkoutDate (YYYY-MM-DD)", "response" => "");
			}
		}
		else {
			$json_result = array("status" => 0, "error_msg" => "Check Parameters. Only three parameters: hotelId (numeric type), checkinDate (YYYY-MM-DD) and checkoutDate (YYYY-MM-DD) are allowed.", "response" => "");
		}
	}
	else {
		$json_result = array("status" => 0, "error_msg" => "Only HTTP GET request is allowed", "response" => "");
	}

	header('Content-type: application/json');
	header("Access-Control-Allow-Origin: *");
	echo json_encode($json_result);
	
?>
