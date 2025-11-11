module Features.JSONLibrary.Destructors.FromJObject.Spec (testFromJObject) where

import JSONLibrary
import TestSupport

{- fromJObject:
   Retorna los pares clave/valor si el JSON es un objeto; Nothing en otro caso.
-}
testFromJObject :: TestCase
testFromJObject = TestCase "fromJObject extracts objects safely" $ do
  let obj = mkJObject [("k", mkJNumber 1)]
  assertJust "extracts entries" (fromJObject obj) $ \entries ->
    assertEqual "preserves key" ["k"] (map fst entries)
  assertNothing "rejects non-object" (fromJObject (mkJNumber 1))
