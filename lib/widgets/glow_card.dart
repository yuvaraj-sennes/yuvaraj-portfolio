import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GlowCard extends StatefulWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.highlighted = false,
    this.glowColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool highlighted;
  final Color? glowColor;
  final VoidCallback? onTap;

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor ?? AppTheme.primary;
    final active = widget.highlighted || _hover;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: widget.padding,
          decoration: AppTheme.cardDecoration(
            highlighted: active,
            glowColor: glow,
          ),
          transform: _hover
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}
