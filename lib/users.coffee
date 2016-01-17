

CRUD = require('polymorphic-crud-resource')


module.exports = (app, db, authMWarez) ->

  CRUDinstance = CRUD db.models.user, [
    name: 'groups'
    model: db.models.usergroup_mship
    fk: 'user_id'
  ]

  # CRUD routes
  CRUDinstance.initApp app,
    'create': authMWarez
    'update': authMWarez
    'delete': authMWarez

  return CRUDinstance
