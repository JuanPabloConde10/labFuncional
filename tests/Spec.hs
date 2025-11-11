module Main where

import Control.Monad (when)
import System.Exit (exitFailure)

import TestSupport (TestCase, runTest)

import Features.AST.Show.Spec (testShowInstance)
import Features.JSONLibrary.LookupField.Spec (testLookupField)
import Features.JSONLibrary.LookupFieldObj.Spec (testLookupFieldObj)
import Features.JSONLibrary.KeysOf.Spec (testKeysOf)
import Features.JSONLibrary.ValuesOf.Spec (testValuesOf)
import Features.JSONLibrary.EntriesOf.Spec (testEntriesOf)
import Features.JSONLibrary.LeftJoin.Spec (testLeftJoin)
import Features.JSONLibrary.RightJoin.Spec (testRightJoin)
import Features.JSONLibrary.FilterArray.Spec (testFilterArray)
import Features.JSONLibrary.InsertKV.Spec (testInsertKV)
import Features.JSONLibrary.ConsKV.Spec (testConsKV)
import Features.JSONLibrary.SortKeys.Spec (testSortKeys)
import Features.JSONLibrary.Constructors.MkJString.Spec (testMkJString)
import Features.JSONLibrary.Constructors.MkJNumber.Spec (testMkJNumber)
import Features.JSONLibrary.Constructors.MkJBoolean.Spec (testMkJBoolean)
import Features.JSONLibrary.Constructors.MkJNull.Spec (testMkJNull)
import Features.JSONLibrary.Constructors.MkJArray.Spec (testMkJArray)
import Features.JSONLibrary.Constructors.MkJObject.Spec (testMkJObject)
import Features.JSONLibrary.Destructors.FromJString.Spec (testFromJString)
import Features.JSONLibrary.Destructors.FromJNumber.Spec (testFromJNumber)
import Features.JSONLibrary.Destructors.FromJBoolean.Spec (testFromJBoolean)
import Features.JSONLibrary.Destructors.FromJObject.Spec (testFromJObject)
import Features.JSONLibrary.Destructors.FromJArray.Spec (testFromJArray)
import Features.JSONLibrary.Predicates.IsJNumber.Spec (testIsJNumber)
import Features.JSONLibrary.Predicates.IsJNull.Spec (testIsJNull)
import Features.JSONLibrary.Predicates.IsJString.Spec (testIsJString)
import Features.JSONLibrary.Predicates.IsJObject.Spec (testIsJObject)
import Features.JSONLibrary.Predicates.IsJArray.Spec (testIsJArray)
import Features.JSONLibrary.Predicates.IsJBoolean.Spec (testIsJBoolean)
import Features.TypedJSON.TypeOf.Spec (testTypeOf)
import Features.TypedJSON.ObjectWf.Spec (testObjectWf)
import Features.TypedJSON.TypeWf.Spec (testTypeWf)
import Features.TypedJSON.HasType.Spec (testHasType)
import Features.Estudiantes.EstaBienFormadoEstudiante.Spec (testEstaBienFormadoEstudiante)
import Features.Estudiantes.GetCI.Spec (testGetCI)
import Features.Estudiantes.GetNombre.Spec (testGetNombre)
import Features.Estudiantes.GetApellido.Spec (testGetApellido)
import Features.Estudiantes.GetCursos.Spec (testGetCursos)
import Features.Estudiantes.Aprobados.Spec (testAprobados)
import Features.Estudiantes.EnAnio.Spec (testEnAnio)
import Features.Estudiantes.PromedioEscolaridad.Spec (testPromedioEscolaridad)
import Features.Estudiantes.AddCurso.Spec (testAddCurso)

main :: IO ()
main = do
  results <- mapM runTest allTests
  when (any not results) exitFailure

allTests :: [TestCase]
allTests =
  [ testShowInstance
  , testLookupField
  , testLookupFieldObj
  , testKeysOf
  , testValuesOf
  , testEntriesOf
  , testLeftJoin
  , testRightJoin
  , testFilterArray
  , testInsertKV
  , testConsKV
  , testSortKeys
  , testMkJString
  , testMkJNumber
  , testMkJBoolean
  , testMkJNull
  , testMkJArray
  , testMkJObject
  , testFromJString
  , testFromJNumber
  , testFromJBoolean
  , testFromJObject
  , testFromJArray
  , testIsJNumber
  , testIsJNull
  , testIsJString
  , testIsJObject
  , testIsJArray
  , testIsJBoolean
  , testTypeOf
  , testObjectWf
  , testTypeWf
  , testHasType
  , testEstaBienFormadoEstudiante
  , testGetCI
  , testGetNombre
  , testGetApellido
  , testGetCursos
  , testAprobados
  , testEnAnio
  , testPromedioEscolaridad
  , testAddCurso
  ]
