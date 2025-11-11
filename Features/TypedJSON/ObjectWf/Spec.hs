module Features.TypedJSON.ObjectWf.Spec (testObjectWf) where

import TypedJSON
import TestSupport

{- objectWf:
   Determina si un tipo objeto tiene sus claves ordenadas lexicográficamente
   y sin duplicados (solo inspecciona el nivel externo).
-}
testObjectWf :: TestCase
testObjectWf = TestCase "objectWf validates ordering and uniqueness" $ do
  let good = [("a", TyNum), ("b", TyString)]
      badOrder = [("b", TyString), ("a", TyNum)]
      duplicates = [("a", TyNum), ("a", TyString)]
  assertBool "sorted unique keys" (objectWf good)
  assertBool "unsorted keys rejected" (not (objectWf badOrder))
  assertBool "duplicate keys rejected" (not (objectWf duplicates))
  assertBool "empty objects rejected" (not (objectWf []))
