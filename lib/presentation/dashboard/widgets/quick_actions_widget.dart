import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

/// Quick actions panel with three prominent cards for main app functions
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Quick Actions',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Action Cards
          Row(
            children: [
              // My Profile Card
              Expanded(
                child: _buildActionCard(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  subtitle: 'View & Edit',
                  color: colorScheme.secondary,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.profileManagement,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Create Request Card
              Expanded(
                child: _buildActionCard(
                  context: context,
                  icon: Icons.add_circle_outline,
                  title: 'Create Request',
                  subtitle: 'New Request',
                  color: colorScheme.error,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.bloodRequestCreation,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Find Donors Card
              Expanded(
                child: _buildActionCard(
                  context: context,
                  icon: Icons.search_outlined,
                  title: 'Find Donors',
                  subtitle: 'Search',
                  color: colorScheme.tertiary,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.donorSearch,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withAlpha(51),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.brightness == Brightness.light
                      ? Colors.black.withAlpha(13)
                      : Colors.white.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Icon with colored background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // Subtitle
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withAlpha(153),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
