module TestHelper exposing (it)

import Test exposing (..)
import Expect exposing (Expectation)

it : String -> Expect.Expectation -> Test
it title content =
    test title <| \() -> content
