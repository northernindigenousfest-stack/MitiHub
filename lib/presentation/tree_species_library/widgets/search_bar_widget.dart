import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search tree species...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged('');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'tune',
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
