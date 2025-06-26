import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: context.colors.primary),
          SizedBox(height: 30),
          Text(
            title,
            style: context.textStyles.titleSmall!.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.textStyles.labelSmall!.copyWith(
              fontSize: 18,
              color: context.colors.onSurface.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}
