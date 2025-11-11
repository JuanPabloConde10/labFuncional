module Features.JSONLibrary.Constructors.MkJBoolean.Spec (testMkJBoolean) where

import JSONLibrary
import TestSupport

{- mkJBoolean:
   Constructor para valores JSON booleanos.
-}
testMkJBoolean :: TestCase
testMkJBoolean = TestCase "mkJBoolean builds JSON booleans" $ do
  assertEqual "round-trip" (Just True) (fromJBoolean (mkJBoolean True))
