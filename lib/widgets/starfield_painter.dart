import 'dart:math';
import 'package:flutter/material.dart';

class StarfieldPainter extends CustomPainter {
  final int numStars;
  final List<Star> _stars = [];
  bool _initialized = false;

  StarfieldPainter({this.numStars = 150});

  void _initStars(Size size) {
    final random = Random();
    for (int i = 0; i < numStars; i++) {
      _stars.add(Star(
        x: random.nextDouble() * size.width,
        y: random.nextDouble() * size.height,
        radius: random.nextDouble() * 2 + 0.5,
        opacity: random.nextDouble() * 0.5 + 0.3,
      ));
    }
    _initialized = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_initialized) {
      _initStars(size);
    }

    final paint = Paint()..color = Colors.white;

    for (var star in _stars) {
      paint.color = Colors.white.withValues(alpha: star.opacity);
      // Glow effect for larger stars
      if (star.radius > 1.5) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      } else {
        paint.maskFilter = null;
      }
      canvas.drawCircle(Offset(star.x, star.y), star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Static starfield, doesn't need repainting
  }
}

class Star {
  final double x;
  final double y;
  final double radius;
  final double opacity;

  Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
  });
}
