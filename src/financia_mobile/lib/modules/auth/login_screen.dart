// ignore_for_file: use_build_context_synchronously
import 'package:financia_mobile/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:financia_mobile/providers/auth_provider.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(backgroundColor: context.colors.surface),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 5.sw),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).welcome, style: context.textStyles.titleLarge),
              const SizedBox(height: 35),
              Text(S.of(context).email, style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                style: context.textStyles.labelSmall,
              ),
              const SizedBox(height: 25),
              Text(
                S.of(context).password,
                style: context.textStyles.labelMedium,
              ),
              const SizedBox(height: 2),
              TextFormField(
                controller: _passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validatePassword,
                style: context.textStyles.labelSmall,
                obscureText: true,
              ),
              const SizedBox(height: 40),
              FullWidthButton(
                text: S.of(context).login,
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    try {
                      await ref
                          .read(authProvider.notifier)
                          .login(email, password);

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      context.push(DashboardScreen());
                    } on DioException {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).invalid_credentials),
                          ),
                        );
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).fill_fields_correctly),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su correo electrónico';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Ingrese su contraseña";
    }

    return null;
  }
}
