import 'package:flutter/material.dart';

/// Shared breakpoints for portfolio layout.
class LayoutBreakpoints {
  static const double compact = 600;
  static const double medium = 960;
  static const double wide = 1200;

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) => width >= compact && width < medium;
  static bool isExpanded(double width) => width >= medium;

  static int gridColumns(double width) {
    if (width >= wide) return 3;
    if (width >= compact) return 2;
    return 1;
  }

  static double contentWidth(double screenWidth, EdgeInsets padding) {
    final max = screenWidth > wide ? wide : screenWidth;
    return (max - padding.horizontal).clamp(0, max);
  }

  static EdgeInsets pagePadding(double width) {
    if (width >= medium) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 72);
    }
    if (width >= compact) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 56);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 48);
  }
}

/// Centers page content and caps max width on large screens.
class PageContent extends StatelessWidget {
  const PageContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutBreakpoints.wide),
        child: child,
      ),
    );
  }
}

/// Anchor for scroll-spy and [Scrollable.ensureVisible]. Must wrap box content, not slivers.
class SectionAnchor extends StatelessWidget {
  const SectionAnchor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}
