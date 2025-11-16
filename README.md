# Biblioteca JSON en Haskell

Repositorio base del laboratorio de Programación Funcional 2025. Incluye:

- `AST.hs`: AST y parser/lexer para valores JSON.
- `JSONLibrary.hs`: interfaz pública para construir, consultar y combinar valores `JSON`.
- `TypedJSON.hs`: noción de tipos, inferencia y chequeo.
- `Estudiantes.hs`: ejemplo de cliente que modela información académica.

Los tests oficiales están en `tests/TestProfes.hs` y se ejecutan con:

```bash
runhaskell tests/TestProfes.hs
```

## Cambios pendientes vs. letra 2025

- `lookupFieldObj`, `valuesOf` y `entriesOf` deben ser polimórficas en el tipo del valor de los objetos; hoy están restringidas a `JSON` y no sirven para trabajar con `TyObject`.
- `consKV` figura en la API pública, pero no se exporta desde `JSONLibrary`; ningún cliente puede usarla.
- `sortKeys` debe ser estable, respetando el orden relativo de claves duplicadas. La implementación actual usa un quicksort que invierte los duplicados.
- `aprobados` y `enAnio` en `Estudiantes.hs` sólo devuelven el arreglo de cursos filtrado. El enunciado pide regresar el objeto estudiante completo con el campo `cursos` actualizado, propagando `Nothing` cuando el JSON no respeta el esquema.

Una vez resueltos estos puntos, el código queda alineado con lo descrito en `letra2025.pdf`.
