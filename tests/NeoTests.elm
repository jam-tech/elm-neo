module NeoTests exposing (..)

import Json.Encode as JE
import Test exposing (..)
import Expect exposing (Expectation)
import Neo

it : String -> Expect.Expectation -> Test
it title content =
    test title <| \() -> content



-- Tests


suite : Test
suite =
    describe "JsonTransform"
        [ it "pass" (Expect.equal (List.length Neo.generatePrivateKey) 32)
           ]