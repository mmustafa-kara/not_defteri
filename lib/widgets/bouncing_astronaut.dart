import 'package:flutter/material.dart';

class BouncingAstronaut extends StatefulWidget {
  const BouncingAstronaut({super.key});

  @override
  State<BouncingAstronaut> createState() => _BouncingAstronautState();
}

class _BouncingAstronautState extends State<BouncingAstronaut> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Position and velocity
  double _x = 50.0;
  double _y = 50.0;
  double _dx = 0.5; // Slower horizontal speed
  double _dy = 0.4; // Slower vertical speed
  double _angle = 0.0; // Rotation angle
  
  final double _astronautSize = 60.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        _updatePosition();
      });
    _controller.repeat();
  }

  void _updatePosition() {
    if (!mounted) return;
    
    setState(() {
      _x += _dx;
      _y += _dy;
      _angle += 0.01; // Slowly rotate
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Bounce logic
        if (_x <= 0) {
          _x = 0;
          _dx = -_dx;
        } else if (_x + _astronautSize >= constraints.maxWidth) {
          _x = constraints.maxWidth - _astronautSize;
          _dx = -_dx;
        }

        if (_y <= 0) {
          _y = 0;
          _dy = -_dy;
        } else if (_y + _astronautSize >= constraints.maxHeight) {
          _y = constraints.maxHeight - _astronautSize;
          _dy = -_dy;
        }

        return Stack(
          children: [
            Positioned(
              left: _x,
              top: _y,
              child: Transform.rotate(
                angle: _angle,
                child: Image.asset(
                  'assets/images/astronaut.png',
                  width: _astronautSize,
                  height: _astronautSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

