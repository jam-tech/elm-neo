module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Expect exposing (Expectation)
import TestHelper exposing (it)
import Neo


suite : Test
suite =
    describe "Neo"
        [ it "should generate private key" (Expect.equal (List.length Neo.generatePrivateKey) 32)
        ]
