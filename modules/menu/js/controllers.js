'use strict'

angular.module('eatsarap.menu.controllers',[]).controller('ListMenuController',['$scope','StoreServices','MenuServices','$state',function($scope,StoreServices,MenuServices,$state){
    var storeid = localStorage.getItem('store_id');
    
    StoreServices.getStoreDetails(storeid).then(function(data){
        $scope.store = data.data;
    });
    
    MenuServices.getStoreMenu(storeid).then(function(data){
        $scope.menu = data.data;
    });
    
    $scope.addnewmenu = function(){
        $state.go('addmenu');
    };
    
}]).controller('AddMenuController',['$scope','MenuServices','$state','$timeout','$upload',function($scope,MenuServices,$state,$timeout,$upload){
    var storeid = localStorage.getItem('store_id');

    $scope.addMenuItem = function(item){
        console.log(item.item_name);
        MenuServices.addMenuItem(storeid,item).then(function(data){
            $state.go('menulist');
        });
    };
    
    var min = 10000;
    var max = 99999;
    
    $scope.uploadResult = [];
    $scope.onFileSelect = function ($files) {
        //$files: an array of files selected, each file has name, size, and type.
        for (var i = 0; i < $files.length; i++) {
            var $file = $files[i];
            $upload.upload({
                url: 'modules/uploads/upload.php',
                file: $file,
                data: {'identity': Math.floor(Math.random() * (max - min + 1)) + min},
                progress: function (e) {}
            }).then(function (response) {
                // file is uploaded successfully
                $timeout(function () {
                    $scope.uploadResult = response.data;
                    $scope.item.itemphoto_url = 'modules/uploads/upload/' + JSON.parse(response.data);
                    console.log($scope.item.itemphoto_url);
                });

            });
        }
    }

    
}]).controller('EditMenuController',['$scope','$state','$stateParams','MenuServices',function($scope,$state,$stateParams,MenuServices){
    var itemid = $stateParams.itemid;
    var storeid = localStorage.getItem('store_id');
    
    MenuServices.getMenuItem(itemid).then(function(data){
        $scope.item = data.data;
    });
    
    $scope.editMenuItem = function(item){
        MenuServices.updateMenuItem(storeid,itemid,item).then(function(data){
            console.log(data);
            $state.go('menulist');
        })
    }
}]).controller('ViewMenuController',['$scope','$state','$stateParams','MenuServices',function($scope,$state,$stateParams,MenuServices){
    var itemid = $stateParams.itemid;
    
    MenuServices.getMenuItem(itemid).then(function(data){
        $scope.item = data.data;
    });
    
    $scope.editMenuItem = function(item){
        $state.go('editmenu',{itemid:item.item_id});
    }
    
    $scope.deleteMenuItem = function(item){
        if(confirm("Are you sure to delete this item on your menu: "+$scope.item.item_name)==true){
            MenuServices.deleteMenuItem(itemid).then(function(data){
                $state.go('menulist');
            })
        }
    }
}]);