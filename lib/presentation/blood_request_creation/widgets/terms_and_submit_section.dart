import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TermsAndSubmitSection extends StatelessWidget {
  final bool termsAccepted;
  final bool isSubmitting;
  final Function(bool?) onTermsChanged;
  final Function() onSubmit;
  final bool isFormValid;

  const TermsAndSubmitSection({
    super.key,
    required this.termsAccepted,
    required this.isSubmitting,
    required this.onTermsChanged,
    required this.onSubmit,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Terms and Conditions Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: termsAccepted,
                  onChanged: isSubmitting ? null : onTermsChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: isSubmitting
                        ? null
                        : () => onTermsChanged(!termsAccepted),
                    child: RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'I confirm that this blood request is authentic and medically necessary. I agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: (isFormValid && termsAccepted && !isSubmitting)
                    ? onSubmit
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      colorScheme.onSurface.withValues(alpha: 0.12),
                  disabledForegroundColor:
                      colorScheme.onSurface.withValues(alpha: 0.38),
                  elevation: isSubmitting ? 0 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Posting Request...',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'send',
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Post Blood Request',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            if (!isFormValid || !termsAccepted) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: colorScheme.error,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        !isFormValid
                            ? 'Please fill in all required fields'
                            : 'Please accept the terms and conditions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 1.h),

            // Help Text
            Text(
              'Your request will be shared with verified donors in your area',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}