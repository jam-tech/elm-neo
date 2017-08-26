module Main exposing (..)


import Html exposing (Html, text)
import Neo exposing (generateBinaryPrivateKey, getWIFFromBinaryPrivateKey)

main : Html a
main =
    let
     pk = Debug.log "priv key" generateBinaryPrivateKey
     wif = Debug.log "wif" (getWIFFromBinaryPrivateKey pk)
    in
      text "Woop"