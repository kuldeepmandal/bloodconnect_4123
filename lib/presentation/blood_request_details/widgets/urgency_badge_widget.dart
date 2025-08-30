import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget to display urgency level badge with appropriate styling
class UrgencyBadgeWidget extends StatelessWidget {
  final String urgencyLevel;
  final DateTime? neededDate;

  const UrgencyBadgeWidget({
    super.key,
    required this.urgencyLevel,
    this.neededDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getUrgencyColor(urgencyLevel).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getUrgencyColor(urgencyLevel),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getUrgencyIcon(urgencyLevel),
            color: _getUrgencyColor(urgencyLevel),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            urgencyLevel.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: _getUrgencyColor(urgencyLevel),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          if (neededDate != null) ...[
            SizedBox(width: 2.w),
            Container(
              width: 1,
              height: 12,
              color: _getUrgencyColor(urgencyLevel).withValues(alpha: 0.3),
            ),
            SizedBox(width: 2.w),
            Text(
              _getTimeRemaining(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getUrgencyColor(urgencyLevel),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return const Color(0xFFD32F2F);
      case 'urgent':
        return const Color(0xFFF57C00);
      case 'normal':
        return const Color(0xFF388E3C);
      default:
        return const Color(0xFF757575);
    }
  }

  String _getUrgencyIcon(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return 'warning';
      case 'urgent':
        return 'schedule';
      case 'normal':
        return 'check_circle';
      default:
        return 'info';
    }
  }

  String _getTimeRemaining() {
    if (neededDate == null) return '';

    final now = DateTime.now();
    final difference = neededDate!.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h left';
    } else {
      return '${difference.inMinutes}m left';
    }
  }
}
