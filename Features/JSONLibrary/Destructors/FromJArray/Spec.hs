module Features.JSONLibrary.Destructors.FromJArray.Spec (testFromJArray) where

import JSONLibrary
import TestSupport

{- fromJArray:
   Permite obtener la lista de elementos de un arreglo JSON cuando el
   valor tiene dicho constructor.
-}
testFromJArray :: TestCase
testFromJArray = TestCase "fromJArray extracts arrays safely" $ do
  let arr = mkJArray [mkJNumber 1, mkJNumber 2]
  assertJust "extracts array elements" (fromJArray arr) $ \xs ->
    assertEqual "length preserved" 2 (length xs)
  assertNothing "rejects non-array" (fromJArray (mkJBoolean True))
