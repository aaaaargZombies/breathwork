module Shared exposing (Model, Msg(..), Pattern, Phase(..))

import Browser
import Browser.Navigation
import I18n.Translate exposing (Language(..))
import Route exposing (Route(..))
import Time
import Url


type alias Model =
    { key : Browser.Navigation.Key
    , page : Route
    , language : Language
    , pattern : Pattern
    , phase : Phase
    , paused : Bool
    , bpm : Float

    -- add a exercise routine in here probably it's own type as well
    -- what did I mean by this? like how many times to do an inhale/exhale or duration?
    }


type alias Pattern =
    { inhaleLength : Int
    , topLength : Int
    , topActive : Bool
    , exhaleLength : Int
    , bottomLength : Int
    , bottomActive : Bool
    }


type Phase
    = Inhale Int
    | Top Int
    | Exhale Int
    | Bottom Int


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | Tick Time.Posix
    | PauseUnpause
    | PatternChanged Pattern
    | PaceChanged Float
