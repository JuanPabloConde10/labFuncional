module Features.JSONLibrary.LeftJoin.Spec (testLeftJoin) where

import JSONLibrary
import TestSupport

{- leftJoin:
   Concatena dos objetos priorizando los campos del primero cuando hay
   claves repetidas y agregando al final las nuevas claves del segundo.
-}
testLeftJoin :: TestCase
testLeftJoin = TestCase "leftJoin keeps left keys on conflicts" $ do
  let left = [("1", mkJNull ()), ("3", mkJNull ())]
      right = [("1", mkJBoolean True), ("2", mkJNull ())]
      expected = [("1", mkJNull ()), ("3", mkJNull ()), ("2", mkJNull ())]
  assertObjectEqual "leftJoin result" expected (leftJoin left right)
