module Features.JSONLibrary.Destructors.FromJNumber.Spec (testFromJNumber) where

import JSONLibrary
import TestSupport

{- fromJNumber:
   Extrae el entero contenido en un valor JSON numérico o Nothing en otro caso.
-}
testFromJNumber :: TestCase
testFromJNumber = TestCase "fromJNumber extracts numbers safely" $ do
  assertEqual "extracts number" (Just 10) (fromJNumber (mkJNumber 10))
  assertEqual "rejects non-number" Nothing (fromJNumber (mkJString "x"))
