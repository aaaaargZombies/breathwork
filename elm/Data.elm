module Data exposing (Model, Playing(..))

import Data.Pattern exposing (Pattern)


type alias Model =
    { pattern : Pattern
    , playing : Playing
    }


type Playing
    = Playing
    | Stopped
