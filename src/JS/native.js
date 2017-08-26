

var _kingsleyh$elm_neo$Native_Neo = (function () {

    var generatePrivateKey = function () {
        try {
            return _elm_lang$core$Native_List.fromArray(all_crypto.secureRandom.randomUint8Array(32));
        } catch (e) {
            return "something went wrong: " + e;
        }
    };


    return {
        generatePrivateKey: generatePrivateKey()
    }

}());