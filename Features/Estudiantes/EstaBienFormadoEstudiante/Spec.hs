module Features.Estudiantes.EstaBienFormadoEstudiante.Spec (testEstaBienFormadoEstudiante) where

import Estudiantes
import TestSupport

{- estaBienFormadoEstudiante:
   Debe decidir si un JSON cumple el esquema tyEstudiante y respeta el
   orden cronológico de los cursos.
-}
testEstaBienFormadoEstudiante :: TestCase
testEstaBienFormadoEstudiante = TestCase "estaBienFormadoEstudiante validates schema and ordering" $ do
  assertBool "valid student accepted" (estaBienFormadoEstudiante validStudent)
  assertBool "missing CI rejected" (not (estaBienFormadoEstudiante studentWithoutCI))
  assertBool "unsorted courses rejected" (not (estaBienFormadoEstudiante studentWithUnsortedCourses))
