import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

/// Emergency floating action button for rapid blood request creation
/// with platform-specific design (Android FAB, iOS prominent button)
class EmergencyFabWidget extends StatelessWidget {
  const EmergencyFabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FloatingActionButton.extended(
      onPressed: () => _handleEmergencyRequest(context),
      backgroundColor: colorScheme.error,
      foregroundColor: Colors.white,
      elevation: 6.0,
      icon: const Icon(Icons.emergency),
      label: Text(
        'Emergency',
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _handleEmergencyRequest(BuildContext context) {
    // Show emergency confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.emergency,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Emergency Request',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'This will create a high-priority blood request. Are you sure this is an emergency?',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  AppRoutes.bloodRequestCreation,
                  arguments: {'emergency': true},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
