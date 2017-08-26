module Neo
    exposing
        ( generatePrivateKey
        )

{-| Elm Neo provides tools for the neo wallet and crypto.

@docs generatePrivateKey

-}

import Native.Neo


{-| generatePrivateKey

uses window.crypto to generate a private key

-}
generatePrivateKey : List Int
generatePrivateKey =
    List.reverse Native.Neo.generatePrivateKey



