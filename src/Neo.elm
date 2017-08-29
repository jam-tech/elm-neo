module Neo
    exposing
        ( BinaryPrivateKey
        , HexPrivateKey
        , Wif
        , HexPublicKey
        , BinaryPublicKey
        , PublicKeyHash
        , ProgramHash
        , Address
        , Account
        , TransactionData
        , Asset
        , AssetName
        , CoinData
        , Transactions
        , Transaction
        , TransactionId
        , AssetId
        , SignatureData
        , ContractData
        , generateBinaryPrivateKey
        , generateHexPrivateKey
        , getWIFFromBinaryPrivateKey
        , getWIFFromHexPrivateKey
        , getBinaryPrivateKeyFromWIF
        , getHexPrivateKeyFromWIF
        , getAccountFromBinaryPrivateKey
        , getAccountFromHexPrivateKey
        , getAccountFromBinaryPublicKey
        , getAccountFromHexPublicKey
        , neoAssetId
        , gasAssetId
        , getTransferData
        , getSignatureData
        , getContractData
        , getBinaryPublicKeyFromHexPrivateKey
        , getBinaryPublicKeyFromBinaryPrivateKey
        , getHexPublicKeyFromBinaryPrivateKey
        , getHexPublicKeyFromHexPrivateKey
        )

{-| Elm Neo provides tools for the neo wallet and crypto.

@docs BinaryPrivateKey, HexPrivateKey, Wif, HexPublicKey, BinaryPublicKey, generateBinaryPrivateKey, generateHexPrivateKey, getWIFFromBinaryPrivateKey, getWIFFromHexPrivateKey, getBinaryPrivateKeyFromWIF,
      PublicKeyHash, ProgramHash, Address, Account, TransactionData, getHexPrivateKeyFromWIF, getAccountFromBinaryPrivateKey, getAccountFromHexPrivateKey, getAccountFromBinaryPublicKey,
      getAccountFromHexPublicKey, Asset, AssetName, CoinData, Transactions, Transaction, TransactionId, neoAssetId, gasAssetId, AssetId, getTransferData,
      SignatureData, getSignatureData, ContractData, getContractData, getBinaryPublicKeyFromHexPrivateKey,getBinaryPublicKeyFromBinaryPrivateKey,getHexPublicKeyFromBinaryPrivateKey,getHexPublicKeyFromHexPrivateKey


-}

import Native.Neo
import Task exposing (Task)


{-| BinaryPrivateKey

providing context to List Int

-}
type alias BinaryPrivateKey =
    List Int


{-| HexPrivateKey

providing context to List Int

-}
type alias HexPrivateKey =
    String


{-| Wif

providing context to String

-}
type alias Wif =
    String


{-| HexPublicKey

providing context to String

-}
type alias HexPublicKey =
    String


{-| BinaryPublicKey

providing context to List Int

-}
type alias BinaryPublicKey =
    List Int


{-| PublicKeyHash

providing context to String

-}
type alias PublicKeyHash =
    String


{-| ProgramHash

providing context to String

-}
type alias ProgramHash =
    String


{-| Address

providing context to String

-}
type alias Address =
    String


{-| TransactionData

providing context to String

-}
type alias TransactionData =
    String


{-| SignatureData

providing context to String

-}
type alias SignatureData =
    String


{-| ContractData

providing context to String

-}
type alias ContractData =
    String


{-| Asset

providing context to asset

-}
type Asset
    = Neo AssetId
    | Gas AssetId


{-| AssetId

providing context to string

-}
type alias AssetId =
    String


{-| neoAssetId

special assetId for NEO

-}
neoAssetId : AssetId
neoAssetId =
    "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"


{-| gasAssetId

special assetId for GAS

-}
gasAssetId : AssetId
gasAssetId =
    "602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"


{-| AssetName

providing context to string

-}
type alias AssetName =
    String


{-| Transactions

cointainer for transactions

-}
type alias Transactions =
    List Transaction


{-| TransactionId

providing context to string

-}
type alias TransactionId =
    String


{-| Transaction

cointainer for Transaction

-}
type alias Transaction =
    { index : Int
    , transactionId : TransactionId
    , value : Float
    }


{-| CoinData

cointainer for coin data

-}
type alias CoinData =
    { assetId : AssetId
    , unspent : Transactions
    , balance : Float
    , name : AssetName
    }


{-| Account

container for wallet info

-}
type alias Account =
    { binaryPrivateKey : BinaryPrivateKey
    , hexPrivateKey : HexPrivateKey
    , binaryPublicKey : BinaryPublicKey
    , hexPublicKey : HexPublicKey
    , publicKeyHash : PublicKeyHash
    , programHash : ProgramHash
    , address : Address
    }


{-| generateBinaryPrivateKey

uses secure-random to generate a private key

-}
generateBinaryPrivateKey : Task x BinaryPrivateKey
generateBinaryPrivateKey =
    Native.Neo.generateBinaryPrivateKey


{-| generateHexPrivateKey

uses secure-random to generate a private key

-}
generateHexPrivateKey : Task x HexPrivateKey
generateHexPrivateKey =
    Native.Neo.generateHexPrivateKey


