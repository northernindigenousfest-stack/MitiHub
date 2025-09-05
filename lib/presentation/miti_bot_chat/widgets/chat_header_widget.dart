import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatHeaderWidget extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onSettingsTap;
  final VoidCallback onBackTap;

  const ChatHeaderWidget({
    Key? key,
    required this.isOnline,
    required this.onSettingsTap,
    required this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBackTap,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            // MitiBot avatar
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.w),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'eco',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            // Bot info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MitiBot',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isOnline ? 'Online' : 'Offline Mode',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Settings button
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName: 'settings',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
