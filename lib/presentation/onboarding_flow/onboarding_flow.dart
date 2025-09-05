import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/tree_growth_animation_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'EN';

  // Permission states
  bool _cameraPermissionGranted = false;
  bool _locationPermissionGranted = false;
  bool _notificationPermissionGranted = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Plant Trees, Save Our Future",
      "titleSw": "Panda Miti, Okoa Mustakabali Wetu",
      "description":
          "Join thousands of environmental guardians in Northern Kenya. Adopt trees, monitor their growth, and make a real impact on climate change.",
      "descriptionSw":
          "Jiunge na maelfu ya walinzi wa mazingira kaskazini mwa Kenya. Panda miti, fuatilia ukuaji wake, na fanya athari halisi kwenye mabadiliko ya tabianchi.",
      "image":
          "https://images.pexels.com/photos/1072824/pexels-photo-1072824.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hasAnimation": true,
    },
    {
      "title": "Monitor & Track Growth",
      "titleSw": "Fuatilia na Rekodi Ukuaji",
      "description":
          "Use your camera and GPS to document tree progress. Capture photos, record locations, and track growth milestones even offline.",
      "descriptionSw":
          "Tumia kamera na GPS yako kurekodi maendeleo ya mti. Piga picha, rekodi maeneo, na fuatilia hatua za ukuaji hata bila mtandao.",
      "image":
          "https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hasAnimation": false,
    },
    {
      "title": "Connect & Compete",
      "titleSw": "Unganisha na Shindana",
      "description":
          "Join your community in conservation efforts. Compete with schools and counties, earn badges, and climb the leaderboards.",
      "descriptionSw":
          "Jiunge na jamii yako katika juhudi za uhifadhi. Shindana na shule na kaunti, pata vibeti, na panda kwenye jedwali la ushindi.",
      "image":
          "https://images.pexels.com/photos/1595385/pexels-photo-1595385.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hasAnimation": false,
    },
    {
      "title": "Grant Permissions",
      "titleSw": "Ongeza Ruhusa",
      "description":
          "Enable essential features for the best conservation experience. All permissions help us serve you better.",
      "descriptionSw":
          "Wezesha vipengele muhimu kwa uzoefu bora wa uhifadhi. Ruhusa zote zinasaidia kutumikia vizuri zaidi.",
      "image":
          "https://images.pexels.com/photos/1108101/pexels-photo-1108101.jpeg?auto=compress&cs=tinysrgb&w=800",
      "hasAnimation": false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/authentication-screen');
  }

  void _requestCameraPermission() {
    setState(() {
      _cameraPermissionGranted = !_cameraPermissionGranted;
    });
    HapticFeedback.selectionClick();
  }

  void _requestLocationPermission() {
    setState(() {
      _locationPermissionGranted = !_locationPermissionGranted;
    });
    HapticFeedback.selectionClick();
  }

  void _requestNotificationPermission() {
    setState(() {
      _notificationPermissionGranted = !_notificationPermissionGranted;
    });
    HapticFeedback.selectionClick();
  }

  String _getLocalizedText(String key, String keySw) {
    return _selectedLanguage == 'SW' ? keySw : key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              HapticFeedback.selectionClick();
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final data = _onboardingData[index];

              if (index == _onboardingData.length - 1) {
                return _buildPermissionPage();
              }

              return OnboardingPageWidget(
                title: _getLocalizedText(data["title"], data["titleSw"]),
                description: _getLocalizedText(
                    data["description"], data["descriptionSw"]),
                imageUrl: data["image"],
                animationWidget: data["hasAnimation"]
                    ? const TreeGrowthAnimationWidget()
                    : null,
              );
            },
          ),

          // Language toggle (only on first page)
          if (_currentPage == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 2.h,
              left: 6.w,
              child: LanguageToggleWidget(
                selectedLanguage: _selectedLanguage,
                onLanguageChanged: (language) {
                  setState(() {
                    _selectedLanguage = language;
                  });
                },
              ),
            ),

          // Skip button (not on last page)
          if (_currentPage < _onboardingData.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 2.h,
              right: 6.w,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  _selectedLanguage == 'SW' ? 'Ruka' : 'Skip',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Bottom navigation
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 4.h,
            left: 6.w,
            right: 6.w,
            child: Column(
              children: [
                PageIndicatorWidget(
                  currentPage: _currentPage,
                  totalPages: _onboardingData.length,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _selectedLanguage == 'SW' ? 'Nyuma' : 'Back',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    if (_currentPage > 0) SizedBox(width: 4.w),
                    Expanded(
                      flex: _currentPage == 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == _onboardingData.length - 1
                              ? (_selectedLanguage == 'SW'
                                  ? 'Anza'
                                  : 'Get Started')
                              : (_selectedLanguage == 'SW'
                                  ? 'Ifuatayo'
                                  : 'Next'),
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionPage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            children: [
              // Header
              Text(
                _getLocalizedText("Grant Permissions", "Ongeza Ruhusa"),
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                _getLocalizedText(
                    "Enable essential features for the best conservation experience. All permissions help us serve you better.",
                    "Wezesha vipengele muhimu kwa uzoefu bora wa uhifadhi. Ruhusa zote zinasaidia kutumikia vizuri zaidi."),
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),

              // Permission cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PermissionCardWidget(
                        iconName: 'camera_alt',
                        title: _getLocalizedText(
                            'Camera Access', 'Ufikiaji wa Kamera'),
                        description: _getLocalizedText(
                            'Take photos of your adopted trees to track their growth progress',
                            'Piga picha za miti yako uliyopanda ili kufuatilia maendeleo ya ukuaji'),
                        benefit: _getLocalizedText(
                            'Essential for tree monitoring',
                            'Muhimu kwa ufuatiliaji wa miti'),
                        isGranted: _cameraPermissionGranted,
                        onTap: _requestCameraPermission,
                      ),
                      PermissionCardWidget(
                        iconName: 'location_on',
                        title: _getLocalizedText(
                            'Location Services', 'Huduma za Mahali'),
                        description: _getLocalizedText(
                            'Record GPS coordinates and get location-based tree recommendations',
                            'Rekodi kuratibu za GPS na pata mapendekezo ya miti kulingana na mahali'),
                        benefit: _getLocalizedText(
                            'Accurate tree mapping', 'Ramani sahihi za miti'),
                        isGranted: _locationPermissionGranted,
                        onTap: _requestLocationPermission,
                      ),
                      PermissionCardWidget(
                        iconName: 'notifications',
                        title: _getLocalizedText('Notifications', 'Arifa'),
                        description: _getLocalizedText(
                            'Receive updates about your trees, community news, and conservation tips',
                            'Pokea masasisho kuhusu miti yako, habari za jamii, na vidokezo vya uhifadhi'),
                        benefit: _getLocalizedText(
                            'Stay connected with community',
                            'Baki umeunganishwa na jamii'),
                        isGranted: _notificationPermissionGranted,
                        onTap: _requestNotificationPermission,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Continue without permissions option
              TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  _getLocalizedText(
                      'Continue without permissions', 'Endelea bila ruhusa'),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
