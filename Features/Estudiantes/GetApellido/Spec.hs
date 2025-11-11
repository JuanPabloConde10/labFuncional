module Features.Estudiantes.GetApellido.Spec (testGetApellido) where

import Estudiantes
import TestSupport

{- getApellido:
   Retorna el campo apellido del estudiante si existe.
-}
testGetApellido :: TestCase
testGetApellido = TestCase "getApellido extracts the student's surname" $ do
  assertEqual "apellido available" (Just "Suarez") (getApellido validStudent)
  assertEqual "missing apellido yields Nothing" Nothing (getApellido studentWithoutApellido)
