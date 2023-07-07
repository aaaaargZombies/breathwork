module Theme.HeaderTemplate exposing (..)

import Html exposing (Html, a, h1, header, text)
import Html.Attributes exposing (href)


type alias HeaderInfo =
    { content : String }


view : HeaderInfo -> Html msg
view headerInfo =
    header []
        [ a [ href "/" ]
            [ h1
                []
                [ text headerInfo.content
                ]
            ]
        ]
