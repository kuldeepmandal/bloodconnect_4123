import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/account_actions_widget.dart';
import './widgets/donation_history_widget.dart';
import './widgets/emergency_contact_widget.dart';
import './widgets/location_section_widget.dart';
import './widgets/medical_info_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/profile_avatar_widget.dart';

class ProfileManagement extends StatefulWidget {
  const ProfileManagement({super.key});

  @override
  State<ProfileManagement> createState() => _ProfileManagementState();
}

class _ProfileManagementState extends State<ProfileManagement> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();

  // Form validation errors
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _ageError;
  String? _cityError;
  String? _addressError;
  String? _emergencyContactError;

  // Profile data
  String? _profileImageUrl;
  String _selectedBloodType = 'A+';
  DateTime? _lastDonationDate;
  bool _profileVisibility = true;
  bool _notificationPreferences = true;
  bool _hasUnsavedChanges = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Kuldeep Mandal",
    "email": "kuldeepmandal609@email.com",
    "phone": "9840990664",
    "age": 20,
    "bloodType": "B+",
    "city": "Biratnagar",
    "address": "Hatkhola",
    "profileImage":
        "https://images.pexels.com/photos/31985997/pexels-photo-31985997.jpeg?_gl=1*5jz174*_ga*MTkwMjk5Nzg0Ny4xNzU2NTI1MDE1*_ga_8JE65Q40S6*czE3NTY1MjUwMTUkbzEkZzEkdDE3NTY1MjUwNjIkajEzJGwwJGgw",
    "lastDonationDate": DateTime.now().subtract(const Duration(days: 45)),
    "emergencyContact": "9840990664",
    "profileVisibility": true,
    "notificationPreferences": true,
  };

  // Mock donation history
  final List<Map<String, dynamic>> _donationHistory = [
    {
      "id": 1,
      "date": DateTime.now().subtract(const Duration(days: 45)),
      "hospital": "City General Hospital",
      "units": 1,
      "status": "Completed",
    },
    {
      "id": 2,
      "date": DateTime.now().subtract(const Duration(days: 120)),
      "hospital": "St. Mary's Medical Center",
      "units": 1,
      "status": "Completed",
    },
    {
      "id": 3,
      "date": DateTime.now().subtract(const Duration(days: 200)),
      "hospital": "Metropolitan Hospital",
      "units": 2,
      "status": "Completed",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    _nameController.text = _userData['name'] ?? '';
    _emailController.text = _userData['email'] ?? '';
    _phoneController.text = _userData['phone'] ?? '';
    _ageController.text = _userData['age']?.toString() ?? '';
    _cityController.text = _userData['city'] ?? '';
    _addressController.text = _userData['address'] ?? '';
    _emergencyContactController.text = _userData['emergencyContact'] ?? '';
    _profileImageUrl = _userData['profileImage'];
    _selectedBloodType = _userData['bloodType'] ?? 'A+';
    _lastDonationDate = _userData['lastDonationDate'];
    _profileVisibility = _userData['profileVisibility'] ?? true;
    _notificationPreferences = _userData['notificationPreferences'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: CustomAppBar.profile(
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _saveProfile,
                child: Text(
                  'Save',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                // Profile Avatar Section
                ProfileAvatarWidget(
                  currentImageUrl: _profileImageUrl,
                  onImageChanged: _onImageChanged,
                ),
                SizedBox(height: 2.h),

                // Personal Information Section
                PersonalInfoSectionWidget(
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  ageController: _ageController,
                  nameError: _nameError,
                  emailError: _emailError,
                  phoneError: _phoneError,
                  ageError: _ageError,
                ),

                // Medical Information Section
                MedicalInfoSectionWidget(
                  selectedBloodType: _selectedBloodType,
                  lastDonationDate: _lastDonationDate,
                  onDateTap: _selectLastDonationDate,
                ),

                // Location Section
                LocationSectionWidget(
                  cityController: _cityController,
                  addressController: _addressController,
                  onUpdateLocation: _updateLocation,
                  cityError: _cityError,
                  addressError: _addressError,
                ),

                // Privacy Settings
                PrivacySettingsWidget(
                  profileVisibility: _profileVisibility,
                  notificationPreferences: _notificationPreferences,
                  onProfileVisibilityChanged: _onProfileVisibilityChanged,
                  onNotificationPreferencesChanged:
                      _onNotificationPreferencesChanged,
                ),

                // Donation History
                DonationHistoryWidget(
                  donationHistory: _donationHistory,
                ),

                // Emergency Contact
                EmergencyContactWidget(
                  emergencyContactController: _emergencyContactController,
                  emergencyContactError: _emergencyContactError,
                ),

                // Account Actions
                AccountActionsWidget(
                  onChangePassword: _changePassword,
                  onDeleteAccount: _deleteAccount,
                ),

                SizedBox(height: 10.h), // Bottom padding for navigation
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomBar.main(
          currentIndex:
              CustomBottomBar.getIndexFromRoute('/profile-management'),
        ),
        floatingActionButton: _hasUnsavedChanges
            ? FloatingActionButton.extended(
                onPressed: _saveProfile,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                icon: CustomIconWidget(
                  iconName: 'save',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(
                  'Save Changes',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      return await _showUnsavedChangesDialog() ?? false;
    }
    return true;
  }

  Future<bool?> _showUnsavedChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Unsaved Changes',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You have unsaved changes. Do you want to save them before leaving?',
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Discard',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _saveProfile();
              },
              child: Text(
                'Save',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onImageChanged(String? imagePath) {
    setState(() {
      _profileImageUrl = imagePath;
      _hasUnsavedChanges = true;
    });
  }

  void _onProfileVisibilityChanged(bool value) {
    setState(() {
      _profileVisibility = value;
      _hasUnsavedChanges = true;
    });
  }

  void _onNotificationPreferencesChanged(bool value) {
    setState(() {
      _notificationPreferences = value;
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _selectLastDonationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastDonationDate ??
          DateTime.now().subtract(const Duration(days: 56)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _lastDonationDate) {
      setState(() {
        _lastDonationDate = picked;
        _hasUnsavedChanges = true;
      });
    }
  }

  void _updateLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Location update feature coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _changePassword() {
    _showChangePasswordDialog();
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Change Password',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    hintText: 'Enter current password',
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm new password',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processPasswordChange();
              },
              child: Text(
                'Change Password',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processPasswordChange() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password changed successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Account deletion feature coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _ageError = null;
      _cityError = null;
      _addressError = null;
      _emergencyContactError = null;
    });

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Name is required');
      isValid = false;
    } else if (_nameController.text.trim().length < 2) {
      setState(() => _nameError = 'Name must be at least 2 characters');
      isValid = false;
    }

    // Validate email
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Email is required');
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text.trim())) {
      setState(() => _emailError = 'Please enter a valid email');
      isValid = false;
    }

    // Validate phone
    if (_phoneController.text.trim().isEmpty) {
      setState(() => _phoneError = 'Phone number is required');
      isValid = false;
    } else if (_phoneController.text.trim().length != 10) {
      setState(() => _phoneError = 'Phone number must be 10 digits');
      isValid = false;
    }

    // Validate age
    if (_ageController.text.trim().isEmpty) {
      setState(() => _ageError = 'Age is required');
      isValid = false;
    } else {
      final age = int.tryParse(_ageController.text.trim());
      if (age == null || age < 18 || age > 65) {
        setState(() => _ageError = 'Age must be between 18 and 65');
        isValid = false;
      }
    }

    // Validate city
    if (_cityController.text.trim().isEmpty) {
      setState(() => _cityError = 'City is required');
      isValid = false;
    }

    // Validate address
    if (_addressController.text.trim().isEmpty) {
      setState(() => _addressError = 'Address is required');
      isValid = false;
    }

    // Validate emergency contact
    if (_emergencyContactController.text.trim().isNotEmpty &&
        _emergencyContactController.text.trim().length != 10) {
      setState(
          () => _emergencyContactError = 'Emergency contact must be 10 digits');
      isValid = false;
    }

    return isValid;
  }

  void _saveProfile() {
    if (_validateForm()) {
      setState(() {
        _hasUnsavedChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              const Text('Profile updated successfully'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
