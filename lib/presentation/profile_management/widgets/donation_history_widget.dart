import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonationHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> donationHistory;

  const DonationHistoryWidget({
    super.key,
    required this.donationHistory,
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
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Donation History',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${donationHistory.length} donations',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          donationHistory.isEmpty
              ? _buildEmptyState()
              : _buildDonationTimeline(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'volunteer_activism',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Donation History',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your donation history will appear here after your first donation',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDonationTimeline() {
    return Column(
      children: donationHistory.asMap().entries.map((entry) {
        final index = entry.key;
        final donation = entry.value;
        final isLast = index == donationHistory.length - 1;

        return _buildTimelineItem(donation, isLast);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> donation, bool isLast) {
    final date = donation['date'] as DateTime;
    final hospital = donation['hospital'] as String;
    final units = donation['units'] as int;
    final status = donation['status'] as String;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 0.5.w,
                height: 8.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
          ],
        ),
        SizedBox(width: 3.w),
        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hospital,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatDate(date),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'bloodtype',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$units unit${units > 1 ? 's' : ''}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }
}
