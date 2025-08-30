import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSectionWidget extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController addressController;
  final VoidCallback onUpdateLocation;
  final String? cityError;
  final String? addressError;

  const LocationSectionWidget({
    super.key,
    required this.cityController,
    required this.addressController,
    required this.onUpdateLocation,
    this.cityError,
    this.addressError,
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
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Location Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTextField(
            controller: cityController,
            label: 'City',
            hint: 'Enter your city',
            icon: 'location_city',
            error: cityError,
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: addressController,
            label: 'Address',
            hint: 'Enter your full address',
            icon: 'home',
            error: addressError,
            maxLines: 3,
          ),
          SizedBox(height: 2.h),
          _buildMapPreview(),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onUpdateLocation,
              icon: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              label: Text(
                'Update Location',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    String? error,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: icon,
                color: error != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null
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
        if (error != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              error,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMapPreview() {
    return Container(
      width: double.infinity,
      height: 20.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Map placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'map',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 12.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Map Preview',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Location will be shown here',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Location marker overlay
            Positioned(
              top: 8.h,
              left: 0,
              right: 0,
              child: Center(
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 8.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
