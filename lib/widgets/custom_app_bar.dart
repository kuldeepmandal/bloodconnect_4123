import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget for blood donation application
/// Implements Contemporary Medical Minimalism design with consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true when there's a previous route)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title (defaults to true for medical app consistency)
  final bool centerTitle;

  /// Custom background color (defaults to theme surface color)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons
  final Color? foregroundColor;

  /// Elevation of the app bar (defaults to 2.0 for subtle depth)
  final double elevation;

  /// Whether to show a bottom border divider
  final bool showDivider;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool canPop = Navigator.of(context).canPop();

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: foregroundColor ?? colorScheme.onSurface,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      shadowColor: theme.brightness == Brightness.light
          ? Colors.black.withAlpha(26)
          : Colors.white.withAlpha(26),
      leading: leading ??
          (canPop && showBackButton ? _buildBackButton(context) : null),
      actions: actions != null ? [...actions!, const SizedBox(width: 8)] : null,
      bottom: showDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                height: 1.0,
                color: theme.dividerColor,
              ),
            )
          : null,
    );
  }

  /// Builds the back button with consistent styling
  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: foregroundColor ?? colorScheme.onSurface,
        size: 20,
      ),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Back',
      splashRadius: 20,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (showDivider ? 1.0 : 0.0),
      );

  /// Factory constructor for dashboard app bar
  factory CustomAppBar.dashboard({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Blood Donation',
      showBackButton: false,
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.person_outline, size: 24),
                onPressed: () =>
                    Navigator.pushNamed(context, '/profile-management'),
                tooltip: 'Profile',
                splashRadius: 20,
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                onPressed: () {
                  // TODO: Implement notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Notifications',
                splashRadius: 20,
              ),
            ),
          ],
    );
  }

  /// Factory constructor for profile management app bar
  factory CustomAppBar.profile({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Profile Management',
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.edit_outlined, size: 24),
                onPressed: () {
                  // TODO: Implement edit profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Edit Profile',
                splashRadius: 20,
              ),
            ),
          ],
    );
  }

  /// Factory constructor for blood request creation app bar
  factory CustomAppBar.bloodRequest({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Create Blood Request',
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.help_outline, size: 24),
                onPressed: () {
                  // TODO: Implement help
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Help',
                splashRadius: 20,
              ),
            ),
          ],
    );
  }

  /// Factory constructor for donor search app bar
  factory CustomAppBar.donorSearch({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Find Donors',
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.filter_list_outlined, size: 24),
                onPressed: () {
                  // TODO: Implement filters
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filter feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Filter',
                splashRadius: 20,
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.search, size: 24),
                onPressed: () {
                  // TODO: Implement search
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Search feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Search',
                splashRadius: 20,
              ),
            ),
          ],
    );
  }

  /// Factory constructor for blood request details app bar
  factory CustomAppBar.requestDetails({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Request Details',
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.share_outlined, size: 24),
                onPressed: () {
                  // TODO: Implement share
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Share',
                splashRadius: 20,
              ),
            ),
            Builder(
              builder: (context) => PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 24),
                tooltip: 'More options',
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      // TODO: Implement edit request
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit request feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      break;
                    case 'delete':
                      // TODO: Implement delete request
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delete request feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Edit Request'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20),
                        SizedBox(width: 12),
                        Text('Delete Request'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
