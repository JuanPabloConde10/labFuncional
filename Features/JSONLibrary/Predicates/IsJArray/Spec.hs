module Features.JSONLibrary.Predicates.IsJArray.Spec (testIsJArray) where

import JSONLibrary
import TestSupport

{- isJArray:
   Predicado que detecta si un valor JSON es un arreglo.
-}
testIsJArray :: TestCase
testIsJArray = TestCase "isJArray detects arrays" $ do
  assertBool "array recognized" (isJArray (mkJArray []))
  assertBool "non-array rejected" (not (isJArray (mkJObject [])))
