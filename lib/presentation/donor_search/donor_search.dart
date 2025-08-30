import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_filter_bottom_sheet.dart';
import './widgets/availability_toggle.dart';
import './widgets/blood_type_filter_chip.dart';
import './widgets/city_filter_dropdown.dart';
import './widgets/donor_card.dart';
import './widgets/search_empty_state.dart';

class DonorSearch extends StatefulWidget {
  const DonorSearch({super.key});

  @override
  State<DonorSearch> createState() => _DonorSearchState();
}

class _DonorSearchState extends State<DonorSearch>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  List<String> _selectedBloodTypes = [];
  String? _selectedCity;
  bool _availableNowOnly = false;
  Map<String, dynamic> _advancedFilters = {};

  // Search states
  bool _isLoading = false;
  bool _hasSearched = false;
  List<Map<String, dynamic>> _searchResults = [];

  // Mock data
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose'
  ];

  final List<Map<String, dynamic>> _mockDonors = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "bloodType": "O+",
      "city": "New York",
      "status": "available",
      "distance": "2.3 km",
      "lastSeen": "2 hours ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "age": 28,
      "gender": "female",
      "verified": true,
      "donationCount": 5,
      "lastDonation": "2024-06-15",
      "daysUntilEligible": null,
    },
    {
      "id": 2,
      "name": "Michael Rodriguez",
      "bloodType": "A+",
      "city": "New York",
      "status": "available_soon",
      "distance": "4.1 km",
      "lastSeen": "1 day ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "age": 34,
      "gender": "male",
      "verified": true,
      "donationCount": 12,
      "lastDonation": "2024-07-20",
      "daysUntilEligible": 15,
    },
    {
      "id": 3,
      "name": "Emily Chen",
      "bloodType": "B-",
      "city": "Los Angeles",
      "status": "available",
      "distance": "1.8 km",
      "lastSeen": "30 minutes ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "age": 25,
      "gender": "female",
      "verified": false,
      "donationCount": 3,
      "lastDonation": null,
      "daysUntilEligible": null,
    },
    {
      "id": 4,
      "name": "David Thompson",
      "bloodType": "AB+",
      "city": "Chicago",
      "status": "recently_donated",
      "distance": "6.7 km",
      "lastSeen": "3 hours ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "age": 42,
      "gender": "male",
      "verified": true,
      "donationCount": 8,
      "lastDonation": "2024-08-25",
      "daysUntilEligible": 45,
    },
    {
      "id": 5,
      "name": "Lisa Anderson",
      "bloodType": "O-",
      "city": "Houston",
      "status": "available",
      "distance": "3.2 km",
      "lastSeen": "5 minutes ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "age": 31,
      "gender": "female",
      "verified": true,
      "donationCount": 15,
      "lastDonation": "2024-05-10",
      "daysUntilEligible": null,
    },
    {
      "id": 6,
      "name": "James Wilson",
      "bloodType": "A-",
      "city": "Phoenix",
      "status": "available_soon",
      "distance": "5.4 km",
      "lastSeen": "2 days ago",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "age": 29,
      "gender": "male",
      "verified": false,
      "donationCount": 2,
      "lastDonation": "2024-07-30",
      "daysUntilEligible": 8,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _performInitialSearch();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performInitialSearch() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _searchResults = List.from(_mockDonors);
          _isLoading = false;
          _hasSearched = true;
        });
      }
    });
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with filters
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        List<Map<String, dynamic>> filteredResults = List.from(_mockDonors);

        // Apply blood type filter
        if (_selectedBloodTypes.isNotEmpty) {
          filteredResults = filteredResults.where((donor) {
            return _selectedBloodTypes.contains(donor['bloodType'] as String);
          }).toList();
        }

        // Apply city filter
        if (_selectedCity != null && _selectedCity != 'current_location') {
          filteredResults = filteredResults.where((donor) {
            return donor['city'] == _selectedCity;
          }).toList();
        }

        // Apply availability filter
        if (_availableNowOnly) {
          filteredResults = filteredResults.where((donor) {
            return donor['status'] == 'available';
          }).toList();
        }

        // Apply advanced filters
        if (_advancedFilters.isNotEmpty) {
          filteredResults = _applyAdvancedFilters(filteredResults);
        }

        setState(() {
          _searchResults = filteredResults;
          _isLoading = false;
          _hasSearched = true;
        });
      }
    });
  }

  List<Map<String, dynamic>> _applyAdvancedFilters(
      List<Map<String, dynamic>> donors) {
    List<Map<String, dynamic>> filtered = donors;

    // Age filter
    if (_advancedFilters['minAge'] != null &&
        _advancedFilters['maxAge'] != null) {
      filtered = filtered.where((donor) {
        final age = donor['age'] as int;
        return age >= _advancedFilters['minAge'] &&
            age <= _advancedFilters['maxAge'];
      }).toList();
    }

    // Gender filter
    if (_advancedFilters['gender'] != null &&
        _advancedFilters['gender'] != 'any') {
      filtered = filtered.where((donor) {
        return donor['gender'] == _advancedFilters['gender'];
      }).toList();
    }

    // Verified only filter
    if (_advancedFilters['verifiedOnly'] == true) {
      filtered = filtered.where((donor) {
        return donor['verified'] == true;
      }).toList();
    }

    // Frequent donors filter
    if (_advancedFilters['frequentDonors'] == true) {
      filtered = filtered.where((donor) {
        return (donor['donationCount'] as int) >= 5;
      }).toList();
    }

    return filtered;
  }

  void _toggleBloodType(String bloodType) {
    setState(() {
      if (_selectedBloodTypes.contains(bloodType)) {
        _selectedBloodTypes.remove(bloodType);
      } else {
        _selectedBloodTypes.add(bloodType);
      }
    });
    _performSearch();
  }

  void _onCityChanged(String? city) {
    setState(() {
      _selectedCity = city;
    });

    if (city == 'current_location') {
      // TODO: Implement location services
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services feature coming soon'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    _performSearch();
  }

  void _onAvailabilityToggle(bool value) {
    setState(() {
      _availableNowOnly = value;
    });
    _performSearch();
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFilterBottomSheet(
        currentFilters: _advancedFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _advancedFilters = filters;
          });
          _performSearch();
        },
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedBloodTypes.clear();
      _selectedCity = null;
      _availableNowOnly = false;
      _advancedFilters.clear();
      _searchController.clear();
    });
    _performSearch();
  }

  void _refreshSearch() {
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar.donorSearch(),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Search'),
                Tab(text: 'Saved'),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSearchTab(),
                _buildSavedTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.main(
        currentIndex: CustomBottomBar.getIndexFromRoute('/donor-search'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAdvancedFilters,
        tooltip: 'Advanced Filters',
        child: CustomIconWidget(
          iconName: 'tune',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return RefreshIndicator(
      onRefresh: () async => _refreshSearch(),
      child: Column(
        children: [
          // Search Header
          Container(
            padding: EdgeInsets.all(4.w),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search donors by name or location...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _performSearch();
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    if (value.isEmpty) {
                      _performSearch();
                    }
                  },
                  onSubmitted: (value) => _performSearch(),
                ),

                SizedBox(height: 2.h),

                // Blood Type Filter
                SizedBox(
                  height: 6.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _bloodTypes.length,
                    itemBuilder: (context, index) {
                      final bloodType = _bloodTypes[index];
                      return BloodTypeFilterChip(
                        bloodType: bloodType,
                        isSelected: _selectedBloodTypes.contains(bloodType),
                        onTap: () => _toggleBloodType(bloodType),
                      );
                    },
                  ),
                ),

                SizedBox(height: 2.h),

                // City and Availability Filters
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CityFilterDropdown(
                        selectedCity: _selectedCity,
                        cities: _cities,
                        onChanged: _onCityChanged,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      flex: 3,
                      child: AvailabilityToggle(
                        isEnabled: _availableNowOnly,
                        onChanged: _onAvailabilityToggle,
                        subtitle: 'Eligible to donate now',
                      ),
                    ),
                  ],
                ),

                // Active Filters Summary
                if (_selectedBloodTypes.isNotEmpty ||
                    _selectedCity != null ||
                    _availableNowOnly ||
                    _advancedFilters.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getActiveFiltersText(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                      TextButton(
                        onPressed: _clearAllFilters,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTab() {
    return const Center(
      child: Text(
        'Saved donors feature coming soon',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (!_hasSearched) {
      return SearchEmptyState(
        title: 'Start Your Search',
        subtitle:
            'Use the filters above to find blood donors in your area. We\'ll help you connect with available donors quickly.',
        iconName: 'search',
      );
    }

    if (_searchResults.isEmpty) {
      return SearchEmptyState.noResults(
        onClearFilters: _clearAllFilters,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 1.h, bottom: 10.h),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final donor = _searchResults[index];
        return DonorCard(
          donor: donor,
          onTap: () => _viewDonorProfile(donor),
          onSendRequest: () => _sendBloodRequest(donor),
          onViewProfile: () => _viewDonorProfile(donor),
          onSaveContact: () => _saveDonorContact(donor),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 1.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Container(
            padding: EdgeInsets.all(4.w),
            height: 12.h,
            child: Row(
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 1.5.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getActiveFiltersText() {
    List<String> filters = [];

    if (_selectedBloodTypes.isNotEmpty) {
      filters.add('${_selectedBloodTypes.length} blood type(s)');
    }

    if (_selectedCity != null) {
      filters.add(_selectedCity == 'current_location'
          ? 'Current location'
          : _selectedCity!);
    }

    if (_availableNowOnly) {
      filters.add('Available now');
    }

    if (_advancedFilters.isNotEmpty) {
      filters.add('Advanced filters');
    }

    return 'Active filters: ${filters.join(', ')}';
  }

  void _viewDonorProfile(Map<String, dynamic> donor) {
    // TODO: Navigate to donor profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing profile for ${donor['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendBloodRequest(Map<String, dynamic> donor) {
    Navigator.pushNamed(context, '/blood-request-creation');
  }

  void _saveDonorContact(Map<String, dynamic> donor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${donor['name']} saved to contacts'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
      ),
    );
  }
}
