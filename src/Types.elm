module Types exposing (..)

import Http
import Window
import Time
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Scrollable exposing (..)


type alias Model =
    { loading : Bool
    , scale : Float
    , cpam : Maybe (ScrollableBag Paciente)
    , message : Maybe String
    , date : String
    , counter : Int
    }


initModel : Model
initModel =
    Model True 0.65 Nothing Nothing "" 0


type Msg
    = Loading
    | Scale Window.Size
    | FetchCpam Time.Time
    | TickTime Time.Time
    | ReceiveCpam (Result Http.Error Cpam)


type alias Cpam =
    { date : String
    , version : String
    , setores : List Setor
    }


decodeCpam : JD.Decoder Cpam
decodeCpam =
    JD.map3 Cpam
        (JD.field "date" JD.string)
        (JD.field "version" JD.string)
        (JD.field "setores" (JD.list decodeSetor))


cpamToScrollableBag : Cpam -> ScrollableBag Paciente
cpamToScrollableBag cpam =
    createScrollableBag (List.map setorToScrollable cpam.setores)


type alias Setor =
    { nome : String
    , pacientes : List Paciente
    }


decodeSetor : JD.Decoder Setor
decodeSetor =
    JD.map2 Setor
        (JD.field "nome" JD.string)
        (JD.field "pacientes" (JD.list decodePaciente))


setorToScrollable : Setor -> Scrollable Paciente
setorToScrollable setor =
    createScrollable setor.nome setor.pacientes


type alias Paciente =
    { apto : String
    , atendimento : Int
    , nome : String
    , altaMedica : String
    , altaHospitalar : String
    , suspensos : List String
    , agora : List String
    , urgente : List String
    , alergias : List String
    }


decodePaciente : JD.Decoder Paciente
decodePaciente =
    JDP.decode Paciente
        |> JDP.required "apto" JD.string
        |> JDP.required "atendimento" JD.int
        |> JDP.required "nome" JD.string
        |> JDP.optional "altaMedica" JD.string ""
        |> JDP.optional "altaHospitalar" JD.string ""
        |> JDP.required "suspensos" (JD.list JD.string)
        |> JDP.required "agora" (JD.list JD.string)
        |> JDP.required "urgente" (JD.list JD.string)
        |> JDP.required "alergias" (JD.list JD.string)
