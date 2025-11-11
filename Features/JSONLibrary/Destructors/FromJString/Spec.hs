module Features.JSONLibrary.Destructors.FromJString.Spec (testFromJString) where

import JSONLibrary
import TestSupport

{- fromJString:
   Descompone un JSON y retorna la cadena subyacente si el valor es string.
-}
testFromJString :: TestCase
testFromJString = TestCase "fromJString extracts strings safely" $ do
  assertEqual "extracts string" (Just "hola") (fromJString (mkJString "hola"))
  assertEqual "rejects non-string" Nothing (fromJString (mkJNumber 1))
