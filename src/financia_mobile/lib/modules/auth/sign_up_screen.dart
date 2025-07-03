import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:financia_mobile/generated/l10n.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
          autovalidateMode: AutovalidateMode.onUnfocus,
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
                controller: _fullNameController,
                style: context.textStyles.labelSmall,
              ),
              SizedBox(height: 25),
              Text(S.of(context).email, style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateEmail,
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
                controller: _passwordConfirmationController,
                style: context.textStyles.labelSmall,
                obscureText: true,
              ),
              SizedBox(height: 25),
              FullWidthButton(
                text: S.of(context).create_account,
                onPressed: () {
                  context.push(DashboardScreen());
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

    if (value.length < 3) {
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
