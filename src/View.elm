module View exposing (..)

import Html exposing (Html, text, div, span)
import Html.Attributes exposing (..)
import Types exposing (..)


customDiv : String -> String -> Html Msg -> Html Msg
customDiv oClass iClass elem =
    div [ class oClass ]
        [ div [ class iClass ]
            [ elem ]
        ]


stringToLi : String -> String -> Html Msg
stringToLi liClass str =
    div [ class liClass ] [ text str ]


rollList : Int -> List a -> List a
rollList counter list =
    let
        len =
            List.length list
    in
        if len < 5 then
            list
        else
            (List.drop (counter % len) list) ++ (List.take (counter % len) list)


cutDate : String -> String
cutDate date =
    String.slice 0 9 date


pacienteToRow : Int -> Int -> Paciente -> Html Msg
pacienteToRow counter idx paciente =
    let
        zebra =
            if (idx % 2 == 0) then
                " zebra"
            else
                ""

        medicamentos =
            div [ class "ul--items" ]
                (rollList counter <|
                    (List.map (stringToLi "li--item li--suspensos") paciente.suspensos)
                        ++ (List.map (stringToLi "li--item li--agora") paciente.agora)
                        ++ (List.map (stringToLi "li--item li--urgente") paciente.urgente)
                )

        alergias =
            div [ class "ul--items" ]
                (rollList counter (List.map (stringToLi "li--item li--alergia") paciente.alergias))
    in
        div [ class ("row row--" ++ (toString idx) ++ zebra) ]
            [ customDiv "column column--info column--leito" "l-padd" <| text paciente.apto
            , customDiv "column column--info column--atendimento" "l-padd" <| text (toString paciente.atendimento)
            , customDiv "column column--info column--paciente" "l-padd" <| text paciente.nome
            , customDiv "column column--datas column--altaMedica" "t-center" <| text (cutDate paciente.altaMedica)
            , customDiv "column column--datas column--altaHospitalar" "t-center" <| span [ class "span--altaHospitalar" ] [ text (cutDate paciente.altaHospitalar) ]
            , customDiv "column column--meds column--medicamentos" "l-padd tb-padd" <| medicamentos
            , customDiv "column column--alergias" "l-padd tb-padd" <| alergias
            ]


rows : Model -> List (Html Msg)
rows model =
    case model.cpam of
        Nothing ->
            []

        Just cpam ->
            case (List.head (List.drop cpam.page cpam.items)) of
                Nothing ->
                    []

                Just setor ->
                    List.indexedMap (pacienteToRow model.counter) (List.take 10 (List.drop (10 * setor.page) setor.items))


view : Model -> Html Msg
view model =
    let
        message =
            case model.message of
                Nothing ->
                    []

                Just m ->
                    [ text m ]

        title =
            case model.cpam of
                Nothing ->
                    "Carregando..."

                Just cpam ->
                    case (List.head (List.drop cpam.page cpam.items)) of
                        Nothing ->
                            "Carregando..."

                        Just setor ->
                            setor.title ++ " - " ++ model.date
    in
        div
            [ class "content"
            , style
                [ ( "-ms-transform", "scale(" ++ (toString model.scale) ++ ")" )
                , ( "-webkit-transform", "scale(" ++ (toString model.scale) ++ ")" )
                , ( "transform", "scale(" ++ (toString model.scale) ++ ")" )
                ]
            ]
            [ div [ class "header" ]
                [ customDiv "h-header h-title" "l-padd" <| text title
                , customDiv "h-header h-leito" "l-padd" <| text "LEITO"
                , customDiv "h-header h-atendimento" "l-padd" <| text "ATEND."
                , customDiv "h-header h-paciente" "l-padd" <| text "PACIENTE"
                , customDiv "h-header h-data-alta" "t-center" <| text "DATA ALTA"
                , customDiv "h-header h-alta-medica" "t-center" <| text "MÉD."
                , customDiv "h-header h-alta-hospitalar" "t-center" <| text "HOSP."
                , customDiv "h-header h-medicamentos" "l-padd" <| text "MEDICAMENTOS"
                  --, customDiv "h-header h-suspensos" "l-padd" <| text "SUSPENSOS"
                  --, customDiv "h-header h-agora" "l-padd" <| text "AGORA"
                  --, customDiv "h-header h-urgente" "l-padd" <| text "URGENTE"
                , customDiv "h-header h-alergia" "l-padd" <| text "ALERGIA"
                ]
            , div [ class "rows" ]
                (message ++ (rows model))
            ]
