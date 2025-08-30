import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileAvatarWidget extends StatefulWidget {
  final String? currentImageUrl;
  final Function(String?) onImageChanged;

  const ProfileAvatarWidget({
    super.key,
    this.currentImageUrl,
    required this.onImageChanged,
  });

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Profile image container
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildProfileImage(),
            ),
          ),
          // Camera overlay button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImagePickerOptions,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImagePath != null) {
      if (kIsWeb) {
        return CustomImageWidget(
          imageUrl: _selectedImagePath!,
          width: 30.w,
          height: 30.w,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(_selectedImagePath!),
          width: 30.w,
          height: 30.w,
          fit: BoxFit.cover,
        );
      }
    } else if (widget.currentImageUrl != null &&
        widget.currentImageUrl!.isNotEmpty) {
      return CustomImageWidget(
        imageUrl: widget.currentImageUrl!,
        width: 30.w,
        height: 30.w,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: 30.w,
        height: 30.w,
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        child: CustomIconWidget(
          iconName: 'person',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 12.w,
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Update Profile Photo',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 3.h),
                _buildOptionTile(
                  icon: 'camera_alt',
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildOptionTile(
                  icon: 'photo_library',
                  title: 'Choose from Library',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (widget.currentImageUrl != null ||
                    _selectedImagePath != null)
                  _buildOptionTile(
                    icon: 'delete_outline',
                    title: 'Remove Photo',
                    onTap: () {
                      Navigator.pop(context);
                      _removePhoto();
                    },
                    isDestructive: true,
                  ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.errorContainer
              : AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Request permission for camera if needed
      if (source == ImageSource.camera && !kIsWeb) {
        final permission = await Permission.camera.request();
        if (!permission.isGranted) {
          _showPermissionDeniedMessage();
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
        widget.onImageChanged(_selectedImagePath);
      }
    } catch (e) {
      _showErrorMessage('Failed to pick image. Please try again.');
    }
  }

  void _removePhoto() {
    setState(() {
      _selectedImagePath = null;
    });
    widget.onImageChanged(null);
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Camera permission is required to take photos'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }
}
