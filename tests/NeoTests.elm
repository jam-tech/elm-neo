module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Test.Runner.Html
import Expect exposing (Expectation)
import TestHelper exposing (it)
import Neo exposing (..)


main : Test.Runner.Html.TestProgram
main =
    [ suite
    ]
        |> concat
        |> Test.Runner.Html.run


suite : Test
suite =
    describe "Neo"
        [ it "should generate a hex private key" (Expect.equal (String.length generateHexPrivateKey) 64)
        , it "should generate a binary private key" (Expect.equal (List.length generateBinaryPrivateKey) 32)
        , it "should get a wif from the binary private key" (Expect.equal (getWIFFromBinaryPrivateKey binaryPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        , it "should get a wif from the hex private key" (Expect.equal (getWIFFromHexPrivateKey hexPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        , it "should get a binary private key from a wif" (Expect.equal (getBinaryPrivateKeyFromWIF wif) binaryPrivateKey)
        , it "should get a hex private key from a wif" (Expect.equal (getHexPrivateKeyFromWIF wif) hexPrivateKey)
--        , it "should get a binary private key from a wif" (Expect.equal (getAccountFromPrivateKey binaryPrivateKey) account)
        ]


binaryPrivateKey : BinaryPrivateKey
binaryPrivateKey =
    [ 198, 92, 83, 247, 95, 217, 95, 1, 185, 25, 130, 202, 248, 55, 239, 113, 163, 210, 104, 87, 71, 227, 145, 177, 145, 182, 217, 88, 1, 181, 8, 136 ]


binaryPublicKey : BinaryPublicKey
binaryPublicKey =
    [ 198, 92, 83, 247, 95, 217, 95, 1, 185, 25, 130, 202, 248, 55, 239, 113, 163, 210, 104, 87, 71, 227, 145, 177, 145, 182, 217, 88, 1, 181, 8, 136 ]


hexPrivateKey : HexPrivateKey
hexPrivateKey =
  "c65c53f75fd95f01b91982caf837ef71a3d2685747e391b191b6d95801b50888"

wif : Wif
wif =
    "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU"


account : Account
account =
    { binaryPrivateKey = binaryPrivateKey
    , hexPrivateKey = ""
    , binaryPublicKey = binaryPublicKey
    , hexPublicKey = ""
    , publicKeyHash = ""
    , programHash = ""
    , address = ""
    }
