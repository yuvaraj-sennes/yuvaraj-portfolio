import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GradientText extends StatelessWidget {
  const GradientText({
    super.key,
    required this.text,
    required this.style,
    this.gradient = AppTheme.brandGradient,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}
