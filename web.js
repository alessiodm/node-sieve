var express = require('express');
var sieve = require('./sieve.js');

var app = express.createServer(express.logger());

app.get('/:num?', function(request, response) {
  var range = 100 + Math.floor(Math.random() * 100);
  var num = parseInt(request.params.num);
  if (typeof num === 'number' && num !== NaN && num > 0 && num < 10000000){
  	range = num;
  }
  response.send(sieve.eratosthenes(range));
});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});
