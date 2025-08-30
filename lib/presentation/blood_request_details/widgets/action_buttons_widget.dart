import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for primary action buttons in thumb-reach zone
class ActionButtonsWidget extends StatelessWidget {
  final bool canHelp;
  final VoidCallback? onICanHelp;
  final VoidCallback? onShareRequest;
  final VoidCallback? onSaveForLater;
  final VoidCallback? onReportRequest;
  final bool isLoading;

  const ActionButtonsWidget({
    super.key,
    required this.canHelp,
    this.onICanHelp,
    this.onShareRequest,
    this.onSaveForLater,
    this.onReportRequest,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary action buttons
            Row(
              children: [
                // I Can Help button
                if (canHelp)
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onICanHelp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'volunteer_activism',
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'I Can Help',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                if (canHelp) SizedBox(width: 3.w),

                // Share Request button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onShareRequest,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary, width: 1),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'share',
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Share',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Secondary action buttons
            Row(
              children: [
                // Save for Later button
                Expanded(
                  child: TextButton(
                    onPressed: onSaveForLater,
                    style: TextButton.styleFrom(
                      foregroundColor:
                          colorScheme.onSurface.withValues(alpha: 0.7),
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'bookmark_border',
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Save for Later',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 20,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),

                // Report Request button
                Expanded(
                  child: TextButton(
                    onPressed: onReportRequest,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'flag_outlined',
                          color: colorScheme.error,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Report',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
