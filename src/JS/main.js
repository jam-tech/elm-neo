

var buffer = require('buffer');

var secureRandom = require('secure-random');

const BASE58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
var base58   = require('base-x')(BASE58);

var wif = require('wif');



exports.secureRandom = secureRandom;
exports.base58       = base58;
exports.wif          = wif;
exports.buffer       = buffer;