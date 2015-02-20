import Color (..)
import List (..)

import Graphics.Element (..)
import Graphics.Element as Element

import Svg (..)
import Svg.Attributes (..)
import Html (Html)

type alias Grid = List (List Color)

main : Html
main =
  svg [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95" ]
    [ polygon [ fill "#F0AD00", points "161.649,152.782 231.514,82.916 91.783,82.916" ] []
    , polygon [ fill "#7FD13B", points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ] []
    , rect
      [ fill "#7FD13B", x "192.99", y "107.392", width "107.676", height "108.167"
      , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
      ]
    []
    , polygon [ fill "#60B5CC", points "323.298,143.724 323.298,0 179.573,0" ] []
    , polygon [ fill "#5A6378", points "152.781,161.649 0,8.868 0,314.432" ] []
    , polygon [ fill "#F0AD00", points "255.522,246.655 323.298,314.432 323.298,178.879" ] []
    , polygon [ fill "#60B5CC", points "161.649,170.517 8.869,323.298 314.43,323.298" ] []
    ]

(width,height) = (720,480)

gridToHtml : Grid -> Element
gridToHtml grid =
  flow left (map (\col ->
    flow down (map (\clr -> Element.color clr (spacer 1 1)) (col)))
  grid)

{--
gridToForm : Grid -> List Form
gridToForm grid =
  let
    indexed = Array.toIndexedList (Array.map Array.toIndexedList grid)
  in
    foldl (\indexedCol lst ->
      let
        x = fst indexedCol
        col = snd indexedCol
      in
        foldl (\indexedCell lst ->
          let
            y = fst indexedCell
            color = snd indexedCell

            pixel = square 1
              |> filled color
              |> move (-(toFloat width / 2) + toFloat x, (toFloat height / 2) - toFloat y)
        in
          pixel :: lst)
      lst col)
    [] indexed
--}

grid : Grid
grid = repeat width (repeat height blue)
