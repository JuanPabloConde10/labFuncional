module TestSupport
  ( TestCase(..)
  , runTest
  , failWith
  , assertBool
  , assertEqual
  , assertFloatApprox
  , assertJust
  , assertNothing
  , assertJsonEqual
  , assertObjectEqual
  , jsonEquals
  , objectEquals
  , validCourse
  , validCourseObj
  , validCourses
  , validStudent
  , studentWithoutCI
  , studentWithoutNombre
  , studentWithoutApellido
  , studentWithoutCursos
  , unsortedCourses
  , studentWithUnsortedCourses
  , tyCursoSpec
  , tyEstudianteSpec
  , courseOrderingKey
  ) where

import JSONLibrary
import TypedJSON
import Estudiantes

import Control.Exception (Exception, SomeException, throwIO, try, fromException)
import Control.Monad (unless)

--------------------------------------------------------------------------------
-- Test harness
--------------------------------------------------------------------------------

data TestCase = TestCase
  { testName   :: String
  , testAction :: IO ()
  }

data TestFailure = TestFailure String deriving (Show)

instance Exception TestFailure

runTest :: TestCase -> IO Bool
runTest (TestCase name action) = do
  outcome <- try action
  case outcome of
    Right _ -> ok
    Left err -> case fromException err of
      Just (TestFailure msg) -> logFailure msg
      Nothing -> logFailure (show (err :: SomeException))
  where
    ok = do
      putStrLn ("[PASS] " ++ name ++ " -> Pasó el test")
      pure True
    logFailure msg = do
      putStrLn ("[FAIL] " ++ name ++ " -> No pasó el test")
      putStrLn ("       " ++ msg)
      pure False

failWith :: String -> IO a
failWith = throwIO . TestFailure

assertBool :: String -> Bool -> IO ()
assertBool msg cond = unless cond (failWith msg)

assertEqual :: (Eq a, Show a) => String -> a -> a -> IO ()
assertEqual msg expected actual =
  unless (actual == expected) $
    failWith (msg ++ ". Expected: " ++ show expected ++ ", but got: " ++ show actual)

assertFloatApprox :: String -> Float -> Float -> IO ()
assertFloatApprox msg expected actual =
  unless (abs (expected - actual) < 1e-4) $
    failWith (msg ++ ". Expected approx: " ++ show expected ++ ", but got: " ++ show actual)

assertJust :: String -> Maybe a -> (a -> IO ()) -> IO ()
assertJust msg maybeValue handler =
  case maybeValue of
    Just v  -> handler v
    Nothing -> failWith (msg ++ " expected Just, got Nothing")

assertNothing :: String -> Maybe a -> IO ()
assertNothing msg value =
  case value of
    Nothing -> pure ()
    Just _  -> failWith (msg ++ " expected Nothing, got Just _")

--------------------------------------------------------------------------------
-- Helpers for comparing JSON values
--------------------------------------------------------------------------------

jsonEquals :: JSON -> JSON -> Bool
jsonEquals a b
  | Just s1 <- fromJString a
  , Just s2 <- fromJString b = s1 == s2
  | Just n1 <- fromJNumber a
  , Just n2 <- fromJNumber b = n1 == n2
  | Just o1 <- fromJObject a
  , Just o2 <- fromJObject b = objectEquals o1 o2
  | Just arr1 <- fromJArray a
  , Just arr2 <- fromJArray b = length arr1 == length arr2 && and (zipWith jsonEquals arr1 arr2)
  | Just b1 <- fromJBoolean a
  , Just b2 <- fromJBoolean b = b1 == b2
  | isJNull a && isJNull b = True
  | otherwise = False

objectEquals :: Object JSON -> Object JSON -> Bool
objectEquals [] [] = True
objectEquals ((k1,v1):xs) ((k2,v2):ys) = k1 == k2 && jsonEquals v1 v2 && objectEquals xs ys
objectEquals _ _ = False

assertJsonEqual :: String -> JSON -> JSON -> IO ()
assertJsonEqual msg expected actual =
  unless (jsonEquals expected actual) $
    failWith (msg ++ ". Expected: " ++ show expected ++ ", but got: " ++ show actual)

