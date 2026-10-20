import 'package:equatable/equatable.dart';
import 'package:money_app/features/pockets/domain/value_objects/card_status.dart';

final class Pocket extends Equatable {
  const Pocket({
    required this.id,
    required this.name,
    required this.isOwner,
    this.balance = 0,
    this.status = CardStatus.red,
  });

  final String id;
  final String name;
  final bool isOwner;
  final int balance;
  final CardStatus status;

  @override
  List<Object?> get props => [id, name, isOwner, balance, status];
}
