angular.module 'Timesheet'
.factory 'Project', ['$http', ($http) ->
  all: (params) ->
    $http.get(ApiBasePath + r(v1_projects_path), {params: params})
]
