module Features.Estudiantes.EnAnio.Spec (testEnAnio) where

import JSONLibrary
import Estudiantes
import TestSupport

{- enAnio:
   Filtra los cursos de un estudiante dejando solo los dictados en el año
   indicado y retorna el estudiante actualizado.
-}
testEnAnio :: TestCase
testEnAnio = TestCase "enAnio keeps only courses from the requested year" $ do
  assertJust "filtered student" (enAnio 2019 validStudent) $ \result ->
    assertJust "cursos field present" (lookupField result "cursos") $ \field ->
      assertJust "array value" (fromJArray field) $ \arr -> do
        assertEqual "course count" 2 (length arr)
        mapM_ (\course -> assertEqual "filtered year" (Just 2019) (lookupNumero "anio" course)) arr

lookupNumero :: String -> JSON -> Maybe Integer
lookupNumero key course = do
  obj <- fromJObject course
  field <- lookupFieldObj obj key
  fromJNumber field
