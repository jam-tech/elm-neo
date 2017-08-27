# Elm Neo

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

This project provides elm tools for the Neo blockchain

## Usage

There are 5 areas:

* Private and public keys
* Accounts
* Transactions
* Signatures
* Contracts

### Private and public keys

```
import Neo as Neo

-- generating private keys
Neo.generateBinaryPrivateKey
Neo.generateHexPrivateKey 

-- getting a wif from a private key 
Neo.getWIFFromBinaryPrivateKey
Neo.getWIFFromHexPrivateKey

-- getting a private key from a wif
Neo.getBinaryPrivateKeyFromWIF
Neo.getHexPrivateKeyFromWIF

-- get binary public key from private key
Neo.getBinaryPublicKeyFromHexPrivateKey hexPrivateKey True
Neo.getBinaryPublicKeyFromBinaryPrivateKey binaryPrivateKey True

-- get hex public key from private key
Neo.getHexPublicKeyFromBinaryPrivateKey binaryPrivateKey True
Neo.getHexPublicKeyFromHexPrivateKey hexPrivateKey True
```

### Accounts

```
import Neo as Neo

-- get wallet account from a private key
Neo.getAccountFromBinaryPrivateKey binaryPrivateKey
Neo.getAccountFromHexPrivateKey hexPrivateKey

-- get wallet account from a public key
Neo.getAccountFromBinaryPublicKey binaryPublicKey
Neo.getAccountFromHexPublicKey hexPublicKey

-- returns Account

type alias Account =
    { binaryPrivateKey : BinaryPrivateKey
    , hexPrivateKey : HexPrivateKey
    , binaryPublicKey : BinaryPublicKey
    , hexPublicKey : HexPublicKey
    , publicKeyHash : PublicKeyHash
    , programHash : ProgramHash
    , address : Address
    }

```

### Transactions

```
import Neo as Neo

-- create transfer data

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


orderedUnspentTransactions : Transactions
orderedUnspentTransactions =
    [ Transaction 0 "2570f939f56afa58b2e1a0bca2d092d6b6d2f73dce26089a768bee7fa61875fd" 10.4
    , Transaction 0 "32a741037084da00d46798f78c2c03f73dd2f760f5ad3d47bca6805a5be421dc" 7.0
    , Transaction 0 "9c295ac33a7948cf80fff907991bbbbad690850d15fb1529e986644a4926e38b" 3.343242
    , Transaction 0 "704c4d20b8072da67d954ab3ea1fd36f75d0d74445184e8e25817629a7945b6f" 2.89898
    , Transaction 0 "3372a67a1b5a382c4ad2caa4ebebd494b0fe944049f55b0b6e62569de1a7841a" 1.56536
    ]
    
-- relevant type alias are below:

type alias CoinData =
    { assetId : AssetId
    , unspent : Transactions
    , balance : Float
    , name : AssetName
    }
    
type alias Transaction =
    { index : Int
    , transactionId : TransactionId
    , value : Float
    }
    
```

### Signatures

```
import Neo as Neo

signatureData : SignatureData
signatureData =
    let
        fromBinaryPrivateKey =
            getBinaryPrivateKeyFromWIF "L1QqQJnpBwbsPGAuutuzPTac8piqvbR1HRjrY5qHup48TBCBFe4g"

        transactionData =
            expectedTransactionDataGasNotEqual
    in
        getSignatureData transactionData fromBinaryPrivateKey



```

### Contracts

```
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

``` 

## Install

you must use [elm-github-install](https://github.com/gdotdesign/elm-github-install) and include in your elm-package.json as follows:

```
"dependencies": {
  "kingsleyh/elm-neo": "1.0.0 <= v < 2.0.0"
}
```

Then run elm-install

## Example

See the [tests](https://github.com/kingsleyh/elm-neo/blob/master/tests/NeoTests.elm) for example usage

## Testing

There are tests in the tests folder which run in the browser - this is because the native code doesn't want to run in elm-test so running in the browser was the only way I could get the tests running.
However this means that they can't be hooked up to travis-ci - maybe I'll be able to resolve this in the future - but for now to see the tests

```
cd tests
elm-reactor 
```

Then fire up the browser on localhost:8000 and visit the NeoTest.elm

## Dev

In the JS folder is a native.js with all the native code in it. There is a main.js with exports that are used in the native.js.
These two files must be concatenated and output to Native/Neo.js - this is what gen.sh does. So after making changes to either main.js or native.js make sure to run
gen.sh to see the changes. Fire up the tests as described above during dev to keep on the straight and narrow.

So this all works by using browserify to package up all the required node_modules into a single js with standalone exports as all_crypto. To access the packaged libs from the 
native.js you just prepend it with all_crypto.**name of export in main.js**.**lib**

so you'll have to yarn install in the JS folder to get all the deps
