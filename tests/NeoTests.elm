module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Test.Runner.Html
import Expect exposing (Expectation)
import TestHelper exposing (it)
import Neo exposing (..)


main : Test.Runner.Html.TestProgram
main =
    [ privateAndPublicKeys
    , accounts
    , transactions
    , signatures
    , contracts
    , keyConversions
    ]
        |> concat
        |> Test.Runner.Html.run


privateAndPublicKeys : Test
privateAndPublicKeys =
    describe "Private and public keys"
        [ --        it "should generate a hex private key" (Expect.equal (String.length generateHexPrivateKey) 64)
          --        , it "should generate a binary private key" (Expect.equal (List.length generateBinaryPrivateKey) 32)
          it "should get a wif from the binary private key" (returnsExpectedKey "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU" (getWIFFromBinaryPrivateKey binaryPrivateKey))
        , it "should return an error given an invalid binary private key" (failsExpectedKey "Error could not get account information from the supplied BinaryPrivateKey: 1,2,3 because it is not a valid BinaryPrivateKey" (getWIFFromBinaryPrivateKey [ 1, 2, 3 ]))
        , it "should get a wif from the hex private key" (returnsExpectedKey "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU" (getWIFFromHexPrivateKey hexPrivateKey))
        , it "should return an error given an invalid hex private key" (failsExpectedKey "Error could not get account information from the supplied HexPrivateKey: not-a-hex-private-key because it is not a valid HexPrivateKey" (getWIFFromHexPrivateKey "not-a-hex-private-key"))
        , it "should get a binary private key from a wif" (returnsExpectedKey binaryPrivateKey (getBinaryPrivateKeyFromWIF wif))
        , it "should return an error given an invalid wif (getBinaryPrivateKeyFromWIF)" (failsExpectedKey "Error the supplied WIF: not-a-valid-wif is not encoded as base58" (getBinaryPrivateKeyFromWIF "not-a-valid-wif"))
        , it "should get a hex private key from a wif" (returnsExpectedKey hexPrivateKey (getHexPrivateKeyFromWIF wif))
        , it "should return an error given an invalid wif (getHexPrivateKeyFromWIF)" (failsExpectedKey "Error the supplied WIF: not-a-valid-wif is not encoded as base58" (getHexPrivateKeyFromWIF "not-a-valid-wif"))
        ]


returnsExpectedKey : a -> Result String a -> Expectation
returnsExpectedKey expectedKey maybeKey =
    case maybeKey of
        Ok account ->
            Expect.equal account expectedKey

        Err error ->
            Expect.fail error


failsExpectedKey : String -> Result String a -> Expectation
failsExpectedKey expectedError maybeKey =
    case maybeKey of
        Ok key ->
            Expect.fail "Should not have returned a key"

        Err error ->
            Expect.equal error expectedError


keyConversions : Test
keyConversions =
    describe "Key conversions"
        [ it "should get a binary public key from a hex private key" (returnsExpectedKey binaryPublicKey (getBinaryPublicKeyFromHexPrivateKey hexPrivateKey True))
        , it "should return an error given an invalid hex private key" (failsExpectedKey "Error the supplied HexPrivateKey: not-a-valid-hex-private-key is not a valid HexPrivateKey" (getBinaryPublicKeyFromHexPrivateKey "not-a-valid-hex-private-key" True))
        , it "should get a binary public key from a binary private key (getBinaryPublicKeyFromBinaryPrivateKey)" (returnsExpectedKey binaryPublicKey (getBinaryPublicKeyFromBinaryPrivateKey binaryPrivateKey True))
        , it "should return an error given an invalid binary private key (getBinaryPublicKeyFromBinaryPrivateKey)" (failsExpectedKey "Error the supplied BinaryPrivateKey: 1,2,3 is not a valid BinaryPrivateKey" (getBinaryPublicKeyFromBinaryPrivateKey [ 1, 2, 3 ] True))
        , it "should get a hex public key from a binary private key" (returnsExpectedKey hexPublicKey (getHexPublicKeyFromBinaryPrivateKey binaryPrivateKey True))
        , it "should return an error given an invalid binary private key (getHexPublicKeyFromBinaryPrivateKey)" (failsExpectedKey "Error the supplied BinaryPrivateKey: 1,2,3 is not a valid BinaryPrivateKey" (getHexPublicKeyFromBinaryPrivateKey [ 1, 2, 3 ] True))
        , it "should get a hex public key from a hex private key" (returnsExpectedKey hexPublicKey (getHexPublicKeyFromHexPrivateKey hexPrivateKey True))
        , it "should return an error given an invalid hex private key (getHexPublicKeyFromHexPrivateKey)" (failsExpectedKey "Error the supplied HexPrivateKey: not-a-valid-hex-private-key is not a valid HexPrivateKey" (getHexPublicKeyFromHexPrivateKey "not-a-valid-hex-private-key" True))
        ]


