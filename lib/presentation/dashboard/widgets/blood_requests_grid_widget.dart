import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

/// Grid widget displaying active blood requests ordered by criticality
/// with swipe-to-view-details functionality and empty states
class BloodRequestsGridWidget extends StatelessWidget {
  final bool showAllRequests;
  final int maxDisplayCount;

  const BloodRequestsGridWidget({
    super.key,
    this.showAllRequests = false,
    this.maxDisplayCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final List<BloodRequestData> requests = _getSampleRequests();
    final List<BloodRequestData> displayRequests =
        showAllRequests ? requests : requests.take(maxDisplayCount).toList();

    if (displayRequests.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: displayRequests.length,
        itemBuilder: (context, index) {
          final request = displayRequests[index];
          return _buildRequestCard(context, request);
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, BloodRequestData request) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final urgencyColor = _getUrgencyColor(request.urgency, theme);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.bloodRequestDetails,
        arguments: request.id,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: urgencyColor.withAlpha(51),
            width: 2,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Urgency Badge and Blood Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: urgencyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.urgency.toUpperCase(),
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      request.bloodType,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Units Needed
              Row(
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 16,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${request.unitsNeeded} units needed',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Hospital Name
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.hospitalName,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Time Remaining
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: urgencyColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.timeRemaining,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: urgencyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          // Hero icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.favorite,
              size: 48,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          // Encouraging message
          Text(
            'Be a Hero',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'No urgent blood requests at the moment.\nYour contribution saves lives!',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Action button
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.bloodRequestCreation,
            ),
            child: Text('Create Request'),
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency, ThemeData theme) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return const Color(0xFFD32F2F); // Red
      case 'urgent':
        return const Color(0xFFF57C00); // Orange
      case 'normal':
      default:
        return theme.colorScheme.primary; // Blue
    }
  }

  List<BloodRequestData> _getSampleRequests() {
    return [
      BloodRequestData(
        id: '1',
        bloodType: 'O-',
        unitsNeeded: 3,
        urgency: 'critical',
        hospitalName: 'City General Hospital',
        timeRemaining: '2 hours left',
      ),
      BloodRequestData(
        id: '2',
        bloodType: 'A+',
        unitsNeeded: 2,
        urgency: 'urgent',
        hospitalName: 'St. Mary Medical Center',
        timeRemaining: '6 hours left',
      ),
      BloodRequestData(
        id: '3',
        bloodType: 'B+',
        unitsNeeded: 1,
        urgency: 'normal',
        hospitalName: 'Regional Health Clinic',
        timeRemaining: '1 day left',
      ),
      BloodRequestData(
        id: '4',
        bloodType: 'AB-',
        unitsNeeded: 4,
        urgency: 'critical',
        hospitalName: 'Emergency Medical Center',
        timeRemaining: '4 hours left',
      ),
      BloodRequestData(
        id: '5',
        bloodType: 'O+',
        unitsNeeded: 2,
        urgency: 'urgent',
        hospitalName: 'Community Hospital',
        timeRemaining: '8 hours left',
      ),
      BloodRequestData(
        id: '6',
        bloodType: 'A-',
        unitsNeeded: 1,
        urgency: 'normal',
        hospitalName: 'Metro Health Center',
        timeRemaining: '2 days left',
      ),
    ];
  }
}

/// Data model for blood request information
class BloodRequestData {
  final String id;
  final String bloodType;
  final int unitsNeeded;
  final String urgency;
  final String hospitalName;
  final String timeRemaining;

  BloodRequestData({
    required this.id,
    required this.bloodType,
    required this.unitsNeeded,
    required this.urgency,
    required this.hospitalName,
    required this.timeRemaining,
  });
}
