module Features.JSONLibrary.Constructors.MkJArray.Spec (testMkJArray) where

import JSONLibrary
import TestSupport

{- mkJArray:
   Constructor para arreglos JSON a partir de una lista de valores.
-}
testMkJArray :: TestCase
testMkJArray = TestCase "mkJArray builds JSON arrays" $ do
  let arr = mkJArray [mkJNumber 1]
  assertJust "array can be deconstructed" (fromJArray arr) $ \xs ->
    assertEqual "length preserved" 1 (length xs)
