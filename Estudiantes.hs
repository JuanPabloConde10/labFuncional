{- Grupo: X
   Integrante(s):
     Apellido, Nombre, XXXXXXXX
     Apellido, Nombre, XXXXXXXX
-}

module Estudiantes where

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

---------------------------------------------------------------------------------------
-- Importante:
-- Notar que NO se puede importar el módulo AST, que es interno a la biblioteca.
---------------------------------------------------------------------------------------


-- decide si un valor que representa un estudiante esta bien formado
estaBienFormadoEstudiante :: JSON -> Bool  
estaBienFormadoEstudiante e =
  hasType e tyEstudiante &&
  maybe False cursosOrdenadosDesc (getCursosArray e)
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
  cursos <- getCursosArray e
  let aprobadosCursos = filter filtro cursos
  return $ mkJArray aprobadosCursos
  where
    filtro jobj = case fromJObject jobj of
                    Nothing -> False
                    Just o -> case lookupFieldObj o "nota" of
                                Nothing -> False
                                Just n -> case fromJNumber n of 
                                            Nothing -> False
                                            Just nota -> 3 <= nota
-- obtiene arreglo con cursos rendidos en un año dado
enAnio :: Integer -> JSON -> Maybe JSON
enAnio anio e = do
  cursos <- getCursosArray e
  let cursosEnAnio = filter filtro cursos
  return $ mkJArray cursosEnAnio
  where
    filtro jobj = case fromJObject jobj of
                    Nothing -> False
                    Just o -> case lookupFieldObj o "anio" of
                                Nothing -> False
                                Just a -> case fromJNumber a of 
                                            Nothing -> False
                                            Just a' -> anio == a'

-- retorna el promedio de las notas de los cursos
promedioEscolaridad :: JSON -> Maybe Float
promedioEscolaridad e = do
  cursos <- getCursosArray e
  let notas = map filtro cursos
  return $ promedio notas
  where
    promedio [] = 0.0
    promedio xs = sum xs / fromIntegral (length xs)
    filtro jobj = case fromJObject jobj of
                    Nothing -> 0.0
                    Just o -> case lookupFieldObj o "nota" of
                                Nothing -> 0.0
                                Just n -> case fromJNumber n of 
                                            Nothing -> 0.0
                                            Just nota -> fromIntegral nota :: Float 

-- agrega curso a lista de cursos de un estudiante
addCurso :: Object JSON -> JSON -> JSON
addCurso cursoNuevo e = case fromJObject e of
                      Nothing -> e
                      Just campos -> mkJObject (map agregarCurso campos)
  where
    nuevoCurso = mkJObject cursoNuevo
    agregarCurso ("cursos", c) = case fromJArray c of
                              Nothing -> ("cursos", c)
                              Just cursos -> ("cursos", mkJArray (insertarCursoOrdenado nuevoCurso cursos))
    agregarCurso par = par

insertarCursoOrdenado :: JSON -> [JSON] -> [JSON]
insertarCursoOrdenado nuevo [] = [nuevo]
insertarCursoOrdenado nuevo (c:cs) = case compareCursos nuevo c of
                                    Just LT -> nuevo : c : cs
                                    _       -> c : insertarCursoOrdenado nuevo cs

compareCursos :: JSON -> JSON -> Maybe Ordering
compareCursos a b = do
  claveA <- cursoKey a
  claveB <- cursoKey b
  pure (compareCursoKey claveA claveB)

type CursoKey = (Integer, Integer, Integer)

cursoKey :: JSON -> Maybe CursoKey
cursoKey curso = do
  obj <- fromJObject curso
  anio <- lookupFieldObj obj "anio" >>= fromJNumber
  semestre <- lookupFieldObj obj "semestre" >>= fromJNumber
  codigo <- lookupFieldObj obj "codigo" >>= fromJNumber
  pure (anio, semestre, codigo)

compareCursoKey :: CursoKey -> CursoKey -> Ordering
compareCursoKey (anio1, semestre1, codigo1) (anio2, semestre2, codigo2)
  | anio1 > anio2 = LT
  | anio1 < anio2 = GT
  | semestre1 > semestre2 = LT
  | semestre1 < semestre2 = GT
  | codigo1 < codigo2 = LT
  | codigo1 > codigo2 = GT
  | otherwise = EQ



cursosOrdenadosDesc :: [JSON] -> Bool
cursosOrdenadosDesc cursos =
  case traverse cursoKey cursos of
    Nothing -> False
    Just [] -> False
    Just claves ->
      all (\(a, b) -> compareCursoKey a b /= GT) (zip claves (drop 1 claves))



                

cursoNuevo =
  [ ("nombre"  , mkJString  "Matemática Discreta")
  , ("codigo"  , mkJNumber  2710)
  , ("anio"    , mkJNumber  2023)
  , ("semestre", mkJNumber  1)
  , ("nota"    , mkJNumber  12)
  ]
