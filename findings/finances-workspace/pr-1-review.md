## Money Architecture Review: PR #1 (Fase 0)

Scope: origin/main..feat/fase-0-scaffolding · 1 commit · 107 files (incluye boilerplate generado de Flutter en android/ios)

### Layers and Structure
- [OK] Feature-First: `lib/features/` vacío con `.gitkeep`, `shared/base_domain` y `shared/base_data` con la estructura prescrita.
- [OK] Dependency rule: `shared/base_domain` sin imports de Flutter ni data. `Money.Domain` no referencia otros proyectos.
- [OK] Backend: `Money.Application` referencia solo Domain; `Money.Infrastructure` referencia Application y Domain.

### Cubit and Presentation
- [OK] Sin Cubits aún en el código (corresponde a slices posteriores). Reglas documentadas en `docs/state-management-best-practices.md`.
- [OK] `MoneyApp` es `StatelessWidget` con `const` constructor.

### Naming and Money Domain
- [OK] Sin sufijos `Impl`. Sin DTOs en el código.
- [OK] Value object `Money` usa `int minorUnits` (sin `double` para montos).
- [WARN] `Money.cop(int minorUnits)` define la unidad mínima sin documentarla en código (no se permiten comentarios). Definir antes de Slice 1 que la unidad es centavos (`DECIMAL(18,2)`) o pesos enteros, y reflejarlo en el nombre del parámetro.

### Backend
- [WARN] `app.UseSwagger()` y `app.UseSwaggerUI()` se activan en todos los entornos. Aceptable para pruebas de campo (Fase 3 del PRD), pero conviene restringirlo a Development antes de cualquier despliegue público.
- [WARN] `Jwt:Key` en `appsettings.Development.json` es un placeholder. Reemplazar por user-secrets o variable de entorno antes de producción.
- [OK] `ConnectionStrings:Money` viene de configuración; `appsettings.json` no contiene secretos.

### Comments (mechanical sweep)
Sweep ejecutado sobre `*.dart` y `*.cs` del diff, excluyendo generados, con las excepciones de la skill.
Resultado: sin hallazgos.

Nota: los archivos boilerplate de `app/android/`, `app/ios/` (Gradle, Swift, storyboards, Podfile) no son Dart/C# y quedan fuera del barrido. Revisar si contienen comentarios de plantilla antes de un release.

### Static checks
- flutter analyze: No issues found
- flutter test: 6 passed
- dotnet build: 0 warnings, 0 errors
- dotnet test: 2 passed

### Verdict
Comment

Sin bloqueadores. Dos advertencias (Swagger en todos los entornos, unidad de `Money`) para atender antes del Slice 1.
