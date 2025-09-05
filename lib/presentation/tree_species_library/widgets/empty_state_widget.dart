import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'eco',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 10.w,
              ),
            ),

            SizedBox(height: 3.h),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1.h),

            // Subtitle
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),

            if (actionText != null && onActionTap != null) ...[
              SizedBox(height: 3.h),

              // Action button
              ElevatedButton(
                onPressed: onActionTap,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
