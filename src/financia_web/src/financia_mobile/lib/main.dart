import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/config/themes.dart';
import 'package:financia_mobile/modules/auth/auth_screen.dart';
import 'package:financia_mobile/modules/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isFirstLaunch =
      await AppPreferences.getFirstTimeRunningPreference();

  runApp(
    ProviderScope(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MainApp(isFirstLaunch: isFirstLaunch);
        },
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  bool isFirstLaunch;

  MainApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    isFirstLaunch = true; // Temporarily set to true for testing purposes
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch ? WelcomeScreen() : AuthScreen(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
