import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
