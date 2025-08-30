import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Splash screen for BloodConnect application
/// Provides branded app launch experience while initializing blood donation services
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoPulseAnimation;
  late Animation<double> _textFadeAnimation;

  bool _isInitialized = false;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup all animations for the splash screen
  void _setupAnimations() {
    // Logo scale animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text fade animation controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo pulse animation
    _logoPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Text fade animation
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _logoAnimationController.forward();

    // Start text animation after logo animation begins
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textAnimationController.forward();
      }
    });

    // Setup pulse animation loop
    _logoAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startPulseAnimation();
      }
    });
  }

  /// Start the pulse animation loop
  void _startPulseAnimation() {
    _logoAnimationController.repeat(
        reverse: true, period: const Duration(milliseconds: 2000));
  }

  /// Initialize app services and check authentication status
  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // Simulate initialization tasks
      await _performInitializationTasks();

      // Mark as initialized
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _loadingText = 'Ready to save lives!';
        });
      }

      // Navigate after splash duration
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization error
      if (mounted) {
        setState(() {
          _loadingText = 'Preparing BloodConnect...';
        });

        // Retry after delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _navigateToNextScreen();
        }
      }
    }
  }

  /// Perform critical background initialization tasks
  Future<void> _performInitializationTasks() async {
    // Update loading text with different stages
    final List<String> loadingStages = [
      'Checking authentication...',
      'Loading donor data...',
      'Fetching blood requests...',
      'Preparing location services...',
      'Almost ready...',
    ];

    for (int i = 0; i < loadingStages.length; i++) {
      if (mounted) {
        setState(() {
          _loadingText = loadingStages[i];
        });
      }

      // Simulate task processing time
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  /// Navigate to the appropriate next screen based on authentication status
  void _navigateToNextScreen() {
    // For now, navigate to dashboard as the main entry point
    // In a real app, this would check authentication status and navigate accordingly
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.surface,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Logo section with animations
              _buildAnimatedLogo(),

              SizedBox(height: 6.h),

              // Mission statement with fade animation
              _buildMissionStatement(),

              const Spacer(flex: 2),

              // Loading indicator and text
              _buildLoadingSection(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the animated logo with blood drop and cross symbol
  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value * _logoPulseAnimation.value,
          child: Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Blood drop shape
                  CustomIconWidget(
                    iconName: 'water_drop',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 12.w,
                  ),

                  // Medical cross overlay
                  CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.surface,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the mission statement with fade animation
  Widget _buildMissionStatement() {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                // App name
                Text(
                  'BloodConnect',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Mission statement
                Text(
                  'Connecting Lives Through Blood Donation',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build the loading section with indicator and text
  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading indicator
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.surface,
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Loading text with animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _loadingText,
            key: ValueKey<String>(_loadingText),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Status indicator
        if (_isInitialized) ...[
          SizedBox(height: 1.h),
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.colorScheme.surface,
            size: 5.w,
          ),
        ],
      ],
    );
  }
}
