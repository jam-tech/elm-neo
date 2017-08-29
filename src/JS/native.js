
//import Native.Scheduler //

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

    var generateBinaryPrivateKey = _elm_lang$core$Native_Scheduler.nativeBinding(function (callback) {
        callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_List.fromArray(all_crypto.secureRandom.randomUint8Array(32))));
    });

    var generateHexPrivateKey = _elm_lang$core$Native_Scheduler.nativeBinding(function (callback) {
        callback(_elm_lang$core$Native_Scheduler.succeed(ab2hexstring(all_crypto.secureRandom.randomUint8Array(32))));
    });

    var getWIFFromBinaryPrivateKey = function (binaryPrivateKey) {
        try {
            var hexPrivateKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey));
            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied BinaryPrivateKey: " + _elm_lang$core$Native_List.toArray(binaryPrivateKey) + " because it is not a valid BinaryPrivateKey");
            }
            return _elm_lang$core$Result$Ok(all_crypto.wif.encode(128, new all_crypto.buffer.Buffer(hexPrivateKey, 'hex'), true));
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getWIFFromHexPrivateKey = function (hexPrivateKey) {
        try {
            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied HexPrivateKey: " + hexPrivateKey + " because it is not a valid HexPrivateKey");
            }
            return _elm_lang$core$Result$Ok(all_crypto.wif.encode(128, new all_crypto.buffer.Buffer(hexPrivateKey, 'hex'), true));
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getBinaryPrivateKeyFromWIF = function (wif) {
        try {
            var hexPrivateKey = getHexPrivateKeyFromWIFInternal(wif);

            if (hexPrivateKey === -1) {
                return _elm_lang$core$Result$Err("Error the supplied WIF: " + wif + " is not encoded as base58");
            } else if (hexPrivateKey === -2) {
                return _elm_lang$core$Result$Err("Error the supplied WIF: " + wif + " is invalid");
            } else if (hexPrivateKey === -3) {
                return _elm_lang$core$Result$Err("Oops something unexpected went wrong");
            }

            return _elm_lang$core$Result$Ok(_elm_lang$core$Native_List.fromArray(hexstring2ab(hexPrivateKey)));
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getHexPrivateKeyFromWIF = function (wif) {
        try {
            var hexPrivateKey = getHexPrivateKeyFromWIFInternal(wif);

            if (hexPrivateKey === -1) {
                return _elm_lang$core$Result$Err("Error the supplied WIF: " + wif + " is not encoded as base58");
            } else if (hexPrivateKey === -2) {
                return _elm_lang$core$Result$Err("Error the supplied WIF: " + wif + " is invalid");
            } else if (hexPrivateKey === -3) {
                return _elm_lang$core$Result$Err("Oops something unexpected went wrong");
            }

            return _elm_lang$core$Result$Ok(hexPrivateKey);
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getHexPrivateKeyFromWIFInternal = function (wif) {
        try {
            try {
                var data = all_crypto.base58.decode(wif);
            } catch (e){
                return -1;
            }

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
            return -3;
        }
    };

    var getBinaryPublicKeyFromHexPrivateKeyInternal = function (hexPrivateKey, shouldEncode) {
        try {
            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return -1;
            }

            var ecparams = all_crypto.ecurve.getCurveByName('secp256r1');
            var curvePt = ecparams.G.multiply(all_crypto.BigInteger.fromBuffer(hexstring2ab(hexPrivateKey)));

            return _elm_lang$core$Native_List.fromArray(curvePt.getEncoded(shouldEncode));
        } catch (e) {
            return -2;
        }
    };


    var getBinaryPublicKeyFromHexPrivateKey = function (hexPrivateKey, shouldEncode) {
        try {
            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied HexPrivateKey: " + hexPrivateKey + " because it is not a valid HexPrivateKey");
            }

            var ecparams = all_crypto.ecurve.getCurveByName('secp256r1');
            var curvePt = ecparams.G.multiply(all_crypto.BigInteger.fromBuffer(hexstring2ab(hexPrivateKey)));

            return _elm_lang$core$Result$Ok(_elm_lang$core$Native_List.fromArray(curvePt.getEncoded(shouldEncode)));
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getBinaryPublicKeyFromBinaryPrivateKey = function (binaryPrivateKey, shouldEncode) {
        try {
            var hexPrivateKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey));
            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return _elm_lang$core$Result$Err("Error the supplied BinaryPrivateKey: " + _elm_lang$core$Native_List.toArray(binaryPrivateKey) + " is not a valid BinaryPrivateKey");
            }

            var binaryPublicKey = getBinaryPublicKeyFromHexPrivateKeyInternal(hexPrivateKey, shouldEncode);

            if(binaryPublicKey === -1){
                _elm_lang$core$Result$Err("Error the supplied BinaryPrivateKey " + _elm_lang$core$Native_List.toArray(binaryPrivateKey) + " is invalid");
            } else if (binaryPublicKey === -2){
                _elm_lang$core$Result$Err("Error unexpected went wrong");
            }

            return _elm_lang$core$Result$Ok(binaryPublicKey);
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getHexPublicKeyFromBinaryPrivateKey = function (binaryPrivateKey, shouldEncode) {
        try {
            var hexPrivateKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey));
            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return _elm_lang$core$Result$Err("Error the supplied BinaryPrivateKey: " + _elm_lang$core$Native_List.toArray(binaryPrivateKey) + " is not a valid BinaryPrivateKey");
            }

            var binaryPublicKey = getBinaryPublicKeyFromHexPrivateKeyInternal(hexPrivateKey, shouldEncode);

            if(binaryPublicKey === -1){
                _elm_lang$core$Result$Err("Error the supplied BinaryPrivateKey " + _elm_lang$core$Native_List.toArray(binaryPrivateKey) + " is invalid");
            } else if (binaryPublicKey === -2){
                _elm_lang$core$Result$Err("Error unexpected went wrong");
            }

            return _elm_lang$core$Result$Ok(ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey)));
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getHexPublicKeyFromHexPrivateKey = function (hexPrivateKey, shouldEncode) {
        try {

            if(!isValidHexPrivateKeyInternal(hexPrivateKey)){
                return _elm_lang$core$Result$Err("Error the supplied HexPrivateKey: " + hexPrivateKey + " is not a valid HexPrivateKey");
            }

            var binaryPublicKey = getBinaryPublicKeyFromHexPrivateKeyInternal(hexPrivateKey, shouldEncode);

            if(binaryPublicKey === -1){
                _elm_lang$core$Result$Err("Error the supplied HexPrivateKey " + hexPrivateKey + " is invalid");
            } else if (binaryPublicKey === -2){
                _elm_lang$core$Result$Err("Error unexpected went wrong");
            }

            return _elm_lang$core$Result$Ok(ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey)));
        } catch (e) {
            return "something went wrong: " + e;
        }
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

    var isValidHexPublicKey = function(hexPublicKey){
        var binaryPublicKey = hexstring2ab(hexPublicKey);
        return isValidBinaryPublicKeyInternal(binaryPublicKey);
    };

    var isValidBinaryPublicKey = function(binaryPublicKey){
        return !!isValidBinaryPublicKeyInternal(_elm_lang$core$Native_List.toArray(binaryPublicKey));
    };

    var isValidBinaryPublicKeyInternal = function(binaryPublicKey){
        return !(binaryPublicKey[0] !== 0x02 && binaryPublicKey[0] !== 0x03);
    };

    var isValidHexPrivateKeyInternal = function(hexPrivateKey){
        return hexPrivateKey.length === 64;
    };


    var verifyPublicKeyEncoded = function(hexPublicKey){
        var binaryPublicKey = hexstring2ab(hexPublicKey);
        if (!isValidBinaryPublicKeyInternal(binaryPublicKey)) {
            return false;
        }

        var ecparams = all_crypto.ecurve.getCurveByName('secp256r1');
        var curvePt = all_crypto.ecurve.Point.decodeFrom(ecparams,new all_crypto.buffer.Buffer(hexPublicKey,"hex"));
        var curvePtX = curvePt.affineX.toBuffer(32);
        var curvePtY = curvePt.affineY.toBuffer(32);

        if ( binaryPublicKey[0] === 0x02 && curvePtY[31] % 2 === 0 ) {
            return true;
        }

        return binaryPublicKey[0] === 0x03 && curvePtY[31] % 2 === 1;
    };

    var getAccountFromBinaryPrivateKey = function (binaryPrivateKey) {
        try {

            var hexPrivateKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPrivateKey));

            if (!isValidHexPrivateKeyInternal(hexPrivateKey)) {
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied BinaryPrivateKey: " + _elm_lang$core$Native_List.toArray(binaryPrivateKey) + " because it is not a valid BinaryPrivateKey");
            }

            return getAccountFromHexPrivateKey(hexPrivateKey);

        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getAccountFromHexPrivateKey = function (hexPrivateKey) {
        try {

            if (!isValidHexPrivateKeyInternal(hexPrivateKey)) {
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied HexPrivateKey: " + hexPrivateKey + " because it is not a valid HexPrivateKey");
            }

            var binaryPrivateKey = _elm_lang$core$Native_List.fromArray(hexstring2ab(hexPrivateKey));

            var binaryPublicKey = getBinaryPublicKeyFromHexPrivateKeyInternal(hexPrivateKey, true);

            var hexPublicKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey));

            var publicKeyHash = getHash(hexPublicKey);

            var script = createSignatureScript(hexPublicKey);

            var programHash = getHash(script);

            var address = toAddress(hexstring2ab(programHash.toString()));

            return _elm_lang$core$Result$Ok({
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: hexPrivateKey
                , binaryPublicKey: binaryPublicKey
                , hexPublicKey: hexPublicKey
                , publicKeyHash: publicKeyHash
                , programHash: programHash
                , address: address
            });
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
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

            if(!isValidBinaryPublicKeyInternal(_elm_lang$core$Native_List.toArray(binaryPublicKey))){
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied BinaryPublicKey: " + _elm_lang$core$Native_List.toArray(binaryPublicKey) + " because it is not a valid BinaryPublicKey");
            }

            var encodedPublicKey = getPublicKeyEncoded(ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey)));

            if (!verifyPublicKeyEncoded(encodedPublicKey)) {
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied BinaryPublicKey: " + _elm_lang$core$Native_List.toArray(binaryPublicKey) + " because it is not a valid BinaryPublicKey");
            }

            var binaryPrivateKey = _elm_lang$core$Native_List.fromArray([]);

            var hexPublicKey = ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey));

            var publicKeyHash = getHash(hexPublicKey);

            var script = createSignatureScript(encodedPublicKey);

            var programHash = getHash(script);

            var address = toAddress(hexstring2ab(programHash.toString()));

            return _elm_lang$core$Result$Ok({
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: ""
                , binaryPublicKey: binaryPublicKey
                , hexPublicKey: hexPublicKey
                , publicKeyHash: publicKeyHash
                , programHash: programHash
                , address: address
            });
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var getAccountFromHexPublicKey = function (hexPublicKey) {
        try {

            var binaryPublicKey = hexstring2ab(hexPublicKey);

            if (!isValidBinaryPublicKeyInternal(binaryPublicKey)) {
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied HexPublicKey: " + hexPublicKey + " because it is not a valid HexPublicKey");
            }

            var encodedPublicKey = getPublicKeyEncoded(hexPublicKey);

            if (!verifyPublicKeyEncoded(encodedPublicKey)) {
                return _elm_lang$core$Result$Err("Error could not get account information from the supplied HexPublicKey: " + hexPublicKey + " because it is not a valid HexPublicKey");
            }

            var binaryPrivateKey = _elm_lang$core$Native_List.fromArray([]);

            var publicKeyHash = getHash(hexPublicKey);

            var script = createSignatureScript(encodedPublicKey);

            var programHash = getHash(script);

            var address = toAddress(hexstring2ab(programHash.toString()));

            return _elm_lang$core$Result$Ok({
                binaryPrivateKey: binaryPrivateKey
                , hexPrivateKey: ""
                , binaryPublicKey: _elm_lang$core$Native_List.fromArray(binaryPublicKey)
                , hexPublicKey: hexPublicKey
                , publicKeyHash: publicKeyHash
                , programHash: programHash
                , address: address
            });
        } catch (e) {
            return _elm_lang$core$Result$Err("Error something went wrong - here is the error: " + e);
        }
    };

    var numStoreInMemory = function (num, length) {
        for (var i = num.length; i < length; i++) {
            num = '0' + num;
        }
        var data = reverseArray(new all_crypto.buffer.Buffer(num, "HEX"));
        return ab2hexstring(data);
    };

    var reverseArray = function (arr) {
        var result = new Uint8Array(arr.length);
        for (var i = 0; i < arr.length; i++) {
            result[i] = arr[arr.length - 1 - i];
        }

        return result;
    };

    var getInputData = function (coinData, amount) {
        // sort
        var coin_ordered = _elm_lang$core$Native_List.toArray(coinData['unspent']);

        for (var i = 0; i < coin_ordered.length - 1; i++) {
            for (var j = 0; j < coin_ordered.length - 1 - i; j++) {
                if (parseFloat(coin_ordered[j].value) < parseFloat(coin_ordered[j + 1].value)) {
                    var temp = coin_ordered[j];
                    coin_ordered[j] = coin_ordered[j + 1];
                    coin_ordered[j + 1] = temp;
                }
            }
        }

        // calc sum
        var sum = 0;
        for (var i = 0; i < coin_ordered.length; i++) {
            sum = sum + parseFloat(coin_ordered[i].value);
        }

        // if sum < amount then exit;
        var amount = parseFloat(amount);
        if (sum < amount) return -1;

        // find input coins
        var k = 0;
        while (parseFloat(coin_ordered[k].value) <= amount) {
            amount = amount - parseFloat(coin_ordered[k].value);
            if (amount === 0) break;
            k = k + 1;
        }

        /////////////////////////////////////////////////////////////////////////
        // coin[0]- coin[k]
        var data = new Uint8Array(1 + 34 * (k + 1));

        // input num
        var inputNum = numStoreInMemory((k + 1).toString(16), 2);

        data.set(hexstring2ab(inputNum));

        // input coins
        for (var x = 0; x < k + 1; x++) {

            // txid
            var pos = 1 + (x * 34);
            data.set(reverseArray(hexstring2ab(coin_ordered[x]['transactionId'])), pos);

            // index
            pos = 1 + (x * 34) + 32;
            var inputIndex = numStoreInMemory(coin_ordered[x]['index'].toString(16), 4);
            data.set(hexstring2ab(inputIndex), pos);

        }

        /////////////////////////////////////////////////////////////////////////

        // calc coin_amount
        var coin_amount = 0;
        for (var i = 0; i < k + 1; i++) {
            coin_amount = coin_amount + parseFloat(coin_ordered[i].value);
        }

        /////////////////////////////////////////////////////////////////////////

        return {
            amount: coin_amount,
            data: data
        }
    };


    var getTransferData = function (coinData, binaryPublicKey, toAddress, amount) {
        try {

            var encodedPublicKey = getPublicKeyEncoded(ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey)));

            var ProgramHash = all_crypto.base58.decode(toAddress);
            var ProgramHexString = all_crypto.cryptojs.enc.Hex.parse(ab2hexstring(ProgramHash.slice(0, 21)));
            var ProgramSha256 = all_crypto.cryptojs.SHA256(ProgramHexString);
            var ProgramSha256_2 = all_crypto.cryptojs.SHA256(ProgramSha256);
            var ProgramSha256Buffer = hexstring2ab(ProgramSha256_2.toString());

            if (ab2hexstring(ProgramSha256Buffer.slice(0, 4)) !== ab2hexstring(ProgramHash.slice(21, 25))) {
                //address verify failed.
                return -1;
            }

            ProgramHash = ProgramHash.slice(1, 21);

            var signatureScript = createSignatureScript(encodedPublicKey);
            var myProgramHash = getHash(signatureScript);

            // INPUT CONSTRUCT
            var inputData = getInputData(coinData, amount);
            if (inputData === -1) return null;

            var inputLen = inputData.data.length;
            var inputAmount = inputData.amount;

            // Set SignableData Len
            var signableDataLen = 124 + inputLen;
            if (inputAmount === amount) {
                signableDataLen = 64 + inputLen;
            }

            // CONSTRUCT
            var data = new Uint8Array(signableDataLen);

            // type
            data.set(hexstring2ab("80"), 0);

            // version
            data.set(hexstring2ab("00"), 1);

            // Attributes
            data.set(hexstring2ab("00"), 2);

            // INPUT
            data.set(inputData.data, 3);

            // OUTPUT
            if (inputAmount === amount) {
                // only one output

                // output num
                data.set(hexstring2ab("01"), inputLen + 3);

                ////////////////////////////////////////////////////////////////////
                // OUTPUT - 0

                // output asset
                data.set(reverseArray(hexstring2ab(coinData['assetId'])), inputLen + 4);

                // output value
                const num1 = parseInt(amount * 100000000);
                const num1str = numStoreInMemory(num1.toString(16), 16);
                data.set(hexstring2ab(num1str), inputLen + 36);

                // output ProgramHash
                data.set(ProgramHash, inputLen + 44);

                ////////////////////////////////////////////////////////////////////

            } else {

                // output num
                data.set(hexstring2ab("02"), inputLen + 3);


                ////////////////////////////////////////////////////////////////////
                // OUTPUT - 0

                // output asset
                data.set(reverseArray(hexstring2ab(coinData['assetId'])), inputLen + 4);

                // output value
                const num1 = parseInt(amount * 100000000);
                const num1str = numStoreInMemory(num1.toString(16), 16);
                data.set(hexstring2ab(num1str), inputLen + 36);

                // output ProgramHash
                data.set(ProgramHash, inputLen + 44);

                ////////////////////////////////////////////////////////////////////
                // OUTPUT - 1

                // output asset
                data.set(reverseArray(hexstring2ab(coinData['assetId'])), inputLen + 64);

                // output value
                const num2 = parseInt(inputAmount * 100000000 - num1);
                const num2str = numStoreInMemory(num2.toString(16), 16);
                data.set(hexstring2ab(num2str), inputLen + 96);

                // output ProgramHash
                data.set(hexstring2ab(myProgramHash.toString()), inputLen + 104);
                ////////////////////////////////////////////////////////////////////

            }

            return ab2hexstring(data);

        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getSignatureData = function (transactionData, binaryPrivateKey) {
        try {

            var msg = all_crypto.cryptojs.enc.Hex.parse(transactionData);
            var msgHash = all_crypto.cryptojs.SHA256(msg);
            const msgHashHex = new all_crypto.buffer.Buffer(msgHash.toString(), "hex");

            var elliptic = new all_crypto.elliptic.ec('p256');
            const sig = elliptic.sign(msgHashHex, _elm_lang$core$Native_List.toArray(binaryPrivateKey), null);
            const signature = {
                signature: all_crypto.buffer.Buffer.concat([
                    sig.r.toArrayLike(all_crypto.buffer.Buffer, 'be', 32),
                    sig.s.toArrayLike(all_crypto.buffer.Buffer, 'be', 32)
                ])
            };

            return signature.signature.toString('hex');

        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    var getContractData = function (transactionData, signatureData, binaryPublicKey) {
        try {

            var encodedPublicKey = getPublicKeyEncoded(ab2hexstring(_elm_lang$core$Native_List.toArray(binaryPublicKey)));

            var signatureScript = createSignatureScript(encodedPublicKey);

            // sign num
            var data = transactionData + "01";
            // sign struct len
            data = data + "41";
            // sign data len
            data = data + "40";
            // sign data
            data = data + signatureData;
            // Contract data len
            data = data + "23";
            // script data
            data = data + signatureScript;
            return data;

        } catch (e) {
            return "something went wrong: " + e;
        }
    };

    return {
        generateBinaryPrivateKey               : generateBinaryPrivateKey,
        generateHexPrivateKey                  : generateHexPrivateKey,
        getWIFFromBinaryPrivateKey             : getWIFFromBinaryPrivateKey,
        getWIFFromHexPrivateKey                : getWIFFromHexPrivateKey,
        getBinaryPrivateKeyFromWIF             : getBinaryPrivateKeyFromWIF,
        getHexPrivateKeyFromWIF                : getHexPrivateKeyFromWIF,
        getAccountFromBinaryPrivateKey         : getAccountFromBinaryPrivateKey,
        getAccountFromHexPrivateKey            : getAccountFromHexPrivateKey,
        getAccountFromBinaryPublicKey          : getAccountFromBinaryPublicKey,
        getAccountFromHexPublicKey             : getAccountFromHexPublicKey,
        getTransferData                        : F4(getTransferData),
        getSignatureData                       : F2(getSignatureData),
        getContractData                        : F3(getContractData),
        getBinaryPublicKeyFromHexPrivateKey    : F2(getBinaryPublicKeyFromHexPrivateKey),
        getBinaryPublicKeyFromBinaryPrivateKey : F2(getBinaryPublicKeyFromBinaryPrivateKey),
        getHexPublicKeyFromBinaryPrivateKey    : F2(getHexPublicKeyFromBinaryPrivateKey),
        getHexPublicKeyFromHexPrivateKey       : F2(getHexPublicKeyFromHexPrivateKey)
        // isValidBinaryPublicKey                 : isValidBinaryPublicKey,
        // isValidHexPublicKey                    : isValidHexPublicKey
    }

}());