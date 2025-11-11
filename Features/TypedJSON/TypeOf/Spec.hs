module Features.TypedJSON.TypeOf.Spec (testTypeOf) where

import JSONLibrary
import TypedJSON
import TestSupport

{- typeOf:
   Dado un valor JSON retorna su JSONType correspondiente o Nothing cuando
   el valor está mal tipado (claves duplicadas, arreglos heterogéneos, etc.).
-}
testTypeOf :: TestCase
testTypeOf = TestCase "typeOf infers well-typed values and rejects malformed ones" $ do
  assertEqual "string type" (Just TyString) (typeOf (mkJString "hola"))
  assertEqual "boolean type" (Just TyBool) (typeOf (mkJBoolean False))
  assertEqual "array type" (Just (TyArray TyNum)) (typeOf (mkJArray [mkJNumber 1, mkJNumber 2]))
  let obj = mkJObject [("b", mkJNumber 2), ("a", mkJBoolean True)]
      expectedType = Just (TyObject [("a", TyBool), ("b", TyNum)])
  assertEqual "object type has sorted keys" expectedType (typeOf obj)
  assertEqual "heterogeneous array rejected" Nothing (typeOf (mkJArray [mkJNull (), mkJNumber 2]))
  let repeatedKeys = mkJObject [("a", mkJNumber 1), ("a", mkJNumber 2)]
  assertEqual "duplicate keys rejected" Nothing (typeOf repeatedKeys)
  assertEqual "empty array rejected" Nothing (typeOf (mkJArray []))
