import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MitiBotChatBubbleWidget extends StatefulWidget {
  final VoidCallback onTap;

  const MitiBotChatBubbleWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MitiBotChatBubbleWidget> createState() =>
      _MitiBotChatBubbleWidgetState();
}

class _MitiBotChatBubbleWidgetState extends State<MitiBotChatBubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12.h,
      right: 4.w,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _animationController.stop(),
        onTapUp: (_) => _animationController.repeat(reverse: true),
        onTapCancel: () => _animationController.repeat(reverse: true),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.successColor,
                      AppTheme.successColor.withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.successColor.withValues(alpha: 0.4),
                      blurRadius: 12 * _pulseAnimation.value,
                      spreadRadius: 2 * _pulseAnimation.value,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CustomIconWidget(
                        iconName: Icons.eco.codePoint.toString(),
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                    Positioned(
                      top: 1.w,
                      right: 1.w,
                      child: Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: AppTheme.warningColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
