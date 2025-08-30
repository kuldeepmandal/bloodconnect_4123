import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySettingsWidget extends StatelessWidget {
  final bool profileVisibility;
  final bool notificationPreferences;
  final Function(bool) onProfileVisibilityChanged;
  final Function(bool) onNotificationPreferencesChanged;

  const PrivacySettingsWidget({
    super.key,
    required this.profileVisibility,
    required this.notificationPreferences,
    required this.onProfileVisibilityChanged,
    required this.onNotificationPreferencesChanged,
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
                  color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'privacy_tip',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Privacy Settings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSettingTile(
            icon: 'visibility',
            title: 'Profile Visibility',
            subtitle: 'Allow other users to see your profile',
            value: profileVisibility,
            onChanged: onProfileVisibilityChanged,
          ),
          SizedBox(height: 2.h),
          _buildSettingTile(
            icon: 'notifications',
            title: 'Push Notifications',
            subtitle: 'Receive notifications for blood requests',
            value: notificationPreferences,
            onChanged: onNotificationPreferencesChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: value
                  ? AppTheme.lightTheme.colorScheme.primaryContainer
                  : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: value
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            activeTrackColor: AppTheme.lightTheme.colorScheme.primaryContainer,
            inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
