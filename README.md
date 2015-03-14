```
rails new raffler
cd raffler
rails g controller raffle index
```

### angularjs-rails gem
```
+ root "raffle#index"

+ gem 'angularjs-rails'

bundle install
```

```
+ //= require angular
- //= require jquery
- //= require jquery_ujs

```

###ng-model
```
<form>
  <input type="text" ng-model="newEntry.name">
</form> 
{{newEntry.name}}

<html ng-app>

<div ng-controller="RaffleCtrl">
  <form>
  ...
  </form>
</div>

<html ng-app="Raffler">
```

```
app = angular.module("Raffler", [])

app.controller('RaffleCtrl', ($scope) ->
  $scope.entries = [
    {name: "Larry"}
    {name: "Curly"}
    {name: "Moe"}
  ]
)

<ul>
  <li ng-repeat="entry in entries">
    {{entry.name}}
  </li>
</ul>
```

###ng-submit
```
<form ng-submit="addEntry()">
  <input type="text" ng-model="newEntry.name">
  <input type="submit" value="Add">
</form>

  $scope.addEntry = ->
    $scope.entries.push($scope.newEntry)
    $scope.newEntry = {}
```

###ng-click
```
<button ng-click="drawWinner()">Draw Winner</button>

$scope.drawWinner = ->
  entry = $scope.entries[Math.floor(Math.random() * $scope.entries.length)]
  entry.winner = true

<li ng-repeat="entry in entries">
  {{entry.name}}
  <span ng-show="entry.winner" class="winner">WINNER</span>
</li>
```

###ng-class
```
$scope.drawWinner = ->
  entry = $scope.entries[Math.floor(Math.random() * $scope.entries.length)]
  entry.winner = true
  $scope.lastWinner = entry

<li ng-repeat="entry in entries">
  {{entry.name}}
  <span ng-show="entry.winner" ng-class="{highlight: entry == lastWinner}" class="winner">WINNER</span>
</li>
```

###random pick out of didn't win yet
```
  $scope.drawWinner = ->
    pool = []
    angular.forEach $scope.entries, (entry) ->
      pool.push(entry) if !entry.winner
    if pool.length > 0
      entry = pool[Math.floor(Math.random() * pool.length)]
      entry.winner = true
      $scope.lastWinner = entry
```

#### didn't work after this... `respond_with` from `entries_controller.rb`
```
rails g resource entry name
```