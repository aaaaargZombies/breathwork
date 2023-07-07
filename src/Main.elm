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
      , pattern = { inhaleLength = 3, exhaleLength = 6, topLength = 1, bottomLength = 1, topActive = False, bottomActive = False }
      , phase = Inhale 3
      , paused = True
      , bpm = 60
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
            onTick model

        PauseUnpause ->
            ( { model | paused = not model.paused }, Cmd.none )

        PatternChanged p ->
            ( { model | pattern = p }, Cmd.none )

        PaceChanged n ->
            ( { model | bpm = n }, Cmd.none )


onTick : Model -> ( Model, Cmd Msg )
onTick model =
    case model.phase of
        Inhale i ->
            case i of
                1 ->
                    if model.pattern.topActive then
                        ( { model | phase = Top model.pattern.topLength }, noise i )

                    else
                        ( { model | phase = Exhale model.pattern.exhaleLength }, noise i )

                _ ->
                    ( { model | phase = Inhale (i - 1) }, noise i )

        Top i ->
            case i of
                1 ->
                    ( { model | phase = Exhale model.pattern.exhaleLength }, noise i )

                _ ->
                    ( { model | phase = Top (i - 1) }, noise i )

        Exhale i ->
            case i of
                1 ->
                    if model.pattern.bottomActive then
                        ( { model | phase = Bottom model.pattern.bottomLength }, noise i )

                    else
                        ( { model | phase = Inhale model.pattern.inhaleLength }, noise i )

                _ ->
                    ( { model | phase = Exhale (i - 1) }, noise i )

        Bottom i ->
            case i of
                1 ->
                    ( { model | phase = Inhale model.pattern.inhaleLength }, noise i )

                _ ->
                    ( { model | phase = Bottom (i - 1) }, noise i )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none

    else
        let
            duration =
                (model.bpm / 60) * 1000

            -- _ =
            --     Debug.log "bpm in millis" (String.fromFloat duration)
        in
        Time.every duration Tick


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
