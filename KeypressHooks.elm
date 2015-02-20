import Signal (..)

import Keyboard (KeyCode, keysDown)

import Debug

import List
import List ((::))

import Char (toCode, fromCode)
import Text (asText, fromString, justified)

import Graphics.Element (..)
import Graphics.Input as Input

type Action
  = NoOp
  | Increment
  | Decrement
  | AllowKeyboard Bool

type alias State = {
  value: Int,
  hooks: List (Char, Action)
}

main : Signal Element
main = map scene state

scene : State -> Element
scene state =
  let
    incrementButton = button "(I) ncrement" 'I'
    decrementButton = button "(D) ecrement" 'D'
  in
    flow down
      [ flow right [incrementButton, decrementButton]
      , flow right
        [ justified (fromString "Keyboard Shortcuts: ")
        , Input.dropDown (send updates) [("Enable", AllowKeyboard True), ("Disable", AllowKeyboard False)]
        ]
      , asText state.value
      ]

state : Signal State
state = foldp step initialState (map2 (,) (subscribe updates) keysDown)

step : (Action, List KeyCode) -> State -> State
step (action, keyCodes) ({hooks} as state) =
  applicator (action :: (List.map (lookup hooks) keyCodes)) state

applicator : List Action -> State -> State
applicator actions state =
  case actions of
    action::rest -> applicator rest (apply action state)
    [] -> state

apply : Action -> State -> State
apply action ({value} as state) =
  case action of
    NoOp -> state

    AllowKeyboard False -> { state | hooks <- [] }
    AllowKeyboard True -> { state | hooks <- defaultActions }

    Increment -> { state | value <- value + 1 }
    Decrement -> { state | value <- value - 1 }

lookup : List (Char, Action) -> KeyCode -> Action
lookup hooks keyCode =
  let
    match = List.filter (\pair -> (toCode (fst pair)) == keyCode) hooks
  in
    if | List.length match > 0 -> snd (List.head match)
       | otherwise -> NoOp

initialState : State
initialState = {value=0,hooks=defaultActions}

defaultActions : List (Char, Action)
defaultActions = [('I', Increment), ('D', Decrement)]

updates : Channel Action
updates = channel NoOp

button : String -> Char -> Element
button label char = Input.button (send updates (lookup defaultActions (toCode char))) label
