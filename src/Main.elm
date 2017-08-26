module Main exposing (..)


import Html exposing (Html, text)
import Neo exposing (generatePrivateKey, getWIFFromBinaryPrivateKey)

main : Html a
main =
    let
     pk = Debug.log "priv key" generatePrivateKey
     wif = Debug.log "wif" (getWIFFromBinaryPrivateKey pk)
    in
      text "Woop"