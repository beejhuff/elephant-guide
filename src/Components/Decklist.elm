module Components.Decklist exposing (..)

import Dict exposing (..)
import ID exposing (..)
import Json.Encode as JE exposing (..)


type alias Decklist =
    Dict ID Int


cardCount : Decklist -> Int
cardCount decklist =
    decklist |> Dict.values |> List.sum


slotValue : Decklist -> ID -> Int
slotValue decklist cardId =
    case Dict.get cardId decklist of
        Nothing ->
            0

        Just value ->
            value


encoder : Decklist -> JE.Value
encoder decklist =
    let
        decklistAsList =
            Dict.toList decklist

        encodeItem ( id, qty ) =
            JE.object
                [ ( "id", JE.int id )
                , ( "qty", JE.int qty )
                ]
    in
        JE.list (List.map encodeItem decklistAsList)
