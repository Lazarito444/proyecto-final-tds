import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/config/themes.dart';
import 'package:financia_mobile/modules/auth/auth_screen.dart';
import 'package:financia_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:financia_mobile/modules/welcome/welcome_screen.dart';
import 'package:financia_mobile/providers/auth_provider.dart';
import 'package:financia_mobile/providers/theme_mode_provider.dart';
import 'package:financia_mobile/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isFirstLaunch =
      await AppPreferences.getFirstTimeRunningPreference();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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

class MainApp extends ConsumerWidget {
  final bool isFirstLaunch;

  const MainApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeModeProvider);
    AuthState authState = ref.watch(authProvider);
    Widget initialScreen;

    if (isFirstLaunch) {
      initialScreen = WelcomeScreen();
    } else {
      switch (authState.status) {
        case AuthStatus.loading:
          initialScreen = LoadingScreen();
          break;
        case AuthStatus.authenticated:
          initialScreen = DashboardScreen();
          break;
        case AuthStatus.unauthenticated:
          initialScreen = AuthScreen();
          break;
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialScreen,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}
