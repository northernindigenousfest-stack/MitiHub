import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AuthTabBar extends StatelessWidget {
  final TabController tabController;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabBar({
    Key? key,
    required this.tabController,
    required this.onLoginTap,
    required this.onRegisterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(4.0),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurface,
        labelStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Container(
              width: double.infinity,
              child: Center(
                child: Text('Login'),
              ),
            ),
          ),
          Tab(
            child: Container(
              width: double.infinity,
              child: Center(
                child: Text('Register'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}