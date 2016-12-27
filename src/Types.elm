module Types exposing (..)


type alias Model =
    { loading : Bool
    }


initModel : Model
initModel =
    Model True


type Msg
    = Loading
