import 'package:equatable/equatable.dart';

/// Patient entity
class Patient extends Equatable {
  final int id;
  final int patientId;
  final String name;
  final String? mobile;
  final String? avgScore;
  final DateTime? createdDate;
  final String? result;

  const Patient({
    required this.id,
    required this.patientId,
    required this.name,
    this.mobile,
    this.avgScore,
    this.createdDate,
    this.result,
  });

  @override
  List<Object?> get props => [
        id,
        patientId,
        name,
        mobile,
        avgScore,
        createdDate,
        result,
      ];

  /// Create a copy with updated fields
  Patient copyWith({
    int? id,
    int? patientId,
    String? name,
    String? mobile,
    String? avgScore,
    DateTime? createdDate,
    String? result,
  }) {
    return Patient(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      avgScore: avgScore ?? this.avgScore,
      createdDate: createdDate ?? this.createdDate,
      result: result ?? this.result,
    );
  }
}
