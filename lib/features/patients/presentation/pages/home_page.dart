import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/loading_error_widgets.dart' as app_widgets;
import '../../../../core/widgets/responsive_layout_builder.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/patients_bloc.dart';
import '../bloc/patients_event.dart';
import '../bloc/patients_state.dart';
import '../widgets/patient_card.dart';

/// Home page displaying patient list
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load patients when page opens
    context.read<PatientsBloc>().add(const PatientsLoadRequested());
  }

  void _onRefresh() {
    context.read<PatientsBloc>().add(const PatientsRefreshRequested());
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.goToLogin();
            },
            child: Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.patients),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
            tooltip: AppStrings.refresh,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
            tooltip: AppStrings.logout,
          ),
        ],
      ),
      body: BlocConsumer<PatientsBloc, PatientsState>(
        listener: (context, state) {
          // Show error message if refresh failed but we have cached data
          if (state.errorMessage != null && state.hasPatients) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<PatientsBloc>().add(const PatientsErrorCleared());
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Offline banner
              if (state.isFromCache) const app_widgets.OfflineBanner(),

              // Refreshing indicator
              if (state.isRefreshing)
                const LinearProgressIndicator(
                  backgroundColor: AppColors.primaryLight,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),

              // Content
              Expanded(
                child: _buildContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(PatientsState state) {
    if (state.isLoading) {
      return const app_widgets.LoadingWidget(message: AppStrings.loading);
    }

    if (state.hasError && !state.hasPatients) {
      return app_widgets.ErrorWidget(
        message: state.errorMessage,
        onRetry: () {
          context.read<PatientsBloc>().add(const PatientsLoadRequested());
        },
      );
    }

    if (!state.hasPatients) {
      return app_widgets.EmptyWidget(
        message: AppStrings.noPatients,
        icon: Icons.people_outline,
        onAction: _onRefresh,
        actionLabel: AppStrings.refresh,
      );
    }

    return ResponsiveLayoutBuilder(
      mobile: _MobilePatientList(
        patients: state.patients,
        onRefresh: _onRefresh,
      ),
      tablet: _TabletPatientList(
        patients: state.patients,
        onRefresh: _onRefresh,
      ),
      desktop: _DesktopPatientList(
        patients: state.patients,
        onRefresh: _onRefresh,
      ),
      android: _AndroidPatientList(
        patients: state.patients,
        onRefresh: _onRefresh,
      ),
    );
  }
}

class _AndroidPatientList extends StatelessWidget {

  final List patients;
  final VoidCallback onRefresh;

  const _AndroidPatientList({
    required this.patients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: PatientCard(
              patient: patient,
              onTap: () => context.pushPatientDetails(patient.id),
            ),
          );
        },
      ),
    );
  }
}

/// Mobile patient list layout
class _MobilePatientList extends StatelessWidget {
  final List patients;
  final VoidCallback onRefresh;

  const _MobilePatientList({
    required this.patients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: PatientCard(
              patient: patient,
              onTap: () => context.pushPatientDetails(patient.id),
            ),
          );
        },
      ),
    );
  }
}

/// Tablet patient list layout (2 columns)
class _TabletPatientList extends StatelessWidget {
  final List patients;
  final VoidCallback onRefresh;

  const _TabletPatientList({
    required this.patients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.spacingM,
          mainAxisSpacing: AppDimensions.spacingM,
          childAspectRatio: 1.8,
        ),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return PatientCard(
            patient: patient,
            onTap: () => context.pushPatientDetails(patient.id),
          );
        },
      ),
    );
  }
}

/// Desktop patient list layout (3 columns with sidebar)
class _DesktopPatientList extends StatelessWidget {
  final List patients;
  final VoidCallback onRefresh;

  const _DesktopPatientList({
    required this.patients,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 250,
          color: AppColors.surface,
          child: Column(
            children: [
              const VerticalSpace.l(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: AppColors.primary),
                    const HorizontalSpace.s(),
                    const Text(
                      AppStrings.patientList,
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpace.m(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.group,
                        color: AppColors.primary,
                        size: AppDimensions.iconS,
                      ),
                      const HorizontalSpace.s(),
                      Text(
                        'Total: ${patients.length}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Text(
                  'ArchiTech v1.0.0',
                  style: TextStyle(
                    fontSize: AppDimensions.fontS,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Divider
        const VerticalDivider(width: 1),
        // Main content
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppDimensions.spacingM,
              mainAxisSpacing: AppDimensions.spacingM,
              childAspectRatio: 1.6,
            ),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return PatientCard(
                patient: patient,
                onTap: () => context.pushPatientDetails(patient.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
