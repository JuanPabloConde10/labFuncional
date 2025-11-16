{- Grupo: X
   Integrante(s):
     Apellido, Nombre, XXXXXXXX
     Apellido, Nombre, XXXXXXXX
-}

module JSONLibrary
 (lookupField,
  lookupFieldObj,
  keysOf,
  valuesOf,
  entriesOf,
  leftJoin,
  rightJoin,
  filterArray,
  insertKV,
  consKV,
  sortKeys,
  mkJString, mkJNumber, mkJBoolean, mkJNull, mkJObject, mkJArray,
  fromJString, fromJNumber, fromJBoolean, fromJObject, fromJArray,
  isJString, isJNumber, isJBoolean, isJNull, isJObject, isJArray,
  JSON(),importJSON,
  Object()
 )
where

import AST


{- lookupField:
 Cuando el primer argumento es un objeto y tiene como clave el valor
 dado como segundo argumento, entonces se retorna el valor JSON
 correspondiente (bajo el constructor {\tt Just}). De lo contrario se
 retorna {\tt Nothing}. Si un objeto tiene claves repetidas, se
 retorna el valor de más a la derecha.
-}
lookupField :: JSON -> Key -> Maybe JSON
lookupField (JObject lista) key = lookupFieldObj lista key
lookupField _ _ = Nothing

-- Análoga a la anterior, pero el primer argumento es un objeto.
lookupFieldObj :: Object a -> Key -> Maybe a
lookupFieldObj lista key =
  foldl (\acc (k, v) -> if k == key then Just v else acc) Nothing lista

-- retorna la lista de claves de un objeto, manteniendo el orden en el
-- que se encontraban.
keysOf :: Object a -> [Key]
keysOf lista = [k | (k,_) <- lista]

-- Retorna una lista con los valores contenidos en los campos de un objeto,
-- manteniendo el orden en el que se encontraban.
valuesOf :: Object a -> [a]
valuesOf lista = [v | (_,v) <- lista]

-- retorna todos los campos de un objeto, en el orden en que se encontraban.
entriesOf :: Object a -> [(Key,a)]
entriesOf x = x

-- Se combinan dos objetos, en orden.  En caso que haya claves
-- repetidas en ambos objetos, en la unión tienen prioridad los
-- campos del primer objeto.
leftJoin :: Object a -> Object a -> Object a
leftJoin l r = l ++ (filter fil r) 
              where 
                fil (k,_) = not $ elem k claves
                claves = keysOf l

-- Se combinan dos objetos, en orden.  En caso que haya claves
-- repetidas en ambos objetos, en la unión tienen prioridad los
-- campos del segundo objeto.
rightJoin :: Object a -> Object a -> Object a
rightJoin l r = (filter fil l) ++ r
              where 
                fil (k,_) = not $ elem k claves
                claves = keysOf r

-- Dado un predicado sobre objetos JSON, y un arreglo, construye el
-- arreglo con los elementos que satisfacen el predicado.
filterArray :: (JSON -> Bool) ->  Array -> Array
filterArray p xs = filter p xs

-- Se inserta un campo en un objeto. Si las claves del objeto están
-- ordenadas lexicográficamente, el resultado debe conservar esta
-- propiedad.
insertKV :: (Key, v) -> Object v -> Object v
insertKV (k,v) xs = takeWhile ((<=k) . fst) xs ++ [(k,v)] ++ dropWhile ((<=k) . fst) xs

-- Se inserta un campo en un objeto, al inicio
consKV :: (Key, v) -> Object v -> Object v
consKV x xs = x:xs

-- ordena claves de un objeto
sortKeys :: Object a -> Object a
sortKeys [] = []
sortKeys (x:xs) = insertKV x (sortKeys xs)

-- constructoras
mkJString :: String -> JSON
mkJString s = JString s

mkJNumber :: Integer -> JSON
mkJNumber i = JNumber i

mkJBoolean :: Bool -> JSON
mkJBoolean b = JBoolean b

mkJNull :: () -> JSON
mkJNull () = JNull 

mkJArray :: [JSON] -> JSON
mkJArray a = JArray a

mkJObject :: [(Key, JSON)] -> JSON
mkJObject o = JObject o


-- destructoras
fromJString :: JSON -> Maybe String
fromJString (JString s) = Just s
fromJString _ = Nothing

fromJNumber :: JSON -> Maybe Integer
fromJNumber (JNumber i) = Just i
fromJNumber _ = Nothing

fromJBoolean  :: JSON -> Maybe Bool
fromJBoolean (JBoolean b) = Just b
fromJBoolean _ = Nothing

fromJObject :: JSON -> Maybe (Object JSON)
fromJObject (JObject o) = Just o
fromJObject _ = Nothing

fromJArray :: JSON -> Maybe [JSON]
fromJArray (JArray a) = Just a
fromJArray _ = Nothing


-- predicados
isJNumber :: JSON -> Bool
isJNumber (JNumber _) = True
isJNumber _ = False

isJNull :: JSON -> Bool
isJNull (JNull) = True
isJNull _ = False

isJString :: JSON -> Bool
isJString (JString _) = True
isJString _ = False

isJObject :: JSON -> Bool
isJObject (JObject _) = True
isJObject _ = False

isJArray :: JSON -> Bool
isJArray (JArray _) = True
isJArray _ = False

isJBoolean :: JSON -> Bool
isJBoolean (JBoolean _) = True
isJBoolean _ = False
