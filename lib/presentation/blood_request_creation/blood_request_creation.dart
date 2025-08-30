import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/additional_details_section.dart';
import './widgets/date_needed_section.dart';
import './widgets/hospital_information_section.dart';
import './widgets/patient_details_section.dart';
import './widgets/terms_and_submit_section.dart';
import './widgets/urgency_section.dart';

class BloodRequestCreation extends StatefulWidget {
  const BloodRequestCreation({super.key});

  @override
  State<BloodRequestCreation> createState() => _BloodRequestCreationState();
}

class _BloodRequestCreationState extends State<BloodRequestCreation> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Form Controllers
  final _patientNameController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _hospitalAddressController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _contactInfoController = TextEditingController();

  // Form State
  String? _selectedBloodType;
  int _unitsNeeded = 1;
  UrgencyLevel? _selectedUrgency;
  DateTime? _selectedDate;
  bool _termsAccepted = false;
  bool _isSubmitting = false;
  bool _hasAttachment = false;
  String? _attachmentName;

  // Error States
  String? _patientNameError;
  String? _bloodTypeError;
  String? _hospitalNameError;
  String? _hospitalAddressError;
  String? _contactPersonError;
  String? _contactPhoneError;
  String? _dateError;

  // Current step for progress indicator
  int _currentStep = 0;
  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _notesController.dispose();
    _contactInfoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Mock user data - in real app, load from user profile
    _contactPersonController.text = 'Dr. Sarah Johnson';
    _contactPhoneController.text = '+1 (555) 123-4567';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Create Blood Request',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showHelpDialog,
            tooltip: 'Help',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                // Progress Indicator
                Row(
                  children: List.generate(_totalSteps, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;

                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getStepTitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Column(
                  children: [
                    // Patient Details Section
                    PatientDetailsSection(
                      patientNameController: _patientNameController,
                      selectedBloodType: _selectedBloodType,
                      unitsNeeded: _unitsNeeded,
                      onBloodTypeChanged: (bloodType) {
                        setState(() {
                          _selectedBloodType = bloodType;
                          _bloodTypeError = null;
                          _updateCurrentStep();
                        });
                      },
                      onUnitsChanged: (units) {
                        setState(() {
                          _unitsNeeded = units;
                        });
                      },
                      patientNameError: _patientNameError,
                      bloodTypeError: _bloodTypeError,
                    ),

                    // Hospital Information Section
                    HospitalInformationSection(
                      hospitalNameController: _hospitalNameController,
                      hospitalAddressController: _hospitalAddressController,
                      contactPersonController: _contactPersonController,
                      contactPhoneController: _contactPhoneController,
                      hospitalNameError: _hospitalNameError,
                      hospitalAddressError: _hospitalAddressError,
                      contactPersonError: _contactPersonError,
                      contactPhoneError: _contactPhoneError,
                    ),

                    // Urgency Section
                    UrgencySection(
                      selectedUrgency: _selectedUrgency,
                      onUrgencyChanged: (urgency) {
                        setState(() {
                          _selectedUrgency = urgency;
                          _updateCurrentStep();
                        });
                      },
                    ),

                    // Date Needed Section
                    DateNeededSection(
                      selectedDate: _selectedDate,
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                          _dateError = null;
                          _updateCurrentStep();
                        });
                      },
                      dateError: _dateError,
                    ),

                    // Additional Details Section
                    AdditionalDetailsSection(
                      notesController: _notesController,
                      contactInfoController: _contactInfoController,
                      hasAttachment: _hasAttachment,
                      attachmentName: _attachmentName,
                      onAttachmentTap: _handleAttachment,
                      onRemoveAttachment: () {
                        setState(() {
                          _hasAttachment = false;
                          _attachmentName = null;
                        });
                      },
                    ),

                    SizedBox(height: 10.h), // Space for bottom section
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TermsAndSubmitSection(
        termsAccepted: _termsAccepted,
        isSubmitting: _isSubmitting,
        onTermsChanged: (value) {
          setState(() {
            _termsAccepted = value ?? false;
          });
        },
        onSubmit: _submitRequest,
        isFormValid: _isFormValid(),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Patient Details';
      case 1:
        return 'Hospital Info';
      case 2:
        return 'Urgency Level';
      case 3:
        return 'Complete';
      default:
        return 'Patient Details';
    }
  }

  void _updateCurrentStep() {
    int newStep = 0;

    // Step 1: Patient details
    if (_patientNameController.text.isNotEmpty && _selectedBloodType != null) {
      newStep = 1;
    }

    // Step 2: Hospital information
    if (newStep >= 1 &&
        _hospitalNameController.text.isNotEmpty &&
        _hospitalAddressController.text.isNotEmpty &&
        _contactPersonController.text.isNotEmpty &&
        _contactPhoneController.text.isNotEmpty) {
      newStep = 2;
    }

    // Step 3: Urgency and date
    if (newStep >= 2 && _selectedUrgency != null && _selectedDate != null) {
      newStep = 3;
    }

    if (newStep != _currentStep) {
      setState(() {
        _currentStep = newStep;
      });
    }
  }

  bool _isFormValid() {
    return _patientNameController.text.trim().isNotEmpty &&
        _selectedBloodType != null &&
        _hospitalNameController.text.trim().isNotEmpty &&
        _hospitalAddressController.text.trim().isNotEmpty &&
        _contactPersonController.text.trim().isNotEmpty &&
        _contactPhoneController.text.trim().isNotEmpty &&
        _selectedUrgency != null &&
        _selectedDate != null;
  }

  void _handleAttachment() {
    // Mock attachment functionality
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Add Medical Document',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Take Photo'),
                subtitle: const Text('Capture document with camera'),
                onTap: () {
                  Navigator.pop(context);
                  _mockAttachDocument('Camera_Document.jpg');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  color: colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select from photo gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _mockAttachDocument('Medical_Report.jpg');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'description',
                  color: colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Choose File'),
                subtitle: const Text('Select PDF or document file'),
                onTap: () {
                  Navigator.pop(context);
                  _mockAttachDocument('Prescription.pdf');
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _mockAttachDocument(String fileName) {
    setState(() {
      _hasAttachment = true;
      _attachmentName = fileName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Document "$fileName" attached successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _submitRequest() async {
    // Clear previous errors
    setState(() {
      _patientNameError = null;
      _bloodTypeError = null;
      _hospitalNameError = null;
      _hospitalAddressError = null;
      _contactPersonError = null;
      _contactPhoneError = null;
      _dateError = null;
    });

    // Validate form
    bool hasErrors = false;

    if (_patientNameController.text.trim().isEmpty) {
      setState(() => _patientNameError = 'Patient name is required');
      hasErrors = true;
    }

    if (_selectedBloodType == null) {
      setState(() => _bloodTypeError = 'Blood type is required');
      hasErrors = true;
    }

    if (_hospitalNameController.text.trim().isEmpty) {
      setState(() => _hospitalNameError = 'Hospital name is required');
      hasErrors = true;
    }

    if (_hospitalAddressController.text.trim().isEmpty) {
      setState(() => _hospitalAddressError = 'Hospital address is required');
      hasErrors = true;
    }

    if (_contactPersonController.text.trim().isEmpty) {
      setState(() => _contactPersonError = 'Contact person is required');
      hasErrors = true;
    }

    if (_contactPhoneController.text.trim().isEmpty) {
      setState(() => _contactPhoneError = 'Contact phone is required');
      hasErrors = true;
    }

    if (_selectedDate == null) {
      setState(() => _dateError = 'Date needed is required');
      hasErrors = true;
    }

    if (hasErrors) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 2));

      // Generate mock request ID
      final requestId =
          'BR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      if (mounted) {
        _showSuccessDialog(requestId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to submit request. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(String requestId) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.primary,
                  size: 48,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Request Posted Successfully!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your blood request has been posted with ID: $requestId',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Verified donors in your area will be notified within the next 15 minutes.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: const Text('Back to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Blood Request Help'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tips for creating an effective blood request:'),
            SizedBox(height: 2.h),
            _buildHelpItem('• Provide accurate patient information'),
            _buildHelpItem('• Select the correct blood type'),
            _buildHelpItem('• Choose appropriate urgency level'),
            _buildHelpItem('• Include hospital contact details'),
            _buildHelpItem('• Attach medical documents if available'),
            SizedBox(height: 2.h),
            Text(
              'Your request will be shared with verified donors in your area.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
