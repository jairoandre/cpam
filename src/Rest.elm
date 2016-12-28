module Rest exposing (..)

import Http
import Types exposing (..)


fetchCpam : Cmd Msg
fetchCpam =
    Http.send ReceiveCpam (Http.get "http://10.1.0.105:8080/painel/rest/api/cpam" decodeCpam)
