import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PatientDetailsSection extends StatelessWidget {
  final TextEditingController patientNameController;
  final String? selectedBloodType;
  final int unitsNeeded;
  final Function(String?) onBloodTypeChanged;
  final Function(int) onUnitsChanged;
  final String? patientNameError;
  final String? bloodTypeError;

  const PatientDetailsSection({
    super.key,
    required this.patientNameController,
    required this.selectedBloodType,
    required this.unitsNeeded,
    required this.onBloodTypeChanged,
    required this.onUnitsChanged,
    this.patientNameError,
    this.bloodTypeError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Patient Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Patient Name Field
            TextFormField(
              controller: patientNameController,
              decoration: InputDecoration(
                labelText: 'Patient Name *',
                hintText: 'Enter patient full name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person_outline',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                errorText: patientNameError,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Patient name is required';
                }
                if (value.trim().length < 2) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),

            // Blood Type Selector
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Required Blood Type *',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: bloodTypeError != null
                          ? colorScheme.error
                          : colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _buildBloodTypeOptions(context),
                  ),
                ),
                if (bloodTypeError != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    bloodTypeError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 3.h),

            // Units Needed
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Units Needed *',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'water_drop',
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Blood Units',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: unitsNeeded > 1
                                ? () => onUnitsChanged(unitsNeeded - 1)
                                : null,
                            icon: CustomIconWidget(
                              iconName: 'remove_circle_outline',
                              color: unitsNeeded > 1
                                  ? colorScheme.primary
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.3),
                              size: 24,
                            ),
                          ),
                          Container(
                            width: 12.w,
                            alignment: Alignment.center,
                            child: Text(
                              unitsNeeded.toString(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: unitsNeeded < 10
                                ? () => onUnitsChanged(unitsNeeded + 1)
                                : null,
                            icon: CustomIconWidget(
                              iconName: 'add_circle_outline',
                              color: unitsNeeded < 10
                                  ? colorScheme.primary
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.3),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Each unit is approximately 450ml of blood',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBloodTypeOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<String> bloodTypes = [
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
      'O+',
      'O-'
    ];

    return bloodTypes.map((bloodType) {
      final isSelected = selectedBloodType == bloodType;

      return GestureDetector(
        onTap: () => onBloodTypeChanged(bloodType),
        child: Container(
          width: 18.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surface,
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'water_drop',
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(height: 0.5.h),
              Text(
                bloodType,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
