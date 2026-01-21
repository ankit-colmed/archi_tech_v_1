import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/card_widgets.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../../domain/entities/patient.dart';

/// Patient card widget
class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.patient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      elevation: 2,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and avatar
          Row(
            children: [
              _buildAvatar(),
              const HorizontalSpace.m(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const VerticalSpace.xs(),
                    Text(
                      '${AppStrings.patientId}: ${patient.patientId}',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontS,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildScoreBadge(),
            ],
          ),

          const VerticalSpace.m(),
          const Divider(height: 1),
          const VerticalSpace.m(),

          // Details
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.phone_outlined,
                  label: AppStrings.mobile,
                  value: patient.mobile ?? AppStrings.notAvailable,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: AppStrings.createdDate,
                  value: _formatDate(patient.createdDate),
                ),
              ),
            ],
          ),

          // Result if available
          if (patient.result != null) ...[
            const VerticalSpace.s(),
            _buildResultBadge(),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final initials = _getInitials(patient.name);
    return Container(
      width: AppDimensions.avatarM,
      height: AppDimensions.avatarM,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: AppDimensions.fontL,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge() {
    final score = patient.avgScore;
    if (score == null || score.isEmpty) return const SizedBox.shrink();

    final scoreValue = double.tryParse(score)?.toInt() ?? 0;
    final color = _getScoreColor(scoreValue);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: AppDimensions.iconXS,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            score,
            style: TextStyle(
              fontSize: AppDimensions.fontS,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconS,
          color: AppColors.textSecondary,
        ),
        const HorizontalSpace.xs(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppDimensions.fontXS,
                  color: AppColors.textHint,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppDimensions.fontS,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.assignment_outlined,
            size: AppDimensions.iconXS,
            color: AppColors.info,
          ),
          const SizedBox(width: 4),
          Text(
            '${AppStrings.result}: ${patient.result}',
            style: const TextStyle(
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w500,
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  /// Safely get initials from name, handling empty strings
  String _getInitials(String name) {
    // Handle empty or whitespace-only names
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return '?';
    }

    final parts = trimmedName.split(' ').where((part) => part.isNotEmpty).toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length >= 2) {
      // Get first letter of first two words
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return '$first$second'.toUpperCase();
    }

    // Single word - return first character
    return parts[0][0].toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return AppStrings.notAvailable;
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }
}