import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalInfoSectionWidget extends StatelessWidget {
  final String selectedBloodType;
  final DateTime? lastDonationDate;
  final VoidCallback onDateTap;

  const MedicalInfoSectionWidget({
    super.key,
    required this.selectedBloodType,
    this.lastDonationDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'medical_services',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Medical Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildBloodTypeField(),
          SizedBox(height: 2.h),
          _buildLastDonationField(context),
        ],
      ),
    );
  }

  Widget _buildBloodTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blood Type',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'bloodtype',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                selectedBloodType,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Verified',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 0.5.h),
        Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Text(
            'Blood type cannot be changed after verification',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastDonationField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last Donation Date',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  lastDonationDate != null
                      ? _formatDate(lastDonationDate!)
                      : 'Select last donation date',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: lastDonationDate != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ),
        if (lastDonationDate != null) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _isEligibleToDonate()
                  ? AppTheme.lightTheme.colorScheme.tertiaryContainer
                  : AppTheme.lightTheme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _isEligibleToDonate() ? 'check_circle' : 'schedule',
                  color: _isEligibleToDonate()
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _isEligibleToDonate()
                        ? 'Eligible to donate blood'
                        : 'Next donation available: ${_getNextDonationDate()}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _isEligibleToDonate()
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _isEligibleToDonate() {
    if (lastDonationDate == null) return true;
    final daysSinceLastDonation =
        DateTime.now().difference(lastDonationDate!).inDays;
    return daysSinceLastDonation >= 56;
  }

  String _getNextDonationDate() {
    if (lastDonationDate == null) return '';
    final nextDonationDate = lastDonationDate!.add(const Duration(days: 56));
    return _formatDate(nextDonationDate);
  }
}
