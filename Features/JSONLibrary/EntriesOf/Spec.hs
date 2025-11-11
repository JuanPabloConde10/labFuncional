module Features.JSONLibrary.EntriesOf.Spec (testEntriesOf) where

import JSONLibrary
import TestSupport

{- entriesOf:
   Expone todos los campos de un objeto en el mismo orden en que fueron
   definidos originalmente.
-}
testEntriesOf :: TestCase
testEntriesOf = TestCase "entriesOf returns the object unchanged" $ do
  let obj = [("c", mkJNull ()), ("a", mkJBoolean True), ("b", mkJNumber 4)]
  assertObjectEqual "entriesOf exposes same structure" obj (entriesOf obj)
