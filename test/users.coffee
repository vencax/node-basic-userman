should = require 'should'
request = require 'request'

module.exports = (g)->

  addr = g.baseurl + '/users'

  it "must NOT create sauron (no auth header)", (done)->
    g.sauron =
      username: 'sauron'
      name: 'Wizard Sauron'
      email: 'sauron@mordor.nl'
      password: 'fkdjsfjs'
      gid: g.wizards.id
      groups: [group_id: g.dwarfs.id]

    request
      url: addr
      body: g.sauron
      json: true
      method: 'post'
    , (err, res, body) ->
      return done(err) if err
      res.statusCode.should.eql 401
      body.should.eql 'not authorized'
      done()

  it "must NOT create sauron (not admin)", (done)->
    token = g.getToken
      gid: 1234
      groups: []

    request
      url: addr
      body: g.sauron
      json: true
      method: 'post'
      headers:
        'Authorization': "Bearer #{token}"
    , (err, res, body) ->
      return done(err) if err
      res.statusCode.should.eql 401
      body.should.eql 'insufficient permissions'
      done()

  it "must create sauron", (done)->
    token = g.getToken
      gid: 0
      groups: []

    request
      url: addr
      body: g.sauron
      json: true
      method: 'post'
      headers:
        'Authorization': "Bearer #{token}"
    , (err, res, body) ->
      return done(err) if err
      console.log body
      res.statusCode.should.eql 201
      body.id.should.be.ok
      body.name.should.eql g.sauron.name
      g.sauron.id = body.id
      done()

  it "must create an regular", (done)->
    g.saruman =
      username: 'saruman'
      name: 'Wizard Saruman'
      email: 'saruman@mordor.nl'
      password: 'superSecret'
      gid: g.wizards.id

    g.api.UserManip.create g.saruman, (err, user)->
      return done(err) if err
      done()
