module Main exposing (..)


import Html exposing (Html, text)
import Neo exposing (generatePrivateKey)

main : Html a
main =
    let
     _ = Debug.log "priv key" generatePrivateKey
    in
      text "Woop"