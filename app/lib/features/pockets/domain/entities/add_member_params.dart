import 'package:equatable/equatable.dart';

final class AddMemberParams extends Equatable {
  const AddMemberParams({required this.pocketId, required this.email});

  final String pocketId;
  final String email;

  @override
  List<Object?> get props => [pocketId, email];
}
