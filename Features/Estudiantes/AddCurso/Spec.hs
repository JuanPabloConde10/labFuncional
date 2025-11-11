module Features.Estudiantes.AddCurso.Spec (testAddCurso) where

import Data.List (sort)
import JSONLibrary
import Estudiantes
import TestSupport

{- addCurso:
   Inserta un curso en la lista del estudiante manteniendo el orden
   cronológico (año, semestre, código) establecido por la consigna.
-}
testAddCurso :: TestCase
testAddCurso = TestCase "addCurso inserts respecting chronological order" $ do
  let newCourse = validCourseObj "Bases de Datos" 305 2019 2 10
      result = addCurso newCourse validStudent
  assertJust "result is still an object" (fromJObject result) $ \obj ->
    assertJust "courses still present" (lookupFieldObj obj "cursos") $ \coursesJSON -> do
      assertJust "courses is an array" (fromJArray coursesJSON) $ \courses -> do
        assertEqual "course count increments" 4 (length courses)
        let maybeKeys = map courseOrderingKey courses
        assertBool "all order keys present" (all (/= Nothing) maybeKeys)
        let keys = map unwrap maybeKeys
        assertEqual "courses remain sorted" (sort keys) keys
  where
    unwrap (Just v) = v
    unwrap Nothing  = error "Unexpected Nothing when computing ordering key"
