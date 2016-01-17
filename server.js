require('coffee-script/register')

var port = process.env.PORT || 8100
var host = process.env.HOST || '0.0.0.0'

var DBMod = require('./db')
var AppMod = require('./index')

DBMod(function(err, db) {
  if(err) { return console.log(err) }

  var api = AppMod(db)
  api.app.listen(port, host, function() {
    console.log('radagast rides his pig crew on ' + port)
  })
})
