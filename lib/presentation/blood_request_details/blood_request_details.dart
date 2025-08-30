import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/blood_type_display_widget.dart';
import './widgets/comments_section_widget.dart';
import './widgets/donor_response_widget.dart';
import './widgets/hospital_info_widget.dart';
import './widgets/request_timeline_widget.dart';
import './widgets/urgency_badge_widget.dart';

/// Blood Request Details screen providing comprehensive request information
/// with donor response capabilities and contact facilitation
class BloodRequestDetails extends StatefulWidget {
  const BloodRequestDetails({super.key});

  @override
  State<BloodRequestDetails> createState() => _BloodRequestDetailsState();
}

class _BloodRequestDetailsState extends State<BloodRequestDetails> {
  bool _isLoading = false;
  bool _isCommenting = false;
  bool _hasResponded = false;

  // Mock data for blood request details
  final Map<String, dynamic> _requestData = {
    "id": "BR001",
    "urgencyLevel": "Critical",
    "bloodType": "O-",
    "unitsNeeded": 3,
    "patientName": "Sarah Johnson",
    "medicalNotes":
        "Patient requires immediate blood transfusion due to severe anemia. Compatible blood type O- needed urgently.",
    "hospitalName": "City General Hospital",
    "hospitalAddress": "123 Medical Center Drive, Downtown, NY 10001",
    "contactPerson": "Dr. Michael Chen",
    "phoneNumber": "+1 (555) 123-4567",
    "mapUrl": "https://maps.google.com/?q=City+General+Hospital+NY",
    "postedDate": "2025-08-29T10:30:00Z",
    "neededDate": "2025-08-30T18:00:00Z",
    "status": "Active",
    "requesterId": "user123",
    "requesterName": "Emily Johnson",
    "requesterPhone": "+1 (555) 987-6543",
    "interestedDonorCount": 12,
  };

  final List<Map<String, dynamic>> _donorResponses = [
    {
      "id": "donor1",
      "name": "Alex Rodriguez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "city": "New York, NY",
      "bloodType": "O-",
      "lastDonation": "3 months ago",
      "responseTime": "2025-08-29T11:15:00Z",
      "isAvailable": true,
    },
    {
      "id": "donor2",
      "name": "Maria Garcia",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "city": "Brooklyn, NY",
      "bloodType": "O-",
      "lastDonation": "2 months ago",
      "responseTime": "2025-08-29T12:30:00Z",
      "isAvailable": true,
    },
    {
      "id": "donor3",
      "name": "James Wilson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "city": "Manhattan, NY",
      "bloodType": "O-",
      "lastDonation": "4 months ago",
      "responseTime": "2025-08-29T13:45:00Z",
      "isAvailable": true,
    },
    {
      "id": "donor4",
      "name": "Lisa Thompson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "city": "Queens, NY",
      "bloodType": "O-",
      "lastDonation": "1 month ago",
      "responseTime": "2025-08-29T14:20:00Z",
      "isAvailable": true,
    },
  ];

  final List<Map<String, dynamic>> _comments = [
    {
      "id": "comment1",
      "name": "Dr. Sarah Mitchell",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "I'm a medical professional and can confirm this is a legitimate urgent request. Please help if you can donate O- blood.",
      "timestamp": "2025-08-29T11:45:00Z",
      "likes": 8,
    },
    {
      "id": "comment2",
      "name": "Mike Johnson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "I donated last month but I'm sharing this with my network. Hope you find donors soon!",
      "timestamp": "2025-08-29T12:20:00Z",
      "likes": 5,
    },
    {
      "id": "comment3",
      "name": "Jennifer Lee",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content":
          "What are the visiting hours at City General Hospital? I'd like to donate directly.",
      "timestamp": "2025-08-29T13:10:00Z",
      "likes": 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar.requestDetails(),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 25.h), // Space for action buttons
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Request header with urgency badge
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UrgencyBadgeWidget(
                        urgencyLevel: _requestData['urgencyLevel'] as String,
                        neededDate: DateTime.parse(
                            _requestData['neededDate'] as String),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Blood Request #${_requestData['id']}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Patient: ${_requestData['patientName']}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Blood type display
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: BloodTypeDisplayWidget(
                    bloodType: _requestData['bloodType'] as String,
                    unitsNeeded: _requestData['unitsNeeded'] as int,
                  ),
                ),

                SizedBox(height: 2.h),

                // Medical notes if provided
                if (_requestData['medicalNotes'] != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'medical_information',
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Medical Notes',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _requestData['medicalNotes'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],

                // Hospital information
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: HospitalInfoWidget(
                    hospitalName: _requestData['hospitalName'] as String,
                    address: _requestData['hospitalAddress'] as String,
                    contactPerson: _requestData['contactPerson'] as String,
                    phoneNumber: _requestData['phoneNumber'] as String,
                    mapUrl: _requestData['mapUrl'] as String?,
                  ),
                ),

                SizedBox(height: 2.h),

                // Request timeline
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: RequestTimelineWidget(
                    postedDate:
                        DateTime.parse(_requestData['postedDate'] as String),
                    neededDate:
                        DateTime.parse(_requestData['neededDate'] as String),
                    status: _requestData['status'] as String,
                  ),
                ),

