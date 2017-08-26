module Neo
    exposing
        ( generateBinaryPrivateKey
        , getWIFFromBinaryPrivateKey
        )

{-| Elm Neo provides tools for the neo wallet and crypto.

@docs generateBinaryPrivateKey, getWIFFromBinaryPrivateKey

-}

import Native.Neo


{-| generateBinaryPrivateKey

uses secure-random to generate a private key

-}
generateBinaryPrivateKey : List Int
generateBinaryPrivateKey =
    Native.Neo.generateBinaryPrivateKey


{-| getWIFFromBinaryPrivateKey

gets a WIF from a binary private key

-}
getWIFFromBinaryPrivateKey : List Int -> String
getWIFFromBinaryPrivateKey binaryPrivateKey =
    Native.Neo.getWIFFromBinaryPrivateKey binaryPrivateKey
