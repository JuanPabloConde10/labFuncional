{- Grupo: X
   Integrante(s):
     Apellido, Nombre, XXXXXXXX
     Apellido, Nombre, XXXXXXXX
-}

module Estudiantes where

import Control.Monad (filterM, guard)
import JSONLibrary
import TypedJSON

tyCurso :: JSONType
tyCurso =
  TyObject
    [ ("anio", TyNum)
    , ("codigo", TyNum)
    , ("nombre", TyString)
    , ("nota", TyNum)
    , ("semestre", TyNum)
    ]

tyEstudiante :: JSONType
tyEstudiante =
  TyObject
    [ ("CI", TyNum)
    , ("apellido", TyString)
    , ("cursos", TyArray tyCurso)
    , ("nombre", TyString)
    ]

cursoClave :: JSON -> Maybe (Integer, Integer, Integer)
cursoClave curso = do
  obj <- fromJObject curso
  anio <- lookupFieldObj obj "anio" >>= fromJNumber
  semestre <- lookupFieldObj obj "semestre" >>= fromJNumber
  codigo <- lookupFieldObj obj "codigo" >>= fromJNumber
  return (anio, semestre, codigo)

---------------------------------------------------------------------------------------
-- Importante:
-- Notar que NO se puede importar el módulo AST, que es interno a la biblioteca.
---------------------------------------------------------------------------------------


-- decide si un valor que representa un estudiante esta bien formado
estaBienFormadoEstudiante :: JSON -> Bool  
estaBienFormadoEstudiante e =
  hasType e tyEstudiante &&
  maybe False cursosOrdenados (getCursosArray e)
  where
    cursosOrdenados [] = False
    cursosOrdenados cursos =
      case traverse cursoClave cursos of
        Nothing -> False
        Just claves -> all paresOrdenados (zip claves (drop 1 claves))

    paresOrdenados ((anio1, semestre1, codigo1), (anio2, semestre2, codigo2))
      | anio1 > anio2 = True
      | anio1 < anio2 = False
      | semestre1 > semestre2 = True
      | semestre1 < semestre2 = False
      | otherwise = codigo1 <= codigo2
-- getters
getCI :: JSON -> Maybe Integer
getCI j = case lookupField j "CI" of
            Nothing -> Nothing
            Just a -> fromJNumber a

getNombre :: JSON -> Maybe String
getNombre j = case lookupField j "nombre" of
            Nothing -> Nothing
            Just a -> fromJString a

getApellido :: JSON -> Maybe String
getApellido j = case lookupField j "apellido" of
            Nothing -> Nothing
            Just a -> fromJString a

getCursos :: JSON -> Maybe JSON
getCursos j = do
  cursos <- lookupField j "cursos"
  case fromJArray cursos of
    Just _  -> Just cursos
    Nothing -> Nothing

getCursosArray :: JSON -> Maybe [JSON]
getCursosArray j = getCursos j >>= fromJArray

-- obtiene arreglo con cursos que fueron aprobados
aprobados :: JSON -> Maybe JSON
aprobados e = do
  campos <- fromJObject e
  cursos <- lookupFieldObj campos "cursos" >>= fromJArray
  aprobadosCursos <-
    filterM
      (\curso -> do
          obj <- fromJObject curso
          nota <- lookupFieldObj obj "nota" >>= fromJNumber
          return (nota >= 3)
      )
      cursos
  let camposActualizados =
        map
          (\(k, v) ->
              if k == "cursos"
                then (k, mkJArray aprobadosCursos)
                else (k, v))
          campos
  return $ mkJObject camposActualizados

-- obtiene arreglo con cursos rendidos en un año dado
enAnio :: Integer -> JSON -> Maybe JSON
enAnio anio e = do
  campos <- fromJObject e
  cursos <- lookupFieldObj campos "cursos" >>= fromJArray
  cursosEnAnio <-
    filterM
      (\curso -> do
          obj <- fromJObject curso
          cursoAnio <- lookupFieldObj obj "anio" >>= fromJNumber
          return (cursoAnio == anio)
      )
      cursos
  guard (not (null cursosEnAnio))
  return $ mkJArray cursosEnAnio

-- retorna el promedio de las notas de los cursos
promedioEscolaridad :: JSON -> Maybe Float
promedioEscolaridad e = do
  cursos <- getCursosArray e
  guard (not (null cursos))
  notas <-
    traverse
      (\curso -> do
          obj <- fromJObject curso
          lookupFieldObj obj "nota" >>= fromJNumber
      )
      cursos
  return $ promedio notas
  where
    promedio xs =
      let total = fromIntegral (sum xs) :: Float
      in total / fromIntegral (length xs)

-- agrega curso a lista de cursos de un estudiante
addCurso :: Object JSON -> JSON -> JSON
addCurso cursoNuevo e =
  case fromJObject e of
    Nothing -> e
    Just campos -> mkJObject (map agregarCurso campos)
  where
    nuevoCurso = mkJObject cursoNuevo

    agregarCurso ("cursos", c) =
      case fromJArray c of
        Nothing -> ("cursos", c)
        Just cursos -> ("cursos", mkJArray (insertar nuevoCurso cursos))
    agregarCurso par = par

    insertar curso [] = [curso]
    insertar curso (x:xs) =
      case comparar curso x of
        Just True -> curso : x : xs
        _         -> x : insertar curso xs

    comparar a b = do
      claveA <- cursoClave a
      claveB <- cursoClave b
      return (antes claveA claveB)

    antes (anio1, semestre1, codigo1) (anio2, semestre2, codigo2)
      | anio1 > anio2 = True
      | anio1 < anio2 = False
      | semestre1 > semestre2 = True
      | semestre1 < semestre2 = False
      | otherwise = codigo1 <= codigo2

cursoNuevo =
  [ ("nombre"  , mkJString  "Matemática Discreta")
  , ("codigo"  , mkJNumber  2710)
  , ("anio"    , mkJNumber  2023)
  , ("semestre", mkJNumber  1)
  , ("nota"    , mkJNumber  12)
  ]
