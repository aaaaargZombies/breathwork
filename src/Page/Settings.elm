module Page.Settings exposing (..)

import Html exposing (Html, button, div, input, label, p, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)
import Shared exposing (Model, Msg(..), Pattern, Phase(..))


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


updatePattern : Pattern -> Phase -> String -> Pattern
updatePattern pa ph s =
    let
        i =
            Maybe.withDefault 0 (String.toInt s)
    in
    case ph of
        Inhale _ ->
            { pa | inhale = i }

        Top _ ->
            { pa | top = i }

        Exhale _ ->
            { pa | exhale = i }

        Bottom _ ->
            { pa | bottom = i }


view : Model -> Html Msg
view model =
    div []
        [ label []
            [ text "[ccc] inhale"
            , viewInput "number" "3" (String.fromInt model.pattern.inhale) (\s -> PatternChanged (updatePattern model.pattern (Inhale 0) s))
            ]
        , label []
            [ text "[ccc] top"
            , viewInput "number" "0" (String.fromInt model.pattern.top) (\s -> PatternChanged (updatePattern model.pattern (Top 0) s))
            ]
        , label []
            [ text "[ccc] exhale"
            , viewInput "number" "6" (String.fromInt model.pattern.exhale) (\s -> PatternChanged (updatePattern model.pattern (Exhale 0) s))
            ]
        , label []
            [ text "[ccc] bottom"
            , viewInput "number" "0" (String.fromInt model.pattern.bottom) (\s -> PatternChanged (updatePattern model.pattern (Bottom 0) s))
            ]
        , button [] []
        ]
