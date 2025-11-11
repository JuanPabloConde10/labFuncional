module Features.JSONLibrary.ValuesOf.Spec (testValuesOf) where

import JSONLibrary
import TestSupport

{- valuesOf:
   Retorna la lista de valores de un objeto manteniendo el orden en que
   aparecen sus campos.
-}
testValuesOf :: TestCase
testValuesOf = TestCase "valuesOf preserves order of values" $ do
  let obj = [("c", mkJNull ()), ("a", mkJBoolean True), ("b", mkJNumber 4)]
      expected = [mkJNull (), mkJBoolean True, mkJNumber 4]
      actual = valuesOf obj
  assertBool "values follow key order"
    (length expected == length actual && and (zipWith jsonEquals expected actual))
