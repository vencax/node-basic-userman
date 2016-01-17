

CRUD = require('polymorphic-crud-resource')


module.exports = (app, db, authMWarez) ->

  CRUDinstance = CRUD db.models.group

  # CRUD routes
  CRUDinstance.initApp app,
    'create': authMWarez
    'update': authMWarez
    'delete': authMWarez

  return CRUDinstance