                SizedBox(height: 2.h),

                // Donor responses
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: DonorResponseWidget(
                    interestedDonorCount:
                        _requestData['interestedDonorCount'] as int,
                    donorResponses: _donorResponses,
                    onViewAllDonors: _handleViewAllDonors,
                  ),
                ),

                SizedBox(height: 2.h),

                // Comments section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CommentsSectionWidget(
                    comments: _comments,
                    onAddComment: _handleAddComment,
                    isLoading: _isCommenting,
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),

          // Action buttons in thumb-reach zone
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ActionButtonsWidget(
              canHelp: !_hasResponded,
              onICanHelp: _handleICanHelp,
              onShareRequest: _handleShareRequest,
              onSaveForLater: _handleSaveForLater,
              onReportRequest: _handleReportRequest,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  void _handleICanHelp() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _hasResponded = true;
    });

    // Show success dialog
    _showSuccessDialog();
  }

  void _handleShareRequest() {
    final requestText = '''
🩸 URGENT BLOOD REQUEST 🩸

Blood Type Needed: ${_requestData['bloodType']}
Units Required: ${_requestData['unitsNeeded']}
Hospital: ${_requestData['hospitalName']}
Contact: ${_requestData['phoneNumber']}

Patient ${_requestData['patientName']} needs your help! 
Please share if you can't donate.

#BloodDonation #SaveLives #${_requestData['bloodType']}
    ''';

    Clipboard.setData(ClipboardData(text: requestText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Request details copied to clipboard. Share to help save a life!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _handleSaveForLater() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request saved for later'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleReportRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Request'),
        content: const Text(
            'Are you sure you want to report this blood request? This action will be reviewed by our team.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Request reported. Thank you for helping keep our community safe.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _handleViewAllDonors() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDonorListModal(),
    );
  }

  void _handleAddComment(String comment) async {
    setState(() {
      _isCommenting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Add comment to list
    final newComment = {
      "id": "comment${_comments.length + 1}",
      "name": "Current User",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "content": comment,
      "timestamp": DateTime.now().toIso8601String(),
      "likes": 0,
    };

    setState(() {
      _comments.insert(0, newComment);
      _isCommenting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment posted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildDonorListModal() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Modal header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Interested Donors',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Donor list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: _donorResponses.length,
              itemBuilder: (context, index) {
                final donor = _donorResponses[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.1),
                        child: CustomImageWidget(
                          imageUrl: donor['avatar'] as String,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donor['name'] as String,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              donor['city'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              'Last donation: ${donor['lastDonation']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactDialog(donor);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                        ),
                        child: const Text('Contact'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Thank You!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your response has been sent to the requester. They will contact you with next steps.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.8),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(Map<String, dynamic> donor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${donor['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Phone: +1 (555) 123-${1000 + (_donorResponses.indexOf(donor))}'),
            SizedBox(height: 1.h),
            Text(
                'Email: ${(donor['name'] as String).toLowerCase().replaceAll(' ', '.')}@email.com'),
            SizedBox(height: 2.h),
            Text(
              'Contact information is shared with mutual consent for blood donation purposes only.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact information copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Copy Info'),
          ),
        ],
      ),
    );
  }
}
