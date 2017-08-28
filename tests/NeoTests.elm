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
        [
--        it "should generate a hex private key" (Expect.equal (String.length generateHexPrivateKey) 64)
--        , it "should generate a binary private key" (Expect.equal (List.length generateBinaryPrivateKey) 32)
          it "should get a wif from the binary private key" (Expect.equal (getWIFFromBinaryPrivateKey binaryPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        , it "should get a wif from the hex private key" (Expect.equal (getWIFFromHexPrivateKey hexPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        , it "should get a binary private key from a wif" (Expect.equal (getBinaryPrivateKeyFromWIF wif) binaryPrivateKey)
        , it "should get a hex private key from a wif" (Expect.equal (getHexPrivateKeyFromWIF wif) hexPrivateKey)
        ]


keyConversions : Test
keyConversions =
    describe "Key conversions"
        [ it "should get a binary public key from a hex private key" (Expect.equal (getBinaryPublicKeyFromHexPrivateKey hexPrivateKey True) binaryPublicKey)
        , it "should get a binary public key from a binary private key" (Expect.equal (getBinaryPublicKeyFromBinaryPrivateKey binaryPrivateKey True) binaryPublicKey)
        , it "should get a hex public key from a binary private key" (Expect.equal (getHexPublicKeyFromBinaryPrivateKey binaryPrivateKey True) hexPublicKey)
        , it "should get a hex public key from a hex private key" (Expect.equal (getHexPublicKeyFromHexPrivateKey hexPrivateKey True) hexPublicKey)
        ]


accounts : Test
accounts =
    describe "Wallet account info"
        [ it "should return an account given a binary private key" (Expect.equal (getAccountFromBinaryPrivateKey binaryPrivateKey) account)
        , it "should return an account given a hex private key" (Expect.equal (getAccountFromHexPrivateKey hexPrivateKey) account)
        , it "should return an account given a binary public key" (Expect.equal (getAccountFromBinaryPublicKey binaryPublicKey) publicAccount)
        , it "should return an account given a hex public key" (Expect.equal (getAccountFromHexPublicKey hexPublicKey) publicAccount)
        ]


transactions : Test
transactions =
    describe "Transactions"
        [ it "can create transfer data for GAS when amounts are not equal" (Expect.equal (transactionTransferData "Gas" gasAssetId 23.789) expectedTransactionDataGasNotEqual)
        , it "can create transfer data for GAS when amounts are equal" (Expect.equal (transactionTransferData "Gas" gasAssetId getUnspentAmount) expectedTransactionDataGasEqual)
        , it "can create transfer data for NEO when amounts are not equal" (Expect.equal (transactionTransferData "Neo" neoAssetId 23.789) expectedTransactionDataNeoNotEqual)
        , it "can create transfer data for NEO when amounts are equal" (Expect.equal (transactionTransferData "Neo" neoAssetId getUnspentAmount) expectedTransactionDataNeoEqual)
        ]


signatures : Test
signatures =
    describe "Signature Data"
        [ it "should return signature data" (Expect.equal signatureData expectedSignatureData) ]


contracts : Test
contracts =
    describe "Contract Data"
        [ it "should return contract data" (Expect.equal contractData expectedContractData) ]


getUnspentAmount : Float
getUnspentAmount =
    List.sum <| List.map .value orderedUnspentTransactions


transactionTransferData : AssetName -> AssetId -> Float -> TransactionData
transactionTransferData assetName assetId amount =
    let
        fromHexPrivateKey =
            getHexPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g"

        fromAccount =
            getAccountFromHexPrivateKey (fromHexPrivateKey)

        toAddress =
            "ALfnhLg7rUyL6Jr98bzzoxz5J7m64fbR4s"

        balance =
            getUnspentAmount

        coinData =
            CoinData assetId orderedUnspentTransactions balance assetName
    in
        getTransferData coinData fromAccount.binaryPublicKey toAddress amount


signatureData : SignatureData
signatureData =
    let
        fromBinaryPrivateKey =
            getBinaryPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g"

        transactionData =
            expectedTransactionDataGasNotEqual
    in
        getSignatureData transactionData fromBinaryPrivateKey


expectedSignatureData : SignatureData
expectedSignatureData =
    "919c47584d3153782cffe1a46487680d10afe9ac68cac1c338e4bd202d2b375a95c9658a2c10e303e4057643d04eee2797b64d5957273dd48cc898cdb2bbe1d1"


contractData : ContractData
contractData =
    let
        fromBinaryPrivateKey =
            getBinaryPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g"

        fromBinaryPublicKey =
            getBinaryPublicKeyFromBinaryPrivateKey fromBinaryPrivateKey True

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
