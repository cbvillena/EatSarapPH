'use strict'

angular.module('eatsarap.menu.services',[]).factory('MenuServices',['$http',function($http){
    var apipath = 'api/';
    var menu = {};
    
    menu.getStoreMenu = function(storeid){
        return $http.get(apipath + 'getStoreMenu?store_id=' + storeid);
    }
    
    menu.addMenuItem = function(storeid,item){
        return $http.post(apipath + 'addMenuItem',{item_id:null,store_id:storeid,item_name:item.item_name,price:item.price,description:item.description,itemphoto_url:item.itemphoto_url,category_name:item.category_name}).then(function(results){
            return results.data;
        })
    }
    
    menu.categories = function(){
        return $http.get(apipath + 'categories');
    };
    
    menu.getMenuItem = function(itemid){
        return $http.get(apipath + 'getMenuItem?item_id=' + itemid);
    }
    
    menu.updateMenuItem = function (storeid,itemid,item) {
        
	    return $http.post(apipath + 'updateMenuItem', {item_id:itemid, item:{item_id:itemid,store_id:storeid,item_name:item.item_name,price:item.price,description:item.description,itemphoto_url:item.itemphoto_url,category_name:item.category_name}}).then(function (results) {
	        return results.data;
	    });
	};
    
    menu.deleteMenuItem = function(itemid){
        return $http.delete(apipath + 'deleteMenuItem?item_id='+itemid).then(function(results){
            return results.data;
        });
    }
    
    return menu;
    
}])