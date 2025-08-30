import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final String iconName;

  const SearchEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.iconName = 'search_off',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: colorScheme.primary,
                  size: 12.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Factory constructors for common empty states
  factory SearchEmptyState.noResults({
    Key? key,
    VoidCallback? onClearFilters,
  }) {
    return SearchEmptyState(
      key: key,
      title: 'No Donors Found',
      subtitle:
          'We couldn\'t find any donors matching your criteria. Try adjusting your filters or search in a different city.',
      actionText: 'Clear Filters',
      onActionPressed: onClearFilters,
      iconName: 'person_search',
    );
  }

  factory SearchEmptyState.noAvailableDonors({
    Key? key,
    VoidCallback? onExpandSearch,
  }) {
    return SearchEmptyState(
      key: key,
      title: 'No Available Donors',
      subtitle:
          'All donors in your area have recently donated. Try expanding your search radius or check back later.',
      actionText: 'Expand Search',
      onActionPressed: onExpandSearch,
      iconName: 'schedule',
    );
  }

  factory SearchEmptyState.networkError({
    Key? key,
    VoidCallback? onRetry,
  }) {
    return SearchEmptyState(
      key: key,
      title: 'Connection Error',
      subtitle:
          'Unable to load donor information. Please check your internet connection and try again.',
      actionText: 'Retry',
      onActionPressed: onRetry,
      iconName: 'wifi_off',
    );
  }

  factory SearchEmptyState.locationError({
    Key? key,
    VoidCallback? onEnableLocation,
  }) {
    return SearchEmptyState(
      key: key,
      title: 'Location Required',
      subtitle:
          'We need your location to find nearby donors. Please enable location services to continue.',
      actionText: 'Enable Location',
      onActionPressed: onEnableLocation,
      iconName: 'location_off',
    );
  }
}
