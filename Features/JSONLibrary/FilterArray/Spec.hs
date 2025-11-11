module Features.JSONLibrary.FilterArray.Spec (testFilterArray) where

import JSONLibrary
import TestSupport

{- filterArray:
   Dados un predicado y un arreglo JSON, retorna un nuevo arreglo que
   contiene solo los elementos que satisfacen el predicado.
-}
testFilterArray :: TestCase
testFilterArray = TestCase "filterArray keeps elements satisfying predicate" $ do
  let arr = [mkJNumber 1, mkJNumber 2, mkJNumber 3, mkJNumber 4]
      predicate json = maybe False even (fromJNumber json)
      expected = [mkJNumber 2, mkJNumber 4]
      filtered = filterArray predicate arr
  assertBool "filters even numbers"
    (length filtered == length expected && and (zipWith jsonEquals expected filtered))
