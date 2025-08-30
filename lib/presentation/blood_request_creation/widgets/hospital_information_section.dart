import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HospitalInformationSection extends StatelessWidget {
  final TextEditingController hospitalNameController;
  final TextEditingController hospitalAddressController;
  final TextEditingController contactPersonController;
  final TextEditingController contactPhoneController;
  final String? hospitalNameError;
  final String? hospitalAddressError;
  final String? contactPersonError;
  final String? contactPhoneError;

  const HospitalInformationSection({
    super.key,
    required this.hospitalNameController,
    required this.hospitalAddressController,
    required this.contactPersonController,
    required this.contactPhoneController,
    this.hospitalNameError,
    this.hospitalAddressError,
    this.contactPersonError,
    this.contactPhoneError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock hospital suggestions for autocomplete
    final List<String> hospitalSuggestions = [
      'City General Hospital',
      'St. Mary\'s Medical Center',
      'Regional Emergency Hospital',
      'Metropolitan Health Center',
      'Community Medical Hospital',
      'Central District Hospital',
      'University Medical Center',
      'Sacred Heart Hospital',
    ];

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
                  iconName: 'local_hospital',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Hospital Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Hospital Name with Autocomplete
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return hospitalSuggestions.where((String option) {
                  return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                });
              },
              onSelected: (String selection) {
                hospitalNameController.text = selection;
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                // Sync with the main controller
                fieldTextEditingController.text = hospitalNameController.text;
                fieldTextEditingController.addListener(() {
                  hospitalNameController.text = fieldTextEditingController.text;
                });

                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Hospital Name *',
                    hintText: 'Enter or select hospital name',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'local_hospital',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'arrow_drop_down',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    errorText: hospitalNameError,
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Hospital name is required';
                    }
                    return null;
                  },
                );
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 88.w,
                      constraints: BoxConstraints(maxHeight: 30.h),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            leading: CustomIconWidget(
                              iconName: 'local_hospital',
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            title: Text(
                              option,
                              style: theme.textTheme.bodyMedium,
                            ),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),

            // Hospital Address
            TextFormField(
              controller: hospitalAddressController,
              decoration: InputDecoration(
                labelText: 'Hospital Address *',
                hintText: 'Enter complete hospital address',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'location_on',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                errorText: hospitalAddressError,
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Hospital address is required';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),

            // Contact Person
            TextFormField(
              controller: contactPersonController,
              decoration: InputDecoration(
                labelText: 'Contact Person *',
                hintText: 'Doctor or staff member name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person_outline',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                errorText: contactPersonError,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Contact person is required';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),

            // Contact Phone
            TextFormField(
              controller: contactPhoneController,
              decoration: InputDecoration(
                labelText: 'Contact Phone *',
                hintText: '+1 (555) 123-4567',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'phone',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                errorText: contactPhoneError,
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Contact phone is required';
                }
                // Basic phone validation
                final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
                if (!phoneRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
