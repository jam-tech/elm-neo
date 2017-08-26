var _kingsleyh$elm_neo$Native_Neo = (function () {

    var browserRandom = function (count) {
        var crypto = window.crypto || window.msCrypto;
        if (!crypto) throw new Error("Your browser does not support window.crypto.");
        var arr = _elm_lang$core$Native_List.Nil;
        var randomList = crypto.getRandomValues(new Uint8Array(count));
        for (var i = 0; i < count; ++i) {
            arr = _elm_lang$core$Native_List.Cons(randomList[i], arr);
        }

        return arr;
    };

    var nodeRandom = function (count) {
        var nodeCrypto = require('crypto');
        var buf = nodeCrypto.randomBytes(count);
        var arr = _elm_lang$core$Native_List.Nil;
        for (var i = 0; i < count; ++i) {
            arr = _elm_lang$core$Native_List.Cons(buf.readUInt8(i), arr);
        }
        return arr;
    };

    var generatePrivateKey = function () {
        try {
            if (typeof process !== 'undefined' && typeof process.pid === 'number') {
                return nodeRandom(32);
            } else {
                return browserRandom(32);
            }
        } catch (e) {
            return "something went wrong: " + e;
        }
    };


    return {
        generatePrivateKey: generatePrivateKey()
    }

}());