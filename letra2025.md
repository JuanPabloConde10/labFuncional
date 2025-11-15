# Laboratorio de Programacion Funcional 2025

## 1. Introduccion

El objetivo del laboratorio es implementar una biblioteca para manipular y usar valores JSON. JSON (JavaScript Object Notation) es un formato de texto plano que permite representar datos utilizando:

- Valores nulos.
- Numeros enteros.
- Cadenas de caracteres.
- Booleanos (`true` y `false`).
- Arreglos (listas no vacias y potencialmente heterogeneas).
- Objetos (mapeos clave/valor con claves string; pueden repetirse).

### Sintaxis EBNF

```
<json>    ::= <number> | <string> | <boolean> | 'null' | <object> | <array>
<boolean> ::= 'true' | 'false'
<object>  ::= '{' <key> ':' <json> { ',' <key> ':' <json> } '}'
<key>     ::= <string>
<array>   ::= '[' <json> { ',' <json> } ']'
```

Por ejemplo:

```json
{
  "nombre": "Haskell SRL",
  "empleados": [
    { "nombre": "Juan",  "apellido": "Perez"      },
    { "nombre": "Ana",   "apellido": "Rodriguez"  },
    { "nombre": "Pedro", "apellido": "Gonzalez"   },
    { "nombre": "Luisa", "apellido": "Gomez"      }
  ],
  "numEmpleados": 4,
  "enRUPE": false,
  "expedientes_asociados": null,
  "contactos": [0303456, "curry@haskell.com.uy"]
}
```

La biblioteca provee:

- El tipo `JSON` y utilidades asociadas.
- Una nocion de tipado para valores JSON.

## 2. Archivos distribuidos

La distribucion incluye cinco modulos.

- **AST.hs**: define el AST para JSON y funciones como `importJSON`.
- **ParserCombinators.hs**: utilidades de parsing usadas para la instancia de `Read` del tipo JSON (no se modifica ni se entrega).
- **JSONLibrary.hs**: interfaz publica que exporta las operaciones necesarias para manipular JSON.
- **TypedJSON.hs**: define una nocion de tipos para valores JSON, junto con chequeo e inferencia.
- **Estudiantes.hs**: ejemplos de uso pensados para clientes de la biblioteca.

Los modulos publicos son `JSONLibrary` y `TypedJSON`; `AST` queda interno y no se puede importar desde `Estudiantes`.

### 2.1. Modulo AST

Define el tipo:

```haskell
data JSON
    = JString String
    | JNumber JSONNumber
    | JObject (Object JSON)
    | JArray  Array
    | JBoolean Bool
    | JNull

type Object a   = [(Key, a)]
type Array      = [JSON]
type Key        = String
type JSONNumber = Integer
```

Tambien implementa el parser para leer JSON y utilidades como las instancias de `Read` y `Show`.

### 2.2. Modulo JSONLibrary

Este modulo define funciones para manipular valores JSON, ocultando los constructores del tipo. Funciones principales:

- `lookupField :: JSON -> Key -> Maybe JSON`
  - Devuelve el valor asociado a una clave de un objeto; si hay claves repetidas se prioriza la ultima aparicion.
- `lookupFieldObj :: Object a -> Key -> Maybe a`
  - Igual que la anterior pero trabaja sobre objetos ya destruidos.
- `entriesOf :: Object a -> [(Key, a)]`
  - Retorna todos los campos en el orden original.
- `keysOf :: Object a -> [Key]`
  - Lista de claves en orden.
- `valuesOf :: Object a -> [a]`
  - Lista de valores respetando el orden original.
- Constructores `mk*` (por ejemplo `mkBoolean :: Bool -> JSON`).
- Destructores `from*` (por ejemplo `fromJNumber :: JSON -> Maybe Integer`).
- Predicados `is*` (por ejemplo `isArray :: JSON -> Bool`).
- `leftJoin :: Object a -> Object a -> Object a`
  - Combina objetos priorizando las claves del primer argumento.
- `rightJoin :: Object a -> Object a -> Object a`
  - Igual que `leftJoin` pero prioriza las claves del segundo argumento.
- `filterArray :: (JSON -> Bool) -> Array -> Array`
  - Filtra arreglos segun un predicado.
