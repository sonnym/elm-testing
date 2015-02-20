import Array (..)
import Color (..)
import List

import Graphics.Element (..)
import Graphics.Element as Element

import Svg (..)
import Svg.Attributes as SvgAttr
import Svg.Lazy (lazy)

import Html (Html)

type alias Grid = Array (Array Color)

(width,height) = (720,480)

main : Html
main = (lazy canvas) grid

canvas : Grid -> Html
canvas grid = svg
  [SvgAttr.version "1.1", SvgAttr.x "0", SvgAttr.y "0", SvgAttr.viewBox "0 0 720 480"]
  (polygons grid)

polygons : Grid -> List Svg
polygons grid =
  List.foldr (\(x,column) lst ->
    (List.foldr (\(y,color) lst ->
      (rect [ SvgAttr.fill "#000000"
            , SvgAttr.x (toString x)
            , SvgAttr.y (toString y)
            , SvgAttr.width "1"
            , SvgAttr.height "1"
            ] []) :: lst)
      lst column))
    [] (toIndexedList (map toIndexedList grid))

grid : Grid
grid = repeat width (repeat height blue)
