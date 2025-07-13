import 'package:financia_mobile/modules/settings/language_settings_screen.dart';
import 'package:financia_mobile/modules/settings/personal_data_screen.dart';
import 'package:financia_mobile/modules/settings/theme_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: context.colors.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).settings, style: context.textStyles.titleLarge),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      S.of(context).personal_data,
                      style: context.textStyles.labelMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalDataScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).theme,
                      style: context.textStyles.labelMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThemeSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).language,
                      style: context.textStyles.labelMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
