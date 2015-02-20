import Graphics.Element (Element)

import Text (asText)

type Foo = Bar Int

main : Element
main = asText (toString (create Bar))

create : (Int -> Foo) -> Foo
create foo = foo 1
