module Tests exposing (..)

import Expect
import Fuzz
import Test exposing (Test)


suite : Test
suite =
    Test.fuzz Fuzz.int "has no effect on a one-item list" <|
        \num ->
            List.reverse [ num ]
                |> Expect.equal [ num ]
