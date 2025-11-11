module Features.JSONLibrary.ConsKV.Spec (testConsKV) where

import JSONLibrary
import TestSupport

{- consKV:
   Inserta un par clave/valor al inicio de un objeto sin considerar el
   ordenamiento lexicográfico.
-}
testConsKV :: TestCase
testConsKV = TestCase "consKV inserts key-value at the beginning" $ do
  let obj = [("b", mkJNumber 1)]
      result = consKV ("a", mkJNumber 0) obj
  assertObjectEqual "new key added to front" [("a", mkJNumber 0), ("b", mkJNumber 1)] result
