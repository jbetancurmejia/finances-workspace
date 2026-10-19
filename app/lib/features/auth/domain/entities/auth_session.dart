import 'package:equatable/equatable.dart';

final class AuthSession extends Equatable {
  const AuthSession({
    required this.userId,
    required this.displayName,
    required this.token,
  });

  final String userId;
  final String displayName;
  final String token;

  @override
  List<Object?> get props => [userId, displayName, token];
}
