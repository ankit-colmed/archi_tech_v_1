import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/patient.dart';

/// Result wrapper that includes data source information
class PatientsResult {
  final List<Patient> patients;
  final bool isFromCache;

  const PatientsResult({
    required this.patients,
    this.isFromCache = false,
  });
}

/// Abstract repository for patient operations
abstract class PatientRepository {
  /// Get all patients
  /// Returns patients from remote API if connected, otherwise from cache
  Future<Either<Failure, PatientsResult>> getPatients();

  /// Get patients from cache only
  Future<Either<Failure, List<Patient>>> getCachedPatients();

  /// Refresh patients from remote API and update cache
  Future<Either<Failure, List<Patient>>> refreshPatients();

  /// Clear cached patients
  Future<Either<Failure, void>> clearCache();
}
