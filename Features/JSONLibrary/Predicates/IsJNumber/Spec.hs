module Features.JSONLibrary.Predicates.IsJNumber.Spec (testIsJNumber) where

import JSONLibrary
import TestSupport

{- isJNumber:
   Predicado que decide si un valor JSON es numérico.
-}
testIsJNumber :: TestCase
testIsJNumber = TestCase "isJNumber detects numbers" $ do
  assertBool "number recognized" (isJNumber (mkJNumber 5))
  assertBool "non-number rejected" (not (isJNumber (mkJString "x")))
