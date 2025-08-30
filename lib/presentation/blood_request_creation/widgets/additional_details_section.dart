import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdditionalDetailsSection extends StatelessWidget {
  final TextEditingController notesController;
  final TextEditingController contactInfoController;
  final bool hasAttachment;
  final String? attachmentName;
  final Function() onAttachmentTap;
  final Function() onRemoveAttachment;

  const AdditionalDetailsSection({
    super.key,
    required this.notesController,
    required this.contactInfoController,
    required this.hasAttachment,
    this.attachmentName,
    required this.onAttachmentTap,
    required this.onRemoveAttachment,
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
                  iconName: 'note_add',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Additional Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Medical Notes
            TextFormField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Medical Notes (Optional)',
                hintText:
                    'Any specific medical conditions, allergies, or special requirements...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'medical_information',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) {
                return Text(
                  '$currentLength/${maxLength ?? 500}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),

            // Photo Attachment
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Documents (Optional)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Attach medical reports, prescriptions, or doctor\'s notes',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                if (!hasAttachment) ...[
                  // Upload Button
                  GestureDetector(
                    onTap: onAttachmentTap,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outline,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.surfaceContainerHighest,
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'cloud_upload',
                            color: colorScheme.primary,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Tap to upload document',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'PDF, JPG, PNG (Max 5MB)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Attached File Display
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.primary),
                      borderRadius: BorderRadius.circular(12),
                      color: colorScheme.primary.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'description',
                            color: colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attachmentName ?? 'Medical Document',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Document attached successfully',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onRemoveAttachment,
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: colorScheme.error,
                            size: 20,
                          ),
                          tooltip: 'Remove attachment',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 3.h),

            // Contact Information Override
            TextFormField(
              controller: contactInfoController,
              decoration: InputDecoration(
                labelText: 'Alternative Contact (Optional)',
                hintText: 'Different contact person or phone number',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'contact_phone',
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                helperText:
                    'Leave empty to use your profile contact information',
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
    );
  }
}
