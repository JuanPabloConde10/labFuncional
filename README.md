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

Correcciones profes `@TestProfes.hs`

1.  rightJoin 1: Al definir rightJoin = flip leftJoin terminás anteponiendo todo el objeto derecho en vez de dejar primero las claves únicas del izquierdo seguidas por el derecho, por eso el orden no coincide (JSONLibrary.hs:69-74).
2.  rightJoin 2: Misma causa: el join simplemente concatena right ++ left\sin claves repetidas, cuando el test espera left\sin claves repetidas ++ right (JSONLibrary.hs:69-74).
3.  rightJoin 3: Otra vez el orden queda invertido porque flip leftJoin no respeta la convención “left-only primero, luego right completo” del enunciado (JSONLibrary.hs:69-74).
4.  typeWf 9: Tu typeWf solo ejecuta objectWf sobre el objeto externo y nunca vuelve a chequear que los campos anidados de tipo TyObject estén bien formados, por lo que pasa un objeto interno desordenado (TypedJSON.hs:54-62).
5.  typeWf 11: Idéntico problema, el tipo con objetos anidados mal formados retorna True porque no hacés validación recursiva de los campos (TypedJSON.hs:54-62).
6.  estaBienFormadoEstudiante 3: Te limitás a chequear que typeOf exista, así no detectás que los cursos deben venir ordenados por año y aceptás est 3 aunque los años estén desordenados (Estudiantes.hs:18-23).
7.  estaBienFormadoEstudiante 4: Falta el control de orden por semestre dentro de un mismo año, por eso est 4 no se rechaza pese al desorden (Estudiantes.hs:18-23).
8.  estaBienFormadoEstudiante 5: Tampoco verificás el orden por código dentro de año/semestre, así est 5 queda aceptado (Estudiantes.hs:18-23).
9.  estaBienFormadoEstudiante 6: No comprobás la presencia obligatoria del campo cursos, por lo que un estudiante incompleto sigue devolviendo True (Estudiantes.hs:18-23).
10.  estaBienFormadoEstudiante 7: Nunca descartás claves extra, entonces est 7 con el campo “?” pasa igual (Estudiantes.hs:18-23).
11.  estaBienFormadoEstudiante 8: No validás los tipos esperados de cada campo (ej., nombre debe ser string), de modo que aceptás JNull en est 8 (Estudiantes.hs:18-23).
12.  addCurso 1: La función solo agrega el curso al final del array y no reordena ni reubica duplicados, por lo que tras varias inserciones el resultado no coincide con la secuencia ordenada que se espera (Estudiantes.hs:95-106).
13.  addCurso 2: El mismo apend simple hace que distintos órdenes de inserción den resultados distintos, en lugar de mantener el orden canonical requerido (Estudiantes.hs:95-106).

Correcciones que tiro GPT (revisar en segundo plano):

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


