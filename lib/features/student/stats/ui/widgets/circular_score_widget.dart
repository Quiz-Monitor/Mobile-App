import 'dart:math' as math;

import 'package:examify/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 7.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      trackPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ArcPainter old) =>
      old.progress != progress || old.color != color;
}

class CircularScoreWidget extends StatelessWidget {
  final double percentage;
  final String label;

  const CircularScoreWidget({
    super.key,
    required this.percentage,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPct = percentage.clamp(0.0, 100.0);
    final Color arcColor;
    if (clampedPct >= 70) {
      arcColor = AppColors.mainGreen;
    } else if (clampedPct >= 40) {
      arcColor = AppColors.brownText;
    } else {
      arcColor = const Color(0xffFB2C36);
    }

    return SizedBox(
      width: 90,
      height: 90,
      child: CustomPaint(
        painter: ArcPainter(
          progress: clampedPct / 100,
          color: arcColor,
          trackColor: AppColors.white10,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${clampedPct.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withAlpha(140),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
