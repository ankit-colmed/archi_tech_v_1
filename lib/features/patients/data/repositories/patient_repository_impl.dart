import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_local_datasource.dart';
import '../datasources/patient_remote_datasource.dart';
import '../models/patient_model.dart';

/// Implementation of PatientRepository
/// Implements offline-first strategy
class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;
  final PatientLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PatientRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PatientsResult>> getPatients() async {
    // Check network connectivity
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Online: Try to fetch from remote
      try {
        final remotePatients = await remoteDataSource.getPatients();

        // Cache the fresh data
        await localDataSource.cachePatients(remotePatients);

        return Right(PatientsResult(
          patients: remotePatients.map((m) => m.toEntity()).toList(),
          isFromCache: false,
        ));
      } on ServerException catch (e) {
        // Server error: Try to return cached data
        return _getCachedPatientsWithFallback(e.message);
      } on NetworkException catch (e) {
        // Network error: Return cached data
        return _getCachedPatientsWithFallback(e.message);
      } catch (e) {
        // Unknown error: Try cached data
        return _getCachedPatientsWithFallback(e.toString());
      }
    } else {
      // Offline: Return cached data
      return _getCachedPatientsResult();
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> getCachedPatients() async {
    try {
      final cachedPatients = await localDataSource.getCachedPatients();
      return Right(cachedPatients.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Patient>>> refreshPatients() async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final remotePatients = await remoteDataSource.getPatients();

      // Update cache
      await localDataSource.cachePatients(remotePatients);

      return Right(remotePatients.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCachedPatients();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  /// Helper method to get cached patients result
  Future<Either<Failure, PatientsResult>> _getCachedPatientsResult() async {
    try {
      final cachedPatients = await localDataSource.getCachedPatients();

      if (cachedPatients.isEmpty) {
        return const Left(CacheFailure(message: 'No cached data available'));
      }

      return Right(PatientsResult(
        patients: cachedPatients.map((m) => m.toEntity()).toList(),
        isFromCache: true,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  /// Helper method to get cached patients with fallback error message
  Future<Either<Failure, PatientsResult>> _getCachedPatientsWithFallback(
    String originalError,
  ) async {
    try {
      final cachedPatients = await localDataSource.getCachedPatients();

      if (cachedPatients.isNotEmpty) {
        return Right(PatientsResult(
          patients: cachedPatients.map((m) => m.toEntity()).toList(),
          isFromCache: true,
        ));
      }

      // No cached data available, return original error
      return Left(ServerFailure(message: originalError));
    } catch (e) {
      // Cache error, return original error
      return Left(ServerFailure(message: originalError));
    }
  }
}
