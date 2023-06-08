module Route exposing (Route(..), fromUrl, toString)

import Url
import Url.Parser as Parser exposing (Parser, map, oneOf, s, string, top)


type Route
    = Index
    | Settings
    | FourOhFour String


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    { url | path = url.path }
        |> Parser.parse routeParser


toString : Route -> String
toString route =
    case route of
        Index ->
            "/"

        Settings ->
            "/settings"

        FourOhFour s ->
            "/" ++ s


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Index top
        , map Settings (s "settings")
        , map FourOhFour string
        ]
