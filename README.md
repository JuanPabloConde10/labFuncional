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

## Estado actual

El proyecto implementa las funciones solicitadas en `letra2025.pdf` y pasa los tests provistos por el equipo docente (`tests/TestProfes.hs`). Las pocas diferencias detectadas originalmente entre la letra y la batería de pruebas (como el contrato de `aprobados`) fueron resueltas en la última versión del archivo de tests, por lo que ya no hay inconsistencias conocidas.
