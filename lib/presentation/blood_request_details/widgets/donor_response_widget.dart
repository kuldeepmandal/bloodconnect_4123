import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget to display donor responses and interested donor count
class DonorResponseWidget extends StatelessWidget {
  final int interestedDonorCount;
  final List<Map<String, dynamic>> donorResponses;
  final VoidCallback? onViewAllDonors;

  const DonorResponseWidget({
    super.key,
    required this.interestedDonorCount,
    required this.donorResponses,
    this.onViewAllDonors,
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
          // Header with donor count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Donor Responses',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$interestedDonorCount ${interestedDonorCount == 1 ? 'Donor' : 'Donors'} Interested',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Donor response list
          if (donorResponses.isEmpty)
            _buildEmptyState(context)
          else
            Column(
              children: [
                ...donorResponses
                    .take(3)
                    .map((donor) => _buildDonorCard(context, donor)),
                if (donorResponses.length > 3) ...[
                  SizedBox(height: 2.h),
                  _buildViewAllButton(context),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'people_outline',
            color: colorScheme.onSurface.withValues(alpha: 0.3),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No donor responses yet',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Share this request to reach more donors',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDonorCard(BuildContext context, Map<String, dynamic> donor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Donor avatar
          CircleAvatar(
            radius: 6.w,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            child: donor['avatar'] != null
                ? CustomImageWidget(
                    imageUrl: donor['avatar'] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  )
                : CustomIconWidget(
                    iconName: 'person',
                    color: colorScheme.primary,
                    size: 6.w,
                  ),
          ),

          SizedBox(width: 3.w),

          // Donor info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor['name'] as String? ?? 'Anonymous Donor',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        donor['city'] as String? ?? 'Unknown City',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (donor['lastDonation'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Last donation: ${donor['lastDonation']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Response time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatResponseTime(donor['responseTime'] as String? ?? ''),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onViewAllDonors,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View All ${donorResponses.length} Donors',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: colorScheme.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatResponseTime(String responseTime) {
    if (responseTime.isEmpty) return '';

    try {
      final time = DateTime.parse(responseTime);
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return responseTime;
    }
  }
}
