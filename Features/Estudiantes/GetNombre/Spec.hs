module Features.Estudiantes.GetNombre.Spec (testGetNombre) where

import Estudiantes
import TestSupport

{- getNombre:
   Extrae el campo nombre del JSON de estudiante cuando está presente.
-}
testGetNombre :: TestCase
testGetNombre = TestCase "getNombre extracts the student's name" $ do
  assertEqual "name available" (Just "Ana") (getNombre validStudent)
  assertEqual "missing nombre yields Nothing" Nothing (getNombre studentWithoutNombre)
