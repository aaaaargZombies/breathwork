module Page.Settings exposing (..)

import Html exposing (Html, button, div, h2, input, label, p, text)
import Html.Attributes exposing (checked, placeholder, type_, value)
import Html.Events exposing (onInput)
import Shared exposing (Model, Msg(..), Pattern, Phase(..))


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


updatePatternLength : Pattern -> Phase -> String -> Pattern
updatePatternLength pa ph s =
    let
        n =
            Maybe.withDefault 1 (String.toInt s)

        i =
            if n < 1 then
                1

            else
                n

        _ =
            Debug.log "i is " i
    in
    case ph of
        Inhale _ ->
            { pa | inhaleLength = i }

        Top _ ->
            { pa | topLength = i }

        Exhale _ ->
            { pa | exhaleLength = i }

        Bottom _ ->
            { pa | bottomLength = i }


updateHoldStatus : Pattern -> HoldType -> Pattern
updateHoldStatus oldPattern topOfBottom =
    case topOfBottom of
        TopStatus ->
            { oldPattern | topActive = not oldPattern.topActive }

        BottomStatus ->
            { oldPattern | bottomActive = not oldPattern.bottomActive }


type HoldType
    = TopStatus
    | BottomStatus


view : Model -> Html Msg
view model =
    div []
        [ h2 []
            [ text " [ccc] Breath pattern" ]
        , div
            []
            [ label []
                [ text "[ccc] inhale"
                , viewInput "number" "3" (String.fromInt model.pattern.inhaleLength) (\s -> PatternChanged (updatePatternLength model.pattern (Inhale 0) s))
                ]
            , label []
                [ text "[ccc] top"
                , viewInput "number" "0" (String.fromInt model.pattern.topLength) (\s -> PatternChanged (updatePatternLength model.pattern (Top 0) s))
                ]
            , label []
                [ text "[ccc] top active"
                , input [ type_ "checkbox", checked model.pattern.topActive, onInput (\_ -> PatternChanged (updateHoldStatus model.pattern TopStatus)) ] []
                ]
            , label []
                [ text "[ccc] exhale"
                , viewInput "number" "6" (String.fromInt model.pattern.exhaleLength) (\s -> PatternChanged (updatePatternLength model.pattern (Exhale 0) s))
                ]
            , label []
                [ text "[ccc] bottom"
                , viewInput "number" "0" (String.fromInt model.pattern.bottomLength) (\s -> PatternChanged (updatePatternLength model.pattern (Bottom 0) s))
                ]
            , label []
                [ text "[ccc] bottom active"
                , input [ type_ "checkbox", checked model.pattern.bottomActive, onInput (\_ -> PatternChanged (updateHoldStatus model.pattern BottomStatus)) ] []
                ]
            , button [] []
            , h2 []
                [ text " [ccc] Pace (BPM)" ]
            , div
                []
                [ label []
                    [ text "[ccc] beats per minute"
                    , viewInput "number" "3" (String.fromFloat model.bpm) (\s -> PaceChanged (Maybe.withDefault 60 (String.toFloat s)))
                    ]
                , button [] []
                ]
            ]
        ]
