module Features.JSONLibrary.Constructors.MkJObject.Spec (testMkJObject) where

import JSONLibrary
import TestSupport

{- mkJObject:
   Constructor para objetos JSON a partir de una lista de pares clave/valor.
-}
testMkJObject :: TestCase
testMkJObject = TestCase "mkJObject builds JSON objects" $ do
  let obj = mkJObject [("k", mkJNumber 1)]
  assertJust "object can be deconstructed" (fromJObject obj) $ \entries ->
    assertEqual "single entry preserved" 1 (length entries)
