'use strict'

angular.module('eatsarap',['ui.router','angular.filter','angularFileUpload','eatsarap.controllers','eatsarap.services','eatsarap.store','eatsarap.menu']);

angular.module('eatsarap').run(['$state',function($state){
    $state.go('login');
}]);
