import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class MitiHubLogo extends StatelessWidget {
  const MitiHubLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'eco',
                color: Colors.white,
                size: 10.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'MitiHub',
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.primaryColor,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Growing Kenya Together',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}