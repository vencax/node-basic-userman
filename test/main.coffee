
should = require('should')
http = require('http')
fs = require('fs')
jwt = require 'jsonwebtoken'
bodyParser = require('body-parser')

process.env.SERVER_SECRET = 'fhdsakjhfkjal'
process.env.ADMINS_GID = '12'
# process.env.DATABASE_URL = 'sqlite://db.sqlite'
port = process.env.PORT || 3333
g =
  sentemails: []

sendMail = (mail, cb) ->
  g.sentemails.push mail
  cb()

g.getToken = (user) ->
  return jwt.sign(
    JSON.parse(JSON.stringify(user)),
    process.env.SERVER_SECRET,
    expiresIn: 30000
  )

# entry ...
describe "app", () ->

  apiMod = require(__dirname + '/../index')
  dbMod = require(__dirname + '/../db')

  before (done) ->
    this.timeout(5000)

    dbMod (err, db) ->
      return done(err) if err

      g.api = apiMod(db, sendMail)

      g.server = g.api.app.listen port, (err) ->
        return done(err) if err
        setTimeout () ->
          done()
        , 1500

  after (done) ->
    g.server.close()
    done()

  it "should exist", (done) ->
    should.exist g.api.app
    done()

  # run the rest of tests
  g.baseurl = "http://localhost:#{port}"

  submodules = [
    './groups'
    './users'
  ]
  for i in submodules
    E = require(i)
    E(g)
