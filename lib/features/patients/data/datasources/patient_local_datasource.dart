import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/patient_model.dart';

/// Abstract patient local data source
abstract class PatientLocalDataSource {
  /// Get cached patients
  Future<List<PatientModel>> getCachedPatients();

  /// Cache patients
  Future<void> cachePatients(List<PatientModel> patients);

  /// Clear cached patients
  Future<void> clearCachedPatients();

  /// Check if cache is valid (not older than specified duration)
  Future<bool> isCacheValid({Duration maxAge = const Duration(hours: 24)});
}

/// Implementation of patient local data source using SQLite
class PatientLocalDataSourceImpl implements PatientLocalDataSource {
  final DatabaseHelper databaseHelper;

  PatientLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<PatientModel>> getCachedPatients() async {
    try {
      final maps = await databaseHelper.query(
        DatabaseHelper.tablePatients,
        orderBy: 'name ASC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return maps.map((map) => PatientModel.fromDatabase(map)).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get cached patients: $e');
    }
  }

  @override
  Future<void> cachePatients(List<PatientModel> patients) async {
    try {
      // Clear existing cache first
      await clearCachedPatients();

      // Insert new patients
      final dataList = patients.map((p) => p.toDatabase()).toList();
      await databaseHelper.batchInsert(
        DatabaseHelper.tablePatients,
        dataList,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache patients: $e');
    }
  }

  @override
  Future<void> clearCachedPatients() async {
    try {
      await databaseHelper.clearTable(DatabaseHelper.tablePatients);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached patients: $e');
    }
  }

  @override
  Future<bool> isCacheValid({Duration maxAge = const Duration(hours: 24)}) async {
    try {
      final maps = await databaseHelper.query(
        DatabaseHelper.tablePatients,
        columns: ['cached_at'],
        orderBy: 'cached_at DESC',
        limit: 1,
      );

      if (maps.isEmpty) {
        return false;
      }

      final cachedAt = maps.first['cached_at'] as int?;
      if (cachedAt == null) {
        return false;
      }

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(cachedAt);
      final now = DateTime.now();

      return now.difference(cachedTime) < maxAge;
    } catch (e) {
      return false;
    }
  }
}
