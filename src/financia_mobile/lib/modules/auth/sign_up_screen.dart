// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/models/register_model.dart';
import 'package:financia_mobile/providers/auth_provider.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:financia_mobile/generated/l10n.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> confirmPasswordKey =
      GlobalKey<FormFieldState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: context.colors.surface),
      backgroundColor: context.colors.surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.sw),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).sign_up, style: context.textStyles.titleLarge),
              const SizedBox(height: 35),
              Text(
                S.of(context).full_name,
                style: context.textStyles.labelMedium,
              ),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _fullNameController,
                style: context.textStyles.labelSmall,
              ),
              SizedBox(height: 25),
              Text(S.of(context).email, style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                style: context.textStyles.labelSmall,
              ),
              SizedBox(height: 25),
              Text(
                S.of(context).password,
                style: context.textStyles.labelMedium,
              ),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordController,
                style: context.textStyles.labelSmall,
                onChanged: (_) => confirmPasswordKey.currentState?.validate(),
                obscureText: true,
              ),
              SizedBox(height: 25),
              Text(
                S.of(context).confirm_password,
                style: context.textStyles.labelMedium,
              ),
              const SizedBox(height: 2),
              TextFormField(
                key: confirmPasswordKey,
                validator: _validatePasswordConfirmation,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordConfirmationController,
                style: context.textStyles.labelSmall,
                obscureText: true,
              ),
              SizedBox(height: 25),
              FullWidthButton(
                text: S.of(context).create_account,
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    String email = _emailController.text.trim();
                    String fullName = _fullNameController.text.trim();
                    String passwordConfirmation =
                        _passwordConfirmationController.text.trim();
                    String password = _passwordController.text.trim();

                    try {
                      await ref
                          .read(authProvider.notifier)
                          .register(
                            RegisterModel(
                              fullName: fullName,
                              email: email,
                              password: password,
                              passwordConfirmation: passwordConfirmation,
                            ),
                          );

                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } on DioException catch (e) {
                      if ((e.response?.statusCode ?? 400) == 400) {
                        for (var error in e.response!.data) {
                          if (error["errorMessage"].contains(
                            "está registrado",
                          )) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    S
                                        .of(context)
                                        .validations_signup_email_taken,
                                  ),
                                ),
                              );
                            return;
                          }
                        }
                      }

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).invalid_credentials),
                          ),
                        );
                    }

                    context.pop();
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).name_required;
    }

    if (value.length < 5) {
      return S.of(context).name_min_length;
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value ?? "")) {
      return S.of(context).invalid_email;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$',
    );

    if (value == null || value.isEmpty) {
      return S.of(context).password_required;
    }

    if (!passwordRegExp.hasMatch(value)) {
      return S.of(context).invalid_password;
    }

    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (_passwordController.text != _passwordConfirmationController.text) {
      return S.of(context).passwords_not_match;
    }

    return null;
  }
}
