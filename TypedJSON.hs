{- Grupo: 25
   Integrante(s):
     Conde Inzaurralde, Juan Pablo, 52734067
     Daneri Dini, Mateo Hernan, 56607501
-}

module TypedJSON where

import AST
import JSONLibrary
import Control.Monad
import Data.List


-- Tipos JSON
data JSONType
  = TyString
  | TyNum
  | TyObject (Object JSONType)
  | TyArray JSONType
  | TyBool
  | TyNull
  deriving (Show, Eq)


-- dado un valor JSON se infiere el tipo. Se devuelve
-- Nothing si el valor está mal tipado
typeOf :: JSON -> Maybe JSONType
typeOf (JString _) = Just TyString
typeOf (JBoolean _) = Just TyBool
typeOf (JNumber _) = Just TyNum
typeOf JNull = Just TyNull
typeOf (JArray (x:xs)) = if (typeOf x /= Nothing) && (and $ map (\json -> typeOf json == typeOf x) xs) then (Just (TyArray tipo)) else Nothing
                          where Just tipo = typeOf x
typeOf (JObject o@((_,_):xs)) 
    |(noKeyRepetida $ keysOf o) && (allTypesValid $ valuesOf o) =  Just (TyObject (map (\(k,v) -> let Just tipo = typeOf v in (k,tipo)) $ sortKeys o))
    | otherwise = Nothing
  where
    noKeyRepetida [] = True
    noKeyRepetida (k:xs) = not (elem k xs) && (noKeyRepetida xs)
    allTypesValid o = and $ map (\json -> typeOf json /= Nothing) o
typeOf _ = Nothing

-- decide si las claves de un objeto están ordenadas
-- lexicográficamente y no se repiten.
objectWf :: Object JSONType -> Bool
objectWf (o@((_,_):xs)) = (noKeyRepetida claves) && (claves == sort claves)
                                where
                                  claves = keysOf o
                                  noKeyRepetida [] = True
                                  noKeyRepetida (k:xs) = not (elem k xs) && (noKeyRepetida xs)
objectWf _ = False

-- decide si todos los tipos objeto contenidos en un tipo JSON
-- están bien formados.
typeWf :: JSONType -> Bool
typeWf TyString = True 
typeWf TyNum = True
typeWf (TyObject o) = objectWf o && all (typeWf . snd) o
typeWf (TyArray t) = typeWf t
typeWf TyBool = True
typeWf TyNull = True

-- dado un valor JSON v, y un tipo t, decide si v tiene tipo t.
hasType :: JSON -> JSONType -> Bool
hasType v t = (typeOf v /= Nothing) && (tipo == t) 
              where 
                Just tipo = typeOf v
