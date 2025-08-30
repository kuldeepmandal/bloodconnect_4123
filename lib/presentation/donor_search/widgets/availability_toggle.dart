import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AvailabilityToggle extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? subtitle;

  const AvailabilityToggle({
    super.key,
    required this.isEnabled,
    required this.onChanged,
    this.label = 'Available Now',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Toggle Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isEnabled
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: isEnabled ? 'check_circle' : 'schedule',
              color: isEnabled
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),

          SizedBox(width: 3.w),

          // Label and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isEnabled ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Switch
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            activeTrackColor: colorScheme.primary.withValues(alpha: 0.3),
            inactiveThumbColor: colorScheme.onSurfaceVariant,
            inactiveTrackColor: colorScheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
