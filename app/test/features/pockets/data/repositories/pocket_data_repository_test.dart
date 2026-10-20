import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/pockets/data/datasources/pocket_remote_datasource.dart';
import 'package:money_app/features/pockets/data/dtos/pocket_dto.dart';
import 'package:money_app/features/pockets/data/repositories/pocket_data_repository.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockPocketRemoteDatasource extends Mock implements PocketRemoteDatasource {}

DioException _httpError(int status) {
  final request = RequestOptions(path: '/api/workspaces');
  return DioException(
    requestOptions: request,
    response: Response<Map<String, dynamic>>(requestOptions: request, statusCode: status),
    type: DioExceptionType.badResponse,
    message: 'status $status',
  );
}

void main() {
  late MockPocketRemoteDatasource datasource;
  late PocketDataRepository repository;

  const addMemberParams = AddMemberParams(pocketId: 'p1', email: 'pareja@example.com');

  setUpAll(() {
    registerFallbackValue(addMemberParams);
  });

  setUp(() {
    datasource = MockPocketRemoteDatasource();
    repository = PocketDataRepository(datasource);
  });

  group('PocketDataRepository.loadPockets', () {
    test('maps every dto to a pocket entity', () async {
      // Arrange
      when(() => datasource.fetchPockets()).thenAnswer(
        (_) async => const [PocketDto(id: 'p1', name: 'Hogar', isOwner: true)],
      );

      // Act
      final pockets = await repository.loadPockets();

      // Assert
      expect(pockets, const [Pocket(id: 'p1', name: 'Hogar', isOwner: true)]);
    });
  });

  group('PocketDataRepository.addMember', () {
    test('maps HTTP 404 to NotFoundFailure', () async {
      // Arrange
      when(() => datasource.fetchAddMember(any())).thenAnswer((_) async => throw _httpError(404));

      // Act
      final call = repository.addMember(addMemberParams);

      // Assert
      await expectLater(call, throwsA(isA<NotFoundFailure>()));
    });

    test('maps HTTP 409 to ConflictFailure', () async {
      // Arrange
      when(() => datasource.fetchAddMember(any())).thenAnswer((_) async => throw _httpError(409));

      // Act
      final call = repository.addMember(addMemberParams);

      // Assert
      await expectLater(call, throwsA(isA<ConflictFailure>()));
    });
  });
}
