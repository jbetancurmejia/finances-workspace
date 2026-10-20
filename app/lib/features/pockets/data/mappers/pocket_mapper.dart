import 'package:money_app/features/pockets/data/dtos/pocket_dto.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';

extension PocketDtoMapper on PocketDto {
  Pocket toEntity() => Pocket(id: id, name: name, isOwner: isOwner);
}
