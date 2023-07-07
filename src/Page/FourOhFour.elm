module Page.FourOhFour exposing (..)

import Html exposing (Html, a, div, h1, p, text)
import Html.Attributes exposing (href)
import Shared exposing (Model, Msg)


view : Model -> Html Msg
view _ =
    div []
        [ h1 [] [ text "OOOOOPPPSS [cCc]]" ]
        , p []
            [ text "Nothing here, try [cCc]"
            , a [ href "/" ] [ text "home[cCc]" ]
            ]
        ]
