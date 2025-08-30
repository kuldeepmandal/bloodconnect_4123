import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdvancedFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const AdvancedFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState extends State<AdvancedFilterBottomSheet> {
  late Map<String, dynamic> _filters;
  late RangeValues _ageRange;
  late double _distanceRadius;
  late String _gender;
  late bool _verifiedOnly;
  late bool _frequentDonors;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _ageRange = RangeValues(
      (_filters['minAge'] as num?)?.toDouble() ?? 18.0,
      (_filters['maxAge'] as num?)?.toDouble() ?? 65.0,
    );
    _distanceRadius = (_filters['distanceRadius'] as num?)?.toDouble() ?? 10.0;
    _gender = _filters['gender'] as String? ?? 'any';
    _verifiedOnly = _filters['verifiedOnly'] as bool? ?? false;
    _frequentDonors = _filters['frequentDonors'] as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle and Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      'Advanced Filters',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Age Range Filter
                  _buildSectionTitle('Age Range'),
                  _buildAgeRangeFilter(theme, colorScheme),

                  SizedBox(height: 3.h),

                  // Distance Radius Filter
                  _buildSectionTitle('Distance Radius'),
                  _buildDistanceRadiusFilter(theme, colorScheme),

                  SizedBox(height: 3.h),

                  // Gender Filter
                  _buildSectionTitle('Gender Preference'),
                  _buildGenderFilter(theme, colorScheme),

                  SizedBox(height: 3.h),

                  // Additional Options
                  _buildSectionTitle('Additional Options'),
                  _buildAdditionalOptions(theme, colorScheme),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildAgeRangeFilter(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_ageRange.start.round()} years',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_ageRange.end.round()} years',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 65,
            divisions: 47,
            labels: RangeLabels(
              '${_ageRange.start.round()}',
              '${_ageRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _ageRange = values;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceRadiusFilter(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Within ${_distanceRadius.round()} km',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              CustomIconWidget(
                iconName: 'location_on',
                color: colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          Slider(
            value: _distanceRadius,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_distanceRadius.round()} km',
            onChanged: (value) {
              setState(() {
                _distanceRadius = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenderFilter(ThemeData theme, ColorScheme colorScheme) {
    final genderOptions = [
      {'value': 'any', 'label': 'Any', 'icon': 'people'},
      {'value': 'male', 'label': 'Male', 'icon': 'man'},
      {'value': 'female', 'label': 'Female', 'icon': 'woman'},
    ];

    return Row(
      children: genderOptions.map((option) {
        final isSelected = _gender == option['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gender = option['value'] as String;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: option['icon'] as String,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    option['label'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalOptions(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Verified Only Option
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: _verifiedOnly
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verified Donors Only',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Show only identity-verified donors',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _verifiedOnly,
                onChanged: (value) {
                  setState(() {
                    _verifiedOnly = value;
                  });
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Frequent Donors Option
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: _frequentDonors
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequent Donors',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Prioritize donors with multiple donations',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _frequentDonors,
                onChanged: (value) {
                  setState(() {
                    _frequentDonors = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _ageRange = const RangeValues(18.0, 65.0);
      _distanceRadius = 10.0;
      _gender = 'any';
      _verifiedOnly = false;
      _frequentDonors = false;
    });
  }

  void _applyFilters() {
    final updatedFilters = {
      'minAge': _ageRange.start.round(),
      'maxAge': _ageRange.end.round(),
      'distanceRadius': _distanceRadius.round(),
      'gender': _gender,
      'verifiedOnly': _verifiedOnly,
      'frequentDonors': _frequentDonors,
    };

    widget.onFiltersChanged(updatedFilters);
    Navigator.pop(context);
  }
}
