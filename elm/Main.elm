module Main exposing (main)

import Browser
import Data exposing (Model, Playing(..))
import Data.Pattern as Pattern exposing (Pattern)
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Remote


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    ( { pattern = Pattern.init, playing = Stopped }, Cmd.none )


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
            ( { model | playing = Playing }
            , model.pattern
                |> Remote.Play
                |> Remote.outgoingValue
                |> Remote.outgoing
            )

        UserPressedStop ->
            ( { model | playing = Stopped }
            , Remote.Stop
                |> Remote.outgoingValue
                |> Remote.outgoing
            )

        UserSetBreatheIn choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Pattern.withBreatheIn choice model.pattern }
            in
            ( model_, Cmd.none )

        UserSetBreatheOut choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Pattern.withBreatheOut choice model.pattern }
            in
            ( model_, Cmd.none )

        USerSetHoldIn choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Pattern.withHoldIn choice model.pattern }
            in
            ( model_, Cmd.none )

        UserSetPauseOut choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Pattern.withPauseOut choice model.pattern }
            in
            ( model_, Cmd.none )


view : Model -> Html Msg
view { pattern } =
    div []
        [ Html.div
            [ Html.Attributes.style "display" "flex"
            , Html.Attributes.style "flex-direction" "column"
            ]
            [ phaseView { msg = UserSetBreatheIn, get = Pattern.getBreatheIn, label = "Breathe In", pattern = pattern }
            , phaseView { msg = USerSetHoldIn, get = Pattern.getHoldIn, label = "Hold In", pattern = pattern }
            , phaseView { msg = UserSetBreatheOut, get = Pattern.getBreatheOut, label = "Breathe Out", pattern = pattern }
            , phaseView { msg = UserSetPauseOut, get = Pattern.getPauseOut, label = "Pause Out", pattern = pattern }
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


subscriptions : Model -> Sub msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


makeChoice : (Int -> Pattern -> Pattern) -> String -> Pattern -> Pattern
makeChoice withA userInput pattern =
    let
        n : Int
        n =
            userInput
                |> String.toInt
                |> Maybe.withDefault 0

        pattern_ : Pattern
        pattern_ =
            withA n pattern
    in
    pattern_
