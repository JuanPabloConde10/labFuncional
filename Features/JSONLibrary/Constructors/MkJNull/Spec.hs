module Features.JSONLibrary.Constructors.MkJNull.Spec (testMkJNull) where

import JSONLibrary
import TestSupport

{- mkJNull:
   Constructor para el valor JSON nulo.
-}
testMkJNull :: TestCase
testMkJNull = TestCase "mkJNull builds JSON null" $ do
  assertBool "result is null" (isJNull (mkJNull ()))
