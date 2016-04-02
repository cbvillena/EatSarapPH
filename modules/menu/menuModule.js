'use strict'

angular.module('eatsarap.menu',['eatsarap.menu.controllers','eatsarap.menu.services']);

angular.module('eatsarap.menu').config(['$stateProvider','$locationProvider',function($stateProvider,$locationProvider){
    $stateProvider.state('menulist',{
        url: '/menu/list',
        controller: 'ListMenuController',
        templateUrl: 'modules/menu/views/menu-list.html'
    }).state('addmenu',{
        url: '/menu/add',
        controller: 'AddMenuController',
        templateUrl: 'modules/menu/views/menu-add.html'
    }).state('editmenu',{
        url: '/menu/edit/:itemid',
        controller: 'EditMenuController',
        templateUrl: 'modules/menu/views/menu-edit.html'
    }).state('viewmenu',{
        url: '/menu/view/:itemid',
        controller: 'ViewMenuController',
        templateUrl: 'modules/menu/views/menu-view.html'
    })
}]);