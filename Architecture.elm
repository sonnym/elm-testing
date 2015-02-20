import Signal

import Text

import Graphics.Input as Input

import Graphics.Element (Element)
import Graphics.Element as Element

type alias State = { value: Int }

type Action
  = NoOp
  | Increment

main : Signal Element
main = Signal.map scene state

scene : State -> Element
scene state =
  Element.flow Element.down [incrementButton, (Text.asText state.value)]

state : Signal State
state = Signal.foldp step initialState (Signal.subscribe updates)

step : Action -> State -> State
step update state =
  case update of
    NoOp -> state
    Increment -> { state | value <- state.value + 1 }

initialState : State
initialState = { value = 0 }

updates : Signal.Channel Action
updates = Signal.channel NoOp

incrementButton : Element
incrementButton =
  Input.button (Signal.send updates Increment) "Increment"
