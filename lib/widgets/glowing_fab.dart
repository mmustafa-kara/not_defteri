import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GlowingFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const GlowingFAB({super.key, required this.onPressed});

  @override
  State<GlowingFAB> createState() => _GlowingFABState();
}

class _GlowingFABState extends State<GlowingFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 4.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.electricBlue.withOpacity(0.6),
                blurRadius: _animation.value,
                spreadRadius: _animation.value / 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: AppTheme.electricBlue,
            foregroundColor: Colors.black,
            onPressed: widget.onPressed,
            child: const Icon(Icons.add, size: 28),
          ),
        );
      },
    );
  }
}
