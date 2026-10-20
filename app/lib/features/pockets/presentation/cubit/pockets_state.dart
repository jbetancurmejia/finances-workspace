import 'package:equatable/equatable.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';

enum PocketsStatus {
  initial,
  loading,
  loaded,
  memberAdded,
  memberNotFound,
  memberAlreadyAdded,
  invalidInput,
  networkError,
}

final class PocketsState extends Equatable {
  const PocketsState({this.status = PocketsStatus.initial, this.pockets = const []});

  final PocketsStatus status;
  final List<Pocket> pockets;

  PocketsState copyWith({PocketsStatus? status, List<Pocket>? pockets}) {
    return PocketsState(
      status: status ?? this.status,
      pockets: pockets ?? this.pockets,
    );
  }

  @override
  List<Object?> get props => [status, pockets];
}
