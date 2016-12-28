module Main exposing (..)

import Html exposing (Html)
import View exposing (view)
import Types exposing (..)
import Rest exposing (..)
import Window
import Task


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initModel, setScale )


setScale : Cmd Msg
setScale =
    Task.perform Scale Window.size


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Loading ->
            ( model, Cmd.none )

        Scale newSize ->
            ( { model | scale = (toFloat newSize.width) / 1920.0 }, Cmd.none )

        FetchCpam ->
            ( { model | loading = True }, fetchCpam )

        ReceiveCpam (Ok cpam) ->
            ( { model | cpam = Just cpam, loading = False }, Cmd.none )

        ReceiveCpam (Err m) ->
            ( { model | loading = False }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
