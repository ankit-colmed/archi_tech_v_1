import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/patient_model.dart';

/// Abstract patient remote data source
abstract class PatientRemoteDataSource {
  /// Get all patients from API
  Future<List<PatientModel>> getPatients();
}

/// Implementation of patient remote data source
class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient apiClient;

  PatientRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PatientModel>> getPatients() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.patients,
      );

      if (response.data == null) {
        throw const ServerException(message: 'No data received from server');
      }

      final patientsResponse = PatientsResponse.fromJson(response.data!);

      if (!patientsResponse.isSuccess) {
        throw ServerException(message: patientsResponse.message);
      }

      return patientsResponse.data;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
