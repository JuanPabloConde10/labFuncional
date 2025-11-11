# Biblioteca JSON en Haskell

Repositorio base del laboratorio de Programación Funcional 2025. La meta es proveer:

- Un AST y parser para valores JSON (`AST.hs`).
- Una biblioteca pública con constructores, destructores y utilidades sobre `JSON` (`JSONLibrary.hs`).
- Un sistema de tipos para JSON y chequeo/inferencia (`TypedJSON.hs`).
- Ejemplos orientados a datos de estudiantes (`Estudiantes.hs`).

Los tests viven en `tests/Spec.hs` y cargan un spec por función (`Features/.../Spec.hs`). Correr con:

```
runghc tests/Spec.hs
```

o compilar:

```
ghc -i. tests/Spec.hs -o spec && ./spec
```

## TODO

Correcciones pendientes detectadas durante la revisión:

1. **`JSONLibrary.sortKeys`**
   Volverlo estable para mantener el orden relativo entre claves duplicadas.

2. **`TypedJSON.typeWf`**
   Hacerlo recursivo: validar objetos anidados más allá de `objectWf`.

3. **`Estudiantes.estaBienFormadoEstudiante`**
   Definir `tyCurso`/`tyEstudiante` y chequear contra ese esquema + orden cronológico de cursos.

4. **`Estudiantes.aprobados` y `Estudiantes.enAnio`**
   Deben devolver el estudiante completo con el campo `cursos` filtrado y validar inputs.

5. **`Estudiantes.promedioEscolaridad`**
   Retornar `Nothing` cuando los datos no cumplen el esquema (campos faltantes o tipos incorrectos).

6. **`Estudiantes.addCurso`**
   Insertar el curso respetando el orden (año, semestre, código) en lugar de anexar al final.
