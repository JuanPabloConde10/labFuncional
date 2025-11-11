module Features.JSONLibrary.Constructors.MkJNumber.Spec (testMkJNumber) where

import JSONLibrary
import TestSupport

{- mkJNumber:
   Constructor para valores JSON numéricos (enteros).
-}
testMkJNumber :: TestCase
testMkJNumber = TestCase "mkJNumber builds JSON numbers" $ do
  assertEqual "round-trip" (Just 42) (fromJNumber (mkJNumber 42))
