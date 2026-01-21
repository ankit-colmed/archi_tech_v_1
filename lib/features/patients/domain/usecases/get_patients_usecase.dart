import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/patient_repository.dart';

/// Use case for getting patients list
class GetPatientsUseCase implements UseCaseNoParams<PatientsResult> {
  final PatientRepository repository;

  GetPatientsUseCase(this.repository);

  @override
  Future<Either<Failure, PatientsResult>> call() async {
    return await repository.getPatients();
  }

  /// Refresh patients from API
  Future<Either<Failure, PatientsResult>> refresh() async {
    final result = await repository.refreshPatients();
    return result.map((patients) => PatientsResult(
          patients: patients,
          isFromCache: false,
        ));
  }
}
