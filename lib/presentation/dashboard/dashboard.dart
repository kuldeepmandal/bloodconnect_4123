import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_bottom_bar.dart';
import './widgets/blood_distribution_chart_widget.dart';
import './widgets/blood_requests_grid_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/emergency_fab_widget.dart';
import './widgets/quick_actions_widget.dart';

/// Dashboard screen providing comprehensive blood donation overview
/// with real-time data visualization optimized for mobile access
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Sample data - in real app this would come from API
  final Map<String, int> _bloodTypeDistribution = {
    'A+': 145,
    'O+': 189,
    'B+': 98,
    'AB+': 34,
    'A-': 67,
    'O-': 23,
    'B-': 45,
    'AB-': 12,
  };

  final String _userBloodType = 'A+';
  final String _lastDonationDate = '15 days ago';
  final String _userName = 'Kuldeep Mandal';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Set initial bottom nav index based on dashboard route
    _currentBottomNavIndex = CustomBottomBar.getIndexFromRoute('/dashboard');
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar Navigation
            Container(
              color: colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.dashboard_outlined),
                    text: 'Dashboard',
                  ),
                  Tab(
                    icon: Icon(Icons.medical_services_outlined),
                    text: 'Requests',
                  ),
                  Tab(
                    icon: Icon(Icons.search_outlined),
                    text: 'Search',
                  ),
                  Tab(
                    icon: Icon(Icons.person_outline),
                    text: 'Profile',
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard Tab - Main Content
                  _buildDashboardContent(),

                  // Requests Tab
                  _buildRequestsTabContent(),

                  // Search Tab
                  _buildSearchTabContent(),

                  // Profile Tab
                  _buildProfileTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Emergency FAB for quick blood request creation
      floatingActionButton:
          _tabController.index == 0 ? const EmergencyFabWidget() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100), // Space for FAB
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Header with user info and blood type
            DashboardHeaderWidget(
              userName: _userName,
              userBloodType: _userBloodType,
              lastDonationDate: _lastDonationDate,
              isRefreshing: _isRefreshing,
            ),

            const SizedBox(height: 16),

            // Blood Distribution Chart
            BloodDistributionChartWidget(
              bloodTypeData: _bloodTypeDistribution,
            ),

            const SizedBox(height: 24),

            // Quick Actions Panel
            const QuickActionsWidget(),

            const SizedBox(height: 24),

            // Active Blood Requests Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Blood Requests',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      _tabController.animateTo(1); // Go to requests tab
                    },
                    child: Text(
                      'View All',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Blood Requests Grid
            const BloodRequestsGridWidget(
              maxDisplayCount: 6,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTabContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Requests',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: BloodRequestsGridWidget(
              showAllRequests: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTabContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Find Donors',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap on "Find Donors" in navigation\nto access full search functionality',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap on "Profile" in navigation\nto access full profile management',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