- `insertKV :: (Key, a) -> Object a -> Object a`
  - Inserta un campo respetando el orden lexicografico (o al final).
- `consKV :: (Key, a) -> Object a -> Object a`
  - Inserta un campo al inicio.
- `sortKeys :: Object a -> Object a`
  - Ordena las claves en forma estable (mantiene el orden relativo de duplicados).

### 2.3. Modulo TypedJSON

Define una nocion de tipado para JSON. Un valor esta bien tipado si:

1. Ningun objeto tiene claves repetidas.
2. Los arreglos son homogeneos y no vacios.

Tipos disponibles:

```haskell
data JSONType
  = TyString
  | TyNum
  | TyObject (Object JSONType)
  | TyArray JSONType
  | TyBool
  | TyNull
  deriving (Show, Eq)
```

Las claves de un `TyObject` se guardan ordenadas. Ejemplos:

- `JBoolean True` tiene tipo `TyBool`.
- `JArray [JObject [("key 1", JNumber 1)]]` tiene tipo `TyArray (TyObject [("key 1", TyNum)])`.
- `JArray [JNull, JNull]` tiene tipo `TyArray TyNull`.
- `JArray [JString ""]` tiene tipo `TyArray TyString`.
- `JArray [JObject [("k", JArray [JBoolean True])], JObject [("k", JArray [JBoolean False, JBoolean True])]]` tiene tipo `TyArray (TyObject [("k", TyArray TyBool)])`.
- `JArray [JObject [("a", JBoolean True), ("b", JArray [JNull])], JObject [("b", JArray [JNull]), ("a", JBoolean False)]]` tiene tipo `TyArray (TyObject [("a", TyBool), ("b", TyArray TyNull)])`.

Valores mal tipados incluyen arreglos heterogeneos o con objetos de distintas claves/ordenes, objetos con claves duplicadas y arreglos vacios en contextos que exigen homogeneidad.

Funciones principales:

- `typeOf :: JSON -> Maybe JSONType`
- `objectWf :: Object JSONType -> Bool`
- `typeWf :: JSONType -> Bool`
- `hasType :: JSON -> JSONType -> Bool`

### 2.4. Modulo Estudiantes

Modela la informacion de estudiantes usando:

```haskell
tyEstudiante =
  TyObject
    [ ("nombre",   TyString)
    , ("apellido", TyString)
    , ("CI",       TyNum)
    , ("cursos",   TyArray tyCurso)
    ]

tyCurso =
  TyObject
    [ ("nombre",   TyString)
    , ("codigo",   TyNum)
    , ("anio",     TyNum)
    , ("semestre", TyNum)
    , ("nota",     TyNum)
    ]
```

Ejemplo valido:

```json
{
  "nombre": "Ana",
  "apellido": "Suarez",
  "CI": 12345678,
  "cursos": [
    { "nombre": "Calculo DIV", "codigo": 123, "anio": 2024, "semestre": 1, "nota": 1 },
    { "nombre": "Calculo DIV", "codigo": 123, "anio": 2019, "semestre": 2, "nota": 7 },
    { "nombre": "Programacion 1", "codigo": 234, "anio": 2019, "semestre": 2, "nota": 7 }
  ]
}
```

La lista de cursos debe estar ordenada cronologicamente (anio y semestre) y en caso de empate se ordena por codigo.

Funciones a implementar:

- `estaBienFormadoEstudiante :: JSON -> Bool`
- `get*` para acceder a cada campo.
- `aprobados :: JSON -> Maybe JSON` (filtra cursos con nota >= 3).
- `enAnio :: Integer -> JSON -> Maybe JSON`.
- `promedioEscolaridad :: JSON -> Maybe Float`.
- `addCurso :: Object JSON -> JSON -> JSON` (inserta manteniendo el orden de los cursos).

## 3. Se pide

Modificar `AST.hs`, `JSONLibrary.hs`, `TypedJSON.hs` y `Estudiantes.hs` implementando las funciones provistas como `undefined`, sin cambiar firmas ni otros modulos. Se pueden definir funciones auxiliares donde sea necesario, pero `AST` no debe importarse desde `Estudiantes`. El equipo docente no permite el uso de IA generativa para resolver el laboratorio.
