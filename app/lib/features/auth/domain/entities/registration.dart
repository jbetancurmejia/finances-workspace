import 'package:equatable/equatable.dart';

final class Registration extends Equatable {
  const Registration({
    required this.email,
    required this.password,
    required this.displayName,
    required this.monthlySalary,
    required this.monthlyWorkHours,
  });

  final String email;
  final String password;
  final String displayName;
  final int monthlySalary;
  final double monthlyWorkHours;

  @override
  List<Object?> get props => [
    email,
    password,
    displayName,
    monthlySalary,
    monthlyWorkHours,
  ];
}
