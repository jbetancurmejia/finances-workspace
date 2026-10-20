import 'package:money_app/features/pockets/data/dtos/pocket_dto.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/value_objects/card_status.dart';

extension PocketDtoMapper on PocketDto {
  Pocket toEntity() => Pocket(
    id: id,
    name: name,
    isOwner: isOwner,
    balance: balance,
    status: _statusFromWire(status),
  );

  static CardStatus _statusFromWire(String value) {
    return switch (value) {
      'Green' => CardStatus.green,
      'Yellow' => CardStatus.yellow,
      _ => CardStatus.red,
    };
  }
}
