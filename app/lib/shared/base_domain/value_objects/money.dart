import 'package:equatable/equatable.dart';

final class Money extends Equatable {
  const Money.cop(this.pesos);

  final int pesos;

  @override
  List<Object?> get props => [pesos];
}
