should = require 'should'
request = require 'request'

module.exports = (g) ->

  addr = g.baseurl + '/groups'

  g.wizards =
    name: 'wizards'

  it "must NOT create wizards group (no auth header)", (done)->
    request
      url: addr
      body: g.wizards
      json: true
      method: 'post'
    , (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 401
      body.should.eql 'not authorized'
      done()

  it "must NOT create wizards group (user not among admins)", (done)->
    token = g.getToken
      gid: 1234
      groups: []

    request
      url: addr
      body: g.wizards
      json: true
      method: 'post'
      headers:
        'Authorization': "Bearer #{token}"
    , (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 401
      body.should.eql 'insufficient permissions'
      done()

  it "must create wizards group", (done)->
    token = g.getToken
      gid: 1234
      groups: [0]

    request
      url: addr
      body: g.wizards
      json: true
      method: 'post'
      headers:
        'Authorization': "Bearer #{token}"
    , (err, res, body) ->
      return done err if err
      res.statusCode.should.eql 201
      body.id.should.be.ok
      body.name.should.eql g.wizards.name
      g.wizards.id = body.id
      done()

  it "must create dwarfs group through direct code call", (done)->
    g.api.GroupManip.create {name: 'dwarfs'}, (err, dwarfs)->
      return done err if err
      g.dwarfs = dwarfs
      done()
