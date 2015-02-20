import Signal (Signal, Channel, map2, foldp, send, subscribe, channel)

import String (toInt)
import Text (leftAligned, fromString)

import Graphics.Element (..)
import Graphics.Input.Field (..)

type alias State = { value: Int }

type Action
  = NoOp
  | Value Int

main : Signal Element
main = map2 scene (state) (subscribe numericChannel)

scene : State -> Content -> Element
scene state content =
  let
    value = extractValue content
  in
    flow right
      [ leftAligned (fromString ("value: " ++ (toString value)))
      , numericField content
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
    Value value -> { state | value <- value }

initialState : State
initialState = { value = 1 }

updates : Channel Action
updates = channel NoOp

numericField : Content -> Element
numericField content =
  field defaultStyle (send numericChannel) "" content

numericChannel : Channel Content
numericChannel = channel (Content "5" (Selection 0 0 Forward))
