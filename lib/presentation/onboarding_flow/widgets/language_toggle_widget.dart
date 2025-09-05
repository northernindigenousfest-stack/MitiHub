import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageToggleWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageToggleWidget({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption('English', 'EN'),
          _buildLanguageOption('Kiswahili', 'SW'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code) {
    final bool isSelected = selectedLanguage == code;

    return GestureDetector(
      onTap: () => onLanguageChanged(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'language',
              color: isSelected
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              language,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
