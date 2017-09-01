module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Test.Runner.Html
import Expect exposing (Expectation)
import TestHelper exposing (it)
import Neo exposing (..)


main : Test.Runner.Html.TestProgram
main =
    [
     privateAndPublicKeys
          , accounts
          , transactions
          , signatures
          , contracts
          , keyConversions
          , formatValidations
          , fullNeoTest
    ]
        |> concat
        |> Test.Runner.Html.run



-- TODO - the generate private keys is done via Task so needs some kind of update loop to catch it and check.


privateAndPublicKeys : Test
privateAndPublicKeys =
    describe "Private and public keys"
        [ -- it "should generate a hex private key" (Expect.equal (String.length generateHexPrivateKey) 64)
          -- , it "should generate a binary private key" (Expect.equal (List.length generateBinaryPrivateKey) 32)
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
        , it "should convert hex private key to binary private key" (returnsExpectedKey binaryPrivateKey (getBinaryPrivateKeyFromHexPrivateKey hexPrivateKey))
        , it "should error on invalid hex private key (getBinaryPrivateKeyFromHexPrivateKey)" (failsExpectedKey "The supplied HexPrivateKey: not-a-valid-hex-private-key is not a valid HexPrivateKey" (getBinaryPrivateKeyFromHexPrivateKey "not-a-valid-hex-private-key"))
        , it "should convert binary private key to hex private key" (returnsExpectedKey hexPrivateKey (getHexPrivateKeyFromBinaryPrivateKey binaryPrivateKey))
        , it "should error on invalid binary private key (getHexPrivateKeyFromBinaryPrivateKey)" (failsExpectedKey "The supplied BinaryPrivateKey: 1,2,3 is not a valid BinaryPrivateKey" (getHexPrivateKeyFromBinaryPrivateKey [ 1, 2, 3 ]))
        , it "should convert hex public key to binary public key" (returnsExpectedKey binaryPublicKey (getBinaryPublicKeyFromHexPublicKey hexPublicKey))
        , it "should error on invalid hex public key (getBinaryPublicKeyFromHexPublicKey)" (failsExpectedKey "The supplied HexPublicKey: not-a-valid-hex-public-key is not a valid HexPublicKey" (getBinaryPublicKeyFromHexPublicKey "not-a-valid-hex-public-key"))
        , it "should convert binary public key to hex public key" (returnsExpectedKey hexPublicKey (getHexPublicKeyFromBinaryPublicKey binaryPublicKey))
        , it "should error on invalid binary public key (getHexPublicKeyFromBinaryPublicKey)" (failsExpectedKey "The supplied BinaryPublicKey: 1,2,3 is not a valid BinaryPublicKey" (getHexPublicKeyFromBinaryPublicKey [ 1, 2, 3 ]))
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


formatValidations : Test
formatValidations =
    describe "Format validations"
        [ it "should return true for a valid binary public key" (Expect.equal (isValidBinaryPublicKey binaryPublicKey) True)
        , it "should return false for an invalid binary public key" (Expect.equal (isValidBinaryPublicKey [ 1, 2, 3 ]) False)
        , it "should return true for a valid hex public key" (Expect.equal (isValidHexPublicKey hexPublicKey) True)
        , it "should return false for an invalid hex public key" (Expect.equal (isValidHexPublicKey "not-a-valid-hex-public-key") False)
        , it "should return true for a valid address" (Expect.equal (isValidAddress "ALfnhLg7rUyL6Jr98bzzoxz5J7m64fbR4s") True)
        , it "should return false for an invalid address" (Expect.equal (isValidAddress "not-a-valid-address") False)
        , it "should return true for a valid hex private key" (Expect.equal (isValidHexPrivateKey hexPrivateKey) True)
        , it "should return false for an invalid hex private key" (Expect.equal (isValidHexPrivateKey "not-a-valid-hex-private-key") False)
        , it "should return true for a valid wif" (Expect.equal (isValidWif wif) True)
        , it "should return false for an invalid wif" (Expect.equal (isValidWif "not-a-valid-wif") False)
        ]


fullNeoTest : Test
fullNeoTest =
    let
        expectedNeoPayload =
            "80000001d54314e7f315e610bcf9331c9b4b809874e332733d400668334df66602f1368d0100029b7cffdaa674beae0f930ebe6085af9093e5fe56b34a5c220ccdcf6efc336fc500e1f5050000000050aaa1301d0e0ed762efb7595e547f368c6d0d719b7cffdaa674beae0f930ebe6085af9093e5fe56b34a5c220ccdcf6efc336fc5007ddaac00000000f7901c8cccd69fc54be2efc41e5fd546cf79d969014140a4ce92550df00dd67631abb82a5399204f4b586904d091096ab9627c789f15bb61b1bbeab48130ae7c69cd510a4feb8dd285fa47facffc0043484ede0fda742523210234f1a4f25318d80ce8aa81449924aff029f4262abd02d056b692d9f8e90fb835ac"
    in
        describe "Neo full test"
            [ it "should make an identical payload to the Neon client" (Expect.equal (createPayloadFor "Neo") expectedNeoPayload) ]


type alias Balance =
    { balance : Float, unspent : List Transaction }


type alias BalanceInfo =
    { gas : Balance, neo : Balance, address : String, net : String }


createPayloadFor : AssetName -> ContractData
createPayloadFor assetName =
    let
        toAddress =
            "AP8Q7Q9uzwaDnKc3GooERipJknzBLQSTy5"

        gasBalance =
            Balance 0 []

        neoBalance =
            Balance 41
                [
                 Transaction 1 "6374a38584e7b5487ffaddab36f106942904081016cdaa4d77539af5c289c977" 1
                ,Transaction 1 "74b4630507f381fbf310e2f3699be7228a24052dc00f0ca844e453fc370c8352" 1
                ,Transaction 0 "6253cbb1eba98ffea217e59f51e60eba86f44f902939f3dab8fda94f5694a16d" 1
                ,Transaction 0 "4c5d9697d7846bbcc2dacf9dfefb16f5e918ceec7810ffd4a2618503edc121d7" 1
                ,Transaction 0 "0c174aab04c2dd4e61e9c6498fcebeffb91980652c9668b92e07805a20c4dd71" 2
                ,Transaction 0 "75abcda83a1dabf30e16e3732ebee94704b9806919187801e2011fd96597e433" 2
                ,Transaction 0 "86191f8130b3c052850a291e0b8f4141e7afda9aab394be851e0147392ac85fe" 2
                ,Transaction 1 "8d36f10266f64d336806403d7332e37498804b9b1c33f9bc10e615f3e71443d5" 30
                ,Transaction 0 "c40b1afbd5d9818ad185e2f22dc406e552bc82b2074e7dc92d12175a43b8bdcb" 1
                ]

        getAccountAndKey : HexPrivateKey -> Result String ( Address, BinaryPublicKey, BinaryPrivateKey )
        getAccountAndKey hexPrivateKey_ =
            Result.map (\account -> ( account.address, account.binaryPublicKey, account.binaryPrivateKey )) (Neo.getAccountFromHexPrivateKey hexPrivateKey_)

        getTransactionData : ( Address, BinaryPublicKey, BinaryPrivateKey ) -> Result String ( Address, BinaryPublicKey, BinaryPrivateKey, TransactionData )
        getTransactionData ( address_, binaryPublicKey_, binaryPrivateKey_ ) =
            let
                balanceInfo =
                    BalanceInfo gasBalance neoBalance address_ "TestNet"

                coinData =
                    CoinData neoAssetId balanceInfo.neo.unspent balanceInfo.neo.balance assetName

                _ = Debug.log "coindata: " coinData
            in
                Result.map (\transactionData_ -> ( address_, binaryPublicKey_, binaryPrivateKey_, transactionData_ )) (Neo.getTransferData coinData binaryPublicKey_ toAddress 1)

        getSignatureData : ( Address, BinaryPublicKey, BinaryPrivateKey, TransactionData ) -> Result String ( Address, BinaryPublicKey, BinaryPrivateKey, TransactionData, SignatureData )
        getSignatureData ( address_, binaryPublicKey_, binaryPrivateKey_, transactionData_ ) =
            let
              _ = Debug.log "sig" (Neo.getSignatureData transactionData_ binaryPrivateKey_)
              _ = Debug.log "txd" (transactionData_)
              _ = Debug.log "pkb" (Neo.getHexPrivateKeyFromBinaryPrivateKey binaryPrivateKey_)
            in
            Result.map (\signatureData_ -> ( address_, binaryPublicKey_, binaryPrivateKey_, transactionData_, signatureData_ )) (Neo.getSignatureData transactionData_ binaryPrivateKey_)

        getContractData : ( Address, BinaryPublicKey, BinaryPrivateKey, TransactionData, SignatureData ) -> Result String ContractData
        getContractData ( address_, binaryPublicKey_, binaryPrivateKey_, transactionData_, signatureData_ ) =
            Neo.getContractData transactionData_ signatureData_ binaryPublicKey_


        result =
            getAccountAndKey "03dfb7d63595106f8936d0da98853e37e3ddf2c4fe2df9b717df936cad985395"
                |> Result.andThen getTransactionData
                |> Result.andThen getSignatureData
                |> Result.andThen getContractData

        _ =
            Debug.log "r: " result
    in
        case result of
            Ok data ->
                data

            Err error ->
                error




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
