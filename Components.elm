import Signal (Signal, Channel, map, foldp, send, subscribe, channel)

import String (toInt)
import Text (leftAligned, fromString)

import Graphics.Element (..)
import Graphics.Input.Field (..)

type alias State = { value: Int }

type Action
  = NoOp
  | Value Content

main : Signal Element
main = map scene state

scene : State -> Element
scene state  =
  flow right
    [ leftAligned (fromString ("value: " ++ (toString state.value)))
    , numericField state.value
    ]

extractValue : Content -> Int
extractValue content =
  let
    result = toInt content.string
  in
    case result of
      Ok value -> value
      Err msg -> 0

state : Signal State
state = foldp step initialState (subscribe updates)

step : Action -> State -> State
step update state =
  case update of
    NoOp -> state
    Value content -> { state | value <- extractValue content }

numericField : Int -> Element
numericField value =
  field
    defaultStyle
    (\content -> send updates (Value content))
    ""
    (Content (toString value) (Selection 0 0 Forward))

initialState : State
initialState = { value = 1 }

updates : Channel Action
updates = channel NoOp
