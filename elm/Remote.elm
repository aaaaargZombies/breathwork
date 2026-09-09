port module Remote exposing (OutMsg(..), outgoing, outgoingValue)

import Data.Pattern exposing (Pattern)
import Json.Encode exposing (Value)


type OutMsg
    = Play Pattern
    | Stop


outgoingValue : OutMsg -> { tag : String, data : Value }
outgoingValue msg =
    case msg of
        Play _ ->
            { tag = "PLAY", data = Json.Encode.null }

        Stop ->
            { tag = "STOP", data = Json.Encode.null }


port outgoing : { tag : String, data : Json.Encode.Value } -> Cmd msg
