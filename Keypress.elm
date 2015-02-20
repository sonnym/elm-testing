import Signal (..)

import List ((::))
import Time (every, millisecond, second)

import Text (asText)
import String

import Keyboard (KeyCode, lastPressed, keysDown)

import Graphics.Element (Element)

main : Signal Element
main = map asText keysDown

keypresses : Signal (List (Maybe KeyCode))
keypresses = foldp (::) [] (dropIf (\k -> k == Nothing) Nothing keypress)

keypress : Signal (Maybe KeyCode)
keypress = merge (map Just lastPressed) (sampleOn (every millisecond) (constant Nothing))
