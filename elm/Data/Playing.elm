module Data.Playing exposing (Playing(..), invert)


type Playing
    = Playing
    | Stopped


invert : Playing -> Playing
invert playing =
    case playing of
        Playing ->
            Stopped

        Stopped ->
            Playing
