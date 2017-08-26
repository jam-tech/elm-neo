module Neo
    exposing
        ( generatePrivateKey
        )

{-| Elm Neo provides tools for the neo wallet and crypto.

@docs generatePrivateKey

-}

import Native.Neo


{-| generatePrivateKey

uses secure-random to generate a private key

-}
generatePrivateKey : List Int
generatePrivateKey =
    Native.Neo.generatePrivateKey



