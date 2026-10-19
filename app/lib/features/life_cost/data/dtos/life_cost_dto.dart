final class LifeCostDto {
  const LifeCostDto({required this.hours, required this.days});

  factory LifeCostDto.fromJson(Map<String, dynamic> json) {
    return LifeCostDto(
      hours: (json['hours'] as num).toDouble(),
      days: (json['days'] as num).toDouble(),
    );
  }

  final double hours;
  final double days;
}
