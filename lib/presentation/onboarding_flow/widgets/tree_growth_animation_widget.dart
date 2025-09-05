import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TreeGrowthAnimationWidget extends StatefulWidget {
  const TreeGrowthAnimationWidget({Key? key}) : super(key: key);

  @override
  State<TreeGrowthAnimationWidget> createState() =>
      _TreeGrowthAnimationWidgetState();
}

class _TreeGrowthAnimationWidgetState extends State<TreeGrowthAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _growthController;
  late AnimationController _leafController;
  late Animation<double> _growthAnimation;
  late Animation<double> _leafAnimation;

  @override
  void initState() {
    super.initState();
    _growthController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _leafController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _growthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _growthController,
      curve: Curves.easeInOut,
    ));

    _leafAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _leafController,
      curve: Curves.elasticOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await _growthController.forward();
    await _leafController.forward();
    await Future.delayed(const Duration(seconds: 1));
    _growthController.reset();
    _leafController.reset();
    _startAnimation();
  }

  @override
  void dispose() {
    _growthController.dispose();
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      height: 30.w,
      child: AnimatedBuilder(
        animation: Listenable.merge([_growthAnimation, _leafAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: TreePainter(
              growthProgress: _growthAnimation.value,
              leafProgress: _leafAnimation.value,
            ),
            size: Size(30.w, 30.w),
          );
        },
      ),
    );
  }
}

class TreePainter extends CustomPainter {
  final double growthProgress;
  final double leafProgress;

  TreePainter({
    required this.growthProgress,
    required this.leafProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trunkPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final Paint leafPaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double bottomY = size.height * 0.9;
    final double trunkHeight = size.height * 0.4 * growthProgress;

    // Draw trunk
    canvas.drawLine(
      Offset(centerX, bottomY),
      Offset(centerX, bottomY - trunkHeight),
      trunkPaint,
    );

    if (growthProgress > 0.5) {
      // Draw branches
      final double branchY = bottomY - trunkHeight * 0.7;
      final double branchLength =
          size.width * 0.15 * (growthProgress - 0.5) * 2;

      canvas.drawLine(
        Offset(centerX, branchY),
        Offset(centerX - branchLength, branchY - branchLength * 0.5),
        trunkPaint,
      );

      canvas.drawLine(
        Offset(centerX, branchY),
        Offset(centerX + branchLength, branchY - branchLength * 0.5),
        trunkPaint,
      );

      // Draw leaves
      if (leafProgress > 0) {
        final double leafSize = 15 * leafProgress;

        // Center leaves
        canvas.drawCircle(
          Offset(centerX, branchY - size.height * 0.1),
          leafSize,
          leafPaint,
        );

        // Left leaves
        canvas.drawCircle(
          Offset(centerX - branchLength * 0.8, branchY - branchLength * 0.3),
          leafSize * 0.8,
          leafPaint,
        );

        // Right leaves
        canvas.drawCircle(
          Offset(centerX + branchLength * 0.8, branchY - branchLength * 0.3),
          leafSize * 0.8,
          leafPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
