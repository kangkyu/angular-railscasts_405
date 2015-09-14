app = angular.module("Raffler", ['ngResource'])

app.factory "Entry", ["$resource", ($resource) ->
  $resource("/entries/:id.json", {id: "@id"}, {update: {method: "PUT"}})
]

app.controller 'RaffleCtrl', ["$scope", "Entry", ($scope, Entry) ->

  $scope.entries = Entry.query()

  $scope.addEntry = ->
    entry = Entry.save($scope.newEntry)
    $scope.entries.push(entry)
    $scope.newEntry = {}

  $scope.drawWinner = ->
    pool = []
    angular.forEach $scope.entries, (entry) ->
      pool.push(entry) if !entry.winner
    if pool.length > 0
      entry = pool[Math.floor(Math.random() * pool.length)]
      entry.winner = true
      entry.$update()
      $scope.lastWinner = entry

  $scope.clearWinner = ->
    angular.forEach $scope.entries, (entry) ->
      entry.winner = false
      entry.$update()
]