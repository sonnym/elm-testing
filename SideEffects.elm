import Signal (..)

import List ((::))
import Time (every, millisecond, second)

import Char (toCode)
import Text (asText)
import String

import Keyboard (KeyCode, lastPressed)

import Graphics.Element (Element)

main : Signal Element
main = map (hook 's') keypress

keypress : Signal (Maybe KeyCode)
keypress = merge (map Just lastPressed) (sampleOn (every second) (constant Nothing))

hook : Char -> Maybe KeyCode -> Element
hook key code =
  let
    output = asText code
  in
    case code of
      Just c ->
        if | (toCode key) == c -> output
           | otherwise -> output
      Nothing -> output
