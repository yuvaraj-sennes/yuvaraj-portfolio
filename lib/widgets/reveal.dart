import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fade + slide in once when scrolled into view.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.slideY = 0.12,
  });

  final Widget child;
  final int delayMs;
  final double slideY;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('reveal-${widget.key ?? widget.hashCode}'),
      onVisibilityChanged: (info) {
        if (!_shown && info.visibleFraction > 0.08) {
          setState(() => _shown = true);
        }
      },
      child: _shown
          ? widget.child
              .animate()
              .fadeIn(
                duration: 650.ms,
                delay: Duration(milliseconds: widget.delayMs),
                curve: Curves.easeOutCubic,
              )
              .slideY(
                begin: widget.slideY,
                end: 0,
                duration: 650.ms,
                delay: Duration(milliseconds: widget.delayMs),
                curve: Curves.easeOutCubic,
              )
          : Opacity(
              opacity: 0,
              child: widget.child,
            ),
    );
  }
}
