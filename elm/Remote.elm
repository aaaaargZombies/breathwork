port module Remote exposing (OutMsg(..), outgoing, outgoingValue)

import Json.Encode exposing (Value)


type OutMsg
    = Play
    | Stop


outgoingValue : OutMsg -> { tag : String, data : Value }
outgoingValue msg =
    case msg of
        Play ->
            { tag = "PLAY", data = Json.Encode.null }

        Stop ->
            { tag = "STOP", data = Json.Encode.null }


port outgoing : { tag : String, data : Json.Encode.Value } -> Cmd msg
