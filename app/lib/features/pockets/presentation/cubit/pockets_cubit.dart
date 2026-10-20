import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/presentation/cubit/pockets_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class PocketsCubit extends Cubit<PocketsState> {
  PocketsCubit(this._loadPockets, this._createPocket, this._addMember)
    : super(const PocketsState());

  final UseCase<List<Pocket>, NoParams> _loadPockets;
  final UseCase<Pocket, String> _createPocket;
  final UseCase<void, AddMemberParams> _addMember;

  Future<void> load() async {
    emit(state.copyWith(status: PocketsStatus.loading));

    try {
      final pockets = await _loadPockets(const NoParams());
      emit(PocketsState(status: PocketsStatus.loaded, pockets: pockets));
    } on Failure catch (failure) {
      emit(state.copyWith(status: _statusFor(failure)));
    }
  }

  Future<void> create(String name) async {
    try {
      await _createPocket(name);
      await load();
    } on Failure catch (failure) {
      emit(state.copyWith(status: _statusFor(failure)));
    }
  }

  Future<void> addMember(String pocketId, String email) async {
    emit(state.copyWith(status: PocketsStatus.loading));

    try {
      await _addMember(AddMemberParams(pocketId: pocketId, email: email));
      emit(state.copyWith(status: PocketsStatus.memberAdded));
      await load();
    } on Failure catch (failure) {
      emit(state.copyWith(status: _statusFor(failure)));
    }
  }

  PocketsStatus _statusFor(Failure failure) {
    return switch (failure) {
      NotFoundFailure() => PocketsStatus.memberNotFound,
      ConflictFailure() => PocketsStatus.memberAlreadyAdded,
      ValidationFailure() => PocketsStatus.invalidInput,
      _ => PocketsStatus.networkError,
    };
  }
}
