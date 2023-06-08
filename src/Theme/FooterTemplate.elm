module Theme.FooterTemplate exposing (..)

import Html exposing (Html, a, footer, p, text)
import Html.Attributes exposing (href)


view : Html msg
view =
    footer []
        [ p
            []
            [ a [ href "/settings" ] [ text "[cCc] settings" ]
            ]
        ]
