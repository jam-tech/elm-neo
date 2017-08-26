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
        , generateBinaryPrivateKey
        , generateHexPrivateKey
        , getWIFFromBinaryPrivateKey
        , getWIFFromHexPrivateKey
        , getBinaryPrivateKeyFromWIF
        , getHexPrivateKeyFromWIF
          --        , getAccountFromPrivateKey
        )

{-| Elm Neo provides tools for the neo wallet and crypto.

@docs BinaryPrivateKey, HexPrivateKey, Wif, HexPublicKey, BinaryPublicKey, generateBinaryPrivateKey, generateHexPrivateKey, getWIFFromBinaryPrivateKey, getWIFFromHexPrivateKey, getBinaryPrivateKeyFromWIF ,PublicKeyHash, ProgramHash, Address, Account, getHexPrivateKeyFromWIF

-}

import Native.Neo


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
generateBinaryPrivateKey : BinaryPrivateKey
generateBinaryPrivateKey =
    Native.Neo.generateBinaryPrivateKey


{-| generateHexPrivateKey

uses secure-random to generate a private key

-}
generateHexPrivateKey : HexPrivateKey
generateHexPrivateKey =
    Native.Neo.generateHexPrivateKey


{-| getWIFFromBinaryPrivateKey

gets a WIF from a binary private key

-}
getWIFFromBinaryPrivateKey : BinaryPrivateKey -> Wif
getWIFFromBinaryPrivateKey binaryPrivateKey =
    Native.Neo.getWIFFromBinaryPrivateKey binaryPrivateKey


{-| getWIFFromHexPrivateKey

gets a WIF from a hex private key

-}
getWIFFromHexPrivateKey : HexPrivateKey -> Wif
getWIFFromHexPrivateKey hexPrivateKey =
    Native.Neo.getWIFFromHexPrivateKey hexPrivateKey


{-| getBinaryPrivateKeyFromWIF

gets a binary private key from a WIF

-}
getBinaryPrivateKeyFromWIF : Wif -> BinaryPrivateKey
getBinaryPrivateKeyFromWIF wif =
    Native.Neo.getBinaryPrivateKeyFromWIF wif


{-| getHexPrivateKeyFromWIF

gets a hex private key from a WIF

-}
getHexPrivateKeyFromWIF : Wif -> HexPrivateKey
getHexPrivateKeyFromWIF wif =
    Native.Neo.getHexPrivateKeyFromWIF wif



--{-| getAccountFromPrivateKey
--
--gets wallet info from a binary private key
--
---}
--getAccountFromPrivateKey : BinaryPrivateKey -> Account
--getAccountFromPrivateKey binaryPrivateKey =
--    Native.Neo.getAccountFromPrivateKey binaryPrivateKey
