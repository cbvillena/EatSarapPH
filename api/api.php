<?php
 	require_once("Rest.inc.php");
	
	class API extends REST {
	
		public $data = "";
		
		const DB_SERVER = "localhost";
		const DB_USER = "root";
		const DB_PASSWORD = "";
		const DB = "eatsarap";

		private $db = NULL;
		private $mysqli = NULL;
		public function __construct(){
			parent::__construct();				// Init parent contructor
			$this->dbConnect();					// Initiate Database connection
		}
		
		/*
		 *  Connect to Database
		*/
		private function dbConnect(){
			$this->mysqli = new mysqli(self::DB_SERVER, self::DB_USER, self::DB_PASSWORD, self::DB);
		}
		
		/*
		 * Dynmically call the method based on the query string
		 */
		public function processApi(){
			$func = strtolower(trim(str_replace("/","",$_REQUEST['x'])));
			if((int)method_exists($this,$func) > 0)
				$this->$func();
			else
				$this->response('',404); // If the method not exist with in this class "Page not found".
		}
				
		private function login(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}
            
            $entry = json_decode(file_get_contents("php://input"));
            $store = $entry->store_id;
            $query="SELECT store_id, storename, storeaddress, storephoto_url, phonenumber, emailaddress FROM store WHERE store_id = '$store'";
            $r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);

            if($r->num_rows > 0) {
                $result = $r->fetch_assoc();	
                // If success everything is good send header as "OK" and user details
                $this->response($this->json($result), 200);
            }
            $this->response('', 204);	// If no records "No Content" status
		}
		
		/* STORE API */
        
        private function storeList(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
			$query="SELECT store_id, storename, storeaddress, storephoto_url, phonenumber, emailaddress FROM store";
			$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);

			if($r->num_rows > 0){
				$result = array();
				while($row = $r->fetch_assoc()){
					$result[] = $row;
				}
                
				$this->response($this->json($result), 200); // send user details
                
                
			}
			$this->response('',204);	// If no records "No Content" status
		}
		
		private function getStoreDetails(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
			$id = (int)$this->_request['store_id'];
			if($id > 0){	
				$query="SELECT store_id, storename, storeaddress, storephoto_url, phonenumber, emailaddress, servicecharge FROM store WHERE store_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				if($r->num_rows > 0) {
					$result = $r->fetch_assoc();	
					$this->response($this->json($result), 200); // send user details
				}
			}
			$this->response('',204);	// If no records "No Content" status
		}
        
		private function addStore(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}

			$store = json_decode(file_get_contents("php://input"),true);
			$column_names = array('store_id', 'storename', 'storeaddress', 'phonenumber', 'emailaddress', 'storephoto_url', 'servicecharge');
			$keys = array_keys($store);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If blank insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $store[$desired_key];
				}
				$columns = $columns.$desired_key.',';
				$values = $values."'".$$desired_key."',";
			}
			$query = "INSERT INTO store(".trim($columns,',').") VALUES(".trim($values,',').")";
			if(!empty($store)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Store Created Successfully.", "data" => $store);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	//"No Content" status
		}
		
		private function updateStore(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}
			$store = json_decode(file_get_contents("php://input"),true);
			$id = (int)$store['store_id'];
			$column_names = array('store_id', 'storename', 'storeaddress', 'phonenumber', 'emailaddress', 'storephoto_url', 'servicecharge');
			$keys = array_keys($store['store']);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If key does not exist, insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $store['store'][$desired_key];
				}
				$columns = $columns.$desired_key."='".$$desired_key."',";
			}
			$query = "UPDATE store SET ".trim($columns,',')." WHERE store_id=$id";
			if(!empty($store)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Store ".$id." Updated Successfully.", "data" => $store);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	// "No Content" status
		}
		
		private function deleteStore(){
			if($this->get_request_method() != "DELETE"){
				$this->response('',406);
			}
			$id = (int)$this->_request['store_id'];
			if($id > 0){				
				$query="DELETE FROM store WHERE store_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Successfully deleted one record.");
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	// If no records "No Content" status
		}
		
        /* MENU API */
        
        private function getStoreMenu(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
			$id = (int)$this->_request['store_id'];
			if($id > 0){	
				$query="SELECT item_id, item_name, price, description, itemphoto_url, category_name FROM menu WHERE store_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				if($r->num_rows > 0){
                    $result = array();
                    while($row = $r->fetch_assoc()){
                        $result[] = $row;
                    }

                    $this->response($this->json($result), 200); // send user details


                }
			}
			$this->response('',204);	// If no records "No Content" status
		}
        
		private function getMenuItem(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
			$id = (int)$this->_request['item_id'];
			if($id > 0){	
				$query="SELECT item_id, store_id, item_name, price, description, itemphoto_url, category_name FROM menu WHERE item_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				if($r->num_rows > 0) {
					$result = $r->fetch_assoc();	
					$this->response($this->json($result), 200); // send user details
				}
			}
			$this->response('',204);	// If no records "No Content" status
		}
		
		private function addMenuItem(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}

			$menu = json_decode(file_get_contents("php://input"),true);
			$column_names = array('item_id', 'store_id', 'item_name', 'price', 'description', 'itemphoto_url', 'category_name');
			$keys = array_keys($menu);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If blank insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $menu[$desired_key];
				}
				$columns = $columns.$desired_key.',';
				$values = $values."'".$$desired_key."',";
			}
			$query = "INSERT INTO menu(".trim($columns,',').") VALUES(".trim($values,',').")";
			if(!empty($menu)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Meenu item Created Successfully.", "data" => $menu);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	//"No Content" status
		}
		
		private function updateMenuItem(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}
			$menu = json_decode(file_get_contents("php://input"),true);
			$id = (int)$menu['item_id'];
			$column_names = array('item_id', 'store_id', 'item_name', 'price', 'description', 'itemphoto_url', 'category_name');
			$keys = array_keys($menu['item']);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If key does not exist, insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $menu['item'][$desired_key];
				}
				$columns = $columns.$desired_key."='".$$desired_key."',";
			}
			$query = "UPDATE menu SET ".trim($columns,',')." WHERE item_id=$id";
			if(!empty($menu)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Item ".$id." Updated Successfully.", "data" => $menu);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	// "No Content" status
		}
		
		private function deleteMenuItem(){
			if($this->get_request_method() != "DELETE"){
				$this->response('',406);
			}
			$id = (int)$this->_request['item_id'];
			if($id > 0){				
				$query="DELETE FROM menu WHERE item_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Successfully deleted one record.");
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	// If no records "No Content" status
		}
		
        
        /* ORDER API */
        
        private function getActiveCustomers(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
            $id = (int)$this->_request['store_id'];
			if($id > 0){	
				$query="SELECT a.order_id, a.store_id, a.customer_id, a.item_id, a.quantity, b.item_name, b.price, b.itemphoto_url, c.storename, c.storephoto_url, d.customer_identity, e.status_name FROM custorder a INNER JOIN menu b ON a.item_id = b.item_id INNER JOIN store c ON a.store_id = c.store_id INNER JOIN customer d ON a.customer_id = d.customer_id INNER JOIN statustbl e ON d.status = e.status_id WHERE a.store_id = '$id' AND e.status_id <> 5";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				if($r->num_rows > 0){
                    $result = array();
                    while($row = $r->fetch_assoc()){
                        $result[] = $row;
                    }

                    $this->response($this->json($result), 200); // send user details


                }
			}
			$this->response('',204);	// If no records "No Content" status
		}
        
        
        private function getCustomerOrder(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
            $id = (int)$this->_request['customer_id'];
            $store = (int)$this->_request['store_id'];
			if($id > 0){	
				$query="SELECT a.order_id, a.store_id, a.customer_id, a.item_id, a.quantity, b.item_name, b.price, b.itemphoto_url, c.storename, c.storephoto_url, d.customer_identity, e.status_name FROM custorder a INNER JOIN menu b ON a.item_id = b.item_id INNER JOIN store c ON a.store_id = c.store_id INNER JOIN customer d ON a.customer_id = d.customer_id INNER JOIN statustbl e ON d.status = e.status_id WHERE a.store_id = '$store' AND a.customer_id = '$id' ";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				if($r->num_rows > 0){
                    $result = array();
                    while($row = $r->fetch_assoc()){
                        $result[] = $row;
                    }

                    $this->response($this->json($result), 200); // send user details


                }
			}
			$this->response('',204);	// If no records "No Content" status
		}
        
        private function addOrder(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}

			$order = json_decode(file_get_contents("php://input"),true);
			$column_names = array('order_id', 'store_id', 'customer_id', 'item_id', 'quantity');
			$keys = array_keys($order);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If blank insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $order[$desired_key];
				}
				$columns = $columns.$desired_key.',';
				$values = $values."'".$$desired_key."',";
			}
			$query = "INSERT INTO custorder(".trim($columns,',').") VALUES(".trim($values,',').")";
			if(!empty($order)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Menu item Created Successfully.", "data" => $order);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	//"No Content" status
		}
        
        private function deleteOrder(){
			if($this->get_request_method() != "DELETE"){
				$this->response('',406);
			}
			$id = (int)$this->_request['customer_id'];
			if($id > 0){				
				$query="DELETE FROM custorder WHERE customer_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Successfully deleted one record.");
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	// If no records "No Content" status
		}
        
        /* CUSTOMER API */
        
        private function getCustomer(){	
			if($this->get_request_method() != "GET"){
				$this->response('',406);
			}
            $id = (int)$this->_request['customer_id'];
			if($id > 0){	
				$query="SELECT customer_id, customer_identity, status FROM customer WHERE customer_id = $id";
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				if($r->num_rows > 0){
                    $result = array();
                    while($row = $r->fetch_assoc()){
                        $result[] = $row;
                    }

                    $this->response($this->json($result), 200); // send user details


                }
			}
			$this->response('',204);	// If no records "No Content" status
		}
        
         private function addCustomer(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}

			$customer = json_decode(file_get_contents("php://input"),true);
			$column_names = array('customer_id', 'customer_identity', 'status');
			$keys = array_keys($customer);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If blank insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $customer[$desired_key];
				}
				$columns = $columns.$desired_key.',';
				$values = $values."'".$$desired_key."',";
			}
			$query = "INSERT INTO customer(".trim($columns,',').") VALUES(".trim($values,',').")";
			if(!empty($customer)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Menu item Created Successfully.", "data" => $customer);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	//"No Content" status
		}
        
        private function updateCustomer(){
			if($this->get_request_method() != "POST"){
				$this->response('',406);
			}
			$customer = json_decode(file_get_contents("php://input"),true);
			$id = (int)$customer['customer_id'];
			$column_names = array('customer_id', 'customer_identity', 'status');
			$keys = array_keys($customer['customer']);
			$columns = '';
			$values = '';
			foreach($column_names as $desired_key){ // Check the customer received. If key does not exist, insert blank into the array.
			   if(!in_array($desired_key, $keys)) {
			   		$$desired_key = '';
				}else{
					$$desired_key = $customer['customer'][$desired_key];
				}
				$columns = $columns.$desired_key."='".$$desired_key."',";
			}
			$query = "UPDATE customer SET ".trim($columns,',')." WHERE customer_id=$id";
			if(!empty($customer)){
				$r = $this->mysqli->query($query) or die($this->mysqli->error.__LINE__);
				$success = array('status' => "Success", "msg" => "Customer ".$id." Updated Successfully.", "data" => $customer);
				$this->response($this->json($success),200);
			}else
				$this->response('',204);	// "No Content" status
		}
        
		/*
		 *	Encode array into JSON
		*/
		private function json($data){
			if(is_array($data)){
				return json_encode($data);
			}
		}
	}
	
	// Initiiate Library
	
	$api = new API;
	$api->processApi();
?>