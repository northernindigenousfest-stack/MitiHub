import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({Key? key}) : super(key: key);

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: _animation.value * 0.3),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                ),
              ),

              // Content skeleton
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title skeleton
                      Container(
                        width: 70.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: _animation.value * 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      // Subtitle skeleton
                      Container(
                        width: 50.w,
                        height: 1.5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: _animation.value * 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Icons skeleton
                      Row(
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: EdgeInsets.only(right: 1.w),
                                  child: Container(
                                    width: 4.w,
                                    height: 4.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline
                                          .withValues(
                                              alpha: _animation.value * 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
