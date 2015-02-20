import Signal (..)

import String (toInt)
import Text (leftAligned, fromString)

import Color (..)
import Graphics.Collage (..)
import Graphics.Element (..)
import Graphics.Input.Field (..)

{--
main : Element
main = collage 40 20 [moveX 20 (filled black (square 20.0))]
--}

main : Signal Element
main = map3 scene (subscribe widthChannel) (subscribe sizeChannel) (subscribe offsetChannel)

scene : Content -> Content -> Content -> Element
scene widthContent sizeContent offsetContent =
  let
    width = extractValue widthContent
    size = extractValue sizeContent
    offset = extractValue offsetContent
  in
    flow down
      [ flow right
          [ leftAligned (fromString "collage width")
          , field defaultStyle (send widthChannel) "" widthContent
          ]


      , flow right
          [ leftAligned (fromString "size")
          , field defaultStyle (send sizeChannel) "" sizeContent
          ]

      , flow right
          [ leftAligned (fromString "offset x")
          , field defaultStyle (send offsetChannel) "" offsetContent
          ]

      , collage width size [moveX (toFloat offset) (filled black (square (toFloat size)))]
      ]

extractValue : Content -> Int
extractValue content =
  let
    result = toInt content.string
  in
    case result of
      Ok value -> value
      Err msg -> 0

widthChannel : Channel Content
widthChannel = channel (Content "40" (Selection 0 0 Forward))

sizeChannel : Channel Content
sizeChannel = channel (Content "20" (Selection 0 0 Forward))

offsetChannel : Channel Content
offsetChannel = channel (Content "40" (Selection 0 0 Forward))
