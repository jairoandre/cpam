module Types exposing (..)

import Http
import Json.Decode as JD
import Window


type alias Model =
    { loading : Bool
    , scale : Float
    , cpam : Maybe Cpam
    }


initModel : Model
initModel =
    Model True 0.65 Nothing


type Msg
    = Loading
    | Scale Window.Size
    | FetchCpam
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


type alias Setor =
    { nome : String
    , pacientes : List Paciente
    }


decodeSetor : JD.Decoder Setor
decodeSetor =
    JD.map2 Setor
        (JD.field "nome" JD.string)
        (JD.field "pacientes" (JD.list decodePaciente))


type alias Paciente =
    { apto : String
    , atendimento : Int
    , nome : String
    , altaMedica : String
    , altaHospitalar : String
    , suspensos : List String
    , agora : List String
    , urgente : List String
    }


decodePaciente : JD.Decoder Paciente
decodePaciente =
    JD.map8 Paciente
        (JD.field "apto" JD.string)
        (JD.field "atendimento" JD.int)
        (JD.field "nome" JD.string)
        (JD.field "altaMedica" JD.string)
        (JD.field "altaHospitalar" JD.string)
        (JD.field "suspensos" (JD.list JD.string))
        (JD.field "agora" (JD.list JD.string))
        (JD.field "urgente" (JD.list JD.string))
