
var secureRandom = require('secure-random');

const BASE58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
var base58   = require('base-x')(BASE58);



exports.secureRandom = secureRandom;
exports.base58       = base58;
