module View exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (..)
import Types exposing (..)


customDiv : String -> String -> Html Msg -> Html Msg
customDiv oClass iClass elem =
    div [ class oClass ]
        [ div [ class iClass ]
            [ elem ]
        ]


view : Model -> Html Msg
view model =
    div
        [ class "content"
        , style
            [ ( "-ms-transform", "scale(" ++ (toString model.scale) ++ ")" )
            , ( "-webkit-transform", "scale(" ++ (toString model.scale) ++ ")" )
            , ( "transform", "scale(" ++ (toString model.scale) ++ ")" )
            ]
        ]
        [ div [ class "header" ]
            [ customDiv "h-header h-leito" "l-padd" <| text "LEITO"
            , customDiv "h-header h-atendimento" "l-padd" <| text "ATEND."
            , customDiv "h-header h-paciente" "l-padd" <| text "PACIENTE"
            , customDiv "h-header h-data-alta" "l-padd" <| text "DATA ALTA"
            , customDiv "h-header h-alta-medica" "l-padd" <| text "MÉDICA"
            , customDiv "h-header h-alta-hospitalar" "l-padd" <| text "HOSPITALAR"
            , customDiv "h-header h-medicamentos" "t-center" <| text "MEDICAMENTOS"
            , customDiv "h-header h-suspensos" "l-padd" <| text "SUSPENSOS"
            , customDiv "h-header h-agora" "l-padd" <| text "AGORA"
            , customDiv "h-header h-urgente" "l-padd" <| text "URGENTE"
            , customDiv "h-header h-alergia" "l-padd" <| text "ALERGIA"
            ]
        , div [ class "rows" ]
            [ text (toString model) ]
        ]
