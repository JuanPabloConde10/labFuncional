module Features.JSONLibrary.InsertKV.Spec (testInsertKV) where

import JSONLibrary
import TestSupport

{- insertKV:
   Inserta un campo en un objeto cuyas claves están ordenadas
   lexicográficamente, manteniendo dicha propiedad en el resultado.
-}
testInsertKV :: TestCase
testInsertKV = TestCase "insertKV preserves lexicographic ordering" $ do
  let sortedObj = [("a", mkJNumber 1), ("c", mkJNumber 3)]
      insertedMiddle = insertKV ("b", mkJNumber 2) sortedObj
      insertedEnd = insertKV ("z", mkJNumber 26) sortedObj
  assertObjectEqual "inserts before first greater key"
    [("a", mkJNumber 1), ("b", mkJNumber 2), ("c", mkJNumber 3)]
    insertedMiddle
  assertObjectEqual "appends when key is greatest"
    [("a", mkJNumber 1), ("c", mkJNumber 3), ("z", mkJNumber 26)]
    insertedEnd
