module Features.JSONLibrary.LookupField.Spec (testLookupField) where

import JSONLibrary
import TestSupport

{- lookupField:
   Cuando el primer argumento es un objeto y la clave coincide con la
   buscada, se retorna el valor JSON (Just). De lo contrario se retorna
   Nothing. Si la clave se repite, se toma el valor más a la derecha.
-}
testLookupField :: TestCase
testLookupField = TestCase "lookupField respects key presence and priority" $ do
  let obj = mkJObject [("k", mkJNumber 1), ("k", mkJNumber 2), ("x", mkJBoolean True)]
  assertNothing "non-object input returns Nothing" (lookupField (mkJString "not object") "k")
  assertNothing "missing key returns Nothing" (lookupField obj "missing")
  assertJust "returns right-most occurrence" (lookupField obj "k") $ \val ->
    assertEqual "should pick last value" (Just 2) (fromJNumber val)
