import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonorCard extends StatelessWidget {
  final Map<String, dynamic> donor;
  final VoidCallback? onTap;
  final VoidCallback? onSendRequest;
  final VoidCallback? onViewProfile;
  final VoidCallback? onSaveContact;

  const DonorCard({
    super.key,
    required this.donor,
    this.onTap,
    this.onSendRequest,
    this.onViewProfile,
    this.onSaveContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String name = donor['name'] as String? ?? 'Unknown';
    final String bloodType = donor['bloodType'] as String? ?? 'Unknown';
    final String city = donor['city'] as String? ?? 'Unknown';
    final String status = donor['status'] as String? ?? 'unknown';
    final String distance = donor['distance'] as String? ?? '0 km';
    final String lastSeen = donor['lastSeen'] as String? ?? 'Unknown';
    final String profileImage = donor['profileImage'] as String? ?? '';
    final int? daysUntilEligible = donor['daysUntilEligible'] as int?;

    return Slidable(
      key: ValueKey(donor['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onSendRequest?.call(),
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.send,
            label: 'Request',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onViewProfile?.call(),
            backgroundColor: colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.person,
            label: 'Profile',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onSaveContact?.call(),
            backgroundColor: AppTheme.successLight,
            foregroundColor: Colors.white,
            icon: Icons.bookmark,
            label: 'Save',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getStatusColor(status, colorScheme),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: profileImage.isNotEmpty
                        ? CustomImageWidget(
                            imageUrl: profileImage,
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: colorScheme.primaryContainer,
                            child: CustomIconWidget(
                              iconName: 'person',
                              color: colorScheme.primary,
                              size: 8.w,
                            ),
                          ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Donor Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Blood Type
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              bloodType,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      // City and Distance
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              '$city • $distance',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Status and Last Seen
                      Row(
                        children: [
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status, colorScheme),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _getStatusText(status, daysUntilEligible),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getStatusColor(status, colorScheme),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Last seen: $lastSeen',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppTheme.successLight;
      case 'available_soon':
        return AppTheme.warningLight;
      case 'recently_donated':
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status, int? daysUntilEligible) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available Now';
      case 'available_soon':
        return daysUntilEligible != null
            ? 'Available in $daysUntilEligible days'
            : 'Available Soon';
      case 'recently_donated':
        return 'Recently Donated';
      default:
        return 'Status Unknown';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'send',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Send Blood Request'),
              onTap: () {
                Navigator.pop(context);
                onSendRequest?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                onViewProfile?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark',
                color: AppTheme.successLight,
                size: 24,
              ),
              title: const Text('Save Contact'),
              onTap: () {
                Navigator.pop(context);
                onSaveContact?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: Theme.of(context).colorScheme.tertiary,
                size: 24,
              ),
              title: const Text('Call Donor'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Call feature coming soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
