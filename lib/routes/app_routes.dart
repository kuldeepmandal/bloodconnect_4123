import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/profile_management/profile_management.dart';
import '../presentation/donor_search/donor_search.dart';
import '../presentation/blood_request_details/blood_request_details.dart';
import '../presentation/blood_request_creation/blood_request_creation.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String dashboard = '/dashboard';
  static const String profileManagement = '/profile-management';
  static const String donorSearch = '/donor-search';
  static const String bloodRequestDetails = '/blood-request-details';
  static const String bloodRequestCreation = '/blood-request-creation';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    dashboard: (context) => const Dashboard(),
    profileManagement: (context) => const ProfileManagement(),
    donorSearch: (context) => const DonorSearch(),
    bloodRequestDetails: (context) => const BloodRequestDetails(),
    bloodRequestCreation: (context) => const BloodRequestCreation(),
    // TODO: Add your other routes here
  };
}
