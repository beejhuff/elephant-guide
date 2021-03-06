module Components.Deck.Model exposing (..)

import ID exposing (..)
import Components.Archetype as Archetype
import Components.Card as Card
import Components.Decklist as Decklist exposing (..)
import Dict
import Json.Encode as JE exposing (..)
import Json.Decode as JD exposing (..)
import Json.Decode.Pipeline exposing (required, hardcoded, decode)
import TableMetrics exposing (..)
import Slot exposing (..)
import Material exposing (Model, model)
import Material.Layout


type alias Model =
    { archetypes : List Archetype.Model
    , cards : List Card.Model
    , maindeck : Decklist
    , sideboard : Decklist
    , name : String
    , notes : String
    , targetSize : Int
    , nextId : ID
    , tableMetrics : Maybe TableMetrics
    , dragState : DragState
    , editState : EditState
    , addCardValue : String
    , hoverColumn : Maybe Int
    , tab : Int
    , mdl : Material.Model
    }


type DragState
    = NotDragging
    | Dragging Int Int


type EditState
    = NotEditing
    | EditingCardName ID String
    | EditingArchetypeSlot Slot String


initialModel : Model
initialModel =
    { archetypes = []
    , cards = []
    , name = ""
    , notes = ""
    , targetSize = 60
    , maindeck = Dict.empty
    , sideboard = Dict.empty
    , nextId = 1
    , tableMetrics = Nothing
    , dragState = NotDragging
    , editState = NotEditing
    , addCardValue = ""
    , hoverColumn = Nothing
    , tab = 0
    , mdl = materialModel
    }


materialModel : Material.Model
materialModel =
    Material.Layout.setTabsWidth 1000 Material.model


encoder : Model -> JE.Value
encoder model =
    JE.object
        [ ( "archetypes", JE.list (List.map Archetype.encoder model.archetypes) )
        , ( "cards", JE.list (List.map Card.encoder model.cards) )
        , ( "maindeck", Decklist.encoder model.maindeck )
        , ( "sideboard", Decklist.encoder model.sideboard )
        , ( "name", JE.string model.name )
        , ( "notes", JE.string model.notes )
        , ( "targetSize", JE.int model.targetSize )
        , ( "nextId", JE.int model.nextId )
        ]


decoder : Decoder Model
decoder =
    decode Model
        |> required "archetypes" (JD.list Archetype.decoder)
        |> required "cards" (JD.list Card.decoder)
        |> required "maindeck" Decklist.decoder
        |> required "sideboard" Decklist.decoder
        |> required "name" JD.string
        |> required "notes" JD.string
        |> required "targetSize" JD.int
        |> required "nextId" JD.int
        |> hardcoded Nothing
        |> hardcoded NotDragging
        |> hardcoded NotEditing
        |> hardcoded ""
        |> hardcoded Nothing
        |> hardcoded 0
        |> hardcoded materialModel
