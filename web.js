var http = require('http');
var sieve = require('./sieve.js');

var port = process.env.PORT || 5000;

http.createServer(function (req, res) {
  var range = 100000 + Math.floor(Math.random() * 1000);

  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(sieve.eratosthenes(range).join(", "));
}).listen(port);

console.log('Server running at port:' + port);
