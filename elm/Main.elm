module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Remote


type alias Model =
    { count : Int }


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    ( { count = 0 }, Cmd.none )


type Msg
    = Play
    | Stop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            ( model
            , Remote.Play
                |> Remote.outgoingValue
                |> Remote.outgoing
            )

        Stop ->
            ( model
            , Remote.Stop
                |> Remote.outgoingValue
                |> Remote.outgoing
            )


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick Play ] [ text "Play" ]
            , button [ onClick Stop ] [ text "Stop" ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
