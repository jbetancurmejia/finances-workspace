final class PocketDto {
  const PocketDto({
    required this.id,
    required this.name,
    required this.isOwner,
    this.balance = 0,
    this.status = 'Red',
  });

  factory PocketDto.fromJson(Map<String, dynamic> json) {
    return PocketDto(
      id: json['id'] as String,
      name: json['name'] as String,
      isOwner: json['isOwner'] as bool,
      balance: (json['balance'] as num? ?? 0).toInt(),
      status: json['status'] as String? ?? 'Red',
    );
  }

  final String id;
  final String name;
  final bool isOwner;
  final int balance;
  final String status;
}
