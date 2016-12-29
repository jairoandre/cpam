module Main exposing (..)

import Html exposing (Html)
import View exposing (view)
import Types exposing (..)
import Rest exposing (..)
import Scrollable exposing (tickScrollableBag)
import Window
import Task
import Time


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
    ( initModel, Cmd.batch [ setScale, fetchCpam ] )


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

        TickTime newTime ->
            case model.cpam of
                Nothing ->
                    ( model, Cmd.none )

                Just bag ->
                    ( { model | cpam = Just (tickScrollableBag bag 20 10), counter = (model.counter + 1) % 1000 }, Cmd.none )

        ReceiveCpam (Ok cpam) ->
            ( { model | cpam = Just (cpamToScrollableBag cpam), loading = False, date = cpam.date, counter = 0 }, Cmd.none )

        ReceiveCpam (Err m) ->
            ( { model | loading = False, message = Just (toString m), counter = 0 }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second TickTime ]
