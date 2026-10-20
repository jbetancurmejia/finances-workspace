import 'package:equatable/equatable.dart';

final class Pocket extends Equatable {
  const Pocket({required this.id, required this.name, required this.isOwner});

  final String id;
  final String name;
  final bool isOwner;

  @override
  List<Object?> get props => [id, name, isOwner];
}
