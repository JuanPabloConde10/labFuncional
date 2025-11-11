module Features.AST.Show.Spec (testShowInstance) where

{- Show (JSON):
   La instancia debe producir una representación textual válida de cada
   constructor de JSON para que pueda inspeccionarse o compararse.
-}

import AST
import JSONLibrary (mkJString, mkJNumber, mkJBoolean, mkJNull, mkJArray, mkJObject)
import TestSupport

testShowInstance :: TestCase
testShowInstance = TestCase "Show instance renders JSON literals" $ do
  assertEqual "string literal" "\"hola\"" (show (mkJString "hola"))
  assertEqual "number literal" "42" (show (mkJNumber 42))
  assertEqual "boolean literal" "true" (show (mkJBoolean True))
  assertEqual "null literal" "null" (show (mkJNull ()))
  assertEqual "array literal"
    "[1, 2]"
    (show (mkJArray [mkJNumber 1, mkJNumber 2]))
  assertEqual "object literal"
    "{\"a\": 1, \"b\": true}"
    (show (mkJObject [("a", mkJNumber 1), ("b", mkJBoolean True)]))
