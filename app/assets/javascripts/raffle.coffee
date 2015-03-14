# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

app = angular.module("Raffler", ["ngResource"])

app.controller('RaffleCtrl', ($scope, $resource) ->
  Entry = $resource("/entries/:id", {id: "@id"},
  {
   get:    {method: 'GET'},
   save:   {method: 'POST'},
   query:  {method: 'GET', isArray: true},
   remove: {method: 'DELETE'},
   delete: {method: 'DELETE'}
   update: {method: "PUT"}
  })
  $scope.entries = Entry.query()

  $scope.addEntry = ->
    $scope.entries.push($scope.newEntry)
    $scope.newEntry = {}

  $scope.drawWinner = ->
    entry = $scope.entries[Math.floor(Math.random() * $scope.entries.length)]
    entry.winner = true
    $scope.lastWinner = entry
)