module Shared exposing (Model, Msg(..), Pattern, Phase(..), encodedPattern, patterDecoder)

import Browser
import Browser.Navigation
import I18n.Translate exposing (Language(..))
import Json.Decode
import Json.Encode
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

    -- add a exercise routine in here probably it's own type as well
    }


{-| Zero indexed measure of time in seconds
-}
type alias Pattern =
    { inhale : Int
    , top : Int
    , exhale : Int
    , bottom : Int
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


patterDecoder : Json.Decode.Decoder Pattern
patterDecoder =
    Json.Decode.map4 Pattern
        (Json.Decode.field "exhale" Json.Decode.int)
        (Json.Decode.field "top" Json.Decode.int)
        (Json.Decode.field "inhale" Json.Decode.int)
        (Json.Decode.field "bottom" Json.Decode.int)


encodedPattern : Pattern -> Json.Encode.Value
encodedPattern pattern =
    Json.Encode.object
        [ ( "exhale", Json.Encode.int pattern.exhale )
        , ( "top", Json.Encode.int pattern.inhale )
        , ( "inhale", Json.Encode.int pattern.inhale )
        , ( "bottom", Json.Encode.int pattern.inhale )
        ]
