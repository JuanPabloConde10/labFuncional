module Features.Estudiantes.PromedioEscolaridad.Spec (testPromedioEscolaridad) where

import Estudiantes
import TestSupport

{- promedioEscolaridad:
   Calcula el promedio de las notas de los cursos de un estudiante válido.
-}
testPromedioEscolaridad :: TestCase
testPromedioEscolaridad = TestCase "promedioEscolaridad computes average grade" $ do
  assertJust "average defined" (promedioEscolaridad validStudent) $ \avg ->
    assertFloatApprox "average grade" ((6 + 8 + 9) / 3) avg
  assertEqual "invalid student rejected" Nothing (promedioEscolaridad studentWithoutCI)
