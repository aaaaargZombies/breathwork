module Page.Index exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
import I18n.Keys exposing (Key(..))
import I18n.Translate exposing (Language(..), translate)
import Route exposing (Route(..))
import Shared exposing (Model, Msg(..), Phase(..))


view : Model -> Html Msg
view model =
    let
        t =
            translate model.language

        n =
            case model.phase of
                Inhale i ->
                    String.fromInt (i + 1)

                Top i ->
                    String.fromInt (i + 1)

                Exhale i ->
                    String.fromInt (i + 1)

                Bottom i ->
                    String.fromInt (i + 1)

        btnTxt =
            if model.paused then
                UnpauseBtn

            else
                PauseBtn

        phaseTxt =
            case model.phase of
                Inhale _ ->
                    InhaleText

                Exhale _ ->
                    ExhaleText

                Top _ ->
                    TopText

                Bottom _ ->
                    BottomText
    in
    div []
        [ p [] [ text (t phaseTxt) ]
        , p []
            [ text n ]
        , button
            [ onClick PauseUnpause ]
            [ text (t btnTxt) ]
        ]
