var ab2hexstring = function (arr) {
    var result = "";
    for (var i = 0; i < arr.length; i++) {
        var str = arr[i].toString(16);
        str = str.length === 0 ? "00" :
            str.length === 1 ? "0" + str :
                str;
        result += str;
    }
    return result;
};

var hexstring2ab = function (str) {
    var result = [];
    while (str.length >= 2) {
        result.push(parseInt(str.substring(0, 2), 16));
        str = str.substring(2, str.length);
    }

    return result;
};

var _kingsleyh$elm_neo$Native_Neo = (function () {

    var generateBinaryPrivateKey = function () {
        try {
            return _elm_lang$core$Native_List.fromArray(all_crypto.secureRandom.randomUint8Array(32));
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var generateHexPrivateKey = function () {
        try {
            return ab2hexstring(all_crypto.secureRandom.randomUint8Array(32));
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getWIFFromBinaryPrivateKey = function (binaryPrivateKey) {
        try {
            var hexKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey));
            return all_crypto.wif.encode(128, new all_crypto.buffer.Buffer(hexKey, 'hex'), true);
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getWIFFromHexPrivateKey = function (hexPrivateKey) {
        try {
            return all_crypto.wif.encode(128, new all_crypto.buffer.Buffer(hexPrivateKey, 'hex'), true);
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getBinaryPrivateKeyFromWIF = function (wif) {
        try {
            return _elm_lang$core$Native_List.fromArray(hexstring2ab(getHexPrivateKeyFromWIF(wif)));
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getHexPrivateKeyFromWIF = function (wif) {
        try {
            var data = all_crypto.base58.decode(wif);

            if (data.length !== 38 || data[0] !== 0x80 || data[33] !== 0x01) {
                // basic encoding errors
                return -1;
            }

            var dataHexString = all_crypto.cryptojs.enc.Hex.parse(ab2hexstring(data.slice(0, data.length - 4)));
            var dataSha256 = all_crypto.cryptojs.SHA256(dataHexString);
            var dataSha256_2 = all_crypto.cryptojs.SHA256(dataSha256);
            var dataSha256Buffer = hexstring2ab(dataSha256_2.toString());

            if (ab2hexstring(dataSha256Buffer.slice(0, 4)) !== ab2hexstring(data.slice(data.length - 4, data.length))) {
                //wif verify failed.
                return -2;
            }

            return ab2hexstring(data.slice(1, 33));
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getAccountFromBinaryPrivateKey = function (binaryPrivateKey) {
        try {
            return {
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey))
                , binaryPublicKey: _elm_lang$core$Native_List.fromArray([])
                , hexPublicKey: ""
                , publicKeyHash: ""
                , programHash: ""
                , address: ""
            };
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    return {
        generateBinaryPrivateKey       : generateBinaryPrivateKey(),
        generateHexPrivateKey          : generateHexPrivateKey(),
        getWIFFromBinaryPrivateKey     : getWIFFromBinaryPrivateKey,
        getWIFFromHexPrivateKey        : getWIFFromHexPrivateKey,
        getBinaryPrivateKeyFromWIF     : getBinaryPrivateKeyFromWIF,
        getHexPrivateKeyFromWIF        : getHexPrivateKeyFromWIF,
        getAccountFromBinaryPrivateKey : getAccountFromBinaryPrivateKey
    }

}());