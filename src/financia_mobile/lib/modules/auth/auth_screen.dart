import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/auth/login_screen.dart';
import 'package:financia_mobile/modules/auth/sign_up_screen.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sw),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 150, width: 150, child: Placeholder()),
              const SizedBox(height: 20),
              Text("FinancIA", style: context.textStyles.titleLarge),
              const SizedBox(height: 20),
              FullWidthButton(
                text: "Iniciar sesión",
                onPressed: () {
                  context.push(LoginScreen());
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.push(SignUpScreen());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF113931),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.green.shade200, width: 3),
                    ),
                  ),
                  child: Text(
                    "Regístrate",
                    style: context.textStyles.titleSmall,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SvgPicture.asset(
                "assets/svg/auth_illustration.svg",
                width: 200,
                height: 200,
              )
              // const SizedBox(width: 200, height: 200, child: Placeholder()),
            ],
          ),
        ),
      ),
    );
  }
}
