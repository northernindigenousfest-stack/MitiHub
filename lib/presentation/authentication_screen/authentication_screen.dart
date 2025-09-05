import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/auth_tab_bar.dart';
import './widgets/forgot_password_sheet.dart';
import './widgets/language_toggle.dart';
import './widgets/login_form.dart';
import './widgets/mitihub_logo.dart';
import './widgets/register_form.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoginLoading = false;
  bool _isRegisterLoading = false;
  String _currentLanguage = 'English';

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockCredentials = {
    'guardian@mitihub.com': {'password': 'guardian123', 'role': 'Guardian'},
    'school@mitihub.com': {'password': 'school123', 'role': 'School'},
    'admin@mitihub.com': {'password': 'admin123', 'role': 'Admin'},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoginLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email.toLowerCase()) &&
          _mockCredentials[email.toLowerCase()]!['password'] == password) {
        final userRole = _mockCredentials[email.toLowerCase()]!['role']!;

        // Haptic feedback for success
        HapticFeedback.lightImpact();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back! Logging in as $userRole'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to dashboard after a short delay
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        // Show error for invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Invalid email or password. Please check your credentials.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Network error. Please check your connection and try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  void _handleRegister(String email, String password, String confirmPassword,
      String role) async {
    setState(() {
      _isRegisterLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      // Check if email already exists
      if (_mockCredentials.containsKey(email.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Account with this email already exists. Please login instead.'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
        return;
      }

      // Haptic feedback for success
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully! Welcome to MitiHub'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to dashboard after a short delay
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRegisterLoading = false;
        });
      }
    }
  }

  void _handleForgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ForgotPasswordSheet(
        onResetPassword: (email) {
          // Handle password reset logic here
          print('Password reset requested for: $email');
        },
      ),
    );
  }

  void _handleLanguageChange(String language) {
    setState(() {
      _currentLanguage = language;
    });
    // Here you would typically update the app's locale
    print('Language changed to: $language');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // Language Toggle
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: LanguageToggle(
                  currentLanguage: _currentLanguage,
                  onLanguageChanged: _handleLanguageChange,
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          8.h,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Column(
                          children: [
                            SizedBox(height: 4.h),

                            // Logo Section
                            MitiHubLogo(),

                            // Tab Bar
                            AuthTabBar(
                              tabController: _tabController,
                              onLoginTap: () => _tabController.animateTo(0),
                              onRegisterTap: () => _tabController.animateTo(1),
                            ),
                            SizedBox(height: 4.h),

                            // Tab Content
                            Container(
                              height: 50.h,
                              child: TabBarView(
                                controller: _tabController,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  // Login Tab
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: LoginForm(
                                        onLogin: _handleLogin,
                                        onForgotPassword: _handleForgotPassword,
                                        isLoading: _isLoginLoading,
                                      ),
                                    ),
                                  ),

                                  // Register Tab
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: RegisterForm(
                                        onRegister: _handleRegister,
                                        isLoading: _isRegisterLoading,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Bottom Spacer
                            Spacer(),

                            // Footer Text
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Text(
                                _currentLanguage == 'English'
                                    ? 'By continuing, you agree to our Terms of Service and Privacy Policy'
                                    : 'Kwa kuendelea, unakubali Masharti yetu ya Huduma na Sera ya Faragha',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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