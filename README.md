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
```

###ng-controller, ng-repeat
```
app = angular.module("Raffler", [])

app.controller('RaffleCtrl', ($scope) ->
  $scope.entries = [
    {name: "Larry"}
    {name: "Curly"}
    {name: "Moe"}
  ]
)

<html ng-app="Raffler">

<div ng-controller="RaffleCtrl">
  
  <ul>
    <li ng-repeat="entry in entries">
      {{entry.name}}
    </li>
  </ul>
</div>
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

###ng-click, ng-show
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
+  $scope.lastWinner = entry

<li ng-repeat="entry in entries">
  {{entry.name}}
  <span ng-show="entry.winner" ng-class="{highlight: entry == lastWinner}" class="winner">WINNER</span>
</li>

.highlight {
  font-weight: bold;
  color: Red;
}
```

###random pick out of those didn't win yet
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

```
rails g resource entry name
```

for `respond_with` and `respond_to` on controller class, add gem `responders`. and use strong parameters for create & update action  

```
gem 'responders', '~> 2.0'
```

And there's CORS, CSRF, skip authenticity token for now. (localhost is not a different uri)

```
class EntriesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    respond_with Entry.all
  end

  def show
    respond_with Entry.find(params[:id])
  end

  def create
    respond_with Entry.create(entry_params)
  end

  def update
    respond_with Entry.update(params[:id], entry_params)
  end

  def destroy
    respond_with Entry.destroy(params[:id])
  end

  private
  def entry_params
    params.require("entry").permit("name")
  end
end
```

###ng-resource
```
//= require angular-resource

app = angular.module("Raffler", ['ngResource'])

app.controller('RaffleCtrl', ["$scope", "$resource", ($scope, $resource) ->
  Entry = $resource("/entries/:id.json", {id: "@id"}, {update: {method: "PUT"}})
  $scope.entries = Entry.query()

  $scope.addEntry = ->
    entry = Entry.save($scope.newEntry)
    $scope.entries.push(entry)
    $scope.newEntry = {}
```

now adding entry persists. However, I had to add `.json` behind urls `/entries.json` works whereas `/entries` doesn't work


and winner status update
```
  $scope.drawWinner = ->
    pool = []
    angular.forEach $scope.entries, (entry) ->
      pool.push(entry) if !entry.winner
    if pool.length > 0
      entry = pool[Math.floor(Math.random() * pool.length)]
      entry.winner = true
+      entry.$update()
      $scope.lastWinner = entry

-    params.require("entry").permit("name")
+    params.require("entry").permit("name", "winner")
```

use `Entry` as service like...

```
app.factory "Entry", ["$resource", ($resource) ->
  $resource("/entries/:id.json", {id: "@id"}, {update: {method: "PUT"}})
]

app.controller 'RaffleCtrl', ["$scope", "Entry", ($scope, Entry) ->
```

Railscasts Source Code [https://github.com/railscasts/405-angularjs](https://github.com/railscasts/405-angularjs)