accounts : Test
accounts =
    describe "Wallet account info"
        [ it "should return an account given a binary private key" (returnsExpectedAccount account (getAccountFromBinaryPrivateKey binaryPrivateKey))
        , it "should return an error given an invalid binary private key" (failsExpectedAccount "Error could not get account information from the supplied BinaryPrivateKey: 1,2,3 because it is not a valid BinaryPrivateKey" (getAccountFromBinaryPrivateKey [ 1, 2, 3 ]))
        , it "should return an account given a hex private key" (returnsExpectedAccount account (getAccountFromHexPrivateKey hexPrivateKey))
        , it "should return an error given an invalid hex private key" (failsExpectedAccount "Error could not get account information from the supplied HexPrivateKey: not-a-hex-private-key because it is not a valid HexPrivateKey" (getAccountFromHexPrivateKey "not-a-hex-private-key"))
        , it "should return an account given a binary public key" (returnsExpectedAccount publicAccount (getAccountFromBinaryPublicKey binaryPublicKey))
        , it "should return an error given an invalid binary public key" (failsExpectedAccount "Error could not get account information from the supplied BinaryPublicKey: 1,2,3 because it is not a valid BinaryPublicKey" (getAccountFromBinaryPublicKey [ 1, 2, 3 ]))
        , it "should return an account given a hex public key" (returnsExpectedAccount publicAccount (getAccountFromHexPublicKey hexPublicKey))
        , it "should return an error given an invalid hex public key" (failsExpectedAccount "Error could not get account information from the supplied HexPublicKey: not-a-hex-public-key because it is not a valid HexPublicKey" (getAccountFromHexPublicKey "not-a-hex-public-key"))
        ]


returnsExpectedAccount : Account -> Result String Account -> Expectation
returnsExpectedAccount expectedAccount maybeAccount =
    case maybeAccount of
        Ok account ->
            Expect.equal account expectedAccount

        Err error ->
            Expect.fail error


failsExpectedAccount : String -> Result String Account -> Expectation
failsExpectedAccount expectedError maybeAccount =
    case maybeAccount of
        Ok account ->
            Expect.fail "Should not have returned an account"

        Err error ->
            Expect.equal error expectedError


transactions : Test
transactions =
    describe "Transactions"
        [ it "can create transfer data for GAS when amounts are not equal" (returnsExpectedTransactionData expectedTransactionDataGasNotEqual (transactionTransferData "Gas" gasAssetId 23.789))
        , it "can create transfer data for GAS when amounts are equal" (returnsExpectedTransactionData expectedTransactionDataGasEqual (transactionTransferData "Gas" gasAssetId getUnspentAmount))
        , it "can create transfer data for NEO when amounts are not equal" (returnsExpectedTransactionData expectedTransactionDataNeoNotEqual (transactionTransferData "Neo" neoAssetId 23.789))
        , it "can create transfer data for NEO when amounts are equal" (returnsExpectedTransactionData expectedTransactionDataNeoEqual (transactionTransferData "Neo" neoAssetId getUnspentAmount))
        , it "should return an error on invalid binary public key" (failsExpectedTransactionData "Error the supplied BinaryPublicKey: 1,2,3 is not a valid BinaryPublicKey" (getTransferData (CoinData neoAssetId orderedUnspentTransactions getUnspentAmount "Neo") [ 1, 2, 3 ] "ALfnhLg7rUyL6Jr98bzzoxz5J7m64fbR4s" 23.789))
        , it "should return an error on invalid address" (failsExpectedTransactionData "Error the supplied Address: not-a-valid-address is not a valid NEO Address" (getTransferData (CoinData neoAssetId orderedUnspentTransactions getUnspentAmount "Neo") binaryPublicKey "not-a-valid-address" 23.789))
        ]


