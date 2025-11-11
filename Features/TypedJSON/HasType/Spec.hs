module Features.TypedJSON.HasType.Spec (testHasType) where

import TypedJSON
import TestSupport

{- hasType:
   Decide si un valor JSON dado tiene un tipo JSONType específico.
-}
testHasType :: TestCase
testHasType = TestCase "hasType matches JSON values with their declared types" $ do
  assertBool "student matches tyEstudiante" (hasType validStudent tyEstudianteSpec)
  assertBool "invalid student rejected" (not (hasType studentWithoutCI tyEstudianteSpec))
