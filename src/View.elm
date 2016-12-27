module View exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ div [ class "header" ] []
        , div [ class "rows" ] []
        ]
