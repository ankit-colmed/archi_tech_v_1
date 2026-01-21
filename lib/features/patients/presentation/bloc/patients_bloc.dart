import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_patients_usecase.dart';
import 'patients_event.dart';
import 'patients_state.dart';

/// Patients BLoC for managing patients list state
class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  final GetPatientsUseCase getPatientsUseCase;

  PatientsBloc({
    required this.getPatientsUseCase,
  }) : super(PatientsState.initial()) {
    on<PatientsLoadRequested>(_onLoadRequested);
    on<PatientsRefreshRequested>(_onRefreshRequested);
    on<PatientsErrorCleared>(_onErrorCleared);
  }

  /// Handle load patients request
  Future<void> _onLoadRequested(
    PatientsLoadRequested event,
    Emitter<PatientsState> emit,
  ) async {
    emit(PatientsState.loading());

    final result = await getPatientsUseCase();

    result.fold(
      (failure) => emit(PatientsState.error(failure.message)),
      (patientsResult) => emit(PatientsState.success(
        patients: patientsResult.patients,
        isFromCache: patientsResult.isFromCache,
      )),
    );
  }

  /// Handle refresh patients request
  Future<void> _onRefreshRequested(
    PatientsRefreshRequested event,
    Emitter<PatientsState> emit,
  ) async {
    // Keep existing data while refreshing
    emit(state.copyWith(isRefreshing: true));

    final result = await getPatientsUseCase.refresh();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: failure.message,
        ));
      },
      (patientsResult) {
        emit(PatientsState.success(
          patients: patientsResult.patients,
          isFromCache: false,
        ));
      },
    );
  }

  /// Handle error cleared
  void _onErrorCleared(
    PatientsErrorCleared event,
    Emitter<PatientsState> emit,
  ) {
    emit(state.copyWith(
      status: state.hasPatients ? PatientsStatus.success : PatientsStatus.initial,
      errorMessage: null,
    ));
  }
}
