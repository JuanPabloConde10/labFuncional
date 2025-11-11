module Features.Estudiantes.GetCursos.Spec (testGetCursos) where

import Estudiantes
import TestSupport

{- getCursos:
   Obtiene el arreglo de cursos del estudiante cuando está definido.
-}
testGetCursos :: TestCase
testGetCursos = TestCase "getCursos returns the course list when present" $ do
  assertJust "courses extracted" (getCursos validStudent) $ \courses ->
    assertEqual "length preserved" 3 (length courses)
  assertNothing "missing cursos yields Nothing" (getCursos studentWithoutCursos)
