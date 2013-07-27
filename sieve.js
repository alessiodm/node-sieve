exports.eratosthenes = function (n) {
	var primes = new Array(n + 1);
	for (var i = 0; i < primes.length; i++){
		primes[i] = true;
	}

	for (var i = 2; i <= Math.sqrt(primes.length); i++){
		if (primes[i] === true){
			for (var j = i*i; j <= n; j += i){
				primes[j] = false;
			}
		}
	}

	var ret = new Array();
	for (var i = 2; i < primes.length; i++){
		if (primes[i] === true){
			ret.push(i);
		}
	}
	
	return ret;
};
