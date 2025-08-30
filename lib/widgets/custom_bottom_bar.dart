import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data class for bottom navigation
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar for blood donation application
/// Implements Contemporary Medical Minimalism with contextual navigation
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  /// Elevation of the bottom bar
  final double elevation;

  /// Whether to show labels
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.showLabels = true,
  });

  /// Navigation items for the blood donation app
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/dashboard',
    ),
    BottomNavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Find Donors',
      route: '/donor-search',
    ),
    BottomNavItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Request',
      route: '/blood-request-creation',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile-management',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.black.withAlpha(26)
                : Colors.white.withAlpha(26),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavItem(
                context,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item
  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color itemColor = isSelected
        ? (selectedItemColor ?? colorScheme.primary)
        : (unselectedItemColor ?? colorScheme.onSurface.withAlpha(153));

    return Expanded(
      child: InkWell(
        onTap: () => _handleNavigation(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with selection animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(4),
                decoration: isSelected
                    ? BoxDecoration(
                        color: colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  color: itemColor,
                  size: 24,
                ),
              ),

              // Label with fade animation
              if (showLabels) ...[
                const SizedBox(height: 2),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected ? 1.0 : 0.7,
                  child: Text(
                    item.label,
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                      color: itemColor,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Handles navigation when item is tapped
  void _handleNavigation(BuildContext context, int index, String route) {
    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route if it's different from current
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      // For dashboard, use pushNamedAndRemoveUntil to clear stack
      if (route == '/dashboard') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
      } else {
        Navigator.pushNamed(context, route);
      }
    }
  }

  /// Factory constructor for main navigation
  factory CustomBottomBar.main({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }

  /// Factory constructor for emergency mode (reduced options)
  factory CustomBottomBar.emergency({
    Key? key,
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      showLabels: false, // Hide labels for cleaner emergency UI
    );
  }

  /// Helper method to get current index based on route
  static int getIndexFromRoute(String? route) {
    switch (route) {
      case '/dashboard':
        return 0;
      case '/donor-search':
        return 1;
      case '/blood-request-creation':
        return 2;
      case '/profile-management':
        return 3;
      default:
        return 0; // Default to dashboard
    }
  }

  /// Helper method to check if route should show bottom navigation
  static bool shouldShowBottomNav(String? route) {
    const List<String> bottomNavRoutes = [
      '/dashboard',
      '/donor-search',
      '/blood-request-creation',
      '/profile-management',
    ];
    return bottomNavRoutes.contains(route);
  }
}
