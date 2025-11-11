module Features.JSONLibrary.Predicates.IsJObject.Spec (testIsJObject) where

import JSONLibrary
import TestSupport

{- isJObject:
   Predicado que verifica si un valor JSON es un objeto.
-}
testIsJObject :: TestCase
testIsJObject = TestCase "isJObject detects objects" $ do
  assertBool "object recognized" (isJObject (mkJObject []))
  assertBool "non-object rejected" (not (isJObject (mkJArray [])))
