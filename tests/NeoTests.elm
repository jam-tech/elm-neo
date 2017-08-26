module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Test.Runner.Html
import Expect exposing (Expectation)
import TestHelper exposing (it)
import Neo exposing (..)


main : Test.Runner.Html.TestProgram
main =
    [ privateAndPublicKeys
    , accounts
    ]
        |> concat
        |> Test.Runner.Html.run


privateAndPublicKeys : Test
privateAndPublicKeys =
    describe "Private and public keys"
        [ it "should generate a hex private key" (Expect.equal (String.length generateHexPrivateKey) 64)
        , it "should generate a binary private key" (Expect.equal (List.length generateBinaryPrivateKey) 32)
        , it "should get a wif from the binary private key" (Expect.equal (getWIFFromBinaryPrivateKey binaryPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        , it "should get a wif from the hex private key" (Expect.equal (getWIFFromHexPrivateKey hexPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        , it "should get a binary private key from a wif" (Expect.equal (getBinaryPrivateKeyFromWIF wif) binaryPrivateKey)
        , it "should get a hex private key from a wif" (Expect.equal (getHexPrivateKeyFromWIF wif) hexPrivateKey)
        ]


accounts : Test
accounts =
    describe "Wallet account info"
        [ it "it should return an account given a binary private key" (Expect.equal (getAccountFromBinaryPrivateKey binaryPrivateKey) account)
        , it "it should return an account given a hex private key" (Expect.equal (getAccountFromHexPrivateKey hexPrivateKey) account)
        , it "it should return an account given a binary public key" (Expect.equal (getAccountFromBinaryPublicKey binaryPublicKey) publicAccount)
        , it "it should return an account given a hex public key" (Expect.equal (getAccountFromHexPublicKey hexPublicKey) publicAccount)
        ]

--transactions : Test
--transactions =
--    describe "Wallet account info"
--        [ it "it should return a binary private key" (Expect.equal (getAccountFromBinaryPrivateKey binaryPrivateKey) account)
--        ]

binaryPrivateKey : BinaryPrivateKey
binaryPrivateKey =
    [ 198, 92, 83, 247, 95, 217, 95, 1, 185, 25, 130, 202, 248, 55, 239, 113, 163, 210, 104, 87, 71, 227, 145, 177, 145, 182, 217, 88, 1, 181, 8, 136 ]


binaryPublicKey : BinaryPublicKey
binaryPublicKey =
    [ 2, 87, 60, 96, 100, 125, 15, 68, 184, 112, 213, 143, 215, 59, 168, 131, 28, 100, 95, 26, 114, 133, 52, 227, 86, 113, 203, 87, 20, 149, 7, 83, 208 ]


hexPrivateKey : HexPrivateKey
hexPrivateKey =
    "c65c53f75fd95f01b91982caf837ef71a3d2685747e391b191b6d95801b50888"


hexPublicKey : HexPublicKey
hexPublicKey =
    "02573c60647d0f44b870d58fd73ba8831c645f1a728534e35671cb5714950753d0"


wif : Wif
wif =
    "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU"


account : Account
account =
    { binaryPrivateKey = binaryPrivateKey
    , hexPrivateKey = hexPrivateKey
    , binaryPublicKey = binaryPublicKey
    , hexPublicKey = hexPublicKey
    , publicKeyHash = "6375ccb1d4b858877b3aa73529774041d7173fc3"
    , programHash = "8d7e6a027f7586747da6f5f3b820135360472256"
    , address = "AUg2MxB9uLfFSGy1EpMiGR75KFAmhUjAH4"
    }

publicAccount : Account
publicAccount =
    { binaryPrivateKey = []
    , hexPrivateKey = ""
    , binaryPublicKey = binaryPublicKey
    , hexPublicKey = hexPublicKey
    , publicKeyHash = "6375ccb1d4b858877b3aa73529774041d7173fc3"
    , programHash = "8d7e6a027f7586747da6f5f3b820135360472256"
    , address = "AUg2MxB9uLfFSGy1EpMiGR75KFAmhUjAH4"
    }