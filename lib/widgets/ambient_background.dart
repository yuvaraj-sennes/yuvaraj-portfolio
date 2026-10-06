import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Lightweight animated gradient orbs (no particle field — smooth on web).
class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value * 2 * math.pi;
          return Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0A1020),
                      AppTheme.backgroundDeep,
                      AppTheme.background,
                    ],
                  ),
                ),
              ),
              _Orb(
                color: AppTheme.primary.withValues(alpha: 0.35),
                size: 420,
                dx: math.sin(t) * 40 - 80,
                dy: math.cos(t * 0.8) * 30 - 60,
              ),
              _Orb(
                color: AppTheme.secondary.withValues(alpha: 0.22),
                size: 520,
                dx: math.cos(t * 0.7) * 50 + 120,
                dy: math.sin(t * 0.6) * 40 + 200,
              ),
              _Orb(
                color: AppTheme.tertiary.withValues(alpha: 0.12),
                size: 360,
                dx: math.sin(t * 1.1) * 35,
                dy: math.cos(t) * 45 + 480,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.color,
    required this.size,
    required this.dx,
    required this.dy,
  });

  final Color color;
  final double size;
  final double dx;
  final double dy;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
