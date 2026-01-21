import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../database/database_helper.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/patients/data/datasources/patient_local_datasource.dart';
import '../../features/patients/data/datasources/patient_remote_datasource.dart';
import '../../features/patients/data/repositories/patient_repository_impl.dart';
import '../../features/patients/domain/repositories/patient_repository.dart';
import '../../features/patients/domain/usecases/get_patients_usecase.dart';
import '../../features/patients/presentation/bloc/patients_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ==================== Core ====================

  // Database
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Network
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // ==================== Auth Feature ====================

  // Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: getIt<AuthLocalDataSource>(),
      apiClient: getIt<ApiClient>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  // BLoC
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  // ==================== Patients Feature ====================

  // Data Sources
  getIt.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<PatientLocalDataSource>(
    () => PatientLocalDataSourceImpl(getIt<DatabaseHelper>()),
  );

  // Repositories
  getIt.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(
      remoteDataSource: getIt<PatientRemoteDataSource>(),
      localDataSource: getIt<PatientLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetPatientsUseCase>(
    () => GetPatientsUseCase(getIt<PatientRepository>()),
  );

  // BLoC
  getIt.registerFactory<PatientsBloc>(
    () => PatientsBloc(
      getPatientsUseCase: getIt<GetPatientsUseCase>(),
    ),
  );
}
