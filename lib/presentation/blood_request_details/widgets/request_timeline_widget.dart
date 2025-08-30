import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget to display request timeline with posted date, needed date, and status
class RequestTimelineWidget extends StatelessWidget {
  final DateTime postedDate;
  final DateTime neededDate;
  final String status;

  const RequestTimelineWidget({
    super.key,
    required this.postedDate,
    required this.neededDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
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
          Text(
            'Request Timeline',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 3.h),

          // Timeline items
          _buildTimelineItem(
            context,
            icon: 'schedule',
            title: 'Request Posted',
            date: postedDate,
            isCompleted: true,
          ),

          SizedBox(height: 2.h),

          _buildTimelineItem(
            context,
            icon: 'event',
            title: 'Blood Needed By',
            date: neededDate,
            isCompleted: false,
            isFuture: true,
          ),

          SizedBox(height: 3.h),

          // Current status
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(status).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Current Status: $status',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String icon,
    required String title,
    required DateTime date,
    required bool isCompleted,
    bool isFuture = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color itemColor = isCompleted
        ? colorScheme.primary
        : isFuture
            ? colorScheme.secondary
            : colorScheme.onSurface.withValues(alpha: 0.5);

    return Row(
      children: [
        // Timeline indicator
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: isCompleted ? colorScheme.primary : colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: itemColor,
              width: 2,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: isCompleted ? 'check' : icon,
              color: isCompleted ? Colors.white : itemColor,
              size: 16,
            ),
          ),
        ),

        SizedBox(width: 4.w),

        // Timeline content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _formatDate(date),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              if (isFuture) ...[
                SizedBox(height: 0.5.h),
                Text(
                  _getTimeUntilNeeded(date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeUntilNeeded(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours remaining';
    } else {
      return '${difference.inMinutes} minutes remaining';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
        return const Color(0xFF388E3C);
      case 'fulfilled':
      case 'completed':
        return const Color(0xFF1976D2);
      case 'expired':
      case 'closed':
        return const Color(0xFF757575);
      case 'urgent':
        return const Color(0xFFF57C00);
      case 'critical':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF757575);
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
        return 'check_circle';
      case 'fulfilled':
      case 'completed':
        return 'done_all';
      case 'expired':
      case 'closed':
        return 'cancel';
      case 'urgent':
        return 'schedule';
      case 'critical':
        return 'warning';
      default:
        return 'info';
    }
  }
}
