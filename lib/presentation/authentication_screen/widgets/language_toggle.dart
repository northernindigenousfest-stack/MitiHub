import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class LanguageToggle extends StatefulWidget {
  final Function(String language) onLanguageChanged;
  final String currentLanguage;

  const LanguageToggle({
    Key? key,
    required this.onLanguageChanged,
    this.currentLanguage = 'English',
  }) : super(key: key);

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'language',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 18,
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption('English', 'EN'),
                SizedBox(width: 2.w),
                _buildLanguageOption('Swahili', 'SW'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code) {
    final isSelected = _selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        widget.onLanguageChanged(language);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          code,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}