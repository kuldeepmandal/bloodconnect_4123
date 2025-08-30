import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DateNeededSection extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateChanged;
  final String? dateError;

  const DateNeededSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.dateError,
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
                  iconName: 'calendar_today',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Date Needed',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'When do you need the blood donation?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),

            // Date Picker Button
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dateError != null
                        ? colorScheme.error
                        : colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'event',
                      color: selectedDate != null
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
                            selectedDate != null
                                ? _formatDate(selectedDate!)
                                : 'Select date needed',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: selectedDate != null
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: selectedDate != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                          if (selectedDate != null) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              _getDateDescription(selectedDate!),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getDateDescriptionColor(
                                  selectedDate!,
                                  colorScheme,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'arrow_drop_down',
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),

            if (dateError != null) ...[
              SizedBox(height: 1.h),
              Text(
                dateError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // Quick Date Options
            Text(
              'Quick Options',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _buildQuickDateOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuickDateOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final quickOptions = [
      {'label': 'Today', 'days': 0},
      {'label': 'Tomorrow', 'days': 1},
      {'label': 'In 3 days', 'days': 3},
      {'label': 'In 1 week', 'days': 7},
    ];

    return quickOptions.map((option) {
      final date = DateTime.now().add(Duration(days: option['days'] as int));
      final isSelected =
          selectedDate != null && _isSameDay(selectedDate!, date);

      return GestureDetector(
        onTap: () => onDateChanged(date),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            option['label'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select date needed',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getDateDescription(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today - Immediate need';
    } else if (difference == 1) {
      return 'Tomorrow - Urgent';
    } else if (difference <= 3) {
      return 'In $difference days - Urgent';
    } else if (difference <= 7) {
      return 'In $difference days - Planned';
    } else {
      return 'In $difference days - Scheduled';
    }
  }

  Color _getDateDescriptionColor(DateTime date, ColorScheme colorScheme) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference <= 1) {
      return Colors.red;
    } else if (difference <= 3) {
      return Colors.orange;
    } else {
      return colorScheme.onSurfaceVariant;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
