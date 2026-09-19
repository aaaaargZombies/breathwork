module Main exposing (main)

import Browser
import Browser.Events
import Data exposing (Model)
import Data.Pattern exposing (Pattern)
import Data.Playing exposing (Playing(..))
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Json.Decode
import Remote


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    ( { pattern = Data.Pattern.init, playing = Stopped }, Cmd.none )


type Msg
    = USerPressedPlay
    | UserPressedStop
    | UserSetBreatheIn String
    | UserSetBreatheOut String
    | USerSetHoldIn String
    | UserSetPauseOut String
    | UserToggledPlaying
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

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

        UserToggledPlaying ->
            case model.playing of
                Playing ->
                    ( { model | playing = Stopped }
                    , Remote.Stop
                        |> Remote.outgoingValue
                        |> Remote.outgoing
                    )

                Stopped ->
                    ( { model | playing = Playing }
                    , model.pattern
                        |> Remote.Play
                        |> Remote.outgoingValue
                        |> Remote.outgoing
                    )

        UserSetBreatheIn choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Data.Pattern.withBreatheIn choice model.pattern }
            in
            ( model_, Cmd.none )

        UserSetBreatheOut choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Data.Pattern.withBreatheOut choice model.pattern }
            in
            ( model_, Cmd.none )

        USerSetHoldIn choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Data.Pattern.withHoldIn choice model.pattern }
            in
            ( model_, Cmd.none )

        UserSetPauseOut choice ->
            let
                model_ : Model
                model_ =
                    { model | pattern = makeChoice Data.Pattern.withPauseOut choice model.pattern }
            in
            ( model_, Cmd.none )


view : Model -> Html Msg
view { pattern } =
    div []
        [ Html.div
            [ Html.Attributes.style "display" "flex"
            , Html.Attributes.style "flex-direction" "column"
            ]
            [ phaseView { msg = UserSetBreatheIn, get = Data.Pattern.getBreatheIn, label = "Breathe In", pattern = pattern }
            , phaseView { msg = USerSetHoldIn, get = Data.Pattern.getHoldIn, label = "Hold In", pattern = pattern }
            , phaseView { msg = UserSetBreatheOut, get = Data.Pattern.getBreatheOut, label = "Breathe Out", pattern = pattern }
            , phaseView { msg = UserSetPauseOut, get = Data.Pattern.getPauseOut, label = "Pause Out", pattern = pattern }
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


keyDecoder : Json.Decode.Decoder Msg
keyDecoder =
    Json.Decode.field "key" Json.Decode.string
        |> Json.Decode.map
            (\key ->
                case key of
                    " " ->
                        UserToggledPlaying

                    _ ->
                        NoOp
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown keyDecoder


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
