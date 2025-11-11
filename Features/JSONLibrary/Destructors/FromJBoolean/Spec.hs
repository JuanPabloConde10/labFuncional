module Features.JSONLibrary.Destructors.FromJBoolean.Spec (testFromJBoolean) where

import JSONLibrary
import TestSupport

{- fromJBoolean:
   Extrae el booleano subyacente si el JSON es de tipo booleano.
-}
testFromJBoolean :: TestCase
testFromJBoolean = TestCase "fromJBoolean extracts booleans safely" $ do
  assertEqual "extracts boolean" (Just False) (fromJBoolean (mkJBoolean False))
  assertEqual "rejects non-boolean" Nothing (fromJBoolean (mkJNumber 0))
