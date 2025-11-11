module Features.JSONLibrary.Predicates.IsJNull.Spec (testIsJNull) where

import JSONLibrary
import TestSupport

{- isJNull:
   Predicado que detecta si un valor JSON es null.
-}
testIsJNull :: TestCase
testIsJNull = TestCase "isJNull detects null" $ do
  assertBool "null recognized" (isJNull (mkJNull ()))
  assertBool "non-null rejected" (not (isJNull (mkJNumber 0)))
