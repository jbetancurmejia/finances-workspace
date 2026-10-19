# Estándares de código - Money

Documento de referencia para desarrollo y revisión de PRs. Complementa `flutter_clean_architecture_guidelines.pdf` y `state-management-best-practices.md`.

## 1. Arquitectura

### Flutter (`app/`)

- Feature-First: `lib/features/<feature>/{domain,data,presentation}`.
- `shared/base_domain` (Dart puro) y `shared/base_data` (puede importar `base_domain`, nunca features).
- Las features no se importan entre sí. Lo compartido vive en `shared/`.
- Dependencia: `Presentation → Domain ← Data`.
  - Domain: sin Flutter, sin DTOs, sin datasources.
  - Data: sin widgets, sin Cubit.
  - Presentation: solo use cases y entidades; sin datasources ni DTOs.

### Backend (`backend/`)

- `Money.Api` (controladores, `Program.cs`), `Money.Application` (casos de uso), `Money.Domain` (entidades y reglas), `Money.Infrastructure` (EF Core, SQLite/SQL Server).
- `Money.Domain` no referencia a ningún otro proyecto.
- `Money.Api` no accede a `DbContext` directamente desde controladores en features nuevas: pasa por Application.

## 2. Nomenclatura

| Elemento | Convención | Ejemplo |
|---|---|---|
| Lectura desde repositorio/use case | `load` | `LoadExpensesUseCase` |
| Red explícita | `fetch` | `fetchExpenses` en el datasource remoto |
| Caché / memoria | `get` | `getCachedExpenses` |
| Repositorio concreto | `XxxDataRepository` (nunca `Impl`) | `ExpenseDataRepository` |
| Cubit / estado | `XxxCubit` / `XxxState` | `ExpenseCubit`, `ExpenseState` |
| Métodos asíncronos | verbo | `load()`, `submit()`, nunca `data()` |

## 3. Dart / Flutter

- Dart 3+: usar modificadores de clase (`final`, `sealed`, `interface`, `base`) donde corresponda.
- Null safety: prohibido `!`. Usar promoción de tipo, `?.`, `??` o `switch` con patrones.
- Records para retornar pares de valores simples; no listas ni clases "Result" ad hoc.
- `const` siempre que sea posible.
- Strings visibles al usuario solo vía `'key'.tr()`. Traducciones en `assets/translations/es.json` y `en.json`.
- Estilos desde `Theme.of(context)` o constantes; prohibido `Colors.x` y valores mágicos en UI.
- Un widget que supere ~200 líneas o un `build()` de ~80 líneas se divide en subwidgets.
- `dart:io`, `dio` y datasources no aparecen en presentation.

## 4. Comentarios (regla crítica)

- Cero comentarios en el código: ni `//`, ni `///`, ni `/* */`.
- Excepciones:
  - `// Arrange`, `// Act`, `// Assert` y sus combinaciones (`// Arrange & Act`, `// Act + Assert`) dentro de `test/` y `tests/`.
  - `// ignore:` / `// ignore_for_file:` (directivas del analizador).
  - `// TODO(nombre):` con responsable.
- Si un comentario parece necesario, renombrar el símbolo o extraer una función o constante con nombre.
- Archivos generados (`*.g.dart`, `*.freezed.dart`) quedan fuera del alcance.

## 5. Tests

- Estructura espejo: `test/` replica `lib/`. Backend: `tests/` replica la estructura de `src/`.
- Patrón AAA en todos los tests con marcadores de la sección 4.
- Un test por comportamiento; nombre descriptivo en lenguaje de negocio.
- Use cases y Cubits se prueban con mocks (`mocktail`). Mappers y entidades con tests unitarios puros.
- `flutter analyze` y `flutter test` deben pasar antes de abrir PR.

## 6. Git y PRs

- Rama por feature: `feat/<descripcion>`, `fix/<descripcion>`, `chore/<descripcion>`.
- Commits en imperativo y en español o inglés consistente dentro del PR.
- Un PR por fase o por slice vertical. No mezclar refactor con features.
- Antes del PR: `dotnet build` y `dotnet test` (backend), `flutter analyze` y `flutter test` (app).

## 7. Backend (.NET)

- Configuración por `appsettings.json` y overrides por entorno. Secretos fuera del repositorio (user-secrets o variables de entorno).
- `ConnectionStrings:Money` apunta a SQLite en desarrollo y a SQL Server en producción.
- Endpoints bajo `api/<recurso>`.
- Decimales monetarios: `decimal` en C# y `DECIMAL(18,2)` en base de datos.
- Tasas: almacenar E.A.; convertir a M.V. con `(1 + EA)^(1/12) - 1` en el servicio de dominio.

## 8. Checklist de PR

- [ ] Sin comentarios fuera de las excepciones.
- [ ] Sin `!` ni strings hardcodeados en UI.
- [ ] Dependencias respetan la regla de capas.
- [ ] Tests AAA agregados para lógica nueva.
- [ ] Analyzer y tests en verde.
