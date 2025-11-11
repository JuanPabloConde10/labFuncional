module Features.Estudiantes.Aprobados.Spec (testAprobados) where

import JSONLibrary
import Estudiantes
import TestSupport

{- aprobados:
   Dado un estudiante retorna el mismo JSON pero con la lista de cursos
   reducida a aquellos con nota mayor o igual que 3.
-}
testAprobados :: TestCase
testAprobados = TestCase "aprobados filters courses with nota >= 3" $ do
  let student = mkJObject
        [ ("nombre",   mkJString "Ana")
        , ("apellido", mkJString "Suarez")
        , ("CI",       mkJNumber 12345678)
        , ("cursos",   mkJArray [ validCourse "Calculo" 101 2019 1 6
                                , validCourse "Prog"    202 2019 2 2
                                ])
        ]
      expectedCourses = [validCourse "Calculo" 101 2019 1 6]
  assertJust "aprobados returns filtered student" (aprobados student) $ \result ->
    assertJust "filtered cursos" (lookupField result "cursos") $ \filtered ->
      assertJust "array after filter" (fromJArray filtered) $ \arr ->
        assertBool "keeps only approved courses"
          (length arr == 1 && and (zipWith jsonEquals expectedCourses arr))
  assertNothing "invalid student rejected" (aprobados studentWithoutCI)
