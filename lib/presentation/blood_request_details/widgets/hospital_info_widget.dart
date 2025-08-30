import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget to display hospital information with contact functionality
class HospitalInfoWidget extends StatelessWidget {
  final String hospitalName;
  final String address;
  final String contactPerson;
  final String phoneNumber;
  final String? mapUrl;

  const HospitalInfoWidget({
    super.key,
    required this.hospitalName,
    required this.address,
    required this.contactPerson,
    required this.phoneNumber,
    this.mapUrl,
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
          // Hospital name
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_hospital',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  hospitalName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Address with map preview
          _buildInfoRow(
            context,
            icon: 'location_on',
            title: 'Address',
            content: address,
            onTap: mapUrl != null ? () => _openMap(context) : null,
          ),

          SizedBox(height: 2.h),

          // Contact person
          _buildInfoRow(
            context,
            icon: 'person',
            title: 'Contact Person',
            content: contactPerson,
          ),

          SizedBox(height: 2.h),

          // Phone number with call functionality
          _buildInfoRow(
            context,
            icon: 'phone',
            title: 'Phone Number',
            content: phoneNumber,
            onTap: () => _makePhoneCall(context),
            showCallButton: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String icon,
    required String title,
    required String content,
    VoidCallback? onTap,
    bool showCallButton = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (showCallButton) ...[
              SizedBox(width: 2.w),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _makePhoneCall(context),
                  icon: CustomIconWidget(
                    iconName: 'call',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: 'Call Hospital',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(BuildContext context) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Copy to clipboard as fallback
        await Clipboard.setData(ClipboardData(text: phoneNumber));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Phone number copied to clipboard: $phoneNumber'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Copy to clipboard as fallback
      await Clipboard.setData(ClipboardData(text: phoneNumber));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number copied to clipboard: $phoneNumber'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _openMap(BuildContext context) async {
    if (mapUrl == null) return;

    try {
      final Uri mapUri = Uri.parse(mapUrl!);
      if (await canLaunchUrl(mapUri)) {
        await launchUrl(mapUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to open map application'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open map application'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
