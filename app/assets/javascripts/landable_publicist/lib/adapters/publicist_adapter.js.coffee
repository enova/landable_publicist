#= require ./rest_adapter

Publicist.PublicistAdapter = Publicist.RESTAdapter.extend
  namespace: 'api'

# assignment by alias
Publicist.TokenAdapter = Publicist.PublicistAdapter