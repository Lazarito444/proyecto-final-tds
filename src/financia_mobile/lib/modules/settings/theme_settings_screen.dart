// theme_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/providers/theme_mode_provider.dart';
import 'package:financia_mobile/generated/l10n.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode currentMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(S.of(context).theme, style: context.textStyles.titleLarge),
          const SizedBox(height: 20),
          RadioListTile<ThemeMode>(
            title: Text(
              S.of(context).light,
              style: context.textStyles.labelMedium,
            ),
            value: ThemeMode.light,
            groupValue: currentMode,
            onChanged: (mode) =>
                ref.read(themeModeProvider.notifier).setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(
              S.of(context).dark,
              style: context.textStyles.labelMedium,
            ),
            value: ThemeMode.dark,
            groupValue: currentMode,
            onChanged: (mode) =>
                ref.read(themeModeProvider.notifier).setThemeMode(mode!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(
              S.of(context).system,
              style: context.textStyles.labelMedium,
            ),
            value: ThemeMode.system,
            groupValue: currentMode,
            onChanged: (mode) =>
                ref.read(themeModeProvider.notifier).setThemeMode(mode!),
          ),
        ],
      ),
    );
  }
}
