import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum UrgencyLevel { critical, urgent, normal }

class UrgencySection extends StatelessWidget {
  final UrgencyLevel? selectedUrgency;
  final Function(UrgencyLevel) onUrgencyChanged;

  const UrgencySection({
    super.key,
    required this.selectedUrgency,
    required this.onUrgencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'priority_high',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Medical Urgency',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Select the urgency level for this blood request',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),

            // Urgency Options
            Column(
              children: [
                _buildUrgencyOption(
                  context,
                  UrgencyLevel.critical,
                  'Critical',
                  'Life-threatening emergency - Immediate blood needed',
                  Colors.red,
                  'emergency',
                ),
                SizedBox(height: 2.h),
                _buildUrgencyOption(
                  context,
                  UrgencyLevel.urgent,
                  'Urgent',
                  'Surgery scheduled - Blood needed within 24 hours',
                  Colors.orange,
                  'schedule',
                ),
                SizedBox(height: 2.h),
                _buildUrgencyOption(
                  context,
                  UrgencyLevel.normal,
                  'Normal',
                  'Planned procedure - Blood needed within 48-72 hours',
                  Colors.blue,
                  'event_note',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyOption(
    BuildContext context,
    UrgencyLevel urgency,
    String title,
    String description,
    Color accentColor,
    String iconName,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedUrgency == urgency;

    return GestureDetector(
      onTap: () => onUrgencyChanged(urgency),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.1)
              : colorScheme.surface,
          border: Border.all(
            color: isSelected ? accentColor : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon with colored background
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.2)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color:
                      isSelected ? accentColor : colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? accentColor : colorScheme.onSurface,
                        ),
                      ),
                      if (urgency == UrgencyLevel.critical) ...[
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'EMERGENCY',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : colorScheme.outline,
                  width: 2,
                ),
                color: isSelected ? accentColor : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  static String getUrgencyDisplayName(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.critical:
        return 'Critical';
      case UrgencyLevel.urgent:
        return 'Urgent';
      case UrgencyLevel.normal:
        return 'Normal';
    }
  }

  static Color getUrgencyColor(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.critical:
        return Colors.red;
      case UrgencyLevel.urgent:
        return Colors.orange;
      case UrgencyLevel.normal:
        return Colors.blue;
    }
  }
}
