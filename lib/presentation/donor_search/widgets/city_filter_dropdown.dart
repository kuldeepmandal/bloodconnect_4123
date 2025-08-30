import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CityFilterDropdown extends StatelessWidget {
  final String? selectedCity;
  final List<String> cities;
  final ValueChanged<String?> onChanged;
  final bool showCurrentLocation;
  final VoidCallback? onCurrentLocationTap;

  const CityFilterDropdown({
    super.key,
    this.selectedCity,
    required this.cities,
    required this.onChanged,
    this.showCurrentLocation = true,
    this.onCurrentLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCity,
          hint: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_city',
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Select City',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: colorScheme.onSurfaceVariant,
            size: 24,
          ),
          isExpanded: true,
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          items: _buildDropdownItems(context),
          onChanged: onChanged,
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<DropdownMenuItem<String>> items = [];

    // Add current location option if enabled
    if (showCurrentLocation) {
      items.add(
        DropdownMenuItem<String>(
          value: 'current_location',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'my_location',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Use Current Location',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

      // Add divider
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Container(
            height: 1,
            color: colorScheme.outline,
            margin: EdgeInsets.symmetric(vertical: 1.h),
          ),
        ),
      );
    }

    // Add city options
    for (String city in cities) {
      items.add(
        DropdownMenuItem<String>(
          value: city,
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_city',
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  city,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return items;
  }
}
