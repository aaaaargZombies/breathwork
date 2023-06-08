port module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (Html)
import I18n.Keys exposing (Key(..))
import I18n.Translate exposing (Language(..), translate)
import Page.FourOhFour
import Page.Index
import Page.Settings
import Route exposing (Route(..))
import Shared exposing (Model, Msg(..), Phase(..))
import Theme.PageTemplate
import Time
import Url


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


port noise : Int -> Cmd msg


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        maybeRoute =
            Route.fromUrl url
    in
    ( { key = key
      , page = Maybe.withDefault (FourOhFour "oops") maybeRoute
      , language = English
      , pattern = { inhale = 2, exhale = 5, top = 0, bottom = 0 }
      , phase = Inhale 2
      , paused = True
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChanged url ->
            let
                newRoute =
                    -- If not a valid route, go to index
                    -- could 404 instead depends on desired behaviour
                    Maybe.withDefault Index (Route.fromUrl url)
            in
            ( { model | page = newRoute }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        Tick _ ->
            case model.phase of
                Inhale i ->
                    case i of
                        0 ->
                            if model.pattern.top == 0 then
                                ( { model | phase = Exhale model.pattern.exhale }, noise i )

                            else
                                ( { model | phase = Top model.pattern.top }, noise i )

                        _ ->
                            ( { model | phase = Inhale (i - 1) }, noise i )

                Top i ->
                    case i of
                        0 ->
                            ( { model | phase = Exhale model.pattern.exhale }, noise i )

                        _ ->
                            ( { model | phase = Top (i - 1) }, noise i )

                Exhale i ->
                    case i of
                        0 ->
                            if model.pattern.bottom == 0 then
                                ( { model | phase = Inhale model.pattern.inhale }, noise i )

                            else
                                ( { model | phase = Bottom model.pattern.bottom }, noise i )

                        _ ->
                            ( { model | phase = Exhale (i - 1) }, noise i )

                Bottom i ->
                    case i of
                        0 ->
                            ( { model | phase = Inhale model.pattern.inhale }, noise i )

                        _ ->
                            ( { model | phase = Bottom (i - 1) }, noise i )

        PauseUnpause ->
            ( { model | paused = not model.paused }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none

    else
        Time.every 1000 Tick


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = translate model.language SiteTitle, body = [ view model ] }


view : Model -> Html Msg
view model =
    case model.page of
        Index ->
            Theme.PageTemplate.view model (Page.Index.view model)

        Settings ->
            Theme.PageTemplate.view model (Page.Settings.view model)

        FourOhFour _ ->
            Theme.PageTemplate.view model (Page.FourOhFour.view model)