returnsExpectedTransactionData : TransactionData -> Result String TransactionData -> Expectation
returnsExpectedTransactionData expectedData maybeData =
    case maybeData of
        Ok data ->
            Expect.equal data expectedData

        Err error ->
            Expect.fail error


failsExpectedTransactionData : String -> Result String TransactionData -> Expectation
failsExpectedTransactionData expectedError maybeData =
    case maybeData of
        Ok data ->
            Expect.fail "Should not have returned transaction data"

        Err error ->
            Expect.equal error expectedError


signatures : Test
signatures =
    describe "Signature Data"
        [ it "should return signature data" (returnsExpectedSignatureData expectedSignatureData signatureData)
        , it "should return an error given an invalid private binary key" (failsExpectedSignatureData "Error the supplied BinaryPrivateKey: 1,2,3 is not a valid BinaryPrivateKey" (getSignatureData "transactionData" [ 1, 2, 3 ]))
        ]


returnsExpectedSignatureData : SignatureData -> Result String SignatureData -> Expectation
returnsExpectedSignatureData expectedData maybeData =
    case maybeData of
        Ok data ->
            Expect.equal data expectedData

        Err error ->
            Expect.fail error


failsExpectedSignatureData : String -> Result String SignatureData -> Expectation
failsExpectedSignatureData expectedError maybeData =
    case maybeData of
        Ok data ->
            Expect.fail "Should not have returned signature data"

        Err error ->
            Expect.equal error expectedError


contracts : Test
contracts =
    describe "Contract Data"
        [ it "should return contract data" (returnsExpectedContractData expectedContractData contractData)
        , it "should return an error given an invalid binary public key " (failsExpectedContractData "Error the supplied BinaryPublicKey: 1,2,3 is not a valid BinaryPublicKey" (getContractData "transaction-data" "signature-data" [ 1, 2, 3 ]))
        ]


returnsExpectedContractData : ContractData -> Result String ContractData -> Expectation
returnsExpectedContractData expectedData maybeData =
    case maybeData of
        Ok data ->
            Expect.equal data expectedData

        Err error ->
            Expect.fail error


failsExpectedContractData : String -> Result String ContractData -> Expectation
failsExpectedContractData expectedError maybeData =
    case maybeData of
        Ok data ->
            Expect.fail "Should not have returned contract data"

        Err error ->
            Expect.equal error expectedError


getUnspentAmount : Float
getUnspentAmount =
    List.sum <| List.map .value orderedUnspentTransactions


