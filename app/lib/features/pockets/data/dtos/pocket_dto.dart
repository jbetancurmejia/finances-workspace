final class PocketDto {
  const PocketDto({required this.id, required this.name, required this.isOwner});

  factory PocketDto.fromJson(Map<String, dynamic> json) {
    return PocketDto(
      id: json['id'] as String,
      name: json['name'] as String,
      isOwner: json['isOwner'] as bool,
    );
  }

  final String id;
  final String name;
  final bool isOwner;
}
