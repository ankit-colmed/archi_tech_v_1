import 'package:equatable/equatable.dart';

import '../../domain/entities/patient.dart';

/// Patients status enum
enum PatientsStatus {
  initial,
  loading,
  success,
  error,
}

/// Patients state
class PatientsState extends Equatable {
  final PatientsStatus status;
  final List<Patient> patients;
  final bool isFromCache;
  final bool isRefreshing;
  final String? errorMessage;

  const PatientsState({
    this.status = PatientsStatus.initial,
    this.patients = const [],
    this.isFromCache = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  /// Initial state
  factory PatientsState.initial() {
    return const PatientsState(status: PatientsStatus.initial);
  }

  /// Loading state
  factory PatientsState.loading() {
    return const PatientsState(status: PatientsStatus.loading);
  }

  /// Success state
  factory PatientsState.success({
    required List<Patient> patients,
    bool isFromCache = false,
  }) {
    return PatientsState(
      status: PatientsStatus.success,
      patients: patients,
      isFromCache: isFromCache,
    );
  }

  /// Error state
  factory PatientsState.error(String message) {
    return PatientsState(
      status: PatientsStatus.error,
      errorMessage: message,
    );
  }

  /// Copy with
  PatientsState copyWith({
    PatientsStatus? status,
    List<Patient>? patients,
    bool? isFromCache,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return PatientsState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      isFromCache: isFromCache ?? this.isFromCache,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Check if loading
  bool get isLoading => status == PatientsStatus.loading;

  /// Check if success
  bool get isSuccess => status == PatientsStatus.success;

  /// Check if has error
  bool get hasError => status == PatientsStatus.error;

  /// Check if has patients
  bool get hasPatients => patients.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        patients,
        isFromCache,
        isRefreshing,
        errorMessage,
      ];
}
