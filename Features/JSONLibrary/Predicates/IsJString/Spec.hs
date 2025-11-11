module Features.JSONLibrary.Predicates.IsJString.Spec (testIsJString) where

import JSONLibrary
import TestSupport

{- isJString:
   Predicado que identifica valores JSON que representan cadenas.
-}
testIsJString :: TestCase
testIsJString = TestCase "isJString detects strings" $ do
  assertBool "string recognized" (isJString (mkJString "x"))
  assertBool "non-string rejected" (not (isJString (mkJNumber 1)))
