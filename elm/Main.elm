module Main exposing (main)

import Browser
import Data.Pattern as Pattern exposing (Pattern)
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Remote


type alias Model =
    Pattern


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    ( Pattern.init, Cmd.none )


type Msg
    = USerPressedPlay
    | UserPressedStop
    | UserSetBreatheIn String
    | UserSetBreatheOut String
    | USerSetHoldIn String
    | UserSetPauseOut String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        USerPressedPlay ->
            ( model
            , Remote.Play
                |> Remote.outgoingValue
                |> Remote.outgoing
            )

        UserPressedStop ->
            ( model
            , Remote.Stop
                |> Remote.outgoingValue
                |> Remote.outgoing
            )

        UserSetBreatheIn choice ->
            let
                model_ : Model
                model_ =
                    makeChoice Pattern.withBreatheIn choice model
            in
            ( model_, Cmd.none )

        UserSetBreatheOut choice ->
            let
                model_ : Model
                model_ =
                    makeChoice Pattern.withBreatheOut choice model
            in
            ( model_, Cmd.none )

        USerSetHoldIn choice ->
            let
                model_ : Model
                model_ =
                    makeChoice Pattern.withHoldIn choice model
            in
            ( model_, Cmd.none )

        UserSetPauseOut choice ->
            let
                model_ : Model
                model_ =
                    makeChoice Pattern.withPauseOut choice model
            in
            ( model_, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ Html.div []
            [ phaseView { msg = UserSetBreatheIn, get = Pattern.getBreatheIn, label = "Breathe In", pattern = model }
            , phaseView { msg = USerSetHoldIn, get = Pattern.getHoldIn, label = "Hold In", pattern = model }
            , phaseView { msg = UserSetBreatheOut, get = Pattern.getBreatheOut, label = "Breathe Out", pattern = model }
            , phaseView { msg = UserSetPauseOut, get = Pattern.getPauseOut, label = "Pause Out", pattern = model }
            ]
        , div []
            [ button [ onClick USerPressedPlay ] [ text "Play" ]
            , button [ onClick UserPressedStop ] [ text "Stop" ]
            ]
        ]


phaseView : { msg : String -> Msg, get : Pattern -> Int, pattern : Pattern, label : String } -> Html Msg
phaseView { msg, get, pattern, label } =
    let
        val =
            pattern |> get |> String.fromInt
    in
    Html.label []
        [ Html.text label
        , Html.input
            [ Html.Attributes.type_ "number", Html.Attributes.value val, Html.Events.onInput msg ]
            []
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


makeChoice : (Int -> Pattern -> Pattern) -> String -> Pattern -> Pattern
makeChoice withA userInput pattern =
    let
        n : Int
        n =
            userInput
                |> String.toInt
                |> Maybe.withDefault 0

        pattern_ : Model
        pattern_ =
            withA n pattern
    in
    pattern_
