express = require('express')
bodyParser = require('body-parser')
cors = require('cors')
expressJwt = require('express-jwt')

ADMINS_GID = parseInt(process.env.ADMINS_GID) || 1


ensureAdmin = (req, res, next)->
  groups = req.user.groups || []
  if req.user.gid == ADMINS_GID || groups.indexOf(ADMINS_GID) >= 0
    return next()
  return res.status(401).send('insufficient permissions')


module.exports = (db) ->

  app = express()
  if process.env.USE_CORS
    app.use(require('cors')({maxAge: 86400}))
  app.use(expressJwt(secret: process.env.SERVER_SECRET))
  app.use(require('body-parser').json())

  usersapp = express()
  Users = require('./lib/users')(usersapp, db, [ensureAdmin])
  app.use "/users", usersapp

  groupsapp = express()
  Groups = require('./lib/groups')(groupsapp, db, [ensureAdmin])
  app.use "/groups", groupsapp

  app.use (err, req, res, next) ->
    if err.name and err.name == 'UnauthorizedError'
      return res.status(401).send(err.message || 'not authorized')
    next(err)

  app: app
  UserManip: Users
  GroupManip: Groups