assertObjectEqual :: String -> Object JSON -> Object JSON -> IO ()
assertObjectEqual msg expected actual =
  unless (objectEquals expected actual) $
    failWith (msg ++ ". Expected object: " ++ show expected ++ ", but got: " ++ show actual)

--------------------------------------------------------------------------------
-- Fixtures
--------------------------------------------------------------------------------

validCourse :: String -> Integer -> Integer -> Integer -> Integer -> JSON
validCourse name code year semester grade =
  mkJObject
    [ ("nombre",   mkJString name)
    , ("codigo",   mkJNumber code)
    , ("anio",     mkJNumber year)
    , ("semestre", mkJNumber semester)
    , ("nota",     mkJNumber grade)
    ]

validCourseObj :: String -> Integer -> Integer -> Integer -> Integer -> Object JSON
validCourseObj name code year semester grade =
  [ ("nombre",   mkJString name)
  , ("codigo",   mkJNumber code)
  , ("anio",     mkJNumber year)
  , ("semestre", mkJNumber semester)
  , ("nota",     mkJNumber grade)
  ]

validCourses :: [JSON]
validCourses =
  [ validCourse "Calculo"        101 2019 1 6
  , validCourse "Programacion 1" 202 2019 2 8
  , validCourse "Logica"         150 2020 1 9
  ]

validStudent :: JSON
validStudent =
  mkJObject
    [ ("nombre",   mkJString "Ana")
    , ("apellido", mkJString "Suarez")
    , ("CI",       mkJNumber 12345678)
    , ("cursos",   mkJArray validCourses)
    ]

studentWithoutCI :: JSON
studentWithoutCI =
  mkJObject
    [ ("nombre",   mkJString "Ana")
    , ("apellido", mkJString "Suarez")
    , ("cursos",   mkJArray validCourses)
    ]

studentWithoutNombre :: JSON
studentWithoutNombre =
  mkJObject
    [ ("apellido", mkJString "Suarez")
    , ("CI",       mkJNumber 12345678)
    , ("cursos",   mkJArray validCourses)
    ]

studentWithoutApellido :: JSON
studentWithoutApellido =
  mkJObject
    [ ("nombre", mkJString "Ana")
    , ("CI", mkJNumber 12345678)
    , ("cursos", mkJArray validCourses)
    ]

studentWithoutCursos :: JSON
studentWithoutCursos =
  mkJObject
    [ ("nombre", mkJString "Ana")
    , ("apellido", mkJString "Suarez")
    , ("CI", mkJNumber 12345678)
    ]

unsortedCourses :: [JSON]
unsortedCourses =
  [ validCourse "Logica"         150 2020 1 9
  , validCourse "Calculo"        101 2019 1 6
  , validCourse "Programacion 1" 202 2019 2 8
  ]

studentWithUnsortedCourses :: JSON
studentWithUnsortedCourses =
  mkJObject
    [ ("nombre",   mkJString "Ana")
    , ("apellido", mkJString "Suarez")
    , ("CI",       mkJNumber 12345678)
    , ("cursos",   mkJArray unsortedCourses)
    ]

tyCursoSpec :: JSONType
tyCursoSpec =
  TyObject
    [ ("anio",     TyNum)
    , ("codigo",   TyNum)
    , ("nombre",   TyString)
    , ("nota",     TyNum)
    , ("semestre", TyNum)
    ]

tyEstudianteSpec :: JSONType
tyEstudianteSpec =
  TyObject
    [ ("CI",       TyNum)
    , ("apellido", TyString)
    , ("cursos",   TyArray tyCursoSpec)
    , ("nombre",   TyString)
    ]

courseOrderingKey :: JSON -> Maybe (Integer, Integer, Integer)
courseOrderingKey courseJSON = do
  obj <- fromJObject courseJSON
  year <- fromJNumber =<< lookupFieldObj obj "anio"
  sem  <- fromJNumber =<< lookupFieldObj obj "semestre"
  code <- fromJNumber =<< lookupFieldObj obj "codigo"
  pure (year, sem, code)
