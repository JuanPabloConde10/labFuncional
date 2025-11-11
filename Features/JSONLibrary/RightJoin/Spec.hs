module Features.JSONLibrary.RightJoin.Spec (testRightJoin) where

import JSONLibrary
import TestSupport

{- rightJoin:
   Similar a leftJoin pero los campos del segundo objeto tienen prioridad
   y los del primero se agregan luego si no había clave.
-}
testRightJoin :: TestCase
testRightJoin = TestCase "rightJoin keeps right keys on conflicts" $ do
  let left = [("1", mkJNull ()), ("3", mkJNull ())]
      right = [("1", mkJBoolean True), ("2", mkJNull ())]
      expected = [("1", mkJBoolean True), ("2", mkJNull ()), ("3", mkJNull ())]
  assertObjectEqual "rightJoin result" expected (rightJoin left right)
