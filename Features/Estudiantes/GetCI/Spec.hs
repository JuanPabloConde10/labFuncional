module Features.Estudiantes.GetCI.Spec (testGetCI) where

import Estudiantes
import TestSupport

{- getCI:
   Dado un estudiante JSON retorna el número de cédula si existe.
-}
testGetCI :: TestCase
testGetCI = TestCase "getCI extracts CI when present" $ do
  assertEqual "CI available" (Just 12345678) (getCI validStudent)
  assertEqual "missing CI yields Nothing" Nothing (getCI studentWithoutCI)
