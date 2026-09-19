module Data exposing (Model)

import Data.Pattern exposing (Pattern)
import Data.Playing exposing (Playing)


type alias Model =
    { pattern : Pattern
    , playing : Playing
    }
