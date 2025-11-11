module Features.JSONLibrary.Constructors.MkJString.Spec (testMkJString) where

import JSONLibrary
import TestSupport

{- mkJString:
   Constructor público para crear valores JSON de tipo cadena.
-}
testMkJString :: TestCase
testMkJString = TestCase "mkJString builds JSON strings" $ do
  assertEqual "round-trip" (Just "hola") (fromJString (mkJString "hola"))
