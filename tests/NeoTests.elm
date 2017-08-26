module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Test.Runner.Html
import Expect exposing (Expectation)
import TestHelper exposing (it)
import Neo exposing (generateBinaryPrivateKey, getWIFFromBinaryPrivateKey)

main : Test.Runner.Html.TestProgram
main =
    [ suite
    ]
        |> concat
        |> Test.Runner.Html.run

suite : Test
suite =
    describe "Neo"
        [ it "should generate private key" (Expect.equal (List.length generateBinaryPrivateKey) 32)
        , it "should generate a wif from the private key" (Expect.equal (getWIFFromBinaryPrivateKey binaryPrivateKey) "L3sJEyvhJyhoknVXeGFGnJgmGNv8cAvK7VLCmn6BJy6BhRyGrhTU")
        ]


binaryPrivateKey : List Int
binaryPrivateKey =
 [ 198,92,83,247,95,217,95,1,185,25,130,202,248,55,239,113,163,210,104,87,71,227,145,177,145,182,217,88,1,181,8,136 ]