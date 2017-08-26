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

    var getBinaryPublicKeyFromHexPrivateKey = function(hexPrivateKey, shouldEncode){

        var ecparams = all_crypto.ecurve.getCurveByName('secp256r1');
        var curvePt = ecparams.G.multiply(all_crypto.BigInteger.fromBuffer(hexstring2ab(hexPrivateKey)));

        return curvePt.getEncoded(shouldEncode);
    };


    var getHash = function(item) {
        var ProgramHexString = all_crypto.cryptojs.enc.Hex.parse(item);
        var ProgramSha256 = all_crypto.cryptojs.SHA256(ProgramHexString);
        return all_crypto.cryptojs.RIPEMD160(ProgramSha256).toString();
    };

    var createSignatureScript = function(binaryPublicKey) {
        return "21" + binaryPublicKey.toString('hex') + "ac";
    };

    var toAddress = function(programHash){

        var data = new Uint8Array(1 + programHash.length);
        data.set([23]);
        data.set(programHash, 1);

        var ProgramHexString = all_crypto.cryptojs.enc.Hex.parse(ab2hexstring(data));
        var ProgramSha256 = all_crypto.cryptojs.SHA256(ProgramHexString);
        var ProgramSha256_2 = all_crypto.cryptojs.SHA256(ProgramSha256);
        var ProgramSha256Buffer = hexstring2ab(ProgramSha256_2.toString());

        var datas = new Uint8Array(1 + programHash.length + 4);
        datas.set(data);
        datas.set(ProgramSha256Buffer.slice(0, 4), 21);

        return all_crypto.base58.encode(datas);
    };

    var verifyPublicKeyEncoded = function(binaryPublicKey){
        var publicKeyArray = hexstring2ab( binaryPublicKey);
        if ( publicKeyArray[0] !== 0x02 && publicKeyArray[0] !== 0x03 ) {
            return false;
        }

        var ecparams = all_crypto.ecurve.getCurveByName('secp256r1');
        var curvePt = all_crypto.ecurve.Point.decodeFrom(ecparams,new all_crypto.buffer.Buffer(binaryPublicKey,"hex"));
        var curvePtX = curvePt.affineX.toBuffer(32);
        var curvePtY = curvePt.affineY.toBuffer(32);

        if ( publicKeyArray[0] === 0x02 && curvePtY[31] % 2 === 0 ) {
            return true;
        }

        return publicKeyArray[0] === 0x03 && curvePtY[31] % 2 === 1;
    };

    var getAccountFromBinaryPrivateKey = function (binaryPrivateKey) {
        try {

            var hexPrivateKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey));
            return getAccountFromHexPrivateKey(hexPrivateKey);

        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getAccountFromHexPrivateKey = function (hexPrivateKey) {
        try {

            if (hexPrivateKey.length !== 64) {
                return -1;
            }

            var binaryPrivateKey = _elm_lang$core$Native_List.fromArray(hexstring2ab(hexPrivateKey));

            var binaryPublicKey = getBinaryPublicKeyFromHexPrivateKey(hexPrivateKey, true);

            var hexPublicKey = ab2hexstring(binaryPublicKey);

            var publicKeyHash = getHash(binaryPublicKey.toString('hex'));

            var script = createSignatureScript(binaryPublicKey);

            var programHash = getHash(script);

            var address = toAddress(hexstring2ab(programHash.toString()));

            return {
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: hexPrivateKey
                , binaryPublicKey: _elm_lang$core$Native_List.fromArray(binaryPublicKey)
                , hexPublicKey: hexPublicKey
                , publicKeyHash: publicKeyHash
                , programHash: programHash
                , address: address
            };
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getPublicKeyEncoded = function(hexPublicKey){
        var publicKeyArray = hexstring2ab(hexPublicKey);
        if ( publicKeyArray[64] % 2 === 1 ) {
            return "03" + ab2hexstring(publicKeyArray.slice(1, 33));
        } else {
            return "02" + ab2hexstring(publicKeyArray.slice(1, 33));
        }
    };

    var getAccountFromBinaryPublicKey = function (binaryPublicKey) {
        try {

            var encodedPublicKey = getPublicKeyEncoded(ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey)));

            if (!verifyPublicKeyEncoded(encodedPublicKey)) {
                // verify failed.
                return -1
            }

            var binaryPrivateKey = _elm_lang$core$Native_List.fromArray([]);

            var hexPublicKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey));

            var publicKeyHash = getHash(hexPublicKey);

            var script = createSignatureScript(encodedPublicKey);

            var programHash = getHash(script);

            var address = toAddress(hexstring2ab(programHash.toString()));

            return {
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: ""
                , binaryPublicKey: binaryPublicKey
                , hexPublicKey: hexPublicKey
                , publicKeyHash: publicKeyHash
                , programHash: programHash
                , address: address
            };
        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getAccountFromHexPublicKey = function (hexPublicKey) {
        try {

            var binaryPublicKey = hexstring2ab(hexPublicKey);

            var encodedPublicKey = getPublicKeyEncoded(hexPublicKey);

            if (!verifyPublicKeyEncoded(encodedPublicKey)) {
                // verify failed.
                return -1
            }

            var binaryPrivateKey = _elm_lang$core$Native_List.fromArray([]);

            var publicKeyHash = getHash(hexPublicKey);

            var script = createSignatureScript(encodedPublicKey);

            var programHash = getHash(script);

            var address = toAddress(hexstring2ab(programHash.toString()));

            return {
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: ""
                , binaryPublicKey: _elm_lang$core$Native_List.fromArray(binaryPublicKey)
                , hexPublicKey: hexPublicKey
                , publicKeyHash: publicKeyHash
                , programHash: programHash
                , address: address
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
        getAccountFromBinaryPrivateKey : getAccountFromBinaryPrivateKey,
        getAccountFromHexPrivateKey    : getAccountFromHexPrivateKey,
        getAccountFromBinaryPublicKey  : getAccountFromBinaryPublicKey,
        getAccountFromHexPublicKey     : getAccountFromHexPublicKey
    }

}());