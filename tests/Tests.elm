module Tests exposing (..)

import Test exposing (Test)
import Expect
import Fuzz


suite : Test
suite =
    Test.fuzz Fuzz.int "has no effect on a one-item list" <|
        \num ->
            List.reverse [ num ]
                |> Expect.equal [ num ]