{-| getWIFFromBinaryPrivateKey

gets a WIF from a binary private key

-}
getWIFFromBinaryPrivateKey : BinaryPrivateKey -> Result String Wif
getWIFFromBinaryPrivateKey binaryPrivateKey =
    Native.Neo.getWIFFromBinaryPrivateKey binaryPrivateKey


{-| getWIFFromHexPrivateKey

gets a WIF from a hex private key

-}
getWIFFromHexPrivateKey : HexPrivateKey -> Result String Wif
getWIFFromHexPrivateKey hexPrivateKey =
    Native.Neo.getWIFFromHexPrivateKey hexPrivateKey


{-| getBinaryPrivateKeyFromWIF

gets a binary private key from a WIF

-}
getBinaryPrivateKeyFromWIF : Wif -> Result String BinaryPrivateKey
getBinaryPrivateKeyFromWIF wif =
    Native.Neo.getBinaryPrivateKeyFromWIF wif


{-| getHexPrivateKeyFromWIF

gets a hex private key from a WIF

-}
getHexPrivateKeyFromWIF : Wif -> Result String HexPrivateKey
getHexPrivateKeyFromWIF wif =
    Native.Neo.getHexPrivateKeyFromWIF wif


{-| getAccountFromBinaryPrivateKey

gets wallet info from a binary private key

-}
getAccountFromBinaryPrivateKey : BinaryPrivateKey -> Result String Account
getAccountFromBinaryPrivateKey binaryPrivateKey =
    Native.Neo.getAccountFromBinaryPrivateKey binaryPrivateKey


{-| getAccountFromBinaryPrivateKey

gets wallet info from a binary private key

-}
getAccountFromHexPrivateKey : HexPrivateKey -> Result String Account
getAccountFromHexPrivateKey hexPrivateKey =
    Native.Neo.getAccountFromHexPrivateKey hexPrivateKey


{-| getAccountFromBinaryPublicKey

gets wallet info from a binary public key

-}
getAccountFromBinaryPublicKey : BinaryPublicKey -> Result String Account
getAccountFromBinaryPublicKey binaryPublicKey =
    Native.Neo.getAccountFromBinaryPublicKey binaryPublicKey


{-| getAccountFromHexPublicKey

gets wallet info from a hex public key

-}
getAccountFromHexPublicKey : HexPublicKey -> Result String Account
getAccountFromHexPublicKey hexPublicKey =
    Native.Neo.getAccountFromHexPublicKey hexPublicKey


{-| getTransferData

gets transaction transfer data

-}
getTransferData : CoinData -> BinaryPublicKey -> Address -> Float -> TransactionData
getTransferData coinData binaryPublicKey toAddress value =
    Native.Neo.getTransferData coinData binaryPublicKey toAddress value


{-| getSignatureData

gets signature data

-}
getSignatureData : TransactionData -> BinaryPrivateKey -> SignatureData
getSignatureData transactionData binaryPrivateKey =
    Native.Neo.getSignatureData transactionData binaryPrivateKey


{-| getContractData

gets contract data

-}
getContractData : TransactionData -> SignatureData -> BinaryPublicKey -> SignatureData
getContractData transactionData signatureData binaryPublicKey =
    Native.Neo.getContractData transactionData signatureData binaryPublicKey


{-| getBinaryPublicKeyFromHexPrivateKey

gets a binary public key from a hex private key

-}
getBinaryPublicKeyFromHexPrivateKey : HexPrivateKey -> Bool -> BinaryPublicKey
getBinaryPublicKeyFromHexPrivateKey hexPrivateKey shouldEncode =
    Native.Neo.getBinaryPublicKeyFromHexPrivateKey hexPrivateKey shouldEncode


{-| getBinaryPublicKeyFromBinaryPrivateKey

gets a binary public key from a binary private key

-}
getBinaryPublicKeyFromBinaryPrivateKey : BinaryPrivateKey -> Bool -> BinaryPublicKey
getBinaryPublicKeyFromBinaryPrivateKey binaryPrivateKey shouldEncode =
    Native.Neo.getBinaryPublicKeyFromBinaryPrivateKey binaryPrivateKey shouldEncode


{-| getHexPublicKeyFromBinaryPrivateKey

gets a hex public key from a binary private key

-}
getHexPublicKeyFromBinaryPrivateKey : BinaryPrivateKey -> Bool -> HexPublicKey
getHexPublicKeyFromBinaryPrivateKey binaryPrivateKey shouldEncode =
    Native.Neo.getHexPublicKeyFromBinaryPrivateKey binaryPrivateKey shouldEncode


{-| getHexPublicKeyFromHexPrivateKey

gets a hex public key from a hex private key

-}
getHexPublicKeyFromHexPrivateKey : HexPrivateKey -> Bool -> HexPublicKey
getHexPublicKeyFromHexPrivateKey hexPrivateKey shouldEncode =
    Native.Neo.getHexPublicKeyFromHexPrivateKey hexPrivateKey shouldEncode
