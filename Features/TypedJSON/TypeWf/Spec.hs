module Features.TypedJSON.TypeWf.Spec (testTypeWf) where

import TypedJSON
import TestSupport

{- typeWf:
   Verifica recursivamente que un JSONType sea bien formado, lo que implica
   que todos los objetos involucrados cumplen objectWf.
-}
testTypeWf :: TestCase
testTypeWf = TestCase "typeWf checks nested object well-formedness" $ do
  let nestedGood = TyArray (TyObject [("a", TyBool)])
      nestedBad = TyObject [("outer", TyObject [("z", TyNum), ("a", TyNum)])]
  assertBool "well-formed nested type" (typeWf nestedGood)
  assertBool "detects unordered nested type" (not (typeWf nestedBad))
