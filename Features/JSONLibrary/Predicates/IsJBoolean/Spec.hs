module Features.JSONLibrary.Predicates.IsJBoolean.Spec (testIsJBoolean) where

import JSONLibrary
import TestSupport

{- isJBoolean:
   Predicado que determina si un valor JSON es booleano.
-}
testIsJBoolean :: TestCase
testIsJBoolean = TestCase "isJBoolean detects booleans" $ do
  assertBool "boolean recognized" (isJBoolean (mkJBoolean True))
  assertBool "non-boolean rejected" (not (isJBoolean (mkJNumber 1)))
