'use strict'

angular.module('eatsarap.store.services',[]).factory('StoreServices',['$http',function($http){
    
    var apipath = 'api/';
    var store = {};
    
    store.login = function(store){
        return $http.post(apipath + 'login',{store_id:store.store_id});
    }
    
    store.addStore = function(store){
        return $http.post(apipath + 'addStore',{store_id:store.store_id,storename:store.storename,storeaddress:store.storeaddress,phonenumber:store.phonenumber,emailaddress:store.emailaddress,storephoto_url:store.photo,servicecharge:store.servicecharge}).then(function(results){
            return results;
        });
    }
    
    store.getStoreDetails = function(store_id){
        return $http.get(apipath + 'getStoreDetails?store_id=' + store_id);
    }
    
    store.updateStore = function (storeid,store) {
        
	    return $http.post(apipath + 'updateStore', {store_id:storeid, store:{store_id:store.store_id,storename:store.storename,storeaddress:store.storeaddress,phonenumber:store.phonenumber,emailaddress:store.emailaddress,storephoto_url:store.storephoto_url,servicecharge:store.servicecharge}}).then(function (results) {
	        return results.data;
	    });
	};
    
    store.deleteStore = function(storeid){
        return $http.delete(apipath + 'deleteStore?store_id='+storeid).then(function(results){
            return results.data;
        });
    }
    
    store.getActiveCustomers = function(storeid){
        return $http.get(apipath + 'getActiveCustomers?store_id='+storeid);
    }
    
  return store;
    
}]);