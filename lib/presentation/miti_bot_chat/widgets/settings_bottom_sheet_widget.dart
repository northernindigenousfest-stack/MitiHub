import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsBottomSheetWidget extends StatefulWidget {
  final bool notificationsEnabled;
  final String selectedLanguage;
  final Function(bool) onNotificationToggle;
  final Function(String) onLanguageChange;

  const SettingsBottomSheetWidget({
    Key? key,
    required this.notificationsEnabled,
    required this.selectedLanguage,
    required this.onNotificationToggle,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  State<SettingsBottomSheetWidget> createState() =>
      _SettingsBottomSheetWidgetState();
}

class _SettingsBottomSheetWidgetState extends State<SettingsBottomSheetWidget> {
  late bool _notificationsEnabled;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.notificationsEnabled;
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Title
          Text(
            'Chat Settings',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 3.h),
          // Notifications setting
          _buildSettingItem(
            icon: 'notifications',
            title: 'Notifications',
            subtitle: 'Get notified about new messages',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                widget.onNotificationToggle(value);
              },
            ),
          ),
          SizedBox(height: 2.h),
          // Language setting
          _buildSettingItem(
            icon: 'language',
            title: 'Language',
            subtitle: 'Choose your preferred language',
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Swahili', child: Text('Swahili')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  widget.onLanguageChange(value);
                }
              },
            ),
          ),
          SizedBox(height: 2.h),
          // Clear chat history
          _buildSettingItem(
            icon: 'delete_outline',
            title: 'Clear Chat History',
            subtitle: 'Remove all previous conversations',
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            onTap: () => _showClearHistoryDialog(context),
          ),
          SizedBox(height: 2.h),
          // About MitiBot
          _buildSettingItem(
            icon: 'info_outline',
            title: 'About MitiBot',
            subtitle: 'Learn more about your AI assistant',
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            onTap: () => _showAboutDialog(context),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
            'Are you sure you want to clear all chat history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Clear history logic would be implemented here
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About MitiBot'),
        content: const Text(
          'MitiBot is your AI-powered assistant for tree care and environmental conservation in Northern Kenya. '
          'It provides expert advice on tree species, climate conditions, and sustainable practices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
