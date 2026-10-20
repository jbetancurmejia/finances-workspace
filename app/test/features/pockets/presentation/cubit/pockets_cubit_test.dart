import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/presentation/cubit/pockets_cubit.dart';
import 'package:money_app/features/pockets/presentation/cubit/pockets_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

class MockLoadPockets extends Mock implements UseCase<List<Pocket>, NoParams> {}

class MockCreatePocket extends Mock implements UseCase<Pocket, String> {}

class MockAddMember extends Mock implements UseCase<void, AddMemberParams> {}

void main() {
  late MockLoadPockets loadPockets;
  late MockCreatePocket createPocket;
  late MockAddMember addMember;

  const hogar = Pocket(id: 'p1', name: 'Hogar', isOwner: true);

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const AddMemberParams(pocketId: '', email: ''));
  });

  setUp(() {
    loadPockets = MockLoadPockets();
    createPocket = MockCreatePocket();
    addMember = MockAddMember();
  });

  group('PocketsCubit.load', () {
    blocTest<PocketsCubit, PocketsState>(
      'emits loading then loaded with the pockets',
      // Arrange
      build: () {
        when(() => loadPockets(any())).thenAnswer((_) async => const [hogar]);
        return PocketsCubit(loadPockets, createPocket, addMember);
      },
      // Act
      act: (cubit) => cubit.load(),
      // Assert
      expect: () => [
        const PocketsState(status: PocketsStatus.loading),
        const PocketsState(status: PocketsStatus.loaded, pockets: [hogar]),
      ],
    );

    blocTest<PocketsCubit, PocketsState>(
      'emits networkError when loading fails',
      // Arrange
      build: () {
        when(() => loadPockets(any())).thenAnswer((_) async => throw const NetworkFailure('down'));
        return PocketsCubit(loadPockets, createPocket, addMember);
      },
      // Act
      act: (cubit) => cubit.load(),
      // Assert
      expect: () => [
        const PocketsState(status: PocketsStatus.loading),
        const PocketsState(status: PocketsStatus.networkError),
      ],
    );
  });

  group('PocketsCubit.addMember', () {
    blocTest<PocketsCubit, PocketsState>(
      'emits memberAdded then reloads the pockets',
      // Arrange
      build: () {
        when(() => addMember(any())).thenAnswer((_) async {});
        when(() => loadPockets(any())).thenAnswer((_) async => const [hogar]);
        return PocketsCubit(loadPockets, createPocket, addMember);
      },
      // Act
      act: (cubit) => cubit.addMember('p1', 'pareja@example.com'),
      // Assert
      expect: () => [
        const PocketsState(status: PocketsStatus.loading),
        const PocketsState(status: PocketsStatus.memberAdded),
        const PocketsState(status: PocketsStatus.loading),
        const PocketsState(status: PocketsStatus.loaded, pockets: [hogar]),
      ],
    );

    blocTest<PocketsCubit, PocketsState>(
      'emits memberNotFound when the email has no account',
      // Arrange
      build: () {
        when(() => addMember(any())).thenAnswer((_) async => throw const NotFoundFailure('404'));
        return PocketsCubit(loadPockets, createPocket, addMember);
      },
      // Act
      act: (cubit) => cubit.addMember('p1', 'nadie@example.com'),
      // Assert
      expect: () => [
        const PocketsState(status: PocketsStatus.loading),
        const PocketsState(status: PocketsStatus.memberNotFound),
      ],
    );

    blocTest<PocketsCubit, PocketsState>(
      'emits memberAlreadyAdded on conflict',
      // Arrange
      build: () {
        when(() => addMember(any())).thenAnswer((_) async => throw const ConflictFailure('409'));
        return PocketsCubit(loadPockets, createPocket, addMember);
      },
      // Act
      act: (cubit) => cubit.addMember('p1', 'pareja@example.com'),
      // Assert
      expect: () => [
        const PocketsState(status: PocketsStatus.loading),
        const PocketsState(status: PocketsStatus.memberAlreadyAdded),
      ],
    );
  });
}
