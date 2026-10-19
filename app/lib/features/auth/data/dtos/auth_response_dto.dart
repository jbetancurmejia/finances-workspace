final class AuthResponseDto {
  const AuthResponseDto({
    required this.token,
    required this.userId,
    required this.displayName,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
    );
  }

  final String token;
  final String userId;
  final String displayName;
}
