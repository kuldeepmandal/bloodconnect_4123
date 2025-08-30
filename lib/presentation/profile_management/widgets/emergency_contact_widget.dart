import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class EmergencyContactWidget extends StatelessWidget {
  final TextEditingController emergencyContactController;
  final String? emergencyContactError;

  const EmergencyContactWidget({
    super.key,
    required this.emergencyContactController,
    this.emergencyContactError,
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
                  color: AppTheme.lightTheme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'emergency',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Contact',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildEmergencyContactField(),
          if (emergencyContactController.text.isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildQuickDialButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact Number',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: emergencyContactController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            hintText: 'Enter emergency contact number',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'phone',
                color: emergencyContactError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: emergencyContactController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: GestureDetector(
                      onTap: _makePhoneCall,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'call',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 4.w,
                        ),
                      ),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: emergencyContactError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: emergencyContactError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: emergencyContactError != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppTheme.lightTheme.colorScheme.surface,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        if (emergencyContactError != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              emergencyContactError!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
        SizedBox(height: 0.5.h),
        Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Text(
            'This contact will be notified in case of emergency',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickDialButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.errorContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'speed_dial',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Dial Available',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                Text(
                  'Tap the call icon to dial emergency contact',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _makePhoneCall,
            icon: CustomIconWidget(
              iconName: 'call',
              color: Colors.white,
              size: 4.w,
            ),
            label: Text(
              'Call',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final phoneNumber = emergencyContactController.text.trim();
    if (phoneNumber.isNotEmpty) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          // Handle case where phone app is not available
          debugPrint('Could not launch phone app');
        }
      } catch (e) {
        debugPrint('Error launching phone app: $e');
      }
    }
  }
}
