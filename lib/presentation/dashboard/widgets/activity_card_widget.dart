import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityCardWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onShare;
  final VoidCallback? onViewDetails;
  final VoidCallback? onMarkAsRead;

  const ActivityCardWidget({
    Key? key,
    required this.activity,
    this.onShare,
    this.onViewDetails,
    this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = activity['type'] as String? ?? 'general';
    final String title = activity['title'] as String? ?? 'Activity';
    final String description = activity['description'] as String? ?? '';
    final String timestamp = activity['timestamp'] as String? ?? '';
    final String imageUrl = activity['imageUrl'] as String? ?? '';
    final bool isRead = activity['isRead'] as bool? ?? false;

    return Slidable(
      key: ValueKey(activity['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onShare?.call(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (_) => onViewDetails?.call(),
            backgroundColor: AppTheme.accentColor,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
            icon: Icons.visibility,
            label: 'View',
          ),
          if (!isRead)
            SlidableAction(
              onPressed: (_) => onMarkAsRead?.call(),
              backgroundColor: AppTheme.successColor,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Read',
            ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isRead
              ? AppTheme.lightTheme.cardColor.withValues(alpha: 0.7)
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead
                ? AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5)
                : AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActivityIcon(type),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight:
                                isRead ? FontWeight.w400 : FontWeight.w600,
                            color: isRead
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (imageUrl.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  SizedBox(height: 1.h),
                  Text(
                    timestamp,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'tree_monitoring':
        iconData = Icons.eco;
        iconColor = AppTheme.successColor;
        break;
      case 'community_achievement':
        iconData = Icons.group;
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'news':
        iconData = Icons.article;
        iconColor = AppTheme.accentColor;
        break;
      case 'adoption':
        iconData = Icons.favorite;
        iconColor = AppTheme.warningColor;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.lightTheme.colorScheme.secondary;
    }

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconData.codePoint.toString(),
          color: iconColor,
          size: 5.w,
        ),
      ),
    );
  }
}
