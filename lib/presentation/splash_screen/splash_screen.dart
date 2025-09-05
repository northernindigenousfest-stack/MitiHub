import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitialized = false;
  String _loadingText = 'Initializing MitiHub...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation with growth effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Start progress animation
      _progressAnimationController.forward();

      // Simulate initialization steps with realistic delays
      await _performInitializationSteps();

      // Navigate based on app state
      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _showRetryOption();
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      {'text': 'Checking authentication...', 'duration': 600},
      {'text': 'Loading tree database...', 'duration': 800},
      {'text': 'Syncing offline data...', 'duration': 700},
      {'text': 'Preparing GPS services...', 'duration': 500},
      {'text': 'Finalizing setup...', 'duration': 400},
    ];

    for (int i = 0; i < steps.length; i++) {
      if (mounted) {
        setState(() {
          _loadingText = steps[i]['text'] as String;
          _progress = (i + 1) / steps.length;
        });
        await Future.delayed(
            Duration(milliseconds: steps[i]['duration'] as int));
      }
    }

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate checking authentication status
    await Future.delayed(const Duration(milliseconds: 300));

    // For demo purposes, navigate to onboarding
    // In real app, this would check actual auth state
    Navigator.pushReplacementNamed(context, '/onboarding-flow');
  }

  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Connection Issue',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Unable to initialize MitiHub. Please check your connection and try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryInitialization();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitialized = false;
      _progress = 0.0;
      _loadingText = 'Initializing MitiHub...';
    });

    _logoAnimationController.reset();
    _progressAnimationController.reset();

    _logoAnimationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.primaryColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.colorScheme.primaryContainer,
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo section
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // MitiBot logo with tree iconography
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'eco',
                                      color: Colors.white,
                                      size: 12.w,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                // App name
                                Text(
                                  'MitiHub',
                                  style: AppTheme
                                      .lightTheme.textTheme.displaySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                // Tagline
                                Text(
                                  'Growing Kenya\'s Future',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Loading section
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Loading text
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _loadingText,
                            key: ValueKey(_loadingText),
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Progress indicator
                        Container(
                          width: 60.w,
                          height: 0.8.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Progress percentage
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom section with version info
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Column(
                    children: [
                      Text(
                        'Powered by Conservation Technology',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Version 1.0.0',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
