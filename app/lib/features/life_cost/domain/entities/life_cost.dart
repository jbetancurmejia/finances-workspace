import 'package:equatable/equatable.dart';

final class LifeCost extends Equatable {
  const LifeCost({required this.hours, required this.days});

  final double hours;
  final double days;

  @override
  List<Object?> get props => [hours, days];
}
