
var ab2hexstring = function(arr){
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

var _kingsleyh$elm_neo$Native_Neo = (function () {

    var generateBinaryPrivateKey = function () {
        try {
            return _elm_lang$core$Native_List.fromArray(all_crypto.secureRandom.randomUint8Array(32));
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

    return {
        generateBinaryPrivateKey: generateBinaryPrivateKey(),
        getWIFFromBinaryPrivateKey: getWIFFromBinaryPrivateKey
    }

}());