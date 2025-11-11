module Features.JSONLibrary.SortKeys.Spec (testSortKeys) where

import JSONLibrary
import TestSupport

{- sortKeys:
   Ordena las claves de un objeto lexicográficamente manteniendo el orden
   relativo entre claves repetidas (ordenamiento estable).
-}
testSortKeys :: TestCase
testSortKeys = TestCase "sortKeys orders keys stably" $ do
  let obj = [("c", mkJNumber 1), ("a", mkJNumber 2), ("b", mkJNumber 3), ("b", mkJNumber 4)]
      expected = [("a", mkJNumber 2), ("b", mkJNumber 3), ("b", mkJNumber 4), ("c", mkJNumber 1)]
  assertObjectEqual "sorted result" expected (sortKeys obj)
