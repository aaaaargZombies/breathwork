module Theme.PageTemplate exposing (..)

import Html exposing (Html, div, main_)
import I18n.Keys exposing (Key(..))
import I18n.Translate exposing (Language(..))
import Route exposing (Route(..))
import Shared exposing (Model, Msg(..), Phase(..))
import Theme.FooterTemplate as FooterTemplate
import Theme.HeaderTemplate as HeaderTemplate


view : Model -> Html Msg -> Html Msg
view _ content =
    div []
        [ HeaderTemplate.view { content = "[cCc] Header" }
        , main_ []
            [ content
            ]
        , FooterTemplate.view
        ]
