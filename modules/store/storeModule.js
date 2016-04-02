'use strict'

angular.module('eatsarap.store',['eatsarap.store.controllers','eatsarap.store.services']);

angular.module('eatsarap.store').config(['$stateProvider','$locationProvider',function($stateProvider,$locationProvider){
    $stateProvider.state('login',{
        url: '/login',
        controller: 'LoginController',
        templateUrl: 'modules/store/views/store-login.html'
    }).state('home',{
        url: '/home',
        controller: 'HomeController',
        templateUrl: 'modules/store/views/store-home.html'
    }).state('addstore',{
        url: '/addstore',
        controller: 'AddStoreController',
        templateUrl: 'modules/store/views/store-add.html'
    }).state('viewstore',{
        url: '/viewstore',
        controller: 'ViewStoreController',
        templateUrl: 'modules/store/views/store-view.html'
    }).state('confirmstore',{
        url: '/confirmstore',
        controller: 'AddStoreConfirmController',
        templateUrl: 'modules/store/views/store-add-confirm.html'
    }).state('editstore',{
        url: '/editstore',
        controller: 'EditStoreController',
        templateUrl: 'modules/store/views/store-edit.html'
    });
}]);