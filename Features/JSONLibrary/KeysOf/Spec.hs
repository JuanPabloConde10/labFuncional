module Features.JSONLibrary.KeysOf.Spec (testKeysOf) where

import JSONLibrary
import TestSupport

{- keysOf:
   Devuelve la lista de claves de un objeto manteniendo el orden original
   en el que aparecían dentro del Object.
-}
testKeysOf :: TestCase
testKeysOf = TestCase "keysOf preserves order of keys" $ do
  let obj = [("c", mkJNull ()), ("a", mkJBoolean True), ("b", mkJNumber 4)]
  assertEqual "keys remain in insertion order" ["c","a","b"] (keysOf obj)
