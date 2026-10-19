# Buenas prácticas de gestión de estado (Cubit)

Aplica a `app/` (Flutter). Stack: `flutter_bloc` (Cubit) + `equatable`. Sin codegen en esta fase.

## 1. Principios

- Cubit = orquestación de presentación. No contiene reglas de negocio ni infraestructura.
- Dependencia: `Presentation → Domain ← Data`. Domain es Dart puro.
- Un Cubit por pantalla o flujo. Vive junto a la página que lo provee.

## 2. Reglas del Cubit

| Regla | Ejemplo correcto | Ejemplo incorrecto |
|---|---|---|
| Solo llama use cases | `await _loadExpenses(const NoParams())` | `await _dio.get('/expenses')` |
| Nunca conoce DTOs | recibe `Expense` (entidad) | `ExpenseDto` en el estado |
| Estado inmutable con `Equatable` | `final class XState extends Equatable` | campos mutables |
| `emit` solo dentro de métodos del Cubit | `void load() { emit(...); }` | `emit` desde un widget |
| Sin `BuildContext` | el Cubit no recibe `context` | `Navigator.of(context)` en el Cubit |

## 3. Reglas de la UI

- Solo las páginas proveen el Cubit (`BlocProvider`) y leen estado (`BlocBuilder` / `BlocSelector`).
- Widgets reutilizables reciben datos y callbacks por constructor. No usan `context.read<XCubit>()`.
- Widgets que puedan ser `const` deben serlo.
- Strings visibles al usuario siempre con `'key'.tr()` (easy_localization). Nunca literales.
- Estilos desde `Theme.of(context)` o constantes de diseño, no `Colors.x` ni `EdgeInsets` mágicos.

## 4. Estado

```dart
final class ExpenseState extends Equatable {
  const ExpenseState({this.status = ExpenseStatus.initial, this.expenses = const []});

  final ExpenseStatus status;
  final List<Expense> expenses;

  ExpenseState copyWith({ExpenseStatus? status, List<Expense>? expenses}) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  List<Object?> get props => [status, expenses];
}
```

- Estados como `enum` de estado (`initial`, `loading`, `success`, `failure`) en lugar de booleanos sueltos.
- `props` debe incluir todos los campos del estado.

## 5. Cubit

```dart
final class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(this._loadExpenses) : super(const ExpenseState());

  final UseCase<List<Expense>, NoParams> _loadExpenses;

  Future<void> load() async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      final expenses = await _loadExpenses(const NoParams());
      emit(state.copyWith(status: ExpenseStatus.success, expenses: expenses));
    } on Failure {
      emit(state.copyWith(status: ExpenseStatus.failure));
    }
  }
}
```

- Métodos públicos con verbo: `load`, `submit`, `refresh`. Nunca `data`.
- Dependencias recibidas por constructor, tipadas contra la abstracción (`UseCase`).
- No usar `!` (null assertion). Usar promoción de tipo o `?.`.

## 6. Página

```dart
final class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExpenseCubit>()..load(),
      child: const _ExpensesView(),
    );
  }
}
```

La inyección concreta se define en la fase de composición (fuera de esta fase).

## 7. Testing (AAA)

Herramientas: `bloc_test` + `mocktail`.

```dart
class MockLoadExpenses extends Mock implements UseCase<List<Expense>, NoParams> {}

void main() {
  late MockLoadExpenses loadExpenses;

  setUp(() {
    loadExpenses = MockLoadExpenses();
  });

  blocTest<ExpenseCubit, ExpenseState>(
    'emits loading then success when load succeeds',
    build: () {
      when(() => loadExpenses(any())).thenAnswer((_) async => const []);
      return ExpenseCubit(loadExpenses);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const ExpenseState(status: ExpenseStatus.loading),
      const ExpenseState(status: ExpenseStatus.success),
    ],
  );
}
```

- Cada test tiene `// Arrange`, `// Act` y `// Assert` (o las formas combinadas `// Arrange & Act`). Son los únicos comentarios permitidos en `test/`.
- Un test valida un comportamiento.
- Cubits se prueban con mocks de use cases, nunca con datasources reales.

## 8. Checklist antes de PR

- [ ] El Cubit solo importa use cases, entidades y `failure.dart`.
- [ ] Estado inmutable y completo en `props`.
- [ ] Ninguna página hace llamadas HTTP.
- [ ] Ningún literal visible al usuario.
- [ ] Tests AAA con `blocTest`.
- [ ] `flutter analyze` sin issues.
