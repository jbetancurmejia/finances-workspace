import 'package:equatable/equatable.dart';

final class Money extends Equatable {
  const Money.cop(this.minorUnits);

  final int minorUnits;

  @override
  List<Object?> get props => [minorUnits];
}
