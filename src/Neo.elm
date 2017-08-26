module Neo
    exposing
        ( generatePrivateKey
        , getWIFFromBinaryPrivateKey
        )

{-| Elm Neo provides tools for the neo wallet and crypto.

@docs generatePrivateKey, getWIFFromBinaryPrivateKey

-}

import Native.Neo


{-| generatePrivateKey

uses secure-random to generate a private key

-}
generatePrivateKey : List Int
generatePrivateKey =
    Native.Neo.generatePrivateKey


{-| getWIFFromBinaryPrivateKey

gets a WIF from a binary private key

-}
getWIFFromBinaryPrivateKey : List Int -> String
getWIFFromBinaryPrivateKey binaryPrivateKey =
    Native.Neo.getWIFFromBinaryPrivateKey binaryPrivateKey
