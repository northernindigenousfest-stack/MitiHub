import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickReplyWidget extends StatelessWidget {
  final List<String> quickReplies;
  final Function(String) onReplyTap;

  const QuickReplyWidget({
    Key? key,
    required this.quickReplies,
    required this.onReplyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quickReplies.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick replies:',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: quickReplies
                .map((reply) => _buildQuickReplyChip(reply))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplyChip(String reply) {
    return GestureDetector(
      onTap: () => onReplyTap(reply),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(5.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          reply,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