transactionTransferData : AssetName -> AssetId -> Float -> Result String TransactionData
transactionTransferData assetName assetId amount =
    let
        fromHexPrivateKey =
            Result.withDefault "" (getHexPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g")

        fromAccount =
            Result.withDefault emptyAccount (getAccountFromHexPrivateKey fromHexPrivateKey)

        toAddress =
            "ALfnhLg7rUyL6Jr98bzzoxz5J7m64fbR4s"

        balance =
            getUnspentAmount

        coinData =
            CoinData assetId orderedUnspentTransactions balance assetName
    in
        getTransferData coinData fromAccount.binaryPublicKey toAddress amount


signatureData : Result String SignatureData
signatureData =
    let
        fromBinaryPrivateKey =
            Result.withDefault [] (getBinaryPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g")

        transactionData =
            expectedTransactionDataGasNotEqual
    in
        getSignatureData transactionData fromBinaryPrivateKey


expectedSignatureData : SignatureData
expectedSignatureData =
    "919c47584d3153782cffe1a46487680d10afe9ac68cac1c338e4bd202d2b375a95c9658a2c10e303e4057643d04eee2797b64d5957273dd48cc898cdb2bbe1d1"


contractData : Result String ContractData
contractData =
    let
        fromBinaryPrivateKey =
            Result.withDefault [] (getBinaryPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g")

        fromBinaryPublicKey =
            Result.withDefault [] (getBinaryPublicKeyFromBinaryPrivateKey fromBinaryPrivateKey True)

        transactionData =
            expectedTransactionDataGasNotEqual

        signatureData =
            expectedSignatureData
    in
        getContractData transactionData signatureData fromBinaryPublicKey


expectedContractData : ContractData
expectedContractData =
    "80000005fd7518a67fee8b769a0826ce3df7d2b6d692d0a2bca0e1b258fa6af539f970250000dc21e45b5a80a6bc473dadf560f7d23df7032c8cf79867d400da84700341a73200008be326494a6486e92915fb150d8590d6babb1b9907f9ff80cf48793ac35a299c00006f5b94a7297681258e4e184544d7d0756fd31feab34a957da62d07b8204d4c7000001a84a7e19d56626e0b5bf5494094feb094d4ebeba4cad24a2c385a1b7aa67233000002e72d286979ee6cb1b7e65dfddfb2e384100b8d148e7758de42e4168b71792c602022cb8d0000000035b20010db73bf86371075ddfba4e6596f1ff35de72d286979ee6cb1b7e65dfddfb2e384100b8d148e7758de42e4168b71792c6097957408000000003775292229eccdf904f16fff8e83e7cffdc0f0ce014140919c47584d3153782cffe1a46487680d10afe9ac68cac1c338e4bd202d2b375a95c9658a2c10e303e4057643d04eee2797b64d5957273dd48cc898cdb2bbe1d1232102028a99826edc0c97d18e22b6932373d908d323aa7f92656a77ec26e8861699efac"


orderedUnspentTransactions : Transactions
orderedUnspentTransactions =
    [ Transaction 0 "2570f939f56afa58b2e1a0bca2d092d6b6d2f73dce26089a768bee7fa61875fd" 10.4
    , Transaction 0 "32a741037084da00d46798f78c2c03f73dd2f760f5ad3d47bca6805a5be421dc" 7.0
    , Transaction 0 "9c295ac33a7948cf80fff907991bbbbad690850d15fb1529e986644a4926e38b" 3.343242
    , Transaction 0 "704c4d20b8072da67d954ab3ea1fd36f75d0d74445184e8e25817629a7945b6f" 2.89898
    , Transaction 0 "3372a67a1b5a382c4ad2caa4ebebd494b0fe944049f55b0b6e62569de1a7841a" 1.56536
    ]


expectedTransactionDataGasNotEqual : TransactionData
expectedTransactionDataGasNotEqual =
    "80000005fd7518a67fee8b769a0826ce3df7d2b6d692d0a2bca0e1b258fa6af539f970250000dc21e45b5a80a6bc473dadf560f7d23df7032c8cf79867d400da84700341a73200008be326494a6486e92915fb150d8590d6babb1b9907f9ff80cf48793ac35a299c00006f5b94a7297681258e4e184544d7d0756fd31feab34a957da62d07b8204d4c7000001a84a7e19d56626e0b5bf5494094feb094d4ebeba4cad24a2c385a1b7aa67233000002e72d286979ee6cb1b7e65dfddfb2e384100b8d148e7758de42e4168b71792c602022cb8d0000000035b20010db73bf86371075ddfba4e6596f1ff35de72d286979ee6cb1b7e65dfddfb2e384100b8d148e7758de42e4168b71792c6097957408000000003775292229eccdf904f16fff8e83e7cffdc0f0ce"


expectedTransactionDataGasEqual : TransactionData
expectedTransactionDataGasEqual =
    "80000005fd7518a67fee8b769a0826ce3df7d2b6d692d0a2bca0e1b258fa6af539f970250000dc21e45b5a80a6bc473dadf560f7d23df7032c8cf79867d400da84700341a73200008be326494a6486e92915fb150d8590d6babb1b9907f9ff80cf48793ac35a299c00006f5b94a7297681258e4e184544d7d0756fd31feab34a957da62d07b8204d4c7000001a84a7e19d56626e0b5bf5494094feb094d4ebeba4cad24a2c385a1b7aa67233000001e72d286979ee6cb1b7e65dfddfb2e384100b8d148e7758de42e4168b71792c60b7b73f960000000035b20010db73bf86371075ddfba4e6596f1ff35d"


expectedTransactionDataNeoNotEqual : TransactionData
expectedTransactionDataNeoNotEqual =
    "80000005fd7518a67fee8b769a0826ce3df7d2b6d692d0a2bca0e1b258fa6af539f970250000dc21e45b5a80a6bc473dadf560f7d23df7032c8cf79867d400da84700341a73200008be326494a6486e92915fb150d8590d6babb1b9907f9ff80cf48793ac35a299c00006f5b94a7297681258e4e184544d7d0756fd31feab34a957da62d07b8204d4c7000001a84a7e19d56626e0b5bf5494094feb094d4ebeba4cad24a2c385a1b7aa672330000029b7cffdaa674beae0f930ebe6085af9093e5fe56b34a5c220ccdcf6efc336fc52022cb8d0000000035b20010db73bf86371075ddfba4e6596f1ff35d9b7cffdaa674beae0f930ebe6085af9093e5fe56b34a5c220ccdcf6efc336fc597957408000000003775292229eccdf904f16fff8e83e7cffdc0f0ce"


expectedTransactionDataNeoEqual : TransactionData
expectedTransactionDataNeoEqual =
    "80000005fd7518a67fee8b769a0826ce3df7d2b6d692d0a2bca0e1b258fa6af539f970250000dc21e45b5a80a6bc473dadf560f7d23df7032c8cf79867d400da84700341a73200008be326494a6486e92915fb150d8590d6babb1b9907f9ff80cf48793ac35a299c00006f5b94a7297681258e4e184544d7d0756fd31feab34a957da62d07b8204d4c7000001a84a7e19d56626e0b5bf5494094feb094d4ebeba4cad24a2c385a1b7aa672330000019b7cffdaa674beae0f930ebe6085af9093e5fe56b34a5c220ccdcf6efc336fc5b7b73f960000000035b20010db73bf86371075ddfba4e6596f1ff35d"


binaryPrivateKey : BinaryPrivateKey
binaryPrivateKey =
    [ 198, 92, 83, 247, 95, 217, 95, 1, 185, 25, 130, 202, 248, 55, 239, 113, 163, 210, 104, 87, 71, 227, 145, 177, 145, 182, 217, 88, 1, 181, 8, 136 ]


binaryPublicKey : BinaryPublicKey
binaryPublicKey =
    [ 2, 87, 60, 96, 100, 125, 15, 68, 184, 112, 213, 143, 215, 59, 168, 131, 28, 100, 95, 26, 114, 133, 52, 227, 86, 113, 203, 87, 20, 149, 7, 83, 208 ]


hexPrivateKey : HexPrivateKey
hexPrivateKey =
    "c65c53f75fd95f01b91982caf837ef71a3d2685747e391b191b6d95801b50888"


hexPublicKey : HexPublicKey
hexPublicKey =
    "02573c60647d0f44b870d58fd73ba8831c645f1a728534e35671cb5714950753d0"


wif : Wif
wif =
    "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU"


account : Account
account =
    { binaryPrivateKey = binaryPrivateKey
    , hexPrivateKey = hexPrivateKey
    , binaryPublicKey = binaryPublicKey
    , hexPublicKey = hexPublicKey
    , publicKeyHash = "6375ccb1d4b858877b3aa73529774041d7173fc3"
    , programHash = "8d7e6a027f7586747da6f5f3b820135360472256"
    , address = "AUg2MxB9uLfFSGy1EpMiGR75KFAmhUjAH4"
    }


publicAccount : Account
publicAccount =
    { binaryPrivateKey = []
    , hexPrivateKey = ""
    , binaryPublicKey = binaryPublicKey
    , hexPublicKey = hexPublicKey
    , publicKeyHash = "6375ccb1d4b858877b3aa73529774041d7173fc3"
    , programHash = "8d7e6a027f7586747da6f5f3b820135360472256"
    , address = "AUg2MxB9uLfFSGy1EpMiGR75KFAmhUjAH4"
    }


emptyAccount : Account
emptyAccount =
    { binaryPrivateKey = []
    , hexPrivateKey = ""
    , binaryPublicKey = []
    , hexPublicKey = ""
    , publicKeyHash = ""
    , programHash = ""
    , address = ""
    }
