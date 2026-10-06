import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'gradient_text.dart';
import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.5, end: 0),
            const SizedBox(width: 20),
            GradientText(
              text: title,
              style: AppTheme.subHeadingStyle,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(width: 20),
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: 0.5, end: 0),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            style: AppTheme.bodyStyle,
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
        ],
      ],
    );
  }
}
