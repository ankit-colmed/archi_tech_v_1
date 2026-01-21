import '../../domain/entities/patient.dart';

/// Patient model for data layer
class PatientModel extends Patient {
  const PatientModel({
    required super.id,
    required super.patientId,
    required super.name,
    super.mobile,
    super.avgScore,
    super.createdDate,
    super.result,
  });

  /// Create from JSON (API response)
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // Use patient_id as fallback for id if id is not present
    final patientId = json['patient_id'] ?? 0;
    return PatientModel(
      id: json['id'] ?? patientId,
      patientId: patientId,
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString(),
      avgScore: json['avg_score']?.toString(),
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'].toString())
          : null,
      result: json['result']?.toString(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'name': name,
      'mobile': mobile,
      'avg_score': avgScore,
      'createdDate': createdDate?.toIso8601String(),
      'result': result,
    };
  }

  /// Create from database map
  factory PatientModel.fromDatabase(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] ?? 0,
      patientId: map['patient_id'] ?? 0,
      name: map['name'] ?? '',
      mobile: map['mobile'],
      avgScore: map['avg_score'],
      createdDate: map['created_date'] != null
          ? DateTime.tryParse(map['created_date'])
          : null,
      result: map['result'],
    );
  }

  /// Convert to database map
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'patient_id': patientId,
      'name': name,
      'mobile': mobile,
      'avg_score': avgScore,
      'created_date': createdDate?.toIso8601String(),
      'result': result,
      'cached_at': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Create from Patient entity
  factory PatientModel.fromEntity(Patient patient) {
    return PatientModel(
      id: patient.id,
      patientId: patient.patientId,
      name: patient.name,
      mobile: patient.mobile,
      avgScore: patient.avgScore,
      createdDate: patient.createdDate,
      result: patient.result,
    );
  }

  /// Convert to Patient entity
  Patient toEntity() {
    return Patient(
      id: id,
      patientId: patientId,
      name: name,
      mobile: mobile,
      avgScore: avgScore,
      createdDate: createdDate,
      result: result,
    );
  }
}

/// Response model for patients API
class PatientsResponse {
  final String status;
  final String message;
  final List<PatientModel> data;

  const PatientsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PatientsResponse.fromJson(Map<String, dynamic> json) {
    return PatientsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  bool get isSuccess => status == 'success';
}