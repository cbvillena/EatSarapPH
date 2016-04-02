'use strict'

angular.module('eatsarap.store.controllers', []).controller('LoginController', ['$scope', 'StoreServices', '$state', function ($scope, StoreServices, $state) {

    $scope.login = function (store) {

        StoreServices.login(store).then(function (data) {
            console.log(data.data);
            if (data.data.store_id != undefined) {
                localStorage.clear();
                localStorage.setItem('store_id', data.data.store_id);
                localStorage.setItem('storename', data.data.storename);

                $state.go('home');
            } else {
                $scope.invalidLogin = true;
                $scope.dataLoading = false;
            }

        });
    }

}]).controller('HomeController', ['$scope', 'StoreServices', '$state', function ($scope, StoreServices, $state) {
    var store_id = localStorage.getItem('store_id');

    StoreServices.getStoreDetails(store_id).then(function (data) {
        $scope.store = data.data;
    });

    StoreServices.getActiveCustomers(store_id).then(function (data) {
        $scope.customers = data.data;
    });

    $scope.getTotal = function (value) {
        var total = 0;
        var itemprice = 0;
        for (var a = 0; a < value.length; a++) {
            itemprice = parseInt(value[a].price) * parseInt(value[a].quantity);
            total = total + itemprice;
        }
        return total;
        //console.log(value.length)
        //return $scope.value.length();
    }

    $scope.logout = function () {
        localStorage.clear();
        $state.go('login');
    }

}]).controller('AddStoreController', ['$scope', 'StoreServices', '$state','$timeout','$upload',function ($scope, StoreServices, $state, $timeout, $upload) {
    localStorage.clear();
    var min = 10000;
    var max = 99999;
    
    $scope.addStore = function (store) {
        $scope.store.store_id = Math.floor(Math.random() * (max - min + 1)) + min;
        StoreServices.addStore(store);
        StoreServices.getStoreDetails(store.store_id).then(function (data) {
            $scope.store = data.data;
            localStorage.setItem('store_id', data.data.store_id);
            localStorage.setItem('storename', data.data.storename);
            $state.go('confirmstore');
        });

    }

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
                    $scope.store.photo = 'modules/uploads/upload/' + JSON.parse(response.data);
                    console.log($scope.store.photo);
                });

            });
        }
    }

}]).controller('ViewStoreController', ['$scope', 'StoreServices', '$state', function ($scope, StoreServices, $state) {
    var storeid = localStorage.getItem('store_id');

    StoreServices.getStoreDetails(storeid).then(function (data) {
        $scope.store = data.data;
    });

    $scope.editStore = function (store) {
        $state.go('editstore');
    }

    $scope.deleteStore = function (store) {
        if (confirm("Are you sure to delete your store: " + $scope.store.storename) == true) {
            StoreServices.deleteStore(storeid).then(function (data) {
                $state.go('login');
            })
        }
    }

}]).controller('AddStoreConfirmController', ['$scope', function ($scope) {
    $scope.store_id = localStorage.getItem('store_id');
}]).controller('EditStoreController', ['$scope', 'StoreServices', '$state', function ($scope, StoreServices, $state) {
    var storeid = localStorage.getItem('store_id');

    StoreServices.getStoreDetails(storeid).then(function (data) {
        $scope.store = data.data;
    });

    $scope.updateStore = function (store) {
        StoreServices.updateStore(storeid, store).then(function (data) {
            $state.go('viewstore');
        })
    }

}])