module Data.Pattern exposing
    ( Pattern
    , getBreatheIn
    , getBreatheOut
    , getHoldIn
    , getPauseOut
    , init
    , read
    , withBreatheIn
    , withBreatheOut
    , withHoldIn
    , withPauseOut
    )


type Pattern
    = Pattern PatternInternal


init : Pattern
init =
    PatternInternal 4 4 4 4
        |> Pattern


withBreatheIn : Int -> Pattern -> Pattern
withBreatheIn n pattern =
    with withBreatheInInternal n pattern


withHoldIn : Int -> Pattern -> Pattern
withHoldIn n pattern =
    with withHoldInInternal n pattern


withBreatheOut : Int -> Pattern -> Pattern
withBreatheOut n pattern =
    with withBreatheOutInternal n pattern


withPauseOut : Int -> Pattern -> Pattern
withPauseOut n pattern =
    with withPauseOutInternal n pattern


getBreatheIn : Pattern -> Int
getBreatheIn =
    get .breatheIn


getHoldIn : Pattern -> Int
getHoldIn =
    get .holdIn


getBreatheOut : Pattern -> Int
getBreatheOut =
    get .breatheOut


getPauseOut : Pattern -> Int
getPauseOut =
    get .pauseOut


type alias PatternInternal =
    { breatheIn : Int
    , holdIn : Int
    , breatheOut : Int
    , pauseOut : Int
    }


read : Pattern -> { breatheIn : Int, holdIn : Int, breatheOut : Int, pauseOut : Int }
read (Pattern data) =
    data


with : (Int -> PatternInternal -> PatternInternal) -> Int -> Pattern -> Pattern
with f n pattern =
    pattern
        |> read
        |> f (minZero n)
        |> Pattern


get : (PatternInternal -> Int) -> Pattern -> Int
get accessor pattern =
    pattern
        |> read
        |> accessor


minZero : number -> number
minZero =
    max 0


withBreatheInInternal : Int -> PatternInternal -> PatternInternal
withBreatheInInternal n pattern =
    { pattern | breatheIn = n }


withHoldInInternal : Int -> PatternInternal -> PatternInternal
withHoldInInternal n pattern =
    { pattern | holdIn = n }


withBreatheOutInternal : Int -> PatternInternal -> PatternInternal
withBreatheOutInternal n pattern =
    { pattern | breatheOut = n }


withPauseOutInternal : Int -> PatternInternal -> PatternInternal
withPauseOutInternal n pattern =
    { pattern | pauseOut = n }
