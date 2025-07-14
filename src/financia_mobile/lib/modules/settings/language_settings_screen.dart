import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/providers/locale_provider.dart';
import 'package:financia_mobile/generated/l10n.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale? currentLocale = ref.watch(localeProvider);

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
          Text(S.of(context).language, style: context.textStyles.titleLarge),
          const SizedBox(height: 20),
          RadioListTile<Locale>(
            value: const Locale('es'),
            groupValue: currentLocale,
            title: Text(
              S.of(context).spanish,
              style: context.textStyles.labelMedium,
            ),
            onChanged: (Locale? value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLocale(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Idioma cambiado a Español')),
                );
              }
            },
          ),
          RadioListTile<Locale>(
            value: const Locale('en'),
            groupValue: currentLocale,
            activeColor: Theme.of(context).colorScheme.primary,
            title: Text(
              S.of(context).english,
              style: context.textStyles.labelMedium,
            ),
            onChanged: (Locale? value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLocale(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Language switched to English')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
