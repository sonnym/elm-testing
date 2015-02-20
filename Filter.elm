import Signal
import List

import Char (fromCode)
import Text (asText)
import Keyboard (KeyCode, keysDown)

main = Signal.map asText (Signal.map (lookup 'I') keysDown)

lookup : Char -> List KeyCode -> List Char
lookup key keyCodes =
  List.filter (\k -> k == key) (List.map fromCode keyCodes)
