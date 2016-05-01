<?php

	/*
	
		Name: class.connection.php
		Purpose: Database Connection [Singleton Design Pattern]
		Author: Anamik Paul
		Email: anamikpaul@gmail.com
	
	*/

	class ConnectDB {
		
		private $hostname="localhost";
		private $username="root";
		private $password="";
		private $dbname="bi_data";
		private static $instance=NULL;
		
		private function __construct() {
			self::$instance=mysql_connect($this->hostname,$this->username,$this->password);
			if(self::$instance!=NULL) {
				if(mysql_select_db($this->dbname,self::$instance)==false) {
					self::$instance==NULL;
				}
			}
		}
		
		public static function getDB() {
			if(self::$instance==NULL) {
				self::$instance=new ConnectDB();
			}
			return self::$instance;
		}
		
	}
?>
