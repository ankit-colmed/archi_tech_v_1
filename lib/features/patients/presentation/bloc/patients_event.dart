import 'package:equatable/equatable.dart';

/// Base class for patients events
abstract class PatientsEvent extends Equatable {
  const PatientsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load patients
class PatientsLoadRequested extends PatientsEvent {
  const PatientsLoadRequested();
}

/// Event to refresh patients from API
class PatientsRefreshRequested extends PatientsEvent {
  const PatientsRefreshRequested();
}

/// Event to clear error state
class PatientsErrorCleared extends PatientsEvent {
  const PatientsErrorCleared();
}
