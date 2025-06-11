import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/auth/sign_up_screen.dart';
import 'package:financia_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.push(DashboardScreen());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 31, 133, 119),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Iniciar sesión",
                    style: context.textStyles.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
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
              const SizedBox(width: 200, height: 200, child: Placeholder()),
            ],
          ),
        ),
      ),
    );
  }
}
