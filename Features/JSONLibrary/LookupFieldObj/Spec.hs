module Features.JSONLibrary.LookupFieldObj.Spec (testLookupFieldObj) where

import JSONLibrary
import TestSupport

{- lookupFieldObj:
   Variante de lookupField donde se opera directamente sobre una lista
   de pares (Object a), respetando la prioridad del valor más reciente.
-}
testLookupFieldObj :: TestCase
testLookupFieldObj = TestCase "lookupFieldObj mirrors lookupField for Object" $ do
  let obj = [("a", mkJNumber 7), ("a", mkJNumber 9)]
  assertNothing "missing key" (lookupFieldObj obj "b")
  assertJust "picks right-most value" (lookupFieldObj obj "a") $ \val ->
    assertEqual "numeric content" (Just 9) (fromJNumber val)
