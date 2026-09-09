module Tests exposing (..)

import Data.Pattern as Pattern
import Expect
import Fuzz exposing (Fuzzer)
import Test exposing (Test)


fuzzPatternInput : Fuzzer ( ( Int, Int ), ( Int, Int ) )
fuzzPatternInput =
    let
        l =
            Fuzz.pair Fuzz.int Fuzz.int

        r =
            Fuzz.pair Fuzz.int Fuzz.int
    in
    Fuzz.pair l r


suite : Test
suite =
    Test.fuzz fuzzPatternInput "has no effect on a one-item list" <|
        \( ( a, b ), ( c, d ) ) ->
            Pattern.init
                |> Pattern.withBreatheIn a
                |> Pattern.withBreatheOut b
                |> Pattern.withHoldIn c
                |> Pattern.withPauseOut d
                |> (\p ->
                        [ Pattern.getBreatheIn p, Pattern.getBreatheOut p, Pattern.getHoldIn p, Pattern.getPauseOut p ]
                            |> List.foldr (\phase currentMin -> min phase currentMin) 0
                            |> Expect.equal 0
                   )
